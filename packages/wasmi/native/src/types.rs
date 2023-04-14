use std::fmt::Display;

use crate::bridge_generated::{wire_ExternalValue, NewWithNullPtr};
use anyhow::Result;
use flutter_rust_bridge::{frb, RustOpaque};

pub use wasmi::{core::Pages, Func, Global, GlobalType, Memory, Mutability, Table};
use wasmi::{core::ValueType, *};

// #[frb(mirror(Value))]
#[derive(Debug)]
pub enum Value2 {
    /// Value of 32-bit signed or unsigned integer.
    I32(i32),
    /// Value of 64-bit signed or unsigned integer.
    I64(i64),
    /// Value of 32-bit IEEE 754-2008 floating point number.
    F32(f32),
    /// Value of 64-bit IEEE 754-2008 floating point number.
    F64(f64),
    /// A nullable [`Func`][`crate::Func`] reference, a.k.a. [`FuncRef`].
    FuncRef(Option<RustOpaque<Func>>), // NonZeroU32
    /// A nullable external object reference, a.k.a. [`ExternRef`].
    ExternRef(u32), // NonZeroU32
}

impl Value2 {
    // TODO: we should probably take ownership of self
    pub fn to_value<T>(&self, ctx: &mut Store<T>) -> Value {
        match self {
            Value2::I32(i) => Value::I32(*i),
            Value2::I64(i) => Value::I64(*i),
            Value2::F32(i) => Value::F32(i.to_bits().into()),
            Value2::F64(i) => Value::F64(i.to_bits().into()),
            Value2::FuncRef(i) => {
                let inner = i.as_ref().map(|f| f.clone().try_unwrap().unwrap());
                Value::FuncRef(FuncRef::new(inner))
            }
            Value2::ExternRef(i) => Value::ExternRef(ExternRef::new::<u32>(ctx, Some(*i))),
        }
    }

    pub fn from_value<'a, T: 'a>(value: &Value, ctx: impl Into<StoreContext<'a, T>>) -> Self {
        match value {
            Value::I32(i) => Value2::I32(*i),
            Value::I64(i) => Value2::I64(*i),
            Value::F32(i) => Value2::F32(i.to_float()),
            Value::F64(i) => Value2::F64(i.to_float()),
            Value::FuncRef(i) => Value2::FuncRef(i.func().map(|f| RustOpaque::new(*f))), // NonZeroU32::new(1).unwrap()),
            Value::ExternRef(i) => {
                Value2::ExternRef(*(i.data(ctx).unwrap().downcast_ref::<u32>().unwrap()))
            } // NonZeroU32::new(1).unwrap()),
        }
    }
}

#[derive(Debug)]
pub struct GlobalTy {
    /// The value type of the global variable.
    pub content: ValueTy,
    /// The mutability of the global variable.
    pub mutability: Mutability,
}

impl From<&GlobalType> for GlobalTy {
    fn from(value: &GlobalType) -> Self {
        GlobalTy {
            content: (&value.content()).into(),
            mutability: value.mutability(),
        }
    }
}

#[derive(Debug)]
pub struct TableTy {
    /// The type of values stored in the [`Table`].
    pub element: ValueTy,
    /// The minimum number of elements the [`Table`] must have.
    pub min: u32,
    /// The optional maximum number of elements the [`Table`] can have.
    ///
    /// If this is `None` then the [`Table`] is not limited in size.
    pub max: Option<u32>,
}

impl From<&TableType> for TableTy {
    fn from(value: &TableType) -> Self {
        TableTy {
            element: (&value.element()).into(),
            min: value.minimum(),
            max: value.maximum(),
        }
    }
}

#[derive(Debug)]
pub enum ValueTy {
    /// 32-bit signed or unsigned integer.
    I32,
    /// 64-bit signed or unsigned integer.
    I64,
    /// 32-bit IEEE 754-2008 floating point number.
    F32,
    /// 64-bit IEEE 754-2008 floating point number.
    F64,
    /// A nullable function reference.
    FuncRef,
    /// A nullable external reference.
    ExternRef,
}

impl From<&ValueType> for ValueTy {
    fn from(value: &ValueType) -> Self {
        match value {
            ValueType::I32 => ValueTy::I32,
            ValueType::I64 => ValueTy::I64,
            ValueType::F32 => ValueTy::F32,
            ValueType::F64 => ValueTy::F64,
            ValueType::FuncRef => ValueTy::FuncRef,
            ValueType::ExternRef => ValueTy::ExternRef,
        }
    }
}

impl From<ValueTy> for ValueType {
    fn from(value: ValueTy) -> Self {
        match value {
            ValueTy::I32 => ValueType::I32,
            ValueTy::I64 => ValueType::I64,
            ValueTy::F32 => ValueType::F32,
            ValueTy::F64 => ValueType::F64,
            ValueTy::FuncRef => ValueType::FuncRef,
            ValueTy::ExternRef => ValueType::ExternRef,
        }
    }
}

pub struct ModuleImport {
    pub module: String,
    pub name: String,
    pub value: ExternalValue,
}

#[frb(mirror(Mutability))]
pub enum _Mutability {
    /// The value of the global variable is a constant.
    Const,
    /// The value of the global variable is mutable.
    Var,
}

#[derive(Debug)]
pub enum ExternalType {
    Func(FuncTy),
    Global(GlobalTy),
    Table(TableTy),
    Memory(WasmMemoryType),
}

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

#[derive(Debug)]
pub struct ModuleImportDesc {
    pub module: String,
    pub name: String,
    pub ty: ExternalType,
}

impl From<&ImportType<'_>> for ModuleImportDesc {
    fn from(import: &ImportType) -> Self {
        ModuleImportDesc {
            module: import.module().to_string(),
            name: import.name().to_string(),
            ty: import.ty().into(),
        }
    }
}

#[derive(Debug)]
pub struct FuncTy {
    /// The number of function parameters.
    pub params: Vec<ValueTy>,
    /// The ordered and merged parameter and result types of the function type.]
    pub results: Vec<ValueTy>,
}

impl From<&FuncType> for FuncTy {
    fn from(func: &FuncType) -> Self {
        FuncTy {
            params: func.params().iter().map(ValueTy::from).collect(),
            results: func.results().iter().map(ValueTy::from).collect(),
        }
    }
}

#[derive(Debug)]
pub struct ModuleExportDesc {
    pub name: String,
    pub ty: ExternalType,
}

impl From<&ExportType<'_>> for ModuleExportDesc {
    fn from(export: &ExportType) -> Self {
        ModuleExportDesc {
            name: export.name().to_string(),
            ty: export.ty().into(),
        }
    }
}

#[derive(Debug)]
pub struct ModuleExportValue {
    pub desc: ModuleExportDesc,
    pub value: ExternalValue,
}

impl ModuleExportValue {
    pub fn from_export<T>(export: Export, store: &Store<T>) -> Self {
        ModuleExportValue {
            desc: ModuleExportDesc {
                name: export.name().to_string(),
                ty: (&export.ty(store)).into(),
            },
            value: export.into_extern().into(),
        }
    }
}

#[derive(Debug)]
pub enum ExternalValue {
    Func(RustOpaque<Func>),
    Global(RustOpaque<Global>),
    Table(RustOpaque<Table>),
    Memory(RustOpaque<Memory>),
}

impl Default for wire_ExternalValue {
    fn default() -> Self {
        wire_ExternalValue::new_with_null_ptr()
    }
}

impl From<Extern> for ExternalValue {
    fn from(extern_: Extern) -> Self {
        match extern_ {
            Extern::Func(f) => ExternalValue::Func(RustOpaque::new(f)),
            Extern::Global(g) => ExternalValue::Global(RustOpaque::new(g)),
            Extern::Table(t) => ExternalValue::Table(RustOpaque::new(t)),
            Extern::Memory(m) => ExternalValue::Memory(RustOpaque::new(m)),
        }
    }
}

impl From<&ExternalValue> for Extern {
    fn from(e: &ExternalValue) -> Extern {
        match e {
            ExternalValue::Func(f) => Extern::Func(**f),
            ExternalValue::Global(g) => Extern::Global(**g),
            ExternalValue::Table(t) => Extern::Table(**t),
            ExternalValue::Memory(m) => Extern::Memory(**m),
        }
    }
    // fn to_extern<T>(&self, store: &mut Store<T>) -> Result<Extern> {
    //     match self {
    //         ExternalValue::Global { value, mutability } => {
    //             let mapped = value.to_value(store);
    //             let global = Global::new(store, mapped, *mutability);
    //             Ok(Extern::Global(global))
    //         }
    //         ExternalValue::Table { value, ty } => {
    //             let mapped_value = value.to_value(store);
    //             let table = Table::new(
    //                 store,
    //                 TableType::new(mapped_value.ty(), ty.min, ty.max),
    //                 mapped_value,
    //             )
    //             .map_err(to_anyhow)?;
    //             Ok(Extern::Table(table))
    //         }
    //         ExternalValue::Memory { ty } => {
    //             let memory = Memory::new(store, ty.to_memory_type()?).map_err(to_anyhow)?;
    //             Ok(Extern::Memory(memory))
    //         }
    //         ExternalValue::Func { pointer } => {
    //             let f: wasm_func = unsafe { std::mem::transmute(*pointer) };
    //             // TODO: let func = Func::wrap(store, f);
    //             let func = Func::wrap(store, || {});
    //             Ok(Extern::Func(func))
    //         }
    //     }
    // }
}

#[derive(Debug)]
pub struct TableType2 {
    /// The minimum number of elements the [`Table`] must have.
    pub min: u32,
    /// The optional maximum number of elements the [`Table`] can have.
    ///
    /// If this is `None` then the [`Table`] is not limited in size.
    pub max: Option<u32>,
}

#[derive(Debug)]
pub struct WasmMemoryType {
    pub initial_pages: u32,
    pub maximum_pages: Option<u32>,
}

impl WasmMemoryType {
    pub fn to_memory_type(&self) -> Result<MemoryType> {
        MemoryType::new(self.initial_pages, self.maximum_pages).map_err(to_anyhow)
    }
}

impl From<&MemoryType> for WasmMemoryType {
    fn from(memory_type: &MemoryType) -> Self {
        WasmMemoryType {
            initial_pages: memory_type.initial_pages().into(),
            maximum_pages: memory_type.maximum_pages().map(|v| v.into()),
        }
    }
}

pub fn to_anyhow<T: Display>(value: T) -> anyhow::Error {
    anyhow::Error::msg(value.to_string())
}
