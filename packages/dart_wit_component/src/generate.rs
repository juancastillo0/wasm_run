use crate::{
    function::FuncKind, strings::Normalize, types::*, Int64TypeConfig, WitGeneratorConfig,
};
use std::collections::{HashMap, HashSet};
use wit_parser::*;

pub fn document_to_dart(
    parsed: &UnresolvedPackage,
    config: WitGeneratorConfig,
) -> Result<String, String> {
    let mut s = String::new();

    s.push_str(&format!(
        "{HEADER}{}",
        config.file_header.as_deref().unwrap_or("")
    ));

    let mut resolve = Resolve::new();
    resolve
        .push(parsed.clone())
        .map_err(|err| err.to_string())?;

    let names = HashMap::<&str, Vec<&TypeDef>>::new();
    let unions = HashMap::<String, Vec<String>>::new();
    let mut p = Parsed(&resolve, names, config, unions);

    // parsed.documents
    // parsed.foreign_deps
    // parsed.interfaces
    // parsed.types

    resolve.types.iter().for_each(|(_id, ty)| {
        if matches!(ty.kind, TypeDefKind::Type(_)) {
            return;
        }
        if let Some(name) = &ty.name {
            let entry = p.1.entry(name);
            entry.or_insert(vec![]).push(ty);
        }
    });
    p.1.retain(|_k, v| v.len() > 1);

    if p.2.same_class_union {
        // Find all unions
        resolve.types.iter().for_each(|(_id, ty)| {
            if let TypeDefKind::Union(union) = &ty.kind {
                let union_name = p.type_def_to_name_definition(ty).unwrap();
                union.cases.iter().for_each(|case| {
                    if let (Some(_), Type::Id(id)) = (p.type_class_name(&case.ty), case.ty) {
                        let case_ty = resolve.types.get(id).unwrap();
                        if let Some(name) = p.type_def_to_name_definition(case_ty) {
                            let implements = p.3.entry(name).or_default();
                            implements.push(union_name.clone());
                        }
                    }
                });
            }
        });
    }
    resolve.types.iter().for_each(|(id, ty)| {
        let docs = &ty.docs;
        if let (TypeDefKind::Type(ty), Some(name)) =
            (&ty.kind, p.type_def_to_name_definition(ty).as_ref())
        {
            // Renamed imports and typedefs
            if let Type::Id(ref_id) = ty {
                let ty = resolve.types.get(*ref_id).unwrap();
                if let Some(ref_name) = p.type_def_to_name_definition(ty).as_ref() {
                    if ref_name != name {
                        add_docs(&mut s, docs);
                        s.push_str(&format!("typedef {name} = {ref_name};"));
                    }
                }
            } else {
                let ref_name = p.type_to_str(ty);
                add_docs(&mut s, docs);
                s.push_str(&format!("typedef {name} = {ref_name};"));
            }
            return;
        }
        let definition = p.type_def_to_definition(&id, ty);

        if !definition.is_empty() {
            s.push_str(&definition);
            s.push_str("\n");
        }
    });

    resolve.worlds.iter().for_each(|(_id, w)| {
        let w_name = heck::AsPascalCase(&w.name);
        let mut func_imports = String::new();
        let mut world_resource_finalizer = String::new();
        // Imports Interfaces as Dart classes
        p.add_interfaces(
            &mut s,
            &mut w.imports.iter(),
            false,
            Some(&mut func_imports),
        );
        let mut interfaces = HashSet::<InterfaceId>::new();
        w.exports.iter().for_each(|(k, _v)| {
            if let WorldKey::Interface(i) = k {
                interfaces.insert(*i);
            }
        });
        resolve
            .types
            .iter()
            .for_each(|(__id, ty)| match (&ty.owner, &ty.kind) {
                (TypeOwner::World(w_id), TypeDefKind::Resource) if _id == *w_id => {
                    let resource_name = p.type_def_to_name_definition(ty).unwrap();
                    let resource_name_var = resource_name.as_var();
                    world_resource_finalizer.push_str(&format!(
                        "late final _{resource_name_var}Finalizer = Finalizer<int>(
                      (i) => canon_resource_drop(library.componentInstance, {resource_name}._spec, i),
                    );"
                    ));
                    func_imports.push_str(&format!(
                        "builder.addImports(resourceImports(getLib, {resource_name}._spec));"
                    ));
                }
                (TypeOwner::Interface(i_id), TypeDefKind::Resource)
                    if interfaces.contains(i_id) =>
                {
                    let resource_name = p.type_def_to_name_definition(ty).unwrap();
                    let resource_name_var = resource_name.as_var();
                    world_resource_finalizer.push_str(&format!(
                        "late final _{resource_name_var}Finalizer = Finalizer<int>(
                      (i) => canon_resource_drop(library.componentInstance, {resource_name}._spec, i),
                    );"
                    ));
                    func_imports.push_str(&format!(
                        "builder.addImports(resourceImports(getLib, {resource_name}._spec));"
                    ));
                }
                _ => (),
            });
        // World Imports
        s.push_str(&format!("class {w_name}WorldImports {{"));
        if w.imports.is_empty() {
            s.push_str(&format!("const {w_name}WorldImports();"));
        } else {
            let mut constructor = format!("const {w_name}WorldImports({{",);
            w.imports.iter().for_each(|(key, i)| {
                let id = p.world_key_type_name(key);
                let id_name = id.as_var();
                match i {
                    WorldItem::Interface(interface_id) => {
                        let interface = p.0.interfaces.get(*interface_id).unwrap();
                        if interface.functions.is_empty() {
                            return;
                        }
                        constructor.push_str(&format!("required this.{id_name},"));
                        s.push_str(&format!(
                            "final {}Import {id_name};",
                            heck::AsPascalCase(id)
                        ));
                    }
                    WorldItem::Type(_type_id) => {}
                    WorldItem::Function(f) => {
                        constructor.push_str(&format!("required this.{id_name},"));
                        p.add_function(&mut s, f, FuncKind::Field, false);

                        func_imports.push_str(&p.function_import(None, id, f));
                    }
                };
            });
            if constructor.ends_with("{") {
                constructor.pop();
                constructor.push_str(");");
            } else {
                constructor.push_str("});");
            }
            s.push_str(&constructor);
        }
        s.push_str("}");

        // World Exports
        //TODO: separate per document?

        p.add_interfaces(&mut s, &mut w.exports.iter(), true, None);

        add_docs(&mut s, &w.docs);
        s.push_str(&format!(
            "class {w_name}World {{
            final {w_name}WorldImports imports;
            final WasmLibrary library;
            {world_resource_finalizer}",
        ));
        let mut constructor: Vec<String> = vec![];
        let mut constructor_body: Vec<String> = vec![];
        let mut methods = String::new();
        w.exports.iter().for_each(|(key, i)| {
            let id = p.world_key_type_name(key);
            let id_name = id.as_var();
            match i {
                WorldItem::Interface(_interface_id) => {
                    constructor_body.push(format!("{id_name} = {}(this);", heck::AsPascalCase(id)));
                    s.push_str(&format!("late final {} {id_name};", heck::AsPascalCase(id),));
                }
                WorldItem::Type(_type_id) => {}
                WorldItem::Function(f) => {
                    let fn_name = if p.2.async_worker {
                        "getComponentFunctionWorker"
                    } else {
                        "getComponentFunction"
                    };
                    constructor.push(format!(
                        "_{id_name} = library.{fn_name}('{id}', const {},)!",
                        p.function_spec(f)
                    ));
                    p.add_function(&mut methods, f, FuncKind::MethodCall, true);
                }
            };
        });

        s.push_str(&format!(
            "\n\n{w_name}World({{
            required this.imports,
            required this.library,
        }})"
        ));
        if constructor.is_empty() && constructor_body.is_empty() {
            s.push_str(";");
        } else if constructor_body.is_empty() {
                s.push_str(&format!(": {};", constructor.join(", ")));
        } else if constructor.is_empty() {
            s.push_str(&format!("{{{}}}", constructor_body.join("\n")));
        } else {
            s.push_str(&format!(
                ": {} {{{}}}",
                constructor.join(", "),
                constructor_body.join("\n")
            ));
        }
        

        let int64_type = match p.2.int64_type {
            Int64TypeConfig::BigInt => "Int64TypeConfig.bigInt",
            Int64TypeConfig::BigIntUnsignedOnly => "Int64TypeConfig.bigIntUnsignedOnly",
            Int64TypeConfig::CoreInt => "Int64TypeConfig.coreInt",
            Int64TypeConfig::NativeObject => "Int64TypeConfig.nativeObject",
        };
        let instantiate = if p.2.async_worker {
            worker_instantiation(int64_type)
        } else {
            let package = resolve.packages.get(w.package.unwrap()).unwrap();
            let component_id = format!("{}/{}", package.name, w.name);
            format!(
                "final instance = await builder.build();

library = WasmLibrary(instance, componentId: '{component_id}', int64Type: {int64_type});"
            )
        };

        s.push_str(&format!(
            "\n\nstatic Future<{w_name}World> init(
                    WasmInstanceBuilder builder, {{
                    required {w_name}WorldImports imports,
                }}) async {{
                    late final WasmLibrary library;
                    WasmLibrary getLib() => library;

                    {func_imports}
                    {instantiate}
                    return {w_name}World(imports: imports, library: library);
                }}

                static final _zoneKey = Object();
                late final _zoneValues = {{_zoneKey: this}};
                static {w_name}World? currentZoneWorld() =>
                    Zone.current[_zoneKey] as {w_name}World?;
                T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);

                {methods}
            ",
        ));
        s.push_str("}");
    });
    Ok(s)
}

fn worker_instantiation(int64_type: &str) -> String {
    format!(
        "
var memType = MemoryTy(minimum: 1, maximum: 2, shared: true);
try {{
    // Find the shared memory import. May not work in web.
    final mem = builder.module.getImports().firstWhere(
        (e) =>
            e.kind == WasmExternalKind.memory &&
            (e.type!.field0 as MemoryTy).shared,
        );
    memType = mem.type!.field0 as MemoryTy;
}} catch (_) {{}}

var attempts = 0;
late WasmSharedMemory wasmMemory;
WasmInstance? instance;
while (instance == null) {{
    try {{
        wasmMemory = builder.module.createSharedMemory(
            minPages: memType.minimum,
            maxPages: memType.maximum! > memType.minimum
                ? memType.maximum!
                : memType.minimum + 1,
        );
        builder.addImport('env', 'memory', wasmMemory);
        instance = await builder.build();
    }} catch (e) {{
        // TODO: This is not great, remove it. 
        if (identical(0, 0.0) && attempts < 2) {{
            final str = e.toString();
            final init = RegExp('initial ([0-9]+)').firstMatch(str);
            final maxi = RegExp('maximum ([0-9]+)').firstMatch(str);
            if (init != null || maxi != null) {{
                final initVal =
                    init == null ? memType.minimum : int.parse(init.group(1)!);
                final maxVal =
                    maxi == null ? memType.maximum : int.parse(maxi.group(1)!);
                memType = MemoryTy(minimum: initVal, maximum: maxVal, shared: true);
                attempts++;
                continue;
            }}
        }}
        rethrow;
    }}
}}

library = WasmLibrary(
    instance,
    int64Type: {int64_type},
    wasmMemory: wasmMemory,
);"
    )
}

pub fn add_docs(s: &mut String, docs: &Docs) {
    if let Some(docs) = extract_dart_docs(docs) {
        s.push_str(&docs);
    }
}

pub fn extract_dart_docs(docs: &Docs) -> Option<String> {
    if let Some(docs) = &docs.contents {
        let mut m = docs.clone();
        if m.ends_with('\n') {
            m.replace_range(m.len() - 1.., "");
        }

        Some(
            m.split("\n")
                .map(|l| format!("/// {}\n", l))
                .collect::<Vec<_>>()
                .join(""),
        )
    } else {
        None
    }
}

const HEADER: &str = "
// FILE GENERATED FROM WIT

// ignore: lines_longer_than_80_chars
// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion, unused_element, avoid_returning_null_for_void

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';
";

#[cfg(test)]
mod tests {
    use std::{fs::File, io::Write, path::Path};

    use crate::{Int64TypeConfig, WitGeneratorConfig};

    const PACKAGE_DIR: &str = env!("CARGO_MANIFEST_DIR");

    fn default_wit_config(int64_type: Int64TypeConfig) -> WitGeneratorConfig {
        WitGeneratorConfig {
            inputs: crate::WitGeneratorInput::FileSystemPaths(crate::FileSystemPaths {
                input_path: "".to_string(),
            }),
            copy_with: true,
            equality_and_hash_code: true,
            generate_docs: true,
            json_serialization: true,
            to_string: true,
            file_header: None,
            use_null_for_option: true,
            object_comparator: None,
            required_option: false,
            typed_number_lists: true,
            async_worker: false,
            same_class_union: true,
            int64_type,
        }
    }

    #[test]
    pub fn parse_wit() {
        let parsed = wit_parser::UnresolvedPackage::parse(
            Path::new("../wasm_wit_component/example/lib/host.wit"),
            "
default world host {
    import print: func(msg: string)

    export run: func()
}
",
        )
        .unwrap();

        let s =
            super::document_to_dart(&parsed, default_wit_config(Int64TypeConfig::BigInt)).unwrap();
        println!("{}", s);
    }

    fn parse_and_write_generation(path: &str, output_path: &str, config: WitGeneratorConfig) {
        let parsed = wit_parser::UnresolvedPackage::parse_file(Path::new(path)).unwrap();

        let s = super::document_to_dart(&parsed, config).unwrap();
        // println!("{}", s);
        File::create(output_path)
            .unwrap()
            .write(s.as_bytes())
            .unwrap();

        std::process::Command::new("dart")
            .arg("format")
            .arg(output_path)
            .output()
            .unwrap();
    }

    #[test]
    pub fn parse_wit_types() {
        let path = format!(
            "{}/wasm_wit_component/example/rust_wit_component_example/wit/types-example.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/wasm_wit_component/example/lib/types_gen.dart",
            PACKAGE_DIR
        );
        let mut config = default_wit_config(Int64TypeConfig::CoreInt);
        config.file_header = Some(
            "// CUSTOM FILE HEADER
             const objectComparator = ObjectComparator();\n\n"
                .to_string(),
        );
        config.object_comparator = Some("objectComparator".to_string());
        config.use_null_for_option = false;
        config.typed_number_lists = false;
        // TODO: test config.required_option = false;
        parse_and_write_generation(&path, &output_path, config);
    }

    #[test]
    pub fn parse_wit_types_big_int() {
        let path = format!(
            "{}/wasm_wit_component/example/rust_wit_component_example/wit/types-example.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/wasm_wit_component/example/lib/types_gen_big_int.dart",
            PACKAGE_DIR
        );
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
    }

    #[test]
    pub fn generate_image_ops() {
        let path = format!(
            "{}/../wasm_packages/image_ops/image_ops_wasm/wit/image-ops.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/../wasm_packages/image_ops/lib/src/image_ops_wit.gen.dart",
            PACKAGE_DIR
        );
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
    }

    #[test]
    pub fn generate_compression_rs() {
        let path = format!(
            "{}/../wasm_packages/compression_rs/compression_rs_wasm/wit/compression-rs.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/../wasm_packages/compression_rs/lib/src/compression_rs_wit.gen.dart",
            PACKAGE_DIR
        );
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
    }

    #[test]
    pub fn generate_compression_rs_worker() {
        let path = format!(
            "{}/../wasm_packages/compression_rs/compression_rs_wasm/wit/compression-rs.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/../wasm_packages/compression_rs/lib/src/compression_rs_wit.worker.gen.dart",
            PACKAGE_DIR
        );
        let mut config = default_wit_config(Int64TypeConfig::BigInt);
        config.async_worker = true;
        parse_and_write_generation(&path, &output_path, config);
    }

    #[test]
    pub fn generate_wasm_parser() {
        let path = format!(
            "{}/../wasm_packages/wasm_parser/wasm_parser_wasm/wit/wasm-parser.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/../wasm_packages/wasm_parser/lib/src/wasm_parser_wit.gen.dart",
            PACKAGE_DIR
        );
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
    }

    #[test]
    pub fn generate_wasm_parser_worker() {
        let path = format!(
            "{}/../wasm_packages/wasm_parser/wasm_parser_wasm/wit/wasm-parser.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/../wasm_packages/wasm_parser/lib/src/wasm_parser_wit.worker.gen.dart",
            PACKAGE_DIR
        );
        let mut config = default_wit_config(Int64TypeConfig::BigInt);
        config.async_worker = true;
        parse_and_write_generation(&path, &output_path, config);
    }

    #[test]
    pub fn generate_rust_crypto() {
        let path = format!(
            "{}/../wasm_packages/rust_crypto/rust_crypto_wasm/wit/rust-crypto.wit",
            PACKAGE_DIR
        );
        let output_path = format!(
            "{}/../wasm_packages/rust_crypto/lib/src/rust_crypto_wit.gen.dart",
            PACKAGE_DIR
        );
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
    }

    #[test]
    pub fn generate_host() {
        let path = format!("{}/wasm_wit_component/example/lib/host.wit", PACKAGE_DIR);
        let output_path = format!(
            "{}/wasm_wit_component/example/lib/host_wit_generation.dart",
            PACKAGE_DIR
        );
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
        let contents = std::fs::read_to_string(&output_path).unwrap();
        std::fs::write(
            &output_path,
            format!("const hostWitDartOutput = r'''\n{contents}''';\n"),
        )
        .unwrap();
    }

    #[test]
    pub fn parse_generator() {
        let path = format!("{}/wit/dart-wit-generator.wit", PACKAGE_DIR);
        let output_path = format!("{}/wasm_wit_component/lib/src/generator.dart", PACKAGE_DIR);
        parse_and_write_generation(
            &path,
            &output_path,
            default_wit_config(Int64TypeConfig::BigInt),
        );
    }

    #[test]
    pub fn generate_all() {
        parse_generator();
        parse_wit_types();
        parse_wit_types_big_int();
        generate_image_ops();
        generate_compression_rs();
        generate_compression_rs_worker();
        generate_rust_crypto();
        generate_host();
        generate_wasm_parser();
        generate_wasm_parser_worker();
    }
}
