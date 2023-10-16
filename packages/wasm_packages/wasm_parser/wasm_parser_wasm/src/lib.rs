use std::fmt::Display;

// Use a procedural macro to generate bindings for the world we specified in `wasm-parser.wit`
wit_bindgen::generate!("wasm-parser");

// Define a custom type and implement the generated trait for it which represents
// implementing all the necessary exported interfaces for this component.
struct WitImplementation;

export_wasm_parser!(WitImplementation);

fn map_error<E: Display>(e: E) -> String {
    e.to_string()
}

impl WasmInput {
    fn to_bytes(self) -> Result<Vec<u8>, String> {
        match self {
            WasmInput::Binary(bytes) => Ok(bytes),
            WasmInput::FilePath(path) => std::fs::read(path).map_err(map_error),
        }
    }
}

impl WasmParser for WitImplementation {
    fn wasm2wasm_component(
        input: WasmInput,
        // TODO: add support for wit embed
        _wit: Option<String>,
        adapters: Vec<ComponentAdapter>,
    ) -> Result<Vec<u8>, String> {
        let validate = false;
        let bytes = input.to_bytes()?;
        let mut encoder = wit_component::ComponentEncoder::default()
            .validate(validate)
            .module(&bytes)
            .map_err(map_error)?;
        for ComponentAdapter { name, wasm } in adapters.into_iter() {
            let bytes = wasm.to_bytes()?;
            encoder = encoder.adapter(&name, &bytes).map_err(map_error)?;
        }
        encoder.encode().map_err(map_error)
    }

    fn wasm_component2wit(input: WasmInput) -> Result<String, String> {
        let bytes = input.to_bytes()?;
        let decoded = decode_wasm(&bytes).map_err(map_error)?;
        wit_component::WitPrinter::default()
            .print(decoded.resolve(), decoded.package())
            .map_err(map_error)
    }

    fn wat2wasm(input: WatInput) -> Result<Vec<u8>, String> {
        match input {
            WatInput::Text(wat) => wat::parse_str(&wat).map_err(map_error),
            WatInput::Binary(wat) => {
                let wasm = wat::parse_bytes(&wat).map_err(map_error)?;
                Ok(wasm.into_owned())
            }
            WatInput::FilePath(path) => wat::parse_file(&path).map_err(map_error),
        }
    }

    fn wasm2wat(input: WasmInput) -> Result<String, String> {
        match input {
            WasmInput::Binary(wat) => wasmprinter::print_bytes(&wat).map_err(map_error),
            WasmInput::FilePath(path) => wasmprinter::print_file(&path).map_err(map_error),
        }
    }

    fn parse_wat(input: WatInput) -> Result<WasmType, String> {
        WitImplementation::wat2wasm(input)
            .and_then(|bytes| WitImplementation::parse_wasm(WasmInput::Binary(bytes)))
    }

    fn parse_wasm(input: WasmInput) -> Result<WasmType, String> {
        let bytes = input.to_bytes()?;
        let types = wasmparser::Validator::new_with_features(features_all_true())
            .validate_all(&bytes)
            .map_err(map_error)?;
        to_wasm_type(&types, bytes)
    }

    fn default_wasm_features() -> WasmFeatures {
        map_parser_features(wasmparser::WasmFeatures::default())
    }

    fn validate_wasm(input: WasmInput, features: Option<WasmFeatures>) -> Result<WasmType, String> {
        let bytes = input.to_bytes()?;
        let types = if let Some(features) = features {
            let mapped_features = map_features(features);
            wasmparser::Validator::new_with_features(mapped_features)
                .validate_all(&bytes)
                .map_err(map_error)?
        } else {
            wasmparser::validate(&bytes).map_err(map_error)?
        };
        to_wasm_type(&types, bytes)
    }

    // wasm_compose::composer::ComponentComposer::new(
    //     &"component",
    //     &wasm_compose::config::Config::default(),
    // );
    // let bytes = input.to_bytes()?;
    // let decoded = wit_component::decode(&bytes).map_err(map_error)?;
    // wit_component::encode(decoded.resolve(), decoded.package()).map_err(map_error)
}

fn to_wasm_type(types: &wasmparser::types::Types, bytes: Vec<u8>) -> Result<WasmType, String> {
    use wasmparser::Payload;
    let parser = TypeParser { types: &types };

    if types.type_at(0, true).is_none() {
        // Component Model
        let mut modules = Vec::new();

        for i in 0..types.module_count() {
            let mut module_type = ModuleType {
                imports: Vec::new(),
                exports: Vec::new(),
            };

            let module = types.module_at(i as u32).unwrap();
            module
                .imports
                .iter()
                .for_each(|((module_name, name), entity)| {
                    let mapped = parser.map_type(entity);
                    let import = ModuleImport {
                        module: module_name.to_string(),
                        name: name.to_string(),
                        type_: mapped,
                    };
                    module_type.imports.push(import);
                });
            module.exports.iter().for_each(|(name, entity)| {
                let mapped = parser.map_type(entity);
                let export = ModuleExport {
                    name: name.to_string(),
                    type_: mapped,
                };
                module_type.exports.push(export);
            });

            modules.push(module_type);
        }

        return Ok(WasmType::ComponentType(ComponentType { modules }));
    }

    let mut module = ModuleType {
        imports: Vec::new(),
        exports: Vec::new(),
    };
    for payload in wasmparser::Parser::new(0).parse_all(&bytes) {
        match payload.map_err(map_error)? {
            Payload::ExportSection(s) => {
                for export in s {
                    let export = export.map_err(map_error)?;
                    let mapped = parser.map_export(export);
                    module.exports.push(mapped);
                }
            }
            Payload::ImportSection(s) => {
                for import in s {
                    let import = import.map_err(map_error)?;
                    let mapped = parser.map_import(import);
                    module.imports.push(mapped);
                }
            }
            // Payload::TypeSection(s) => ,
            // Payload::FunctionSection(s) => ,
            // Payload::TableSection(s) => ,
            // Payload::MemorySection(s) => ,
            // Payload::TagSection(s) => ,
            // Payload::GlobalSection(s) => ,
            _other => {}
        }
    }

    Ok(WasmType::ModuleType(module))
}

fn decode_wasm(bytes: &[u8]) -> Result<wit_component::DecodedWasm, String> {
    if wasmparser::Parser::is_component(bytes) {
        wit_component::decode(bytes).map_err(map_error)
    } else {
        let (_wasm, bindgen) = wit_component::metadata::decode(bytes).map_err(map_error)?;
        Ok(wit_component::DecodedWasm::Component(
            bindgen.resolve,
            bindgen.world,
        ))
    }
}

fn map_features(features: WasmFeatures) -> wasmparser::WasmFeatures {
    wasmparser::WasmFeatures {
        bulk_memory: features.bulk_memory,
        multi_value: features.multi_value,
        simd: features.simd,
        threads: features.threads,
        reference_types: features.reference_types,
        tail_call: features.tail_call,
        multi_memory: features.multi_memory,
        memory64: features.memory64,
        exceptions: features.exceptions,
        sign_extension: features.sign_extension,
        function_references: features.function_references,
        gc: features.gc,
        component_model: features.component_model,
        extended_const: features.extended_const,
        floats: features.floats,
        memory_control: features.memory_control,
        mutable_global: features.mutable_global,
        relaxed_simd: features.relaxed_simd,
        saturating_float_to_int: features.saturating_float_to_int,
    }
}

fn map_parser_features(features: wasmparser::WasmFeatures) -> WasmFeatures {
    WasmFeatures {
        bulk_memory: features.bulk_memory,
        multi_value: features.multi_value,
        simd: features.simd,
        threads: features.threads,
        reference_types: features.reference_types,
        tail_call: features.tail_call,
        multi_memory: features.multi_memory,
        memory64: features.memory64,
        exceptions: features.exceptions,
        sign_extension: features.sign_extension,
        function_references: features.function_references,
        gc: features.gc,
        component_model: features.component_model,
        extended_const: features.extended_const,
        floats: features.floats,
        memory_control: features.memory_control,
        mutable_global: features.mutable_global,
        relaxed_simd: features.relaxed_simd,
        saturating_float_to_int: features.saturating_float_to_int,
    }
}

fn features_all_true() -> wasmparser::WasmFeatures {
    wasmparser::WasmFeatures {
        mutable_global: true,
        saturating_float_to_int: true,
        sign_extension: true,
        reference_types: true,
        multi_value: true,
        bulk_memory: true,
        simd: true,
        relaxed_simd: true,
        threads: true,
        tail_call: true,
        floats: true,
        multi_memory: true,
        exceptions: true,
        memory64: true,
        extended_const: true,
        component_model: true,
        function_references: true,
        memory_control: true,
        gc: true,
    }
}

struct TypeParser<'a> {
    types: &'a wasmparser::types::Types,
}

impl<'a> TypeParser<'a> {
    fn map_export(&self, export: wasmparser::Export) -> ModuleExport {
        let entity = self.types.entity_type_from_export(&export).unwrap();
        let mapped = self.map_type(&entity);
        ModuleExport {
            name: export.name.to_string(),
            type_: mapped,
        }
    }

    fn map_import(&self, import: wasmparser::Import) -> ModuleImport {
        let entity = self.types.entity_type_from_import(&import).unwrap();
        let mapped = self.map_type(&entity);
        ModuleImport {
            module: import.module.to_string(),
            name: import.name.to_string(),
            type_: mapped,
        }
    }

    fn map_type(&self, ty: &wasmparser::types::EntityType) -> ExternType {
        use wasmparser::types::EntityType;
        match ty {
            EntityType::Func(id) => {
                let ty = self
                    .types
                    .type_from_id(*id)
                    .unwrap()
                    .as_func_type()
                    .unwrap();
                ExternType::FunctionType(FunctionType {
                    parameters: ty
                        .params()
                        .iter()
                        .cloned()
                        .map(|p| self.map_val_type(p))
                        .collect(),
                    results: ty
                        .results()
                        .iter()
                        .cloned()
                        .map(|p| self.map_val_type(p))
                        .collect(),
                })
            }
            EntityType::Table(ty) => ExternType::TableType(TableType {
                element: self.map_ref_type(ty.element_type),
                maximum: ty.maximum,
                minimum: ty.initial,
            }),
            EntityType::Memory(ty) => ExternType::MemoryType(MemoryType {
                memory64: ty.memory64,
                maximum: ty.maximum,
                minimum: ty.initial,
                shared: ty.shared,
            }),
            EntityType::Global(ty) => ExternType::GlobalType(GlobalType {
                mutable: ty.mutable,
                value: self.map_val_type(ty.content_type),
            }),
            EntityType::Tag(id) => {
                let kind = wasmparser::TagKind::Exception;
                let kind = match kind {
                    wasmparser::TagKind::Exception => TagKind::Exception,
                };
                ExternType::TagType(TagType {
                    kind,
                    function_type: match self.map_type(&EntityType::Func(*id)) {
                        ExternType::FunctionType(ty) => ty,
                        _ => unreachable!(),
                    },
                })
            }
        }
    }

    fn map_val_type(&self, ty: wasmparser::ValType) -> ValueType {
        match ty {
            wasmparser::ValType::I32 => ValueType::I32,
            wasmparser::ValType::I64 => ValueType::I64,
            wasmparser::ValType::F32 => ValueType::F32,
            wasmparser::ValType::F64 => ValueType::F64,
            wasmparser::ValType::V128 => ValueType::V128,
            wasmparser::ValType::Ref(ty) => ValueType::Ref(self.map_ref_type(ty)),
        }
    }

    fn map_ref_type(&self, ty: wasmparser::RefType) -> RefType {
        RefType {
            heap_type: self.map_heap_type(ty.heap_type()),
            nullable: ty.is_nullable(),
        }
    }

    fn map_heap_type(&self, heap_type: wasmparser::HeapType) -> HeapType {
        match heap_type {
            wasmparser::HeapType::Indexed(index) => HeapType::Indexed(index),
            wasmparser::HeapType::Func => HeapType::Func,
            wasmparser::HeapType::Extern => HeapType::Extern,
            wasmparser::HeapType::Any => HeapType::Any,
            wasmparser::HeapType::None => HeapType::None,
            wasmparser::HeapType::NoExtern => HeapType::NoExtern,
            wasmparser::HeapType::NoFunc => HeapType::NoFunc,
            wasmparser::HeapType::Eq => HeapType::Eq,
            wasmparser::HeapType::Struct => HeapType::Struct,
            wasmparser::HeapType::Array => HeapType::Array,
            wasmparser::HeapType::I31 => HeapType::I31,
        }
    }
}
