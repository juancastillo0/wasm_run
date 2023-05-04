use crate::types::*;
use std::{fs::File, io::Write, path::Path};
use wit_parser::*;

pub fn document_to_dart(parsed: &UnresolvedPackage) -> String {
    let mut s = String::new();

    s.push_str(&format!(
        "library {};{}\n{}",
        parsed.name,
        parsed
            .url
            .as_deref()
            .map(|url| format!(" // url: {}", url))
            .unwrap_or("".to_string()),
        HEADER,
    ));
    let p = Parsed(&parsed);

    // parsed.documents
    // parsed.foreign_deps
    // parsed.interfaces
    // parsed.types

    parsed.types.iter().for_each(|(id, ty)| {
        let definition = p.type_def_to_definition(ty);

        if !definition.is_empty() {
            s.push_str(&definition);
            s.push_str("\n");
        }
    });

    parsed.worlds.iter().for_each(|(id, w)| {
        let w_name = heck::AsPascalCase(&w.name);

        // Imports Interfaces as Dart classes
        p.add_interfaces(&mut s, &mut w.imports.iter());
        // World Imports
        s.push_str(&format!("class {}WorldImports {{", w_name));
        if w.imports.is_empty() {
            s.push_str(&format!("const {}WorldImports();", w_name));
        } else {
            let mut constructor = format!("const {}WorldImports({{", w_name);
            w.imports.iter().for_each(|(id, i)| {
                match i {
                    WorldItem::Interface(_interface_id) => {
                        constructor.push_str(&format!("required this.{},", id));
                        s.push_str(&format!("final {} {};", heck::AsPascalCase(id), id));
                    }
                    WorldItem::Type(_type_id) => {}
                    WorldItem::Function(f) => {
                        constructor.push_str(&format!("required this.{},", id)); // TODO: should be name
                        p.add_function(&mut s, f, FuncKind::Field);
                    }
                };
            });
            constructor.push_str("});");
            s.push_str(&constructor);
        }
        s.push_str("}");

        // World Exports
        //TODO: separate per document?

        p.add_interfaces(&mut s, &mut w.exports.iter());

        add_docs(&mut s, &w.docs);
        s.push_str(&format!("abstract class {}World {{", w_name));
        w.exports.iter().for_each(|(id, i)| {
            match i {
                WorldItem::Interface(interface_id) => {
                    let interface = parsed.interfaces.get(*interface_id).unwrap();
                    p.add_interface(&mut s, id, interface)
                }
                WorldItem::Type(_type_id) => {}
                WorldItem::Function(f) => {
                    p.add_function(&mut s, f, FuncKind::Method);
                }
            };
        });
        s.push_str("}");
    });
    s
}

pub fn add_docs(s: &mut String, docs: &Docs) {
    if let Some(docs) = &docs.contents {
        s.push_str(
            &docs
                .split("\n")
                .map(|l| format!("/// {}\n", l))
                .collect::<Vec<_>>()
                .join(""),
        );
    }
}

const HEADER: &str = "
// FILE GENERATED FROM WIT

import 'dart:typed_data';

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
        .arg("-w")
        .arg(&output_path)
        .output()
        .unwrap();
}
