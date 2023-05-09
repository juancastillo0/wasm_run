use crate::{function::FuncKind, strings::Normalize, types::*};
use std::{collections::HashMap, fs::File, io::Write, path::Path};
use wit_parser::*;

pub fn document_to_dart(parsed: &UnresolvedPackage) -> String {
    let mut s = String::new();

    s.push_str(&format!(
        "{}\n{}",
        parsed
            .url
            .as_deref()
            .map(|url| format!("// WIT url: {}", url))
            .unwrap_or("".to_string()),
        HEADER,
    ));

    let names = HashMap::<&str, Vec<&TypeDef>>::new();
    let mut p = Parsed(&parsed, names);

    // parsed.documents
    // parsed.foreign_deps
    // parsed.interfaces
    // parsed.types

    parsed.types.iter().for_each(|(_id, ty)| {
        if matches!(ty.kind, TypeDefKind::Type(_)) {
            return;
        }
        if let Some(name) = &ty.name {
            let entry = p.1.entry(name);
            entry.or_insert(vec![]).push(ty);
        }
    });
    p.1.retain(|_k, v| v.len() > 1);

    parsed.types.iter().for_each(|(_id, ty)| {
        if let (TypeDefKind::Type(ty), Some(name)) =
            (&ty.kind, p.type_def_to_name_definition(ty).as_ref())
        {
            // Renamed imports and typedefs
            if let Type::Id(ref_id) = ty {
                let ty = parsed.types.get(*ref_id).unwrap();
                if let Some(ref_name) = p.type_def_to_name_definition(ty).as_ref() {
                    if ref_name != name {
                        s.push_str(&format!("typedef {name} = {ref_name};"));
                    }
                }
            }
            return;
        }
        let definition = p.type_def_to_definition(ty);

        if !definition.is_empty() {
            s.push_str(&definition);
            s.push_str("\n");
        }
    });

    parsed.worlds.iter().for_each(|(_id, w)| {
        let w_name = heck::AsPascalCase(&w.name);

        let mut func_imports = String::new();
        // Imports Interfaces as Dart classes
        p.add_interfaces(
            &mut s,
            &mut w.imports.iter(),
            false,
            Some(&mut func_imports),
        );
        // World Imports
        s.push_str(&format!("class {w_name}WorldImports {{"));
        if w.imports.is_empty() {
            s.push_str(&format!("const {w_name}WorldImports();"));
        } else {
            let mut constructor = format!("const {w_name}WorldImports({{",);
            w.imports.iter().for_each(|(id, i)| {
                match i {
                    WorldItem::Interface(_interface_id) => {
                        constructor.push_str(&format!("required this.{id},"));
                        s.push_str(&format!("final {} {id};", heck::AsPascalCase(id)));
                    }
                    WorldItem::Type(_type_id) => {}
                    WorldItem::Function(f) => {
                        constructor.push_str(&format!("required this.{id},")); // TODO: should be name
                        p.add_function(&mut s, f, FuncKind::Field);

                        func_imports.push_str(&p.function_import(None, id, f));
                    }
                };
            });
            constructor.push_str("});");
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
            final WasmLibrary library;",
        ));
        let mut constructor: Vec<String> = vec![];
        let mut methods = String::new();
        w.exports.iter().for_each(|(id, i)| {
            match i {
                WorldItem::Interface(interface_id) => {
                    let interface = parsed.interfaces.get(*interface_id).unwrap();
                    constructor.push(format!(
                        "{} = {}(library)",
                        id.as_var(),
                        heck::AsPascalCase(id)
                    ));
                    s.push_str(&format!(
                        "final {} {};",
                        heck::AsPascalCase(id),
                        id.as_var()
                    ));
                }
                WorldItem::Type(_type_id) => {}
                WorldItem::Function(f) => {
                    constructor.push(format!(
                        "_{} = library.getComponentFunction('{id}', const {},)!",
                        id.as_var(),
                        p.function_spec(f)
                    ));
                    p.add_function(&mut methods, f, FuncKind::MethodCall);
                }
            };
        });

        s.push_str(
            "TypesWorld({
            required this.imports,
            required this.library,
        })",
        );
        if constructor.is_empty() {
            s.push_str(";");
        } else {
            s.push_str(&format!(": {};", constructor.join(", ")));
        }

        s.push_str(&format!(
            "static Future<{w_name}World> init(
                    WasmInstanceBuilder builder, {{
                    required {w_name}WorldImports imports,
                }}) async {{
                    late final WasmLibrary library;
                    WasmLibrary getLib() => library;

                    {func_imports}

                    final instance = await builder.build();

                    library = WasmLibrary(instance);
                    return {w_name}World(imports: imports, library: library);
                }}

                {methods}
            ",
        ));
        s.push_str("}");
    });
    s
}

pub fn add_docs(s: &mut String, docs: &Docs) {
    if let Some(docs) = &docs.contents {
        let mut m = docs.clone();
        if m.ends_with('\n') {
            m.replace_range(m.len() - 1.., "");
        }
        s.push_str(
            &m.split("\n")
                .map(|l| format!("/// {}\n", l))
                .collect::<Vec<_>>()
                .join(""),
        );
    }
}

const HEADER: &str = "
// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings

import 'dart:typed_data';

import 'package:wasmit/wasmit.dart';

import 'component.dart';
import 'canonical_abi.dart';
";

const PACKAGE_DIR: &str = env!("CARGO_MANIFEST_DIR");

#[test]
pub fn parse_wit() {
    let parsed = wit_parser::UnresolvedPackage::parse(
        Path::new("../wit/host.wit"),
        "
default world host {
    import print: func(msg: string)

    export run: func()
}
",
    )
    .unwrap();

    let s = document_to_dart(&parsed);
    println!("{}", s);
}

#[test]
pub fn parse_wit_types() {
    let path = format!("{}/wit/types.wit", PACKAGE_DIR);
    let parsed = wit_parser::UnresolvedPackage::parse_file(Path::new(&path)).unwrap();

    let s = document_to_dart(&parsed);
    println!("{}", s);

    let output_path = format!("{}/dart_output/lib/types_gen.dart", PACKAGE_DIR);
    File::create(&output_path)
        .unwrap()
        .write(s.as_bytes())
        .unwrap();

    std::process::Command::new("dart")
        .arg("format")
        .arg(&output_path)
        .output()
        .unwrap();
}
