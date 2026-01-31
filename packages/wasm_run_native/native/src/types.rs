use std::fmt::Display;

use anyhow::Result;
use crate::frb_generated::RustOpaque;

use crate::external::{WFunc, WGlobal, WTable, WMemory, WAnyRef, WExnRef, WModule, WSharedMemory};
// wasmi 1.0: ValType is now directly exported (not from core module)
#[cfg(not(feature = "wasmtime"))]
use wasmi::{ValType as ValueType, *};

#[allow(non_camel_case_types)]
#[derive(Debug)]
pub enum WasmVal {
    /// Value of 32-bit signed or unsigned integer.
    i32(i32),
    /// Value of 64-bit signed or unsigned integer.
    i64(i64),
    /// Value of 32-bit IEEE 754-2008 floating point number.
    f32(f32),
    /// Value of 64-bit IEEE 754-2008 floating point number.
    f64(f64),
    /// A 128 bit number.
    v128([u8; 16]),
    /// A nullable function reference.
    funcRef(Option<RustOpaque<WFunc>>),
    /// A nullable external object reference.
    externRef(Option<u32>), // NonZeroU32
    /// A nullable internal GC reference (wasmtime GC only).
    /// Represents anyref/eqref/structref/arrayref/i31ref types.
    #[cfg(feature = "wasmtime")]
    anyRef(Option<RustOpaque<WAnyRef>>),
    /// A nullable exception reference (wasmtime exception handling only).
    #[cfg(feature = "wasmtime")]
    exnRef(Option<RustOpaque<WExnRef>>),
}

impl WasmVal {
    #[cfg(not(feature = "wasmtime"))]
    #[allow(clippy::wrong_self_convention)]
    pub fn to_value(self, mut ctx: impl AsContextMut) -> wasmi::Val {
        use wasmi::Ref;
        match self {
            WasmVal::i32(i) => wasmi::Val::I32(i),
            WasmVal::i64(i) => wasmi::Val::I64(i),
            WasmVal::f32(i) => wasmi::Val::F32(wasmi::F32::from_bits(i.to_bits())),
            WasmVal::f64(i) => wasmi::Val::F64(wasmi::F64::from_bits(i.to_bits())),
            WasmVal::v128(i) => wasmi::Val::V128(wasmi::V128::from(u128::from_ne_bytes(i))),
            WasmVal::funcRef(i) => {
                // wasmi 1.0: Val::FuncRef uses Ref<Func> for nullable references
                match i {
                    Some(f) => wasmi::Val::FuncRef(Ref::Val(Func::clone(&f.func_wasmi))),
                    None => wasmi::Val::FuncRef(Ref::Null),
                }
            }
            WasmVal::externRef(i) => {
                // wasmi 1.0: Val::ExternRef uses Ref<ExternRef> for nullable references
                match i {
                    Some(val) => {
                        let extern_ref = ExternRef::new(&mut ctx, val);
                        wasmi::Val::ExternRef(Ref::Val(extern_ref))
                    }
                    None => wasmi::Val::ExternRef(Ref::Null),
                }
            }
        }
    }

    #[cfg(not(feature = "wasmtime"))]
    pub fn from_value<'a, T: 'a>(value: &wasmi::Val, ctx: impl Into<StoreContext<'a, T>>) -> Self {
        let ctx = ctx.into();
        match value {
            wasmi::Val::I32(i) => WasmVal::i32(*i),
            wasmi::Val::I64(i) => WasmVal::i64(*i),
            wasmi::Val::F32(i) => WasmVal::f32(i.to_float()),
            wasmi::Val::F64(i) => WasmVal::f64(i.to_float()),
            // wasmi 1.0: V128 doesn't impl Into<u128>, use transmute
            wasmi::Val::V128(i) => WasmVal::v128(unsafe { std::mem::transmute::<wasmi::V128, [u8; 16]>(*i) }),
            wasmi::Val::FuncRef(ref_func) => {
                // wasmi 1.0: FuncRef uses Ref<Func>
                WasmVal::funcRef(ref_func.val().map(|f| RustOpaque::new((*f).into())))
            }
            wasmi::Val::ExternRef(ref_extern) => {
                // wasmi 1.0: ExternRef uses Ref<ExternRef>
                WasmVal::externRef(
                    ref_extern
                        .val()
                        .and_then(|er| er.data(&ctx).downcast_ref::<u32>().copied())
                )
            }
        }
    }

    #[cfg(feature = "wasmtime")]
    #[allow(clippy::wrong_self_convention)]
    pub fn to_val(self, mut store: impl wasmtime::AsContextMut) -> Result<wasmtime::Val> {
        Ok(match self {
            WasmVal::i32(i) => wasmtime::Val::I32(i),
            WasmVal::i64(i) => wasmtime::Val::I64(i),
            WasmVal::f32(i) => wasmtime::Val::F32(i.to_bits()),
            WasmVal::f64(i) => wasmtime::Val::F64(i.to_bits()),
            WasmVal::v128(i) => wasmtime::Val::V128(wasmtime::V128::from(u128::from_ne_bytes(i))),
            WasmVal::funcRef(i) => wasmtime::Val::FuncRef(i.map(|f| f.func_wasmtime)),
            WasmVal::externRef(i) => match i {
                Some(val) => {
                    let extern_ref = wasmtime::ExternRef::new(&mut store, val)?;
                    wasmtime::Val::ExternRef(Some(extern_ref))
                }
                None => wasmtime::Val::ExternRef(None),
            },
            WasmVal::anyRef(i) => wasmtime::Val::AnyRef(i.map(|r| r.inner.clone())),
            WasmVal::exnRef(i) => wasmtime::Val::ExnRef(i.map(|r| r.inner.clone())),
        })
    }

    /// Convert to Val without a store context.
    /// Only works for simple types (i32, i64, f32, f64, v128, funcRef, null externRef).
    /// For non-null externRef and GC types, use `to_val` with a store context.
    #[cfg(feature = "wasmtime")]
    #[allow(clippy::wrong_self_convention)]
    pub fn to_val_simple(self) -> Result<wasmtime::Val> {
        Ok(match self {
            WasmVal::i32(i) => wasmtime::Val::I32(i),
            WasmVal::i64(i) => wasmtime::Val::I64(i),
            WasmVal::f32(i) => wasmtime::Val::F32(i.to_bits()),
            WasmVal::f64(i) => wasmtime::Val::F64(i.to_bits()),
            WasmVal::v128(i) => wasmtime::Val::V128(wasmtime::V128::from(u128::from_ne_bytes(i))),
            WasmVal::funcRef(i) => wasmtime::Val::FuncRef(i.map(|f| f.func_wasmtime)),
            WasmVal::externRef(None) => wasmtime::Val::ExternRef(None),
            WasmVal::externRef(Some(_)) => {
                return Err(anyhow::anyhow!(
                    "Cannot convert non-null externRef without a store context. \
                     Use to_val() with a store context instead."
                ))
            }
            WasmVal::anyRef(_) | WasmVal::exnRef(_) => {
                return Err(anyhow::anyhow!(
                    "Cannot convert GC reference types (anyRef, exnRef) without a store context. \
                     Use to_val() with a store context instead."
                ))
            }
        })
    }

    /// Convert from Val without a store context.
    /// Only works for simple types (i32, i64, f32, f64, v128, funcRef).
    /// For externRef and GC types, use `from_val` with a store context.
    #[cfg(feature = "wasmtime")]
    #[allow(dead_code)]
    pub fn from_val_simple(val: wasmtime::Val) -> Result<Self> {
        Ok(match val {
            wasmtime::Val::I32(i) => WasmVal::i32(i),
            wasmtime::Val::I64(i) => WasmVal::i64(i),
            wasmtime::Val::V128(i) => WasmVal::v128(i.as_u128().to_ne_bytes()),
            wasmtime::Val::F32(i) => WasmVal::f32(f32::from_bits(i)),
            wasmtime::Val::F64(i) => WasmVal::f64(f64::from_bits(i)),
            wasmtime::Val::FuncRef(i) => WasmVal::funcRef(i.map(|f| RustOpaque::new(f.into()))),
            wasmtime::Val::ExternRef(None) => WasmVal::externRef(None),
            wasmtime::Val::ExternRef(Some(_)) => {
                return Err(anyhow::anyhow!(
                    "Cannot convert non-null externRef without a store context. \
                     Use from_val() with a store context instead."
                ))
            }
            wasmtime::Val::AnyRef(_) | wasmtime::Val::ExnRef(_) | wasmtime::Val::ContRef(_) => {
                return Err(anyhow::anyhow!(
                    "Cannot convert GC reference types without a store context. \
                     Use from_val() with a store context instead."
                ))
            }
        })
    }

    #[cfg(feature = "wasmtime")]
    pub fn from_val(val: wasmtime::Val, store: impl wasmtime::AsContext) -> Result<Self> {
        Ok(match val {
            wasmtime::Val::I32(i) => WasmVal::i32(i),
            wasmtime::Val::I64(i) => WasmVal::i64(i),
            wasmtime::Val::V128(i) => WasmVal::v128(i.as_u128().to_ne_bytes()),
            wasmtime::Val::F32(i) => WasmVal::f32(f32::from_bits(i)),
            wasmtime::Val::F64(i) => WasmVal::f64(f64::from_bits(i)),
            wasmtime::Val::FuncRef(i) => WasmVal::funcRef(i.map(|f| RustOpaque::new(f.into()))),
            wasmtime::Val::ExternRef(i) => match i {
                Some(extern_ref) => {
                    let data = extern_ref.data(&store)?;
                    WasmVal::externRef(data.and_then(|d| d.downcast_ref::<u32>().copied()))
                }
                None => WasmVal::externRef(None),
            },
            wasmtime::Val::AnyRef(i) => {
                WasmVal::anyRef(i.map(|r| RustOpaque::new(WAnyRef { inner: r })))
            }
            wasmtime::Val::ExnRef(i) => {
                WasmVal::exnRef(i.map(|r| RustOpaque::new(WExnRef { inner: r })))
            }
            wasmtime::Val::ContRef(_) => {
                // ContRef is a stub implementation - return an error for now
                return Err(anyhow::anyhow!(
                    "Continuation references (contref) are not yet fully supported in wasmtime"
                ));
            }
        })
    }
}

#[derive(Debug)]
pub struct GlobalTy {
    /// The value type of the global variable.
    pub value: ValueTy,
    /// The mutability of the global variable.
    pub mutable: bool,
}

#[cfg(not(feature = "wasmtime"))]
impl From<&GlobalType> for GlobalTy {
    fn from(value: &GlobalType) -> Self {
        GlobalTy {
            value: (&value.content()).into(),
            mutable: value.mutability() == Mutability::Var,
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::GlobalType> for GlobalTy {
    fn from(value: &wasmtime::GlobalType) -> Self {
        GlobalTy {
            value: value.content().into(),
            mutable: value.mutability() == wasmtime::Mutability::Var,
        }
    }
}

#[derive(Debug)]
pub struct TableTy {
    /// The type of values stored in the [WasmTable].
    pub element: ValueTy,
    /// The minimum number of elements the [WasmTable] must have.
    pub minimum: u32,
    /// The optional maximum number of elements the [WasmTable] can have.
    ///
    /// If this is `None` then the [WasmTable] is not limited in size.
    pub maximum: Option<u32>,
}

#[cfg(not(feature = "wasmtime"))]
impl From<&TableType> for TableTy {
    fn from(value: &TableType) -> Self {
        TableTy {
            element: (&value.element()).into(),
            // wasmi 1.0: minimum/maximum return u64
            minimum: value.minimum() as u32,
            maximum: value.maximum().map(|v| v as u32),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::TableType> for TableTy {
    fn from(value: &wasmtime::TableType) -> Self {
        // Convert RefType to ValueTy based on the heap type
        let element = match value.element().heap_type() {
            wasmtime::HeapType::Func | wasmtime::HeapType::ConcreteFunc(_) | wasmtime::HeapType::NoFunc => ValueTy::funcRef,
            wasmtime::HeapType::Extern | wasmtime::HeapType::NoExtern => ValueTy::externRef,
            _ => ValueTy::externRef, // Default to externRef for other heap types
        };
        TableTy {
            element,
            minimum: value.minimum() as u32,
            maximum: value.maximum().map(|v| v as u32),
        }
    }
}

#[allow(non_camel_case_types)]
#[derive(Debug, Clone)]
pub enum ValueTy {
    /// 32-bit signed or unsigned integer.
    i32,
    /// 64-bit signed or unsigned integer.
    i64,
    /// 32-bit IEEE 754-2008 floating point number.
    f32,
    /// 64-bit IEEE 754-2008 floating point number.
    f64,
    /// A 128 bit number.
    v128,
    /// A nullable function reference.
    funcRef,
    /// A nullable external reference.
    externRef,
    /// A nullable internal GC reference (wasmtime GC only).
    anyRef,
    /// A nullable eq reference for GC comparison (wasmtime GC only).
    eqRef,
    /// A nullable i31 reference - 31-bit integer (wasmtime GC only).
    i31Ref,
    /// A nullable struct reference (wasmtime GC only).
    structRef,
    /// A nullable array reference (wasmtime GC only).
    arrayRef,
    /// A nullable exception reference (wasmtime exception handling only).
    exnRef,
    /// A nullable continuation reference (wasmtime stack switching - experimental).
    contRef,
}

#[cfg(not(feature = "wasmtime"))]
impl From<&ValueType> for ValueTy {
    fn from(value: &ValueType) -> Self {
        match value {
            ValueType::I32 => ValueTy::i32,
            ValueType::I64 => ValueTy::i64,
            ValueType::F32 => ValueTy::f32,
            ValueType::F64 => ValueTy::f64,
            ValueType::V128 => ValueTy::v128,
            ValueType::FuncRef => ValueTy::funcRef,
            ValueType::ExternRef => ValueTy::externRef,
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::ValType> for ValueTy {
    fn from(value: &wasmtime::ValType) -> Self {
        match value {
            wasmtime::ValType::I32 => ValueTy::i32,
            wasmtime::ValType::I64 => ValueTy::i64,
            wasmtime::ValType::F32 => ValueTy::f32,
            wasmtime::ValType::F64 => ValueTy::f64,
            wasmtime::ValType::V128 => ValueTy::v128,
            wasmtime::ValType::Ref(ref_type) => {
                // Determine the base heap type (ignoring nullability)
                let heap_type = ref_type.heap_type();
                match heap_type {
                    wasmtime::HeapType::Func | wasmtime::HeapType::ConcreteFunc(_) | wasmtime::HeapType::NoFunc => {
                        ValueTy::funcRef
                    }
                    wasmtime::HeapType::Extern | wasmtime::HeapType::NoExtern => {
                        ValueTy::externRef
                    }
                    wasmtime::HeapType::Any | wasmtime::HeapType::None => {
                        ValueTy::anyRef
                    }
                    wasmtime::HeapType::Eq => {
                        ValueTy::eqRef
                    }
                    wasmtime::HeapType::I31 => {
                        ValueTy::i31Ref
                    }
                    wasmtime::HeapType::Struct | wasmtime::HeapType::ConcreteStruct(_) => {
                        ValueTy::structRef
                    }
                    wasmtime::HeapType::Array | wasmtime::HeapType::ConcreteArray(_) => {
                        ValueTy::arrayRef
                    }
                    wasmtime::HeapType::Exn | wasmtime::HeapType::ConcreteExn(_) | wasmtime::HeapType::NoExn => {
                        ValueTy::exnRef
                    }
                    wasmtime::HeapType::Cont | wasmtime::HeapType::ConcreteCont(_) | wasmtime::HeapType::NoCont => {
                        ValueTy::contRef
                    }
                }
            }
        }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<ValueTy> for ValueType {
    fn from(value: ValueTy) -> Self {
        use crate::errors::wasmi_limitations;
        match value {
            ValueTy::i32 => ValueType::I32,
            ValueTy::i64 => ValueType::I64,
            ValueTy::f32 => ValueType::F32,
            ValueTy::f64 => ValueType::F64,
            ValueTy::v128 => ValueType::V128,
            ValueTy::funcRef => ValueType::FuncRef,
            ValueTy::externRef => ValueType::ExternRef,
            // GC types not supported in wasmi
            ValueTy::anyRef | ValueTy::eqRef | ValueTy::i31Ref | ValueTy::structRef | ValueTy::arrayRef => {
                panic!("{}", wasmi_limitations::GC)
            }
            // Exception handling not supported in wasmi
            ValueTy::exnRef => {
                panic!("Exception handling (exnref) is not supported in the wasmi runtime. \
                        For exception handling support, use the wasmtime runtime by enabling the 'wasmtime' feature.")
            }
            // Continuation/stack switching not supported in wasmi
            ValueTy::contRef => {
                panic!("Continuation references (contref) are not supported in the wasmi runtime. \
                        For stack switching support, use the wasmtime runtime by enabling the 'wasmtime' feature.")
            }
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<ValueTy> for wasmtime::ValType {
    fn from(value: ValueTy) -> Self {
        match value {
            ValueTy::i32 => wasmtime::ValType::I32,
            ValueTy::i64 => wasmtime::ValType::I64,
            ValueTy::f32 => wasmtime::ValType::F32,
            ValueTy::f64 => wasmtime::ValType::F64,
            ValueTy::v128 => wasmtime::ValType::V128,
            ValueTy::funcRef => wasmtime::ValType::FUNCREF,
            ValueTy::externRef => wasmtime::ValType::EXTERNREF,
            ValueTy::anyRef => wasmtime::ValType::ANYREF,
            ValueTy::eqRef => wasmtime::ValType::EQREF,
            ValueTy::i31Ref => wasmtime::ValType::I31REF,
            ValueTy::structRef => wasmtime::ValType::STRUCTREF,
            ValueTy::arrayRef => wasmtime::ValType::ARRAYREF,
            ValueTy::exnRef => wasmtime::ValType::EXNREF,
            ValueTy::contRef => wasmtime::ValType::CONTREF,
        }
    }
}

#[derive(Debug)]
pub struct ModuleImport {
    pub module: String,
    pub name: String,
    pub value: ExternalValue,
}

/// The type of an external (imported or exported) WASM value.
#[derive(Debug)]
pub enum ExternalType {
    /// A [FuncTy].
    Func(FuncTy),
    /// A [GlobalTy].
    Global(GlobalTy),
    /// A [TableTy].
    Table(TableTy),
    /// A [MemoryTy].
    Memory(MemoryTy),
}

#[cfg(not(feature = "wasmtime"))]
impl From<&ExternType> for ExternalType {
    fn from(import: &ExternType) -> Self {
        match import {
            ExternType::Func(f) => ExternalType::Func(f.into()),
            ExternType::Global(f) => ExternalType::Global(f.into()),
            ExternType::Table(f) => ExternalType::Table(f.into()),
            ExternType::Memory(f) => ExternalType::Memory(f.into()),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::ExternType> for ExternalType {
    fn from(import: &wasmtime::ExternType) -> Self {
        match import {
            wasmtime::ExternType::Func(f) => ExternalType::Func(f.into()),
            wasmtime::ExternType::Global(f) => ExternalType::Global(f.into()),
            wasmtime::ExternType::Table(f) => ExternalType::Table(f.into()),
            wasmtime::ExternType::Memory(f) => ExternalType::Memory(f.into()),
            // Tag type is for exception handling - treat as a function for now
            wasmtime::ExternType::Tag(_) => {
                panic!("Tag exports are not yet supported")
            }
        }
    }
}

#[derive(Debug)]
pub struct ModuleImportDesc {
    pub module: String,
    pub name: String,
    pub ty: ExternalType,
}

#[cfg(not(feature = "wasmtime"))]
impl From<&ImportType<'_>> for ModuleImportDesc {
    fn from(import: &ImportType) -> Self {
        ModuleImportDesc {
            module: import.module().to_string(),
            name: import.name().to_string(),
            ty: import.ty().into(),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::ImportType<'_>> for ModuleImportDesc {
    fn from(import: &wasmtime::ImportType) -> Self {
        ModuleImportDesc {
            module: import.module().to_string(),
            name: import.name().to_string(),
            ty: (&import.ty()).into(),
        }
    }
}

#[derive(Debug)]
pub struct FuncTy {
    /// The number of function parameters.
    pub parameters: Vec<ValueTy>,
    /// The ordered and merged parameter and result types of the function type.]
    pub results: Vec<ValueTy>,
}

#[cfg(not(feature = "wasmtime"))]
impl From<&FuncType> for FuncTy {
    fn from(func: &FuncType) -> Self {
        FuncTy {
            parameters: func.params().iter().map(ValueTy::from).collect(),
            results: func.results().iter().map(ValueTy::from).collect(),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::FuncType> for FuncTy {
    fn from(func: &wasmtime::FuncType) -> Self {
        FuncTy {
            parameters: func.params().map(|a| ValueTy::from(&a)).collect(),
            results: func.results().map(|a| ValueTy::from(&a)).collect(),
        }
    }
}

#[allow(dead_code)]
pub enum ParallelExec {
    Ok(Vec<WasmVal>),
    Err(String),
    Call(FunctionCall),
}

pub struct FunctionCall {
    pub args: Vec<WasmVal>,
    pub function_id: u32,
    pub function_pointer: usize,
    pub num_results: usize,
    pub worker_index: usize,
}

#[derive(Debug)]
pub struct ModuleExportDesc {
    pub name: String,
    pub ty: ExternalType,
}

#[cfg(not(feature = "wasmtime"))]
impl From<&ExportType<'_>> for ModuleExportDesc {
    fn from(export: &ExportType) -> Self {
        ModuleExportDesc {
            name: export.name().to_string(),
            ty: export.ty().into(),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::ExportType<'_>> for ModuleExportDesc {
    fn from(export: &wasmtime::ExportType) -> Self {
        ModuleExportDesc {
            name: export.name().to_string(),
            ty: (&export.ty()).into(),
        }
    }
}

#[derive(Debug)]
pub struct ModuleExportValue {
    pub desc: ModuleExportDesc,
    pub value: ExternalValue,
}

impl ModuleExportValue {
    #[cfg(not(feature = "wasmtime"))]
    pub fn from_export<T>(export: Export, store: &Store<T>) -> Self {
        ModuleExportValue {
            desc: ModuleExportDesc {
                name: export.name().to_string(),
                ty: (&export.ty(store)).into(),
            },
            value: export.into_extern().into(),
        }
    }

    #[cfg(feature = "wasmtime")]
    pub fn from_export(
        export: (String, wasmtime::Extern),
        store: impl wasmtime::AsContext,
    ) -> Self {
        ModuleExportValue {
            desc: ModuleExportDesc {
                name: export.0,
                ty: (&export.1.ty(store)).into(),
            },
            value: export.1.into(),
        }
    }
}

#[derive(Debug)]
pub enum ExternalValue {
    Func(RustOpaque<WFunc>),
    Global(RustOpaque<WGlobal>),
    Table(RustOpaque<WTable>),
    Memory(RustOpaque<WMemory>),
    SharedMemory(crate::api::WasmRunSharedMemory),
}

#[cfg(not(feature = "wasmtime"))]
impl From<Extern> for ExternalValue {
    fn from(extern_: Extern) -> Self {
        match extern_ {
            Extern::Func(f) => ExternalValue::Func(RustOpaque::new(f.into())),
            Extern::Global(g) => ExternalValue::Global(RustOpaque::new(g.into())),
            Extern::Table(t) => ExternalValue::Table(RustOpaque::new(t.into())),
            Extern::Memory(m) => ExternalValue::Memory(RustOpaque::new(m.into())),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::Extern> for ExternalValue {
    fn from(extern_: wasmtime::Extern) -> Self {
        match extern_ {
            wasmtime::Extern::Func(f) => ExternalValue::Func(RustOpaque::new(f.into())),
            wasmtime::Extern::Global(g) => ExternalValue::Global(RustOpaque::new(g.into())),
            wasmtime::Extern::Table(t) => ExternalValue::Table(RustOpaque::new(t.into())),
            wasmtime::Extern::Memory(m) => ExternalValue::Memory(RustOpaque::new(m.into())),
            wasmtime::Extern::SharedMemory(m) => ExternalValue::SharedMemory(m.into()),
            // Tag type is for exception handling - not yet supported
            wasmtime::Extern::Tag(_) => {
                panic!("Tag exports are not yet supported")
            }
        }
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<&ExternalValue> for Extern {
    fn from(e: &ExternalValue) -> Extern {
        match e {
            ExternalValue::Func(f) => Extern::Func(f.func_wasmi),
            ExternalValue::Global(g) => Extern::Global(g.inner),
            ExternalValue::Table(t) => Extern::Table(t.inner),
            ExternalValue::Memory(m) => Extern::Memory(m.inner),
            ExternalValue::SharedMemory(_) => unreachable!(),
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&ExternalValue> for wasmtime::Extern {
    fn from(e: &ExternalValue) -> wasmtime::Extern {
        match e {
            ExternalValue::Func(f) => wasmtime::Extern::Func(f.func_wasmtime),
            ExternalValue::Global(g) => wasmtime::Extern::Global(g.inner),
            ExternalValue::Table(t) => wasmtime::Extern::Table(t.inner),
            ExternalValue::Memory(m) => wasmtime::Extern::Memory(m.inner),
            ExternalValue::SharedMemory(m) => {
                wasmtime::Extern::SharedMemory(m.0.read().unwrap().inner.clone())
            }
        }
    }
}

#[derive(Debug)]
pub struct TableArgs {
    /// The minimum number of elements the [`Table`] must have.
    pub minimum: u32,
    /// The optional maximum number of elements the [`Table`] can have.
    ///
    /// If this is `None` then the [`Table`] is not limited in size.
    pub maximum: Option<u32>,
}

#[derive(Debug)]
pub struct MemoryTy {
    /// Whether or not this memory could be shared between multiple processes.
    pub shared: bool,
    /// The number of initial pages associated with the memory.
    pub minimum: u32,
    /// The maximum number of pages this memory can have.
    pub maximum: Option<u32>,
}

impl MemoryTy {
    #[cfg(not(feature = "wasmtime"))]
    pub fn to_memory_type(&self) -> Result<MemoryType> {
        // wasmi 1.0: MemoryType::new doesn't return Result
        Ok(MemoryType::new(self.minimum, self.maximum))
    }

    #[cfg(feature = "wasmtime")]
    pub fn to_memory_type(&self) -> Result<wasmtime::MemoryType> {
        if self.shared {
            return Ok(wasmtime::MemoryType::shared(
                self.minimum,
                self.maximum.ok_or(anyhow::anyhow!(
                    "maximum_pages is required for shared memories"
                ))?,
            ));
        }
        Ok(wasmtime::MemoryType::new(self.minimum, self.maximum))
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<&MemoryType> for MemoryTy {
    fn from(memory_type: &MemoryType) -> Self {
        MemoryTy {
            // wasmi 1.0: minimum/maximum return u64, renamed from initial_pages/maximum_pages
            minimum: memory_type.minimum() as u32,
            maximum: memory_type.maximum().map(|v| v as u32),
            shared: false,
        }
    }
}

#[cfg(feature = "wasmtime")]
impl From<&wasmtime::MemoryType> for MemoryTy {
    fn from(memory_type: &wasmtime::MemoryType) -> Self {
        MemoryTy {
            minimum: memory_type.minimum().try_into().unwrap(),
            maximum: memory_type.maximum().map(|v| v.try_into().unwrap()),
            shared: memory_type.is_shared(),
        }
    }
}

pub struct PointerAndLength {
    pub pointer: usize,
    pub length: usize,
}

pub fn to_anyhow<T: Display>(value: T) -> anyhow::Error {
    anyhow::Error::msg(value.to_string())
}
