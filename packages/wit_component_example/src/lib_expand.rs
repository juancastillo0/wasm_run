#![feature(prelude_import)]
#[prelude_import]
use std::prelude::rust_2021::*;
#[macro_use]
extern crate std;
mod function {
    use wit_parser::*;
    use crate::{generate::add_docs, strings::Normalize, types::Parsed};
    pub enum FuncKind {
        MethodCall,
        Method,
        Field,
    }
    impl Parsed<'_> {
        pub fn function_import(
            &self,
            interface_name: Option<&str>,
            id: &str,
            f: &Function,
        ) -> String {
            let interface_name_m = interface_name.unwrap_or("$root");
            let getter = {
                let res = ::alloc::fmt::format(
                    format_args!(
                        "imports.{0}{1}", interface_name.map(| v | { let res =
                        ::alloc::fmt::format(format_args!("{0}.", v)); res })
                        .unwrap_or("".to_string()), id.as_var()
                    ),
                );
                res
            };
            {
                let res = ::alloc::fmt::format(
                    format_args!(
                        "{{\n                const ft = {0};\n                {1}\n                final lowered = loweredImportFunction(ft, exec{2}, getLib);\n                builder.addImport(r\'{3}\', \'{4}\', lowered);\n            }}",
                        self.function_spec(f), self.function_exec(& getter, f), getter
                        .as_fn_suffix(), interface_name_m, id
                    ),
                );
                res
            }
        }
        pub fn function_spec(&self, function: &Function) -> String {
            {
                let res = ::alloc::fmt::format(
                    format_args!(
                        "FuncType([{0}], [{1}])", function.params.iter().map(| (name, ty)
                        | { let res = ::alloc::fmt::format(format_args!("(\'{1}\', {0})",
                        self.type_to_spec(ty), name)); res }).collect::< Vec < _ >> ()
                        .join(", "), match & function.results { Results::Anon(a) => { let
                        res = ::alloc::fmt::format(format_args!("(\'\', {0})", self
                        .type_to_spec(a))); res } Results::Named(results) => results
                        .iter().map(| (name, ty) | { let res =
                        ::alloc::fmt::format(format_args!("(\'{1}\', {0})", self
                        .type_to_spec(ty), name)); res }).collect::< Vec < _ >> ()
                        .join(", "), }
                    ),
                );
                res
            }
        }
        pub fn function_exec(&self, getter: &str, function: &Function) -> String {
            {
                let res = ::alloc::fmt::format(
                    format_args!(
                        "\n        (ListValue, void Function()) exec{0}(ListValue args) {{\n        {2}\n        {1}{5}({3});\n        return ({4}, () {{}});\n        }}\n        ",
                        getter.as_fn_suffix(), if function.results.len() == 0 { "" } else
                        { "final results = " }, function.params.iter().enumerate().map(|
                        (i, (_name, _ty)) | { let res =
                        ::alloc::fmt::format(format_args!("final args{0} = args[{0}];",
                        i)); res }).collect::< String > (), function.params.iter()
                        .enumerate().map(| (i, (name, ty)) | { let res =
                        ::alloc::fmt::format(format_args!("{0}: {1}", name.as_var(), self
                        .type_from_json(& { let res =
                        ::alloc::fmt::format(format_args!("args{0}", i)); res }, ty)));
                        res }).collect::< Vec < _ >> ().join(", "), match & function
                        .results { Results::Anon(a) => { let res =
                        ::alloc::fmt::format(format_args!("[{0}]", self
                        .type_to_json("results", a))); res } Results::Named(results) =>
                        if results.is_empty() { "const []".to_string() } else { { let res
                        = ::alloc::fmt::format(format_args!("[{0}]", results.iter().map(|
                        (name, ty) | self.type_to_json(& { let res =
                        ::alloc::fmt::format(format_args!("results.{0}", name.as_var()));
                        res }, ty)).collect::< Vec < _ >> ().join(", "))); res } }, },
                        getter
                    ),
                );
                res
            }
        }
        pub fn add_interfaces(
            &self,
            mut s: &mut String,
            map: &mut dyn Iterator<Item = (&String, &WorldItem)>,
            is_export: bool,
            mut func_imports: Option<&mut String>,
        ) {
            map.for_each(|(id, item)| match item {
                WorldItem::Interface(interface_id) => {
                    let interface = self.0.interfaces.get(*interface_id).unwrap();
                    self.add_interface(
                        &mut s,
                        id,
                        interface,
                        is_export,
                        &mut func_imports,
                    )
                }
                _ => {}
            });
        }
        pub fn add_interface(
            &self,
            mut s: &mut String,
            interface_id: &str,
            interface: &Interface,
            is_export: bool,
            func_imports: &mut Option<&mut String>,
        ) {
            let name = heck::AsPascalCase(interface_id);
            add_docs(&mut s, &interface.docs);
            if is_export {
                s.push_str(
                    &{
                        let res = ::alloc::fmt::format(
                            format_args!("class {0} {{ {0}(WasmLibrary library)", name),
                        );
                        res
                    },
                );
                if interface.functions.is_empty() {
                    s.push_str(";");
                } else {
                    s.push_str(":");
                    interface
                        .functions
                        .iter()
                        .enumerate()
                        .for_each(|(index, (id, f))| {
                            s.push_str(
                                &{
                                    let res = ::alloc::fmt::format(
                                        format_args!(
                                            "_{0} = library.getComponentFunction(\'{2}\', const {1},)!",
                                            id.as_var(), self.function_spec(f), id
                                        ),
                                    );
                                    res
                                },
                            );
                            if index != interface.functions.len() - 1 {
                                s.push_str(",");
                            }
                        });
                    s.push_str(";");
                }
                interface
                    .functions
                    .iter()
                    .for_each(|(_id, f)| {
                        self.add_function(&mut s, f, FuncKind::MethodCall);
                    });
                s.push_str("}");
            } else {
                s.push_str(
                    &{
                        let res = ::alloc::fmt::format(
                            format_args!("abstract class {0} {{", name),
                        );
                        res
                    },
                );
                interface
                    .functions
                    .iter()
                    .for_each(|(id, f)| {
                        self.add_function(&mut s, f, FuncKind::Method);
                        if let Some(func_imports) = func_imports {
                            func_imports
                                .push_str(&self.function_import(Some(interface_id), id, f));
                        }
                    });
                s.push_str("}");
            }
        }
        pub fn is_option(&self, ty: &Type) -> bool {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    match ty_def.kind {
                        TypeDefKind::Option(_) => true,
                        _ => false,
                    }
                }
                _ => false,
            }
        }
        pub fn is_unit(&self, ty: &Type) -> bool {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    if let TypeDefKind::Tuple(Tuple { types }) = &ty_def.kind {
                        types.is_empty()
                    } else {
                        false
                    }
                }
                _ => false,
            }
        }
        pub fn add_function(&self, mut s: &mut String, f: &Function, kind: FuncKind) {
            let mut params = f
                .params
                .iter()
                .map(|(name, ty)| {
                    if self.is_option(ty) {
                        {
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "{0} {1} = const None(),", self.type_to_str(ty), name
                                    .as_var()
                                ),
                            );
                            res
                        }
                    } else {
                        {
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "required {0} {1},", self.type_to_str(ty), name.as_var()
                                ),
                            );
                            res
                        }
                    }
                })
                .collect::<String>();
            if params.len() > 0 {
                params = {
                    let res = ::alloc::fmt::format(format_args!("{{{0}}}", params));
                    res
                };
            }
            let results = match &f.results {
                Results::Anon(ty) => self.type_to_str(ty),
                Results::Named(list) => {
                    if list.is_empty() {
                        "void".to_string()
                    } else {
                        {
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "({{{0}}})", list.iter().map(| (name, ty) | { { let res =
                                    ::alloc::fmt::format(format_args!("{0} {1}", self
                                    .type_to_str(ty), name.as_var())); res } }).collect::< Vec <
                                    _ >> ().join(",")
                                ),
                            );
                            res
                        }
                    }
                }
            };
            let name = &f.name.as_fn();
            match kind {
                FuncKind::Field => {
                    add_docs(&mut s, &f.docs);
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "final {0} Function({1}) {2};", results, params, name
                                ),
                            );
                            res
                        },
                    )
                }
                FuncKind::Method => {
                    add_docs(&mut s, &f.docs);
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!("{0} {1}({2});", results, name, params),
                            );
                            res
                        },
                    )
                }
                FuncKind::MethodCall => {
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "final ListValue Function(ListValue) _{0};", name
                                ),
                            );
                            res
                        },
                    );
                    add_docs(&mut s, &f.docs);
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!("{0} {1}({2}) {{", results, name, params),
                            );
                            res
                        },
                    );
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "{0}_{3}([{1}]);{2}", if f.results.len() == 0 || (f.results
                                    .len() == 1 && self.is_unit(f.results.iter_types().next()
                                    .unwrap())) { "" } else { "final results = " }, f.params
                                    .iter().map(| (name, ty) | self.type_to_json(& name
                                    .as_var(), ty)).collect::< Vec < _ >> ().join(", "), match &
                                    f.results { Results::Anon(a) => { if self.is_unit(& a) {
                                    "return ();".to_string() } else { { let res =
                                    ::alloc::fmt::format(format_args!("final result = results[0];return {0};",
                                    self.type_from_json("result", a))); res } } }
                                    Results::Named(results) => if results.is_empty() { ""
                                    .to_string() } else { { let res =
                                    ::alloc::fmt::format(format_args!("{0}return ({1},);", (0
                                    ..results.len()).map(| i | { let res =
                                    ::alloc::fmt::format(format_args!("final r{0} = results[{0}];",
                                    i)); res }).collect::< String > (), results.iter()
                                    .enumerate().map(| (i, (name, ty)) | { let res =
                                    ::alloc::fmt::format(format_args!("{0}: {1}", name.as_var(),
                                    self.type_from_json(& { let res =
                                    ::alloc::fmt::format(format_args!("r{0}", i)); res }, ty)));
                                    res }).collect::< Vec < _ >> ().join(", "))); res } }, },
                                    name
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("}");
                }
            }
        }
    }
}
pub mod generate {
    use crate::{function::FuncKind, strings::Normalize, types::*};
    use std::{collections::HashMap, fs::File, io::Write, path::Path};
    use wit_parser::*;
    pub fn document_to_dart(parsed: &UnresolvedPackage) -> String {
        let mut s = String::new();
        s.push_str(
            &{
                let res = ::alloc::fmt::format(
                    format_args!(
                        "{0}\n{1}", parsed.url.as_deref().map(| url | { let res =
                        ::alloc::fmt::format(format_args!("// WIT url: {0}", url)); res
                        }).unwrap_or("".to_string()), HEADER
                    ),
                );
                res
            },
        );
        let names = HashMap::<&str, Vec<&TypeDef>>::new();
        let mut p = Parsed(&parsed, names);
        parsed
            .types
            .iter()
            .for_each(|(_id, ty)| {
                if match ty.kind {
                    TypeDefKind::Type(_) => true,
                    _ => false,
                } {
                    return;
                }
                if let Some(name) = &ty.name {
                    let entry = p.1.entry(name);
                    entry.or_insert(::alloc::vec::Vec::new()).push(ty);
                }
            });
        p.1.retain(|_k, v| v.len() > 1);
        parsed
            .types
            .iter()
            .for_each(|(_id, ty)| {
                if let (TypeDefKind::Type(ty), Some(name))
                    = (&ty.kind, p.type_def_to_name_definition(ty).as_ref()) {
                    if let Type::Id(ref_id) = ty {
                        let ty = parsed.types.get(*ref_id).unwrap();
                        if let Some(ref_name)
                            = p.type_def_to_name_definition(ty).as_ref()
                        {
                            if ref_name != name {
                                s.push_str(
                                    &{
                                        let res = ::alloc::fmt::format(
                                            format_args!("typedef {0} = {1};", name, ref_name),
                                        );
                                        res
                                    },
                                );
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
        parsed
            .worlds
            .iter()
            .for_each(|(_id, w)| {
                let w_name = heck::AsPascalCase(&w.name);
                let mut func_imports = String::new();
                p.add_interfaces(
                    &mut s,
                    &mut w.imports.iter(),
                    false,
                    Some(&mut func_imports),
                );
                s.push_str(
                    &{
                        let res = ::alloc::fmt::format(
                            format_args!("class {0}WorldImports {{", w_name),
                        );
                        res
                    },
                );
                if w.imports.is_empty() {
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!("const {0}WorldImports();", w_name),
                            );
                            res
                        },
                    );
                } else {
                    let mut constructor = {
                        let res = ::alloc::fmt::format(
                            format_args!("const {0}WorldImports({{", w_name),
                        );
                        res
                    };
                    w.imports
                        .iter()
                        .for_each(|(id, i)| {
                            match i {
                                WorldItem::Interface(_interface_id) => {
                                    constructor
                                        .push_str(
                                            &{
                                                let res = ::alloc::fmt::format(
                                                    format_args!("required this.{0},", id),
                                                );
                                                res
                                            },
                                        );
                                    s.push_str(
                                        &{
                                            let res = ::alloc::fmt::format(
                                                format_args!("final {0} {1};", heck::AsPascalCase(id), id),
                                            );
                                            res
                                        },
                                    );
                                }
                                WorldItem::Type(_type_id) => {}
                                WorldItem::Function(f) => {
                                    constructor
                                        .push_str(
                                            &{
                                                let res = ::alloc::fmt::format(
                                                    format_args!("required this.{0},", id),
                                                );
                                                res
                                            },
                                        );
                                    p.add_function(&mut s, f, FuncKind::Field);
                                    func_imports.push_str(&p.function_import(None, id, f));
                                }
                            };
                        });
                    constructor.push_str("});");
                    s.push_str(&constructor);
                }
                s.push_str("}");
                p.add_interfaces(&mut s, &mut w.exports.iter(), true, None);
                add_docs(&mut s, &w.docs);
                s.push_str(
                    &{
                        let res = ::alloc::fmt::format(
                            format_args!(
                                "class {0}World {{\n            final {0}WorldImports imports;\n            final WasmLibrary library;",
                                w_name
                            ),
                        );
                        res
                    },
                );
                let mut constructor: Vec<String> = ::alloc::vec::Vec::new();
                let mut methods = String::new();
                w.exports
                    .iter()
                    .for_each(|(id, i)| {
                        match i {
                            WorldItem::Interface(interface_id) => {
                                let interface = parsed
                                    .interfaces
                                    .get(*interface_id)
                                    .unwrap();
                                constructor
                                    .push({
                                        let res = ::alloc::fmt::format(
                                            format_args!(
                                                "{0} = {1}(library)", id.as_var(), heck::AsPascalCase(id)
                                            ),
                                        );
                                        res
                                    });
                                s.push_str(
                                    &{
                                        let res = ::alloc::fmt::format(
                                            format_args!(
                                                "final {0} {1};", heck::AsPascalCase(id), id.as_var()
                                            ),
                                        );
                                        res
                                    },
                                );
                            }
                            WorldItem::Type(_type_id) => {}
                            WorldItem::Function(f) => {
                                constructor
                                    .push({
                                        let res = ::alloc::fmt::format(
                                            format_args!(
                                                "_{0} = library.getComponentFunction(\'{2}\', const {1},)!",
                                                id.as_var(), p.function_spec(f), id
                                            ),
                                        );
                                        res
                                    });
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
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(": {0};", constructor.join(", ")),
                            );
                            res
                        },
                    );
                }
                s.push_str(
                    &{
                        let res = ::alloc::fmt::format(
                            format_args!(
                                "static Future<{0}World> init(\n                    WasmInstanceBuilder builder, {{\n                    required {0}WorldImports imports,\n                }}) async {{\n                    late final WasmLibrary library;\n                    WasmLibrary getLib() => library;\n\n                    {1}\n\n                    final instance = await builder.build();\n\n                    library = WasmLibrary(instance);\n                    return {0}World(imports: imports, library: library);\n                }}\n\n                {2}\n            ",
                                w_name, func_imports, methods
                            ),
                        );
                        res
                    },
                );
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
                &m
                    .split("\n")
                    .map(|l| {
                        let res = ::alloc::fmt::format(format_args!("/// {0}\n", l));
                        res
                    })
                    .collect::<Vec<_>>()
                    .join(""),
            );
        }
    }
    const HEADER: &str = "
// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings

import 'dart:typed_data';

import 'package:wasm_run/wasm_run.dart';

import 'component.dart';
import 'canonical_abi.dart';
";
    const PACKAGE_DIR: &str = "/Users/juanmanuelcastillo/Desktop/flutter/wasmi_dart/packages/wit_component_example";
}
mod strings {
    pub trait Normalize {
        fn as_str(&self) -> &str;
        fn as_type(&self) -> String {
            heck::AsPascalCase(self.as_str()).to_string()
        }
        fn as_fn(&self) -> String {
            escape_reserved_word(&heck::AsLowerCamelCase(self.as_str()).to_string())
        }
        fn as_fn_suffix(&self) -> String {
            heck::AsPascalCase(&self.as_str()).to_string()
        }
        fn as_var(&self) -> String {
            escape_reserved_word(&heck::AsLowerCamelCase(self.as_str()).to_string())
        }
        fn as_const(&self) -> String {
            heck::AsShoutySnakeCase(self.as_str()).to_string()
        }
        fn as_namespace(&self) -> String {
            heck::AsShoutySnakeCase(self.as_str()).to_string()
        }
    }
    impl<T: AsRef<str>> Normalize for T {
        fn as_str(&self) -> &str {
            self.as_ref()
        }
    }
    /// Checks the given word against a list of reserved keywords.
    /// If the given word conflicts with a keyword, a trailing underscore will be
    /// appended.
    ///
    /// Adapted from [wiggle](https://docs.rs/wiggle/latest/wiggle/index.html)
    pub fn escape_reserved_word(word: &str) -> String {
        if RESERVED.iter().any(|k| (*k).eq(word)) {
            {
                let res = ::alloc::fmt::format(format_args!("{0}_", word));
                res
            }
        } else {
            word.to_string()
        }
    }
    const RESERVED: &[&str] = &[
        "assert",
        "break",
        "case",
        "catch",
        "class",
        "const",
        "continue",
        "default",
        "do",
        "else",
        "enum",
        "extends",
        "false",
        "final",
        "finally",
        "for",
        "if",
        "in",
        "is",
        "new",
        "null",
        "rethrow",
        "return",
        "super",
        "switch",
        "this",
        "throw",
        "true",
        "try",
        "var",
        "void",
        "while",
        "with",
        "abstract",
        "as",
        "covariant",
        "deferred",
        "dynamic",
        "export",
        "extension",
        "external",
        "factory",
        "Function",
        "get",
        "implements",
        "import",
        "interface",
        "late",
        "library",
        "operator",
        "mixin",
        "part",
        "required",
        "set",
        "static",
        "typedef",
        "await",
        "yield",
        "async",
        "base",
        "hide",
        "of",
        "on",
        "sealed",
        "show",
        "sync",
        "when",
    ];
}
mod types {
    use std::{collections::HashMap, fmt::format};
    use crate::{generate::*, strings::Normalize};
    use wit_parser::*;
    pub struct DartType {
        pub name: String,
        pub ty: Type,
        pub ffi_ty: String,
        pub is_pointer: bool,
    }
    pub struct Parsed<'a>(
        pub &'a UnresolvedPackage,
        pub HashMap<&'a str, Vec<&'a TypeDef>>,
    );
    impl Parsed<'_> {
        pub fn type_to_ffi(&self, ty: &Type) -> String {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    ty_def.name.clone().unwrap()
                }
                Type::Bool => "Bool".to_string(),
                Type::String => "String".to_string(),
                Type::Char => "Uint32".to_string(),
                Type::Float32 => "Float".to_string(),
                Type::Float64 => "Double".to_string(),
                Type::S8 => "Int8".to_string(),
                Type::S16 => "Int16".to_string(),
                Type::S32 => "Int32".to_string(),
                Type::S64 => "Int64".to_string(),
                Type::U8 => "Uint8".to_string(),
                Type::U16 => "Uint16".to_string(),
                Type::U32 => "Uint32".to_string(),
                Type::U64 => "Uint64".to_string(),
            }
        }
        pub fn type_to_str(&self, ty: &Type) -> String {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    self.type_def_to_name(ty_def, true)
                }
                Type::Bool => "bool".to_string(),
                Type::String => "String".to_string(),
                Type::Char => "String /*Char*/".to_string(),
                Type::Float32 => "double /*F32*/".to_string(),
                Type::Float64 => "double /*F64*/".to_string(),
                Type::S8 => "int /*S8*/".to_string(),
                Type::S16 => "int /*S16*/".to_string(),
                Type::S32 => "int /*S32*/".to_string(),
                Type::S64 => "int /*S64*/".to_string(),
                Type::U8 => "int /*U8*/".to_string(),
                Type::U16 => "int /*U16*/".to_string(),
                Type::U32 => "int /*U32*/".to_string(),
                Type::U64 => "int /*U64*/".to_string(),
            }
        }
        pub fn type_to_json(&self, getter: &str, ty: &Type) -> String {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    self.type_def_to_json(getter, ty_def)
                }
                Type::Bool => getter.to_string(),
                Type::String => getter.to_string(),
                Type::Char => getter.to_string(),
                Type::Float32 => getter.to_string(),
                Type::Float64 => getter.to_string(),
                Type::S8 => getter.to_string(),
                Type::S16 => getter.to_string(),
                Type::S32 => getter.to_string(),
                Type::S64 => getter.to_string(),
                Type::U8 => getter.to_string(),
                Type::U16 => getter.to_string(),
                Type::U32 => getter.to_string(),
                Type::U64 => getter.to_string(),
            }
        }
        pub fn type_def_to_json(&self, getter: &str, ty: &TypeDef) -> String {
            match &ty.kind {
                TypeDefKind::Record(_record) => {
                    let res = ::alloc::fmt::format(format_args!("{0}.toJson()", getter));
                    res
                }
                TypeDefKind::Enum(_enum_) => {
                    let res = ::alloc::fmt::format(format_args!("{0}.toJson()", getter));
                    res
                }
                TypeDefKind::Union(_union) => {
                    let res = ::alloc::fmt::format(format_args!("{0}.toJson()", getter));
                    res
                }
                TypeDefKind::Flags(_flags) => {
                    let res = ::alloc::fmt::format(format_args!("{0}.toJson()", getter));
                    res
                }
                TypeDefKind::Variant(_variant) => {
                    let res = ::alloc::fmt::format(format_args!("{0}.toJson()", getter));
                    res
                }
                TypeDefKind::Option(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "{1}.toJson((some) => {0})", self.type_to_json("some", & ty),
                            getter
                        ),
                    );
                    res
                }
                TypeDefKind::Result(r) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "{2}.toJson({0}, {1})", r.ok.map_or_else(|| "null"
                            .to_string(), | ok | { let to_json = self.type_to_json("ok",
                            & ok); if to_json == "ok" { return "null".to_string(); } {
                            let res = ::alloc::fmt::format(format_args!("(ok) => {0}",
                            to_json)); res } }), r.err.map_or_else(|| "null".to_string(),
                            | error | { let to_json = self.type_to_json("error", &
                            error); if to_json == "error" { return "null".to_string(); }
                            { let res =
                            ::alloc::fmt::format(format_args!("(error) => {0}",
                            to_json)); res } }), getter
                        ),
                    );
                    res
                }
                TypeDefKind::Tuple(t) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "[{0}]", t.types.iter().enumerate().map(| (i, t) | self
                            .type_to_json(& { let res =
                            ::alloc::fmt::format(format_args!("{1}.${0}", i + 1,
                            getter)); res }, t)).collect::< Vec < _ >> ().join(", ")
                        ),
                    );
                    res
                }
                TypeDefKind::List(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "{1}.map((e) => {0}).toList()", self.type_to_json("e", & ty),
                            getter
                        ),
                    );
                    res
                }
                TypeDefKind::Future(_ty) => {
                    ::core::panicking::panic_fmt(
                        format_args!(
                            "internal error: entered unreachable code: {0}",
                            format_args!("Future")
                        ),
                    )
                }
                TypeDefKind::Stream(_s) => {
                    ::core::panicking::panic_fmt(
                        format_args!(
                            "internal error: entered unreachable code: {0}",
                            format_args!("Stream")
                        ),
                    )
                }
                TypeDefKind::Type(ty) => self.type_to_json(getter, &ty),
                TypeDefKind::Unknown => {
                    ::core::panicking::panic_fmt(
                        format_args!(
                            "not implemented: {0}", format_args!("Unknown type")
                        ),
                    )
                }
            }
        }
        pub fn type_to_spec(&self, ty: &Type) -> String {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    self.type_def_to_spec(ty_def)
                }
                Type::Bool => "Bool()".to_string(),
                Type::String => "StringType()".to_string(),
                Type::Char => "Char()".to_string(),
                Type::Float32 => "Float32()".to_string(),
                Type::Float64 => "Float64()".to_string(),
                Type::S8 => "S8()".to_string(),
                Type::S16 => "S16()".to_string(),
                Type::S32 => "S32()".to_string(),
                Type::S64 => "S64()".to_string(),
                Type::U8 => "U8()".to_string(),
                Type::U16 => "U16()".to_string(),
                Type::U32 => "U32()".to_string(),
                Type::U64 => "U64()".to_string(),
            }
        }
        pub fn type_def_to_spec_option(&self, r: Option<Type>) -> String {
            r.map(|ty| self.type_to_spec(&ty)).unwrap_or("null".to_string())
        }
        pub fn type_def_to_spec(&self, ty: &TypeDef) -> String {
            match &ty.kind {
                TypeDefKind::Record(record) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Record([{0}])", record.fields.iter().map(| t | { let res =
                            ::alloc::fmt::format(format_args!("(label: \'{0}\', t: {1})",
                            t.name, self.type_to_spec(& t.ty))); res }).collect::< Vec <
                            _ >> ().join(", ")
                        ),
                    );
                    res
                }
                TypeDefKind::Enum(enum_) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "EnumType([\'{0}\'])", enum_.cases.iter().map(| t | t.name
                            .clone()).collect::< Vec < _ >> ().join("', '")
                        ),
                    );
                    res
                }
                TypeDefKind::Union(union) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Union([{0}])", union.cases.iter().map(| t | self
                            .type_to_spec(& t.ty)).collect::< Vec < _ >> ().join(", ")
                        ),
                    );
                    res
                }
                TypeDefKind::Flags(flags) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Flags([\'{0}\'])", flags.flags.iter().map(| t | t.name
                            .clone()).collect::< Vec < _ >> ().join("', '")
                        ),
                    );
                    res
                }
                TypeDefKind::Variant(variant) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Variant([{0}])", variant.cases.iter().map(| t | { let res =
                            ::alloc::fmt::format(format_args!("Case(\'{0}\', {1})", t
                            .name, self.type_def_to_spec_option(t.ty))); res })
                            .collect::< Vec < _ >> ().join(", ")
                        ),
                    );
                    res
                }
                TypeDefKind::Tuple(t) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Tuple([{0}])", t.types.iter().map(| t | self
                            .type_to_spec(t)).collect::< Vec < _ >> ().join(", ")
                        ),
                    );
                    res
                }
                TypeDefKind::Option(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!("OptionType({0})", self.type_to_spec(& ty)),
                    );
                    res
                }
                TypeDefKind::Result(r) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "ResultType({0}, {1})", self.type_def_to_spec_option(r.ok),
                            self.type_def_to_spec_option(r.err)
                        ),
                    );
                    res
                }
                TypeDefKind::List(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!("ListType({0})", self.type_to_spec(& ty)),
                    );
                    res
                }
                TypeDefKind::Future(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "FutureType({0})", self.type_def_to_spec_option(* ty)
                        ),
                    );
                    res
                }
                TypeDefKind::Stream(s) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "StreamType({0})", self.type_def_to_spec_option(s.element)
                        ),
                    );
                    res
                }
                TypeDefKind::Type(ty) => self.type_to_spec(&ty),
                TypeDefKind::Unknown => {
                    ::core::panicking::panic_fmt(
                        format_args!(
                            "not implemented: {0}", format_args!("Unknown type")
                        ),
                    )
                }
            }
        }
        pub fn type_from_json(&self, getter: &str, ty: &Type) -> String {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    self.type_def_from_json(getter, ty_def)
                }
                Type::Bool => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as bool", getter));
                    res
                }
                Type::String => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "{0} is String ? {0} : ({0}! as ParsedString).value", getter
                        ),
                    );
                    res
                }
                Type::Char => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}! as String", getter),
                    );
                    res
                }
                Type::Float32 => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}! as double", getter),
                    );
                    res
                }
                Type::Float64 => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}! as double", getter),
                    );
                    res
                }
                Type::S8 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::S16 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::S32 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::S64 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::U8 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::U16 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::U32 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
                Type::U64 => {
                    let res = ::alloc::fmt::format(format_args!("{0}! as int", getter));
                    res
                }
            }
        }
        pub fn type_def_from_json_option(
            &self,
            getter: &str,
            r: Option<Type>,
        ) -> String {
            r.map(|ty| self.type_from_json(getter, &ty)).unwrap_or("null".to_string())
        }
        pub fn type_def_from_json(&self, getter: &str, ty: &TypeDef) -> String {
            let name = self.type_def_to_name_definition(ty);
            match &ty.kind {
                TypeDefKind::Record(_record) => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}.fromJson({1})", name.unwrap(), getter),
                    );
                    res
                }
                TypeDefKind::Enum(_enum_) => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}.fromJson({1})", name.unwrap(), getter),
                    );
                    res
                }
                TypeDefKind::Union(_union) => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}.fromJson({1})", name.unwrap(), getter),
                    );
                    res
                }
                TypeDefKind::Flags(_flags) => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}.fromJson({1})", name.unwrap(), getter),
                    );
                    res
                }
                TypeDefKind::Variant(_variant) => {
                    let res = ::alloc::fmt::format(
                        format_args!("{0}.fromJson({1})", name.unwrap(), getter),
                    );
                    res
                }
                TypeDefKind::Tuple(t) => {
                    if t.types.len() == 0 {
                        {
                            let res = ::alloc::fmt::format(format_args!("()"));
                            res
                        }
                    } else {
                        let spread = (0..t.types.len())
                            .map(|i| {
                                let res = ::alloc::fmt::format(
                                    format_args!("final v{0}", i),
                                );
                                res
                            })
                            .collect::<Vec<_>>()
                            .join(",");
                        let s_comma = if t.types.len() == 1 { "," } else { "" };
                        {
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "(() {{final l = {2} is Map\n                        ? List.generate({1}, (i) => {2}[i.toString()], growable: false)\n                        : {2};\n                        return switch (l) {{\n                            [{3}] || ({3}{4}) => ({0},),\n                            _ => throw Exception(\'Invalid JSON ${2}\')}};\n                        }})()",
                                    t.types.iter().enumerate().map(| (i, t) | self
                                    .type_from_json(& { let res =
                                    ::alloc::fmt::format(format_args!("v{0}", i)); res }, t))
                                    .collect::< Vec < _ >> ().join(", "), t.types.len(), getter,
                                    spread, s_comma
                                ),
                            );
                            res
                        }
                    }
                }
                TypeDefKind::Option(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Option.fromJson({1}, (some) => {0})", self
                            .type_from_json("some", & ty), getter
                        ),
                    );
                    res
                }
                TypeDefKind::Result(r) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Result.fromJson({2}, (ok) => {0}, (error) => {1})", self
                            .type_def_from_json_option("ok", r.ok), self
                            .type_def_from_json_option("error", r.err), getter
                        ),
                    );
                    res
                }
                TypeDefKind::List(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "({1}! as Iterable).map((e) => {0}).toList()", self
                            .type_from_json("e", & ty), getter
                        ),
                    );
                    res
                }
                TypeDefKind::Future(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "FutureType({0})", self.type_def_from_json_option(getter, *
                            ty)
                        ),
                    );
                    res
                }
                TypeDefKind::Stream(s) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "StreamType({0})", self.type_def_from_json_option(getter, s
                            .element)
                        ),
                    );
                    res
                }
                TypeDefKind::Type(ty) => self.type_from_json(getter, &ty),
                TypeDefKind::Unknown => {
                    ::core::panicking::panic_fmt(
                        format_args!(
                            "not implemented: {0}", format_args!("Unknown type")
                        ),
                    )
                }
            }
        }
        pub fn type_to_dart_definition(&self, ty: &Type) -> String {
            match ty {
                Type::Id(ty_id) => {
                    let ty_def = self.0.types.get(*ty_id).unwrap();
                    self.type_def_to_definition(ty_def)
                }
                Type::Bool => "".to_string(),
                Type::String => "".to_string(),
                Type::Char => "".to_string(),
                Type::Float32 => "".to_string(),
                Type::Float64 => "".to_string(),
                Type::S8 => "".to_string(),
                Type::S16 => "".to_string(),
                Type::S32 => "".to_string(),
                Type::S64 => "".to_string(),
                Type::U8 => "".to_string(),
                Type::U16 => "".to_string(),
                Type::U32 => "".to_string(),
                Type::U64 => "".to_string(),
            }
        }
        pub fn type_def_to_name(&self, ty: &TypeDef, allow_alias: bool) -> String {
            let name = self.type_def_to_name_definition(ty);
            if allow_alias && name.is_some() {
                return name.unwrap();
            }
            match &ty.kind {
                TypeDefKind::Record(_record) => name.unwrap(),
                TypeDefKind::Enum(_enum) => name.unwrap(),
                TypeDefKind::Union(_union) => name.unwrap(),
                TypeDefKind::Flags(_flags) => name.unwrap(),
                TypeDefKind::Variant(_variant) => name.unwrap(),
                TypeDefKind::Tuple(t) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "({0})", t.types.iter().map(| t | { let mut s = self
                            .type_to_str(t); s.push_str(", "); s }).collect::< String >
                            ()
                        ),
                    );
                    res
                }
                TypeDefKind::Option(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!("Option<{0}>", self.type_to_str(& ty)),
                    );
                    res
                }
                TypeDefKind::Result(r) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Result<{0}, {1}>", r.ok.map(| ty | self.type_to_str(& ty))
                            .unwrap_or("void".to_string()), r.err.map(| ty | self
                            .type_to_str(& ty)).unwrap_or("void".to_string())
                        ),
                    );
                    res
                }
                TypeDefKind::List(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!("List<{0}>", self.type_to_str(& ty)),
                    );
                    res
                }
                TypeDefKind::Future(ty) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Future<{0}>", ty.map(| ty | self.type_to_str(& ty))
                            .unwrap_or("void".to_string())
                        ),
                    );
                    res
                }
                TypeDefKind::Stream(s) => {
                    let res = ::alloc::fmt::format(
                        format_args!(
                            "Stream<{0}>", s.element.map(| ty | self.type_to_str(& ty))
                            .unwrap_or("void".to_string())
                        ),
                    );
                    res
                }
                TypeDefKind::Type(ty) => self.type_to_str(&ty),
                TypeDefKind::Unknown => {
                    ::core::panicking::panic_fmt(
                        format_args!(
                            "not implemented: {0}", format_args!("Unknown type")
                        ),
                    )
                }
            }
        }
        pub fn type_def_to_name_definition(&self, ty: &TypeDef) -> Option<String> {
            if let Some(v) = &ty.name {
                let defined = self.1.get(v as &str);
                if let Some(def) = defined {
                    let owner = match ty.owner {
                        TypeOwner::World(id) => {
                            Some(&self.0.worlds.get(id).unwrap().name)
                        }
                        TypeOwner::Interface(id) => {
                            self.0.interfaces.get(id).unwrap().name.as_ref()
                        }
                        TypeOwner::None => None,
                    };
                    let name = {
                        let res = ::alloc::fmt::format(
                            format_args!(
                                "{1}-{0}", owner.unwrap_or(& def.iter().position(| e | (* e)
                                .eq(ty)).unwrap().to_string()), v
                            ),
                        );
                        res
                    };
                    Some(heck::AsPascalCase(name).to_string())
                } else {
                    Some(heck::AsPascalCase(v).to_string())
                }
            } else {
                None
            }
        }
        pub fn type_def_to_definition(&self, ty: &TypeDef) -> String {
            let name = self.type_def_to_name_definition(ty);
            let mut s = String::new();
            add_docs(&mut s, &ty.docs);
            match &ty.kind {
                TypeDefKind::Record(r) => {
                    let name = name.unwrap();
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!("class {0} {{", name),
                            );
                            res
                        },
                    );
                    r.fields
                        .iter()
                        .for_each(|f| {
                            add_docs(&mut s, &f.docs);
                            s.push_str(
                                &{
                                    let res = ::alloc::fmt::format(
                                        format_args!(
                                            "final {0} {1};", self.type_to_str(& f.ty), f.name.as_var()
                                        ),
                                    );
                                    res
                                },
                            );
                        });
                    if r.fields.is_empty() {
                        s.push_str(
                            &{
                                let res = ::alloc::fmt::format(
                                    format_args!("\n\nconst {0}();", name),
                                );
                                res
                            },
                        );
                    } else {
                        s.push_str(
                            &{
                                let res = ::alloc::fmt::format(
                                    format_args!("\n\nconst {0}({{", name),
                                );
                                res
                            },
                        );
                        r.fields
                            .iter()
                            .for_each(|f| {
                                s.push_str(
                                    &{
                                        let res = ::alloc::fmt::format(
                                            format_args!("required this.{0},", f.name.as_var()),
                                        );
                                        res
                                    },
                                );
                            });
                        s.push_str("});");
                    }
                    if r.fields.is_empty() {
                        s.push_str(
                            &{
                                let res = ::alloc::fmt::format(
                                    format_args!(
                                        "\n\nfactory {0}.fromJson(Object? _) => const {0}();", name
                                    ),
                                );
                                res
                            },
                        );
                    } else {
                        let spread = r
                            .fields
                            .iter()
                            .map(|f| {
                                let res = ::alloc::fmt::format(
                                    format_args!("final {0}", f.name.as_var()),
                                );
                                res
                            })
                            .collect::<Vec<_>>()
                            .join(",");
                        let s_comma = if r.fields.len() == 1 { "," } else { "" };
                        s.push_str(
                            &{
                                let res = ::alloc::fmt::format(
                                    format_args!(
                                        "\n\nfactory {1}.fromJson(Object? json_) {{\n                        final json = json_ is Map ? _spec.fields.map((f) => json_[f.label]).toList(growable: false) : json_;\n                        return switch (json) {{\n                            [{2}] || ({2}{3}) => {1}({0}),\n                            _ => throw Exception(\'Invalid JSON $json_\')}};\n                        }}",
                                        r.fields.iter().map(| f | { let res =
                                        ::alloc::fmt::format(format_args!("{0}: {1},", f.name
                                        .as_var(), self.type_from_json(& f.name.as_var(), & f.ty)));
                                        res }).collect::< String > (), name, spread, s_comma
                                    ),
                                );
                                res
                            },
                        );
                    }
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "\nObject? toJson() => {{{0}}};\n", r.fields.iter().map(| f
                                    | { let res =
                                    ::alloc::fmt::format(format_args!("\'{0}\': {1},", f.name,
                                    self.type_to_json(& f.name.as_var(), & f.ty))); res })
                                    .collect::< String > ()
                                ),
                            );
                            res
                        },
                    );
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "static const _spec = {0};", self.type_def_to_spec(& ty)
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("}");
                    s
                }
                TypeDefKind::Enum(e) => {
                    let name = name.unwrap();
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!("enum {0} {{", name),
                            );
                            res
                        },
                    );
                    e.cases
                        .iter()
                        .enumerate()
                        .for_each(|(i, v)| {
                            add_docs(&mut s, &v.docs);
                            s.push_str(
                                &{
                                    let res = ::alloc::fmt::format(
                                        format_args!(
                                            "{0}{1}", v.name.as_var(), if i == e.cases.len() - 1 { ";" }
                                            else { "," }
                                        ),
                                    );
                                    res
                                },
                            );
                        });
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "factory {0}.fromJson(Object? json_) {{\n                        final json = json_ is Map ? json_.keys.first : json_;\n                        if (json is String) {{\n                            final index = _spec.labels.indexOf(json);\n                            return index != -1 ? values[index] : values.byName(json);\n                        }}\n                        return values[json! as int];}}",
                                    name
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("\nObject? toJson() => _spec.labels[index];\n");
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "static const _spec = {0};", self.type_def_to_spec(& ty)
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("}");
                    s
                }
                TypeDefKind::Union(u) => {
                    let name = name.unwrap();
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "sealed class {1} {{\n                    factory {1}.fromJson(Object? json_) {{\n                        Object? json = json_;\n                        if (json is Map) {{\n                            final k = json.keys.first;\n                            json = (k is int ? k : int.parse(k! as String), json.values.first);\n                        }}\n                        return switch (json) {{ {0} _ => throw Exception(\'Invalid JSON $json_\'), }};\n                    }}",
                                    u.cases.iter().enumerate().map(| (i, v) | { let ty = self
                                    .type_to_str(& v.ty); let inner_name = heck::AsPascalCase(&
                                    ty); { let res =
                                    ::alloc::fmt::format(format_args!("({1}, final value) => {2}{3}({0}),",
                                    self.type_from_json("value", & v.ty), i, name, inner_name));
                                    res } }).collect::< String > (), name
                                ),
                            );
                            res
                        },
                    );
                    let mut cases_string = String::new();
                    u.cases
                        .iter()
                        .enumerate()
                        .for_each(|(i, v)| {
                            add_docs(&mut cases_string, &v.docs);
                            let ty = self.type_to_str(&v.ty);
                            let inner_name = heck::AsPascalCase(&ty);
                            let class_name = {
                                let res = ::alloc::fmt::format(
                                    format_args!("{0}{1}", name, inner_name),
                                );
                                res
                            };
                            cases_string
                                .push_str(
                                    &{
                                        let res = ::alloc::fmt::format(
                                            format_args!(
                                                "class {1} implements {2} {{ final {3} value; const {1}(this.value);\n                         @override\nObject? toJson() => {{\'{4}\': {0}}}; }}",
                                                self.type_to_json("value", & v.ty), class_name, name, ty, i
                                            ),
                                        );
                                        res
                                    },
                                );
                            s.push_str(
                                &{
                                    let res = ::alloc::fmt::format(
                                        format_args!(
                                            "const factory {1}.{0}({2} value) = {3};", ty.as_var(),
                                            name, ty, class_name
                                        ),
                                    );
                                    res
                                },
                            );
                        });
                    s.push_str("\n\nObject? toJson();\n");
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "static const _spec = {0};", self.type_def_to_spec(& ty)
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("}");
                    s.push_str(&cases_string);
                    s
                }
                TypeDefKind::Variant(a) => {
                    let name = name.unwrap();
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "sealed class {1} {{ factory {1}.fromJson(Object? json_) {{\n                    Object? json = json_;\n                    if (json is Map) {{\n                        final k = json.keys.first;\n                        json = (\n                          k is int ? k : _spec.cases.indexWhere((c) => c.label == k),\n                          json.values.first\n                        );\n                    }}\n                    return switch (json) {{ {0} _ => throw Exception(\'Invalid JSON $json_\'), }};\n                }}",
                                    a.cases.iter().enumerate().map(| (i, v) | { let inner_name =
                                    heck::AsPascalCase(& v.name); match v.ty { Some(ty) => { let
                                    res =
                                    ::alloc::fmt::format(format_args!("({1}, final value) => {2}{3}({0}),",
                                    self.type_from_json("value", & ty), i, name, inner_name));
                                    res } None => { let res =
                                    ::alloc::fmt::format(format_args!("({0}, null) => const {1}{2}(),",
                                    i, name, inner_name)); res } } }).collect::< String > (),
                                    name
                                ),
                            );
                            res
                        },
                    );
                    let mut cases_string = String::new();
                    a.cases
                        .iter()
                        .for_each(|v| {
                            add_docs(&mut cases_string, &v.docs);
                            let inner_name = heck::AsPascalCase(&v.name);
                            let class_name = {
                                let res = ::alloc::fmt::format(
                                    format_args!("{0}{1}", name, inner_name),
                                );
                                res
                            };
                            if let Some(ty) = v.ty {
                                let ty_str = self.type_to_str(&ty);
                                cases_string
                                    .push_str(
                                        &{
                                            let res = ::alloc::fmt::format(
                                                format_args!(
                                                    "class {2} implements {3} {{ final {4} value; const {2}(this.value);\n                            @override\nObject? toJson() => {{\'{0}\': {1}}};\n                         }}",
                                                    v.name, self.type_to_json("value", & ty), class_name, name,
                                                    ty_str
                                                ),
                                            );
                                            res
                                        },
                                    );
                                s.push_str(
                                    &{
                                        let res = ::alloc::fmt::format(
                                            format_args!(
                                                "const factory {1}.{0}({2} value) = {3};", v.name.as_var(),
                                                name, ty_str, class_name
                                            ),
                                        );
                                        res
                                    },
                                );
                            } else {
                                cases_string
                                    .push_str(
                                        &{
                                            let res = ::alloc::fmt::format(
                                                format_args!(
                                                    "class {1} implements {2} {{ const {1}();\n                            @override\nObject? toJson() => {{\'{0}\': null}}; }}",
                                                    v.name, class_name, name
                                                ),
                                            );
                                            res
                                        },
                                    );
                                s.push_str(
                                    &{
                                        let res = ::alloc::fmt::format(
                                            format_args!(
                                                "const factory {1}.{0}() = {2};", v.name.as_var(), name,
                                                class_name
                                            ),
                                        );
                                        res
                                    },
                                );
                            }
                        });
                    s.push_str("\n\nObject? toJson();\n");
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "static const _spec = {0};", self.type_def_to_spec(& ty)
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("}");
                    s.push_str(&cases_string);
                    s
                }
                TypeDefKind::Flags(f) => {
                    let name = name.unwrap();
                    let num_bytes = ((f.flags.len() + 32 - 1) / 32) * 4;
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "class {0} {{ final ByteData flagBits; const {0}(this.flagBits); {0}.none(): flagBits = ByteData({1});\n                    {0}.all(): flagBits = (Uint8List({1})..fillRange(0, {1}, 255)).buffer.asByteData();\n\n                    factory {0}.fromJson(Object? json) {{\n                        final flagBits = flagBitsFromJson(json, _spec);\n                        return {0}(flagBits);\n                    }}\n\n                    Object toJson() => Uint32List.view(flagBits.buffer);\n                    \n                    int _index(int i) => flagBits.getUint32(i, Endian.little);\n                    void _setIndex(int i, int flag, bool enable) {{\n                        final currentValue = _index(i);\n                        flagBits.setUint32(\n                            i,\n                            enable ? (flag | currentValue) : ((~flag) & currentValue),\n                            Endian.little,\n                        );\n                    }}\n                    ",
                                    name, num_bytes
                                ),
                            );
                            res
                        },
                    );
                    f.flags
                        .iter()
                        .enumerate()
                        .for_each(|(i, v)| {
                            let property = v.name.as_var();
                            let index = (i / 32) * 4;
                            let flag = 2_u32.pow(i.try_into().unwrap());
                            let getter = {
                                let res = ::alloc::fmt::format(
                                    format_args!("_index({0})", index),
                                );
                                res
                            };
                            add_docs(&mut s, &v.docs);
                            s.push_str(
                                &{
                                    let res = ::alloc::fmt::format(
                                        format_args!(
                                            "bool get {0} => ({1} & {2}) != 0;", property, getter, flag
                                        ),
                                    );
                                    res
                                },
                            );
                            s.push_str(
                                &{
                                    let res = ::alloc::fmt::format(
                                        format_args!(
                                            "set {0}(bool enable) => _setIndex({1}, {2}, enable);",
                                            property, index, flag
                                        ),
                                    );
                                    res
                                },
                            );
                        });
                    s.push_str(
                        &{
                            let res = ::alloc::fmt::format(
                                format_args!(
                                    "static const _spec = {0};", self.type_def_to_spec(& ty)
                                ),
                            );
                            res
                        },
                    );
                    s.push_str("}");
                    s
                }
                TypeDefKind::Type(ty) => self.type_to_dart_definition(ty),
                TypeDefKind::List(_)
                | TypeDefKind::Tuple(_)
                | TypeDefKind::Option(_)
                | TypeDefKind::Result(_)
                | TypeDefKind::Future(_)
                | TypeDefKind::Stream(_) => {
                    if let Some(name) = name {
                        s.push_str(
                            &{
                                let res = ::alloc::fmt::format(
                                    format_args!(
                                        "typedef {1} = {0};", self.type_def_to_name(ty, false), name
                                    ),
                                );
                                res
                            },
                        );
                    }
                    s
                }
                TypeDefKind::Unknown => ::core::panicking::panic("not yet implemented"),
            }
        }
    }
}
#[allow(clippy::all)]
pub mod types_interface {
    pub type T9 = wit_bindgen::rt::vec::Vec<wit_bindgen::rt::string::String>;
    pub type T2 = (u32, u64);
    pub type T10 = T9;
    /// a bitflags type
    pub struct Permissions(
        <Permissions as ::bitflags::__private::PublicFlags>::Internal,
    );
    #[automatically_derived]
    impl ::core::marker::StructuralPartialEq for Permissions {}
    #[automatically_derived]
    impl ::core::cmp::PartialEq for Permissions {
        #[inline]
        fn eq(&self, other: &Permissions) -> bool {
            self.0 == other.0
        }
    }
    #[automatically_derived]
    impl ::core::marker::StructuralEq for Permissions {}
    #[automatically_derived]
    impl ::core::cmp::Eq for Permissions {
        #[inline]
        #[doc(hidden)]
        #[no_coverage]
        fn assert_receiver_is_total_eq(&self) -> () {
            let _: ::core::cmp::AssertParamIsEq<
                <Permissions as ::bitflags::__private::PublicFlags>::Internal,
            >;
        }
    }
    #[automatically_derived]
    impl ::core::cmp::PartialOrd for Permissions {
        #[inline]
        fn partial_cmp(
            &self,
            other: &Permissions,
        ) -> ::core::option::Option<::core::cmp::Ordering> {
            ::core::cmp::PartialOrd::partial_cmp(&self.0, &other.0)
        }
    }
    #[automatically_derived]
    impl ::core::cmp::Ord for Permissions {
        #[inline]
        fn cmp(&self, other: &Permissions) -> ::core::cmp::Ordering {
            ::core::cmp::Ord::cmp(&self.0, &other.0)
        }
    }
    #[automatically_derived]
    impl ::core::hash::Hash for Permissions {
        fn hash<__H: ::core::hash::Hasher>(&self, state: &mut __H) -> () {
            ::core::hash::Hash::hash(&self.0, state)
        }
    }
    #[automatically_derived]
    impl ::core::fmt::Debug for Permissions {
        fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
            ::core::fmt::Formatter::debug_tuple_field1_finish(f, "Permissions", &&self.0)
        }
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Permissions {
        #[inline]
        fn clone(&self) -> Permissions {
            let _: ::core::clone::AssertParamIsClone<
                <Permissions as ::bitflags::__private::PublicFlags>::Internal,
            >;
            *self
        }
    }
    #[automatically_derived]
    impl ::core::marker::Copy for Permissions {}
    impl Permissions {
        #[allow(dead_code, deprecated, unused_attributes, non_upper_case_globals)]
        pub const READ: Self = Self::from_bits_retain(1 << 0);
        #[allow(dead_code, deprecated, unused_attributes, non_upper_case_globals)]
        pub const WRITE: Self = Self::from_bits_retain(1 << 1);
        #[allow(dead_code, deprecated, unused_attributes, non_upper_case_globals)]
        pub const EXEC: Self = Self::from_bits_retain(1 << 2);
    }
    #[allow(
        dead_code,
        deprecated,
        unused_doc_comments,
        unused_attributes,
        unused_mut,
        unused_imports,
        non_upper_case_globals
    )]
    const _: () = {
        #[repr(transparent)]
        pub struct InternalBitFlags {
            bits: u8,
        }
        #[automatically_derived]
        impl ::core::clone::Clone for InternalBitFlags {
            #[inline]
            fn clone(&self) -> InternalBitFlags {
                let _: ::core::clone::AssertParamIsClone<u8>;
                *self
            }
        }
        #[automatically_derived]
        impl ::core::marker::Copy for InternalBitFlags {}
        #[automatically_derived]
        impl ::core::marker::StructuralPartialEq for InternalBitFlags {}
        #[automatically_derived]
        impl ::core::cmp::PartialEq for InternalBitFlags {
            #[inline]
            fn eq(&self, other: &InternalBitFlags) -> bool {
                self.bits == other.bits
            }
        }
        #[automatically_derived]
        impl ::core::marker::StructuralEq for InternalBitFlags {}
        #[automatically_derived]
        impl ::core::cmp::Eq for InternalBitFlags {
            #[inline]
            #[doc(hidden)]
            #[no_coverage]
            fn assert_receiver_is_total_eq(&self) -> () {
                let _: ::core::cmp::AssertParamIsEq<u8>;
            }
        }
        #[automatically_derived]
        impl ::core::cmp::PartialOrd for InternalBitFlags {
            #[inline]
            fn partial_cmp(
                &self,
                other: &InternalBitFlags,
            ) -> ::core::option::Option<::core::cmp::Ordering> {
                ::core::cmp::PartialOrd::partial_cmp(&self.bits, &other.bits)
            }
        }
        #[automatically_derived]
        impl ::core::cmp::Ord for InternalBitFlags {
            #[inline]
            fn cmp(&self, other: &InternalBitFlags) -> ::core::cmp::Ordering {
                ::core::cmp::Ord::cmp(&self.bits, &other.bits)
            }
        }
        #[automatically_derived]
        impl ::core::hash::Hash for InternalBitFlags {
            fn hash<__H: ::core::hash::Hasher>(&self, state: &mut __H) -> () {
                ::core::hash::Hash::hash(&self.bits, state)
            }
        }
        pub struct Iter {
            inner: IterRaw,
            done: bool,
        }
        pub struct IterRaw {
            idx: usize,
            source: InternalBitFlags,
            state: InternalBitFlags,
        }
        impl ::bitflags::__private::PublicFlags for Permissions {
            type Internal = InternalBitFlags;
        }
        impl ::bitflags::__private::core::default::Default for InternalBitFlags {
            #[inline]
            fn default() -> Self {
                InternalBitFlags::empty()
            }
        }
        impl ::bitflags::__private::core::fmt::Debug for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter<'_>,
            ) -> ::bitflags::__private::core::fmt::Result {
                if self.is_empty() {
                    f.write_fmt(
                        format_args!(
                            "{0:#x}", < u8 as ::bitflags::__private::Bits >::EMPTY
                        ),
                    )
                } else {
                    ::bitflags::__private::core::fmt::Display::fmt(self, f)
                }
            }
        }
        impl ::bitflags::__private::core::fmt::Display for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter<'_>,
            ) -> ::bitflags::__private::core::fmt::Result {
                let mut first = true;
                let mut iter = self.iter_names();
                for (name, _) in &mut iter {
                    if !first {
                        f.write_str(" | ")?;
                    }
                    first = false;
                    f.write_str(name)?;
                }
                let extra_bits = iter.state.bits();
                if extra_bits != <u8 as ::bitflags::__private::Bits>::EMPTY {
                    if !first {
                        f.write_str(" | ")?;
                    }
                    f.write_fmt(format_args!("{0:#x}", extra_bits))?;
                }
                ::bitflags::__private::core::fmt::Result::Ok(())
            }
        }
        impl ::bitflags::__private::core::str::FromStr for InternalBitFlags {
            type Err = ::bitflags::parser::ParseError;
            fn from_str(
                s: &str,
            ) -> ::bitflags::__private::core::result::Result<Self, Self::Err> {
                let s = s.trim();
                let mut parsed_flags = Self::empty();
                if s.is_empty() {
                    return ::bitflags::__private::core::result::Result::Ok(parsed_flags);
                }
                for flag in s.split('|') {
                    let flag = flag.trim();
                    if flag.is_empty() {
                        return ::bitflags::__private::core::result::Result::Err(
                            ::bitflags::parser::ParseError::empty_flag(),
                        );
                    }
                    let parsed_flag = if let ::bitflags::__private::core::option::Option::Some(
                        flag,
                    ) = flag.strip_prefix("0x")
                    {
                        let bits = <u8>::from_str_radix(flag, 16)
                            .map_err(|_| ::bitflags::parser::ParseError::invalid_hex_flag(
                                flag,
                            ))?;
                        Self::from_bits_retain(bits)
                    } else {
                        Self::from_name(flag)
                            .ok_or_else(|| ::bitflags::parser::ParseError::invalid_named_flag(
                                flag,
                            ))?
                    };
                    parsed_flags.insert(parsed_flag);
                }
                ::bitflags::__private::core::result::Result::Ok(parsed_flags)
            }
        }
        impl ::bitflags::__private::core::fmt::Binary for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Binary::fmt(&self.bits(), f)
            }
        }
        impl ::bitflags::__private::core::fmt::Octal for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Octal::fmt(&self.bits(), f)
            }
        }
        impl ::bitflags::__private::core::fmt::LowerHex for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::LowerHex::fmt(&self.bits(), f)
            }
        }
        impl ::bitflags::__private::core::fmt::UpperHex for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::UpperHex::fmt(&self.bits(), f)
            }
        }
        impl InternalBitFlags {
            #[inline]
            pub const fn empty() -> Self {
                Self {
                    bits: <u8 as ::bitflags::__private::Bits>::EMPTY,
                }
            }
            #[inline]
            pub const fn all() -> Self {
                Self::from_bits_truncate(<u8 as ::bitflags::__private::Bits>::ALL)
            }
            #[inline]
            pub const fn bits(&self) -> u8 {
                self.bits
            }
            #[inline]
            pub fn bits_mut(&mut self) -> &mut u8 {
                &mut self.bits
            }
            #[inline]
            pub const fn from_bits(
                bits: u8,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                let truncated = Self::from_bits_truncate(bits).bits;
                if truncated == bits {
                    ::bitflags::__private::core::option::Option::Some(Self { bits })
                } else {
                    ::bitflags::__private::core::option::Option::None
                }
            }
            #[inline]
            pub const fn from_bits_truncate(bits: u8) -> Self {
                if bits == <u8 as ::bitflags::__private::Bits>::EMPTY {
                    return Self { bits };
                }
                let mut truncated = <u8 as ::bitflags::__private::Bits>::EMPTY;
                {
                    if bits & Permissions::READ.bits() == Permissions::READ.bits() {
                        truncated |= Permissions::READ.bits();
                    }
                };
                {
                    if bits & Permissions::WRITE.bits() == Permissions::WRITE.bits() {
                        truncated |= Permissions::WRITE.bits();
                    }
                };
                {
                    if bits & Permissions::EXEC.bits() == Permissions::EXEC.bits() {
                        truncated |= Permissions::EXEC.bits();
                    }
                };
                Self { bits: truncated }
            }
            #[inline]
            pub const fn from_bits_retain(bits: u8) -> Self {
                Self { bits }
            }
            #[inline]
            pub fn from_name(
                name: &str,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                {
                    if name == "READ" {
                        return ::bitflags::__private::core::option::Option::Some(Self {
                            bits: Permissions::READ.bits(),
                        });
                    }
                };
                {
                    if name == "WRITE" {
                        return ::bitflags::__private::core::option::Option::Some(Self {
                            bits: Permissions::WRITE.bits(),
                        });
                    }
                };
                {
                    if name == "EXEC" {
                        return ::bitflags::__private::core::option::Option::Some(Self {
                            bits: Permissions::EXEC.bits(),
                        });
                    }
                };
                let _ = name;
                ::bitflags::__private::core::option::Option::None
            }
            #[inline]
            pub const fn iter(&self) -> Iter {
                Iter {
                    inner: self.iter_names(),
                    done: false,
                }
            }
            #[inline]
            pub const fn iter_names(&self) -> IterRaw {
                IterRaw {
                    idx: 0,
                    source: *self,
                    state: *self,
                }
            }
            #[inline]
            pub const fn is_empty(&self) -> bool {
                self.bits == Self::empty().bits
            }
            #[inline]
            pub const fn is_all(&self) -> bool {
                Self::all().bits | self.bits == self.bits
            }
            #[inline]
            pub const fn intersects(&self, other: Self) -> bool {
                !(Self {
                    bits: self.bits & other.bits,
                })
                    .is_empty()
            }
            #[inline]
            pub const fn contains(&self, other: Self) -> bool {
                (self.bits & other.bits) == other.bits
            }
            #[inline]
            pub fn insert(&mut self, other: Self) {
                self.bits |= other.bits;
            }
            #[inline]
            pub fn remove(&mut self, other: Self) {
                self.bits &= !other.bits;
            }
            #[inline]
            pub fn toggle(&mut self, other: Self) {
                self.bits ^= other.bits;
            }
            #[inline]
            pub fn set(&mut self, other: Self, value: bool) {
                if value {
                    self.insert(other);
                } else {
                    self.remove(other);
                }
            }
            #[inline]
            #[must_use]
            pub const fn intersection(self, other: Self) -> Self {
                Self {
                    bits: self.bits & other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn union(self, other: Self) -> Self {
                Self {
                    bits: self.bits | other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn difference(self, other: Self) -> Self {
                Self {
                    bits: self.bits & !other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn symmetric_difference(self, other: Self) -> Self {
                Self {
                    bits: self.bits ^ other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn complement(self) -> Self {
                Self::from_bits_truncate(!self.bits)
            }
        }
        impl ::bitflags::__private::core::convert::AsRef<u8> for InternalBitFlags {
            fn as_ref(&self) -> &u8 {
                &self.bits
            }
        }
        impl ::bitflags::__private::core::convert::From<u8> for InternalBitFlags {
            fn from(bits: u8) -> Self {
                Self::from_bits_retain(bits)
            }
        }
        impl ::bitflags::__private::core::iter::Iterator for Iter {
            type Item = Permissions;
            fn next(
                &mut self,
            ) -> ::bitflags::__private::core::option::Option<Self::Item> {
                match self.inner.next().map(|(_, value)| value) {
                    ::bitflags::__private::core::option::Option::Some(value) => {
                        ::bitflags::__private::core::option::Option::Some(value)
                    }
                    ::bitflags::__private::core::option::Option::None if !self.done => {
                        self.done = true;
                        if self.inner.state != InternalBitFlags::empty() {
                            ::bitflags::__private::core::option::Option::Some(
                                Permissions::from_bits_retain(self.inner.state.bits()),
                            )
                        } else {
                            ::bitflags::__private::core::option::Option::None
                        }
                    }
                    _ => ::bitflags::__private::core::option::Option::None,
                }
            }
        }
        impl ::bitflags::__private::core::iter::Iterator for IterRaw {
            type Item = (&'static str, Permissions);
            fn next(
                &mut self,
            ) -> ::bitflags::__private::core::option::Option<Self::Item> {
                const NUM_FLAGS: usize = {
                    let mut num_flags = 0;
                    {
                        {
                            num_flags += 1;
                        }
                    };
                    {
                        {
                            num_flags += 1;
                        }
                    };
                    {
                        {
                            num_flags += 1;
                        }
                    };
                    num_flags
                };
                const OPTIONS: [u8; NUM_FLAGS] = [
                    { Permissions::READ.bits() },
                    { Permissions::WRITE.bits() },
                    { Permissions::EXEC.bits() },
                ];
                const OPTIONS_NAMES: [&'static str; NUM_FLAGS] = [
                    { "READ" },
                    { "WRITE" },
                    { "EXEC" },
                ];
                if self.state.is_empty() || NUM_FLAGS == 0 {
                    ::bitflags::__private::core::option::Option::None
                } else {
                    #[allow(clippy::indexing_slicing)]
                    for (flag, flag_name) in OPTIONS[self.idx..NUM_FLAGS]
                        .iter()
                        .copied()
                        .zip(OPTIONS_NAMES[self.idx..NUM_FLAGS].iter().copied())
                    {
                        self.idx += 1;
                        if self.source.contains(InternalBitFlags { bits: flag }) {
                            self.state.remove(InternalBitFlags { bits: flag });
                            return ::bitflags::__private::core::option::Option::Some((
                                flag_name,
                                Permissions::from_bits_retain(flag),
                            ));
                        }
                    }
                    ::bitflags::__private::core::option::Option::None
                }
            }
        }
        impl ::bitflags::__private::core::fmt::Binary for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Binary::fmt(&self.0, f)
            }
        }
        impl ::bitflags::__private::core::fmt::Octal for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Octal::fmt(&self.0, f)
            }
        }
        impl ::bitflags::__private::core::fmt::LowerHex for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::LowerHex::fmt(&self.0, f)
            }
        }
        impl ::bitflags::__private::core::fmt::UpperHex for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::UpperHex::fmt(&self.0, f)
            }
        }
        impl Permissions {
            /// Returns an empty set of flags.
            #[inline]
            pub const fn empty() -> Self {
                Self(InternalBitFlags::empty())
            }
            /// Returns the set containing all flags.
            #[inline]
            pub const fn all() -> Self {
                Self(InternalBitFlags::all())
            }
            /// Returns the raw value of the flags currently stored.
            #[inline]
            pub const fn bits(&self) -> u8 {
                self.0.bits()
            }
            /// Convert from underlying bit representation, unless that
            /// representation contains bits that do not correspond to a flag.
            #[inline]
            pub const fn from_bits(
                bits: u8,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                match InternalBitFlags::from_bits(bits) {
                    ::bitflags::__private::core::option::Option::Some(bits) => {
                        ::bitflags::__private::core::option::Option::Some(Self(bits))
                    }
                    ::bitflags::__private::core::option::Option::None => {
                        ::bitflags::__private::core::option::Option::None
                    }
                }
            }
            /// Convert from underlying bit representation, dropping any bits
            /// that do not correspond to flags.
            #[inline]
            pub const fn from_bits_truncate(bits: u8) -> Self {
                Self(InternalBitFlags::from_bits_truncate(bits))
            }
            /// Convert from underlying bit representation, preserving all
            /// bits (even those not corresponding to a defined flag).
            #[inline]
            pub const fn from_bits_retain(bits: u8) -> Self {
                Self(InternalBitFlags::from_bits_retain(bits))
            }
            /// Get the value for a flag from its stringified name.
            ///
            /// Names are _case-sensitive_, so must correspond exactly to
            /// the identifier given to the flag.
            #[inline]
            pub fn from_name(
                name: &str,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                match InternalBitFlags::from_name(name) {
                    ::bitflags::__private::core::option::Option::Some(bits) => {
                        ::bitflags::__private::core::option::Option::Some(Self(bits))
                    }
                    ::bitflags::__private::core::option::Option::None => {
                        ::bitflags::__private::core::option::Option::None
                    }
                }
            }
            /// Iterate over enabled flag values.
            #[inline]
            pub const fn iter(&self) -> Iter {
                self.0.iter()
            }
            /// Iterate over enabled flag values with their stringified names.
            #[inline]
            pub const fn iter_names(&self) -> IterRaw {
                self.0.iter_names()
            }
            /// Returns `true` if no flags are currently stored.
            #[inline]
            pub const fn is_empty(&self) -> bool {
                self.0.is_empty()
            }
            /// Returns `true` if all flags are currently set.
            #[inline]
            pub const fn is_all(&self) -> bool {
                self.0.is_all()
            }
            /// Returns `true` if there are flags common to both `self` and `other`.
            #[inline]
            pub const fn intersects(&self, other: Self) -> bool {
                self.0.intersects(other.0)
            }
            /// Returns `true` if all of the flags in `other` are contained within `self`.
            #[inline]
            pub const fn contains(&self, other: Self) -> bool {
                self.0.contains(other.0)
            }
            /// Inserts the specified flags in-place.
            #[inline]
            pub fn insert(&mut self, other: Self) {
                self.0.insert(other.0)
            }
            /// Removes the specified flags in-place.
            #[inline]
            pub fn remove(&mut self, other: Self) {
                self.0.remove(other.0)
            }
            /// Toggles the specified flags in-place.
            #[inline]
            pub fn toggle(&mut self, other: Self) {
                self.0.toggle(other.0)
            }
            /// Inserts or removes the specified flags depending on the passed value.
            #[inline]
            pub fn set(&mut self, other: Self, value: bool) {
                self.0.set(other.0, value)
            }
            /// Returns the intersection between the flags in `self` and
            /// `other`.
            ///
            /// Specifically, the returned set contains only the flags which are
            /// present in *both* `self` *and* `other`.
            ///
            /// This is equivalent to using the `&` operator (e.g.
            /// [`ops::BitAnd`]), as in `flags & other`.
            ///
            /// [`ops::BitAnd`]: https://doc.rust-lang.org/std/ops/trait.BitAnd.html
            #[inline]
            #[must_use]
            pub const fn intersection(self, other: Self) -> Self {
                Self(self.0.intersection(other.0))
            }
            /// Returns the union of between the flags in `self` and `other`.
            ///
            /// Specifically, the returned set contains all flags which are
            /// present in *either* `self` *or* `other`, including any which are
            /// present in both (see [`Self::symmetric_difference`] if that
            /// is undesirable).
            ///
            /// This is equivalent to using the `|` operator (e.g.
            /// [`ops::BitOr`]), as in `flags | other`.
            ///
            /// [`ops::BitOr`]: https://doc.rust-lang.org/std/ops/trait.BitOr.html
            #[inline]
            #[must_use]
            pub const fn union(self, other: Self) -> Self {
                Self(self.0.union(other.0))
            }
            /// Returns the difference between the flags in `self` and `other`.
            ///
            /// Specifically, the returned set contains all flags present in
            /// `self`, except for the ones present in `other`.
            ///
            /// It is also conceptually equivalent to the "bit-clear" operation:
            /// `flags & !other` (and this syntax is also supported).
            ///
            /// This is equivalent to using the `-` operator (e.g.
            /// [`ops::Sub`]), as in `flags - other`.
            ///
            /// [`ops::Sub`]: https://doc.rust-lang.org/std/ops/trait.Sub.html
            #[inline]
            #[must_use]
            pub const fn difference(self, other: Self) -> Self {
                Self(self.0.difference(other.0))
            }
            /// Returns the [symmetric difference][sym-diff] between the flags
            /// in `self` and `other`.
            ///
            /// Specifically, the returned set contains the flags present which
            /// are present in `self` or `other`, but that are not present in
            /// both. Equivalently, it contains the flags present in *exactly
            /// one* of the sets `self` and `other`.
            ///
            /// This is equivalent to using the `^` operator (e.g.
            /// [`ops::BitXor`]), as in `flags ^ other`.
            ///
            /// [sym-diff]: https://en.wikipedia.org/wiki/Symmetric_difference
            /// [`ops::BitXor`]: https://doc.rust-lang.org/std/ops/trait.BitXor.html
            #[inline]
            #[must_use]
            pub const fn symmetric_difference(self, other: Self) -> Self {
                Self(self.0.symmetric_difference(other.0))
            }
            /// Returns the complement of this set of flags.
            ///
            /// Specifically, the returned set contains all the flags which are
            /// not set in `self`, but which are allowed for this type.
            ///
            /// Alternatively, it can be thought of as the set difference
            /// between [`Self::all()`] and `self` (e.g. `Self::all() - self`)
            ///
            /// This is equivalent to using the `!` operator (e.g.
            /// [`ops::Not`]), as in `!flags`.
            ///
            /// [`Self::all()`]: Self::all
            /// [`ops::Not`]: https://doc.rust-lang.org/std/ops/trait.Not.html
            #[inline]
            #[must_use]
            pub const fn complement(self) -> Self {
                Self(self.0.complement())
            }
        }
        impl ::bitflags::__private::core::ops::BitOr for Permissions {
            type Output = Self;
            /// Returns the union of the two sets of flags.
            #[inline]
            fn bitor(self, other: Permissions) -> Self {
                self.union(other)
            }
        }
        impl ::bitflags::__private::core::ops::BitOrAssign for Permissions {
            /// Adds the set of flags.
            #[inline]
            fn bitor_assign(&mut self, other: Self) {
                self.0 = self.0.union(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::BitXor for Permissions {
            type Output = Self;
            /// Returns the left flags, but with all the right flags toggled.
            #[inline]
            fn bitxor(self, other: Self) -> Self {
                self.symmetric_difference(other)
            }
        }
        impl ::bitflags::__private::core::ops::BitXorAssign for Permissions {
            /// Toggles the set of flags.
            #[inline]
            fn bitxor_assign(&mut self, other: Self) {
                self.0 = self.0.symmetric_difference(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::BitAnd for Permissions {
            type Output = Self;
            /// Returns the intersection between the two sets of flags.
            #[inline]
            fn bitand(self, other: Self) -> Self {
                self.intersection(other)
            }
        }
        impl ::bitflags::__private::core::ops::BitAndAssign for Permissions {
            /// Disables all flags disabled in the set.
            #[inline]
            fn bitand_assign(&mut self, other: Self) {
                self.0 = self.0.intersection(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::Sub for Permissions {
            type Output = Self;
            /// Returns the set difference of the two sets of flags.
            #[inline]
            fn sub(self, other: Self) -> Self {
                self.difference(other)
            }
        }
        impl ::bitflags::__private::core::ops::SubAssign for Permissions {
            /// Disables all flags enabled in the set.
            #[inline]
            fn sub_assign(&mut self, other: Self) {
                self.0 = self.0.difference(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::Not for Permissions {
            type Output = Self;
            /// Returns the complement of this set of flags.
            #[inline]
            fn not(self) -> Self {
                self.complement()
            }
        }
        impl ::bitflags::__private::core::iter::Extend<Permissions> for Permissions {
            fn extend<T: ::bitflags::__private::core::iter::IntoIterator<Item = Self>>(
                &mut self,
                iterator: T,
            ) {
                for item in iterator {
                    self.insert(item)
                }
            }
        }
        impl ::bitflags::__private::core::iter::FromIterator<Permissions>
        for Permissions {
            fn from_iter<
                T: ::bitflags::__private::core::iter::IntoIterator<Item = Self>,
            >(iterator: T) -> Self {
                use ::bitflags::__private::core::iter::Extend;
                let mut result = Self::empty();
                result.extend(iterator);
                result
            }
        }
        impl ::bitflags::__private::core::iter::IntoIterator for Permissions {
            type Item = Self;
            type IntoIter = Iter;
            fn into_iter(self) -> Self::IntoIter {
                self.0.iter()
            }
        }
        impl ::bitflags::BitFlags for Permissions {
            type Bits = u8;
            type Iter = Iter;
            type IterNames = IterRaw;
            fn empty() -> Self {
                Permissions::empty()
            }
            fn all() -> Self {
                Permissions::all()
            }
            fn bits(&self) -> u8 {
                Permissions::bits(self)
            }
            fn from_bits(
                bits: u8,
            ) -> ::bitflags::__private::core::option::Option<Permissions> {
                Permissions::from_bits(bits)
            }
            fn from_bits_truncate(bits: u8) -> Permissions {
                Permissions::from_bits_truncate(bits)
            }
            fn from_bits_retain(bits: u8) -> Permissions {
                Permissions::from_bits_retain(bits)
            }
            fn from_name(
                name: &str,
            ) -> ::bitflags::__private::core::option::Option<Permissions> {
                Permissions::from_name(name)
            }
            fn iter(&self) -> Self::Iter {
                Permissions::iter(self)
            }
            fn iter_names(&self) -> Self::IterNames {
                Permissions::iter_names(self)
            }
            fn is_empty(&self) -> bool {
                Permissions::is_empty(self)
            }
            fn is_all(&self) -> bool {
                Permissions::is_all(self)
            }
            fn intersects(&self, other: Permissions) -> bool {
                Permissions::intersects(self, other)
            }
            fn contains(&self, other: Permissions) -> bool {
                Permissions::contains(self, other)
            }
            fn insert(&mut self, other: Permissions) {
                Permissions::insert(self, other)
            }
            fn remove(&mut self, other: Permissions) {
                Permissions::remove(self, other)
            }
            fn toggle(&mut self, other: Permissions) {
                Permissions::toggle(self, other)
            }
            fn set(&mut self, other: Permissions, value: bool) {
                Permissions::set(self, other, value)
            }
        }
        impl ::bitflags::__private::ImplementedByBitFlagsMacro for Permissions {}
    };
    /// similar to `variant`, but no type payloads
    #[repr(u8)]
    pub enum Errno {
        TooBig,
        TooSmall,
        TooFast,
        TooSlow,
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Errno {
        #[inline]
        fn clone(&self) -> Errno {
            *self
        }
    }
    #[automatically_derived]
    impl ::core::marker::Copy for Errno {}
    #[automatically_derived]
    impl ::core::marker::StructuralPartialEq for Errno {}
    #[automatically_derived]
    impl ::core::cmp::PartialEq for Errno {
        #[inline]
        fn eq(&self, other: &Errno) -> bool {
            let __self_tag = ::core::intrinsics::discriminant_value(self);
            let __arg1_tag = ::core::intrinsics::discriminant_value(other);
            __self_tag == __arg1_tag
        }
    }
    #[automatically_derived]
    impl ::core::marker::StructuralEq for Errno {}
    #[automatically_derived]
    impl ::core::cmp::Eq for Errno {
        #[inline]
        #[doc(hidden)]
        #[no_coverage]
        fn assert_receiver_is_total_eq(&self) -> () {}
    }
    impl core::fmt::Debug for Errno {
        fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
            match self {
                Errno::TooBig => f.debug_tuple("Errno::TooBig").finish(),
                Errno::TooSmall => f.debug_tuple("Errno::TooSmall").finish(),
                Errno::TooFast => f.debug_tuple("Errno::TooFast").finish(),
                Errno::TooSlow => f.debug_tuple("Errno::TooSlow").finish(),
            }
        }
    }
    pub type T7 = Result<char, Errno>;
}
#[allow(clippy::all)]
pub mod imports {
    pub type T7 = super::types_interface::T7;
    /// Same name as the type in `types-interface`, but this is a different type
    pub enum Human {
        Baby,
        Child(u64),
        Adult(
            (
                wit_bindgen::rt::string::String,
                Option<Option<wit_bindgen::rt::string::String>>,
                (i64,),
            ),
        ),
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Human {
        #[inline]
        fn clone(&self) -> Human {
            match self {
                Human::Baby => Human::Baby,
                Human::Child(__self_0) => {
                    Human::Child(::core::clone::Clone::clone(__self_0))
                }
                Human::Adult(__self_0) => {
                    Human::Adult(::core::clone::Clone::clone(__self_0))
                }
            }
        }
    }
    impl core::fmt::Debug for Human {
        fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
            match self {
                Human::Baby => f.debug_tuple("Human::Baby").finish(),
                Human::Child(e) => f.debug_tuple("Human::Child").field(e).finish(),
                Human::Adult(e) => f.debug_tuple("Human::Adult").field(e).finish(),
            }
        }
    }
    #[allow(clippy::all)]
    pub fn api_a1_b2(arg: &[&Human]) -> (T7, Human) {
        #[allow(unused_imports)]
        use wit_bindgen::rt::{alloc, vec::Vec, string::String};
        unsafe {
            #[repr(align(8))]
            struct RetArea([u8; 48]);
            let mut ret_area = core::mem::MaybeUninit::<RetArea>::uninit();
            let vec4 = arg;
            let len4 = vec4.len() as i32;
            let layout4 = alloc::Layout::from_size_align_unchecked(vec4.len() * 40, 8);
            let result4 = if layout4.size() != 0 {
                let ptr = alloc::alloc(layout4);
                if ptr.is_null() {
                    alloc::handle_alloc_error(layout4);
                }
                ptr
            } else {
                core::ptr::null_mut()
            };
            for (i, e) in vec4.into_iter().enumerate() {
                let base = result4 as i32 + (i as i32) * 40;
                {
                    match e {
                        Human::Baby => {
                            *((base + 0) as *mut u8) = (0i32) as u8;
                        }
                        Human::Child(e) => {
                            *((base + 0) as *mut u8) = (1i32) as u8;
                            *((base + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                        }
                        Human::Adult(e) => {
                            *((base + 0) as *mut u8) = (2i32) as u8;
                            let (t0_0, t0_1, t0_2) = e;
                            let vec1 = t0_0;
                            let ptr1 = vec1.as_ptr() as i32;
                            let len1 = vec1.len() as i32;
                            *((base + 12) as *mut i32) = len1;
                            *((base + 8) as *mut i32) = ptr1;
                            match t0_1 {
                                Some(e) => {
                                    *((base + 16) as *mut u8) = (1i32) as u8;
                                    match e {
                                        Some(e) => {
                                            *((base + 20) as *mut u8) = (1i32) as u8;
                                            let vec2 = e;
                                            let ptr2 = vec2.as_ptr() as i32;
                                            let len2 = vec2.len() as i32;
                                            *((base + 28) as *mut i32) = len2;
                                            *((base + 24) as *mut i32) = ptr2;
                                        }
                                        None => {
                                            *((base + 20) as *mut u8) = (0i32) as u8;
                                        }
                                    };
                                }
                                None => {
                                    *((base + 16) as *mut u8) = (0i32) as u8;
                                }
                            };
                            let (t3_0,) = t0_2;
                            *((base + 32) as *mut i64) = wit_bindgen::rt::as_i64(t3_0);
                        }
                    };
                }
            }
            let ptr5 = ret_area.as_mut_ptr() as i32;
            #[link(wasm_import_module = "imports")]
            extern "C" {
                #[link_name = "imports_api-a1-b2"]
                fn wit_import(_: i32, _: i32, _: i32);
            }
            wit_import(result4 as i32, len4, ptr5);
            if layout4.size() != 0 {
                alloc::dealloc(result4, layout4);
            }
            (
                match i32::from(*((ptr5 + 0) as *const u8)) {
                    0 => {
                        Ok({
                            #[cfg(debug_assertions)]
                            {
                                core::char::from_u32(*((ptr5 + 4) as *const i32) as u32)
                                    .unwrap()
                            }
                        })
                    }
                    1 => {
                        Err({
                            #[cfg(debug_assertions)]
                            {
                                match i32::from(*((ptr5 + 4) as *const u8)) {
                                    0 => super::types_interface::Errno::TooBig,
                                    1 => super::types_interface::Errno::TooSmall,
                                    2 => super::types_interface::Errno::TooFast,
                                    3 => super::types_interface::Errno::TooSlow,
                                    _ => {
                                        ::core::panicking::panic_fmt(
                                            format_args!("invalid enum discriminant"),
                                        )
                                    }
                                }
                            }
                        })
                    }
                    #[cfg(debug_assertions)]
                    _ => {
                        ::core::panicking::panic_fmt(
                            format_args!("invalid enum discriminant"),
                        )
                    }
                },
                {
                    {
                        match i32::from(*((ptr5 + 8) as *const u8)) {
                            0 => Human::Baby,
                            1 => Human::Child(*((ptr5 + 16) as *const i64) as u64),
                            #[cfg(debug_assertions)]
                            2 => {
                                Human::Adult({
                                    let len6 = *((ptr5 + 20) as *const i32) as usize;
                                    (
                                        {
                                            #[cfg(debug_assertions)]
                                            {
                                                String::from_utf8(
                                                        Vec::from_raw_parts(
                                                            *((ptr5 + 16) as *const i32) as *mut _,
                                                            len6,
                                                            len6,
                                                        ),
                                                    )
                                                    .unwrap()
                                            }
                                        },
                                        match i32::from(*((ptr5 + 24) as *const u8)) {
                                            0 => None,
                                            1 => {
                                                Some(
                                                    match i32::from(*((ptr5 + 28) as *const u8)) {
                                                        0 => None,
                                                        1 => {
                                                            Some({
                                                                let len7 = *((ptr5 + 36) as *const i32) as usize;
                                                                {
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        String::from_utf8(
                                                                                Vec::from_raw_parts(
                                                                                    *((ptr5 + 32) as *const i32) as *mut _,
                                                                                    len7,
                                                                                    len7,
                                                                                ),
                                                                            )
                                                                            .unwrap()
                                                                    }
                                                                }
                                                            })
                                                        }
                                                        #[cfg(debug_assertions)]
                                                        _ => {
                                                            ::core::panicking::panic_fmt(
                                                                format_args!("invalid enum discriminant"),
                                                            )
                                                        }
                                                    },
                                                )
                                            }
                                            #[cfg(debug_assertions)]
                                            _ => {
                                                ::core::panicking::panic_fmt(
                                                    format_args!("invalid enum discriminant"),
                                                )
                                            }
                                        },
                                        (*((ptr5 + 40) as *const i64),),
                                    )
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                )
                            }
                        }
                    }
                },
            )
        }
    }
}
#[allow(clippy::all)]
pub mod inline {
    #[allow(clippy::all)]
    /// Comment for import inline function
    pub fn inline_imp(args: &[Option<char>]) -> Result<(), char> {
        #[allow(unused_imports)]
        use wit_bindgen::rt::{alloc, vec::Vec, string::String};
        unsafe {
            #[repr(align(4))]
            struct RetArea([u8; 8]);
            let mut ret_area = core::mem::MaybeUninit::<RetArea>::uninit();
            let vec0 = args;
            let len0 = vec0.len() as i32;
            let layout0 = alloc::Layout::from_size_align_unchecked(vec0.len() * 8, 4);
            let result0 = if layout0.size() != 0 {
                let ptr = alloc::alloc(layout0);
                if ptr.is_null() {
                    alloc::handle_alloc_error(layout0);
                }
                ptr
            } else {
                core::ptr::null_mut()
            };
            for (i, e) in vec0.into_iter().enumerate() {
                let base = result0 as i32 + (i as i32) * 8;
                {
                    match e {
                        Some(e) => {
                            *((base + 0) as *mut u8) = (1i32) as u8;
                            *((base + 4) as *mut i32) = wit_bindgen::rt::as_i32(e);
                        }
                        None => {
                            *((base + 0) as *mut u8) = (0i32) as u8;
                        }
                    };
                }
            }
            let ptr1 = ret_area.as_mut_ptr() as i32;
            #[link(wasm_import_module = "inline")]
            extern "C" {
                #[link_name = "inline_inline-imp"]
                fn wit_import(_: i32, _: i32, _: i32);
            }
            wit_import(result0 as i32, len0, ptr1);
            if layout0.size() != 0 {
                alloc::dealloc(result0, layout0);
            }
            match i32::from(*((ptr1 + 0) as *const u8)) {
                0 => Ok(()),
                1 => {
                    Err({
                        #[cfg(debug_assertions)]
                        {
                            core::char::from_u32(*((ptr1 + 4) as *const i32) as u32)
                                .unwrap()
                        }
                    })
                }
                #[cfg(debug_assertions)]
                _ => {
                    ::core::panicking::panic_fmt(
                        format_args!("invalid enum discriminant"),
                    )
                }
            }
        }
    }
}
pub type T2Renamed = types_interface::T2;
pub type T10 = types_interface::T10;
pub type Permissions = types_interface::Permissions;
#[repr(u8)]
pub enum LogLevel {
    /// lowest level
    Debug,
    Info,
    Warn,
    Error,
}
#[automatically_derived]
impl ::core::clone::Clone for LogLevel {
    #[inline]
    fn clone(&self) -> LogLevel {
        *self
    }
}
#[automatically_derived]
impl ::core::marker::Copy for LogLevel {}
#[automatically_derived]
impl ::core::marker::StructuralPartialEq for LogLevel {}
#[automatically_derived]
impl ::core::cmp::PartialEq for LogLevel {
    #[inline]
    fn eq(&self, other: &LogLevel) -> bool {
        let __self_tag = ::core::intrinsics::discriminant_value(self);
        let __arg1_tag = ::core::intrinsics::discriminant_value(other);
        __self_tag == __arg1_tag
    }
}
#[automatically_derived]
impl ::core::marker::StructuralEq for LogLevel {}
#[automatically_derived]
impl ::core::cmp::Eq for LogLevel {
    #[inline]
    #[doc(hidden)]
    #[no_coverage]
    fn assert_receiver_is_total_eq(&self) -> () {}
}
impl core::fmt::Debug for LogLevel {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            LogLevel::Debug => f.debug_tuple("LogLevel::Debug").finish(),
            LogLevel::Info => f.debug_tuple("LogLevel::Info").finish(),
            LogLevel::Warn => f.debug_tuple("LogLevel::Warn").finish(),
            LogLevel::Error => f.debug_tuple("LogLevel::Error").finish(),
        }
    }
}
#[repr(C)]
pub struct Empty {}
#[automatically_derived]
impl ::core::marker::Copy for Empty {}
#[automatically_derived]
impl ::core::clone::Clone for Empty {
    #[inline]
    fn clone(&self) -> Empty {
        *self
    }
}
impl core::fmt::Debug for Empty {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        f.debug_struct("Empty").finish()
    }
}
#[allow(clippy::all)]
pub fn print(message: &str, level: LogLevel) {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    unsafe {
        let vec0 = message;
        let ptr0 = vec0.as_ptr() as i32;
        let len0 = vec0.len() as i32;
        #[link(wasm_import_module = "$root")]
        extern "C" {
            #[link_name = "$root_print"]
            fn wit_import(_: i32, _: i32, _: i32);
        }
        wit_import(
            ptr0,
            len0,
            match level {
                LogLevel::Debug => 0,
                LogLevel::Info => 1,
                LogLevel::Warn => 2,
                LogLevel::Error => 3,
            },
        );
    }
}
#[allow(clippy::all)]
pub mod types_export {
    pub type T9 = wit_bindgen::rt::vec::Vec<wit_bindgen::rt::string::String>;
    pub type T2 = (u32, u64);
    pub type T10 = T9;
    /// a bitflags type
    pub struct Permissions(
        <Permissions as ::bitflags::__private::PublicFlags>::Internal,
    );
    #[automatically_derived]
    impl ::core::marker::StructuralPartialEq for Permissions {}
    #[automatically_derived]
    impl ::core::cmp::PartialEq for Permissions {
        #[inline]
        fn eq(&self, other: &Permissions) -> bool {
            self.0 == other.0
        }
    }
    #[automatically_derived]
    impl ::core::marker::StructuralEq for Permissions {}
    #[automatically_derived]
    impl ::core::cmp::Eq for Permissions {
        #[inline]
        #[doc(hidden)]
        #[no_coverage]
        fn assert_receiver_is_total_eq(&self) -> () {
            let _: ::core::cmp::AssertParamIsEq<
                <Permissions as ::bitflags::__private::PublicFlags>::Internal,
            >;
        }
    }
    #[automatically_derived]
    impl ::core::cmp::PartialOrd for Permissions {
        #[inline]
        fn partial_cmp(
            &self,
            other: &Permissions,
        ) -> ::core::option::Option<::core::cmp::Ordering> {
            ::core::cmp::PartialOrd::partial_cmp(&self.0, &other.0)
        }
    }
    #[automatically_derived]
    impl ::core::cmp::Ord for Permissions {
        #[inline]
        fn cmp(&self, other: &Permissions) -> ::core::cmp::Ordering {
            ::core::cmp::Ord::cmp(&self.0, &other.0)
        }
    }
    #[automatically_derived]
    impl ::core::hash::Hash for Permissions {
        fn hash<__H: ::core::hash::Hasher>(&self, state: &mut __H) -> () {
            ::core::hash::Hash::hash(&self.0, state)
        }
    }
    #[automatically_derived]
    impl ::core::fmt::Debug for Permissions {
        fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
            ::core::fmt::Formatter::debug_tuple_field1_finish(f, "Permissions", &&self.0)
        }
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Permissions {
        #[inline]
        fn clone(&self) -> Permissions {
            let _: ::core::clone::AssertParamIsClone<
                <Permissions as ::bitflags::__private::PublicFlags>::Internal,
            >;
            *self
        }
    }
    #[automatically_derived]
    impl ::core::marker::Copy for Permissions {}
    impl Permissions {
        #[allow(dead_code, deprecated, unused_attributes, non_upper_case_globals)]
        pub const READ: Self = Self::from_bits_retain(1 << 0);
        #[allow(dead_code, deprecated, unused_attributes, non_upper_case_globals)]
        pub const WRITE: Self = Self::from_bits_retain(1 << 1);
        #[allow(dead_code, deprecated, unused_attributes, non_upper_case_globals)]
        pub const EXEC: Self = Self::from_bits_retain(1 << 2);
    }
    #[allow(
        dead_code,
        deprecated,
        unused_doc_comments,
        unused_attributes,
        unused_mut,
        unused_imports,
        non_upper_case_globals
    )]
    const _: () = {
        #[repr(transparent)]
        pub struct InternalBitFlags {
            bits: u8,
        }
        #[automatically_derived]
        impl ::core::clone::Clone for InternalBitFlags {
            #[inline]
            fn clone(&self) -> InternalBitFlags {
                let _: ::core::clone::AssertParamIsClone<u8>;
                *self
            }
        }
        #[automatically_derived]
        impl ::core::marker::Copy for InternalBitFlags {}
        #[automatically_derived]
        impl ::core::marker::StructuralPartialEq for InternalBitFlags {}
        #[automatically_derived]
        impl ::core::cmp::PartialEq for InternalBitFlags {
            #[inline]
            fn eq(&self, other: &InternalBitFlags) -> bool {
                self.bits == other.bits
            }
        }
        #[automatically_derived]
        impl ::core::marker::StructuralEq for InternalBitFlags {}
        #[automatically_derived]
        impl ::core::cmp::Eq for InternalBitFlags {
            #[inline]
            #[doc(hidden)]
            #[no_coverage]
            fn assert_receiver_is_total_eq(&self) -> () {
                let _: ::core::cmp::AssertParamIsEq<u8>;
            }
        }
        #[automatically_derived]
        impl ::core::cmp::PartialOrd for InternalBitFlags {
            #[inline]
            fn partial_cmp(
                &self,
                other: &InternalBitFlags,
            ) -> ::core::option::Option<::core::cmp::Ordering> {
                ::core::cmp::PartialOrd::partial_cmp(&self.bits, &other.bits)
            }
        }
        #[automatically_derived]
        impl ::core::cmp::Ord for InternalBitFlags {
            #[inline]
            fn cmp(&self, other: &InternalBitFlags) -> ::core::cmp::Ordering {
                ::core::cmp::Ord::cmp(&self.bits, &other.bits)
            }
        }
        #[automatically_derived]
        impl ::core::hash::Hash for InternalBitFlags {
            fn hash<__H: ::core::hash::Hasher>(&self, state: &mut __H) -> () {
                ::core::hash::Hash::hash(&self.bits, state)
            }
        }
        pub struct Iter {
            inner: IterRaw,
            done: bool,
        }
        pub struct IterRaw {
            idx: usize,
            source: InternalBitFlags,
            state: InternalBitFlags,
        }
        impl ::bitflags::__private::PublicFlags for Permissions {
            type Internal = InternalBitFlags;
        }
        impl ::bitflags::__private::core::default::Default for InternalBitFlags {
            #[inline]
            fn default() -> Self {
                InternalBitFlags::empty()
            }
        }
        impl ::bitflags::__private::core::fmt::Debug for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter<'_>,
            ) -> ::bitflags::__private::core::fmt::Result {
                if self.is_empty() {
                    f.write_fmt(
                        format_args!(
                            "{0:#x}", < u8 as ::bitflags::__private::Bits >::EMPTY
                        ),
                    )
                } else {
                    ::bitflags::__private::core::fmt::Display::fmt(self, f)
                }
            }
        }
        impl ::bitflags::__private::core::fmt::Display for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter<'_>,
            ) -> ::bitflags::__private::core::fmt::Result {
                let mut first = true;
                let mut iter = self.iter_names();
                for (name, _) in &mut iter {
                    if !first {
                        f.write_str(" | ")?;
                    }
                    first = false;
                    f.write_str(name)?;
                }
                let extra_bits = iter.state.bits();
                if extra_bits != <u8 as ::bitflags::__private::Bits>::EMPTY {
                    if !first {
                        f.write_str(" | ")?;
                    }
                    f.write_fmt(format_args!("{0:#x}", extra_bits))?;
                }
                ::bitflags::__private::core::fmt::Result::Ok(())
            }
        }
        impl ::bitflags::__private::core::str::FromStr for InternalBitFlags {
            type Err = ::bitflags::parser::ParseError;
            fn from_str(
                s: &str,
            ) -> ::bitflags::__private::core::result::Result<Self, Self::Err> {
                let s = s.trim();
                let mut parsed_flags = Self::empty();
                if s.is_empty() {
                    return ::bitflags::__private::core::result::Result::Ok(parsed_flags);
                }
                for flag in s.split('|') {
                    let flag = flag.trim();
                    if flag.is_empty() {
                        return ::bitflags::__private::core::result::Result::Err(
                            ::bitflags::parser::ParseError::empty_flag(),
                        );
                    }
                    let parsed_flag = if let ::bitflags::__private::core::option::Option::Some(
                        flag,
                    ) = flag.strip_prefix("0x")
                    {
                        let bits = <u8>::from_str_radix(flag, 16)
                            .map_err(|_| ::bitflags::parser::ParseError::invalid_hex_flag(
                                flag,
                            ))?;
                        Self::from_bits_retain(bits)
                    } else {
                        Self::from_name(flag)
                            .ok_or_else(|| ::bitflags::parser::ParseError::invalid_named_flag(
                                flag,
                            ))?
                    };
                    parsed_flags.insert(parsed_flag);
                }
                ::bitflags::__private::core::result::Result::Ok(parsed_flags)
            }
        }
        impl ::bitflags::__private::core::fmt::Binary for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Binary::fmt(&self.bits(), f)
            }
        }
        impl ::bitflags::__private::core::fmt::Octal for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Octal::fmt(&self.bits(), f)
            }
        }
        impl ::bitflags::__private::core::fmt::LowerHex for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::LowerHex::fmt(&self.bits(), f)
            }
        }
        impl ::bitflags::__private::core::fmt::UpperHex for InternalBitFlags {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::UpperHex::fmt(&self.bits(), f)
            }
        }
        impl InternalBitFlags {
            #[inline]
            pub const fn empty() -> Self {
                Self {
                    bits: <u8 as ::bitflags::__private::Bits>::EMPTY,
                }
            }
            #[inline]
            pub const fn all() -> Self {
                Self::from_bits_truncate(<u8 as ::bitflags::__private::Bits>::ALL)
            }
            #[inline]
            pub const fn bits(&self) -> u8 {
                self.bits
            }
            #[inline]
            pub fn bits_mut(&mut self) -> &mut u8 {
                &mut self.bits
            }
            #[inline]
            pub const fn from_bits(
                bits: u8,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                let truncated = Self::from_bits_truncate(bits).bits;
                if truncated == bits {
                    ::bitflags::__private::core::option::Option::Some(Self { bits })
                } else {
                    ::bitflags::__private::core::option::Option::None
                }
            }
            #[inline]
            pub const fn from_bits_truncate(bits: u8) -> Self {
                if bits == <u8 as ::bitflags::__private::Bits>::EMPTY {
                    return Self { bits };
                }
                let mut truncated = <u8 as ::bitflags::__private::Bits>::EMPTY;
                {
                    if bits & Permissions::READ.bits() == Permissions::READ.bits() {
                        truncated |= Permissions::READ.bits();
                    }
                };
                {
                    if bits & Permissions::WRITE.bits() == Permissions::WRITE.bits() {
                        truncated |= Permissions::WRITE.bits();
                    }
                };
                {
                    if bits & Permissions::EXEC.bits() == Permissions::EXEC.bits() {
                        truncated |= Permissions::EXEC.bits();
                    }
                };
                Self { bits: truncated }
            }
            #[inline]
            pub const fn from_bits_retain(bits: u8) -> Self {
                Self { bits }
            }
            #[inline]
            pub fn from_name(
                name: &str,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                {
                    if name == "READ" {
                        return ::bitflags::__private::core::option::Option::Some(Self {
                            bits: Permissions::READ.bits(),
                        });
                    }
                };
                {
                    if name == "WRITE" {
                        return ::bitflags::__private::core::option::Option::Some(Self {
                            bits: Permissions::WRITE.bits(),
                        });
                    }
                };
                {
                    if name == "EXEC" {
                        return ::bitflags::__private::core::option::Option::Some(Self {
                            bits: Permissions::EXEC.bits(),
                        });
                    }
                };
                let _ = name;
                ::bitflags::__private::core::option::Option::None
            }
            #[inline]
            pub const fn iter(&self) -> Iter {
                Iter {
                    inner: self.iter_names(),
                    done: false,
                }
            }
            #[inline]
            pub const fn iter_names(&self) -> IterRaw {
                IterRaw {
                    idx: 0,
                    source: *self,
                    state: *self,
                }
            }
            #[inline]
            pub const fn is_empty(&self) -> bool {
                self.bits == Self::empty().bits
            }
            #[inline]
            pub const fn is_all(&self) -> bool {
                Self::all().bits | self.bits == self.bits
            }
            #[inline]
            pub const fn intersects(&self, other: Self) -> bool {
                !(Self {
                    bits: self.bits & other.bits,
                })
                    .is_empty()
            }
            #[inline]
            pub const fn contains(&self, other: Self) -> bool {
                (self.bits & other.bits) == other.bits
            }
            #[inline]
            pub fn insert(&mut self, other: Self) {
                self.bits |= other.bits;
            }
            #[inline]
            pub fn remove(&mut self, other: Self) {
                self.bits &= !other.bits;
            }
            #[inline]
            pub fn toggle(&mut self, other: Self) {
                self.bits ^= other.bits;
            }
            #[inline]
            pub fn set(&mut self, other: Self, value: bool) {
                if value {
                    self.insert(other);
                } else {
                    self.remove(other);
                }
            }
            #[inline]
            #[must_use]
            pub const fn intersection(self, other: Self) -> Self {
                Self {
                    bits: self.bits & other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn union(self, other: Self) -> Self {
                Self {
                    bits: self.bits | other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn difference(self, other: Self) -> Self {
                Self {
                    bits: self.bits & !other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn symmetric_difference(self, other: Self) -> Self {
                Self {
                    bits: self.bits ^ other.bits,
                }
            }
            #[inline]
            #[must_use]
            pub const fn complement(self) -> Self {
                Self::from_bits_truncate(!self.bits)
            }
        }
        impl ::bitflags::__private::core::convert::AsRef<u8> for InternalBitFlags {
            fn as_ref(&self) -> &u8 {
                &self.bits
            }
        }
        impl ::bitflags::__private::core::convert::From<u8> for InternalBitFlags {
            fn from(bits: u8) -> Self {
                Self::from_bits_retain(bits)
            }
        }
        impl ::bitflags::__private::core::iter::Iterator for Iter {
            type Item = Permissions;
            fn next(
                &mut self,
            ) -> ::bitflags::__private::core::option::Option<Self::Item> {
                match self.inner.next().map(|(_, value)| value) {
                    ::bitflags::__private::core::option::Option::Some(value) => {
                        ::bitflags::__private::core::option::Option::Some(value)
                    }
                    ::bitflags::__private::core::option::Option::None if !self.done => {
                        self.done = true;
                        if self.inner.state != InternalBitFlags::empty() {
                            ::bitflags::__private::core::option::Option::Some(
                                Permissions::from_bits_retain(self.inner.state.bits()),
                            )
                        } else {
                            ::bitflags::__private::core::option::Option::None
                        }
                    }
                    _ => ::bitflags::__private::core::option::Option::None,
                }
            }
        }
        impl ::bitflags::__private::core::iter::Iterator for IterRaw {
            type Item = (&'static str, Permissions);
            fn next(
                &mut self,
            ) -> ::bitflags::__private::core::option::Option<Self::Item> {
                const NUM_FLAGS: usize = {
                    let mut num_flags = 0;
                    {
                        {
                            num_flags += 1;
                        }
                    };
                    {
                        {
                            num_flags += 1;
                        }
                    };
                    {
                        {
                            num_flags += 1;
                        }
                    };
                    num_flags
                };
                const OPTIONS: [u8; NUM_FLAGS] = [
                    { Permissions::READ.bits() },
                    { Permissions::WRITE.bits() },
                    { Permissions::EXEC.bits() },
                ];
                const OPTIONS_NAMES: [&'static str; NUM_FLAGS] = [
                    { "READ" },
                    { "WRITE" },
                    { "EXEC" },
                ];
                if self.state.is_empty() || NUM_FLAGS == 0 {
                    ::bitflags::__private::core::option::Option::None
                } else {
                    #[allow(clippy::indexing_slicing)]
                    for (flag, flag_name) in OPTIONS[self.idx..NUM_FLAGS]
                        .iter()
                        .copied()
                        .zip(OPTIONS_NAMES[self.idx..NUM_FLAGS].iter().copied())
                    {
                        self.idx += 1;
                        if self.source.contains(InternalBitFlags { bits: flag }) {
                            self.state.remove(InternalBitFlags { bits: flag });
                            return ::bitflags::__private::core::option::Option::Some((
                                flag_name,
                                Permissions::from_bits_retain(flag),
                            ));
                        }
                    }
                    ::bitflags::__private::core::option::Option::None
                }
            }
        }
        impl ::bitflags::__private::core::fmt::Binary for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Binary::fmt(&self.0, f)
            }
        }
        impl ::bitflags::__private::core::fmt::Octal for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::Octal::fmt(&self.0, f)
            }
        }
        impl ::bitflags::__private::core::fmt::LowerHex for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::LowerHex::fmt(&self.0, f)
            }
        }
        impl ::bitflags::__private::core::fmt::UpperHex for Permissions {
            fn fmt(
                &self,
                f: &mut ::bitflags::__private::core::fmt::Formatter,
            ) -> ::bitflags::__private::core::fmt::Result {
                ::bitflags::__private::core::fmt::UpperHex::fmt(&self.0, f)
            }
        }
        impl Permissions {
            /// Returns an empty set of flags.
            #[inline]
            pub const fn empty() -> Self {
                Self(InternalBitFlags::empty())
            }
            /// Returns the set containing all flags.
            #[inline]
            pub const fn all() -> Self {
                Self(InternalBitFlags::all())
            }
            /// Returns the raw value of the flags currently stored.
            #[inline]
            pub const fn bits(&self) -> u8 {
                self.0.bits()
            }
            /// Convert from underlying bit representation, unless that
            /// representation contains bits that do not correspond to a flag.
            #[inline]
            pub const fn from_bits(
                bits: u8,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                match InternalBitFlags::from_bits(bits) {
                    ::bitflags::__private::core::option::Option::Some(bits) => {
                        ::bitflags::__private::core::option::Option::Some(Self(bits))
                    }
                    ::bitflags::__private::core::option::Option::None => {
                        ::bitflags::__private::core::option::Option::None
                    }
                }
            }
            /// Convert from underlying bit representation, dropping any bits
            /// that do not correspond to flags.
            #[inline]
            pub const fn from_bits_truncate(bits: u8) -> Self {
                Self(InternalBitFlags::from_bits_truncate(bits))
            }
            /// Convert from underlying bit representation, preserving all
            /// bits (even those not corresponding to a defined flag).
            #[inline]
            pub const fn from_bits_retain(bits: u8) -> Self {
                Self(InternalBitFlags::from_bits_retain(bits))
            }
            /// Get the value for a flag from its stringified name.
            ///
            /// Names are _case-sensitive_, so must correspond exactly to
            /// the identifier given to the flag.
            #[inline]
            pub fn from_name(
                name: &str,
            ) -> ::bitflags::__private::core::option::Option<Self> {
                match InternalBitFlags::from_name(name) {
                    ::bitflags::__private::core::option::Option::Some(bits) => {
                        ::bitflags::__private::core::option::Option::Some(Self(bits))
                    }
                    ::bitflags::__private::core::option::Option::None => {
                        ::bitflags::__private::core::option::Option::None
                    }
                }
            }
            /// Iterate over enabled flag values.
            #[inline]
            pub const fn iter(&self) -> Iter {
                self.0.iter()
            }
            /// Iterate over enabled flag values with their stringified names.
            #[inline]
            pub const fn iter_names(&self) -> IterRaw {
                self.0.iter_names()
            }
            /// Returns `true` if no flags are currently stored.
            #[inline]
            pub const fn is_empty(&self) -> bool {
                self.0.is_empty()
            }
            /// Returns `true` if all flags are currently set.
            #[inline]
            pub const fn is_all(&self) -> bool {
                self.0.is_all()
            }
            /// Returns `true` if there are flags common to both `self` and `other`.
            #[inline]
            pub const fn intersects(&self, other: Self) -> bool {
                self.0.intersects(other.0)
            }
            /// Returns `true` if all of the flags in `other` are contained within `self`.
            #[inline]
            pub const fn contains(&self, other: Self) -> bool {
                self.0.contains(other.0)
            }
            /// Inserts the specified flags in-place.
            #[inline]
            pub fn insert(&mut self, other: Self) {
                self.0.insert(other.0)
            }
            /// Removes the specified flags in-place.
            #[inline]
            pub fn remove(&mut self, other: Self) {
                self.0.remove(other.0)
            }
            /// Toggles the specified flags in-place.
            #[inline]
            pub fn toggle(&mut self, other: Self) {
                self.0.toggle(other.0)
            }
            /// Inserts or removes the specified flags depending on the passed value.
            #[inline]
            pub fn set(&mut self, other: Self, value: bool) {
                self.0.set(other.0, value)
            }
            /// Returns the intersection between the flags in `self` and
            /// `other`.
            ///
            /// Specifically, the returned set contains only the flags which are
            /// present in *both* `self` *and* `other`.
            ///
            /// This is equivalent to using the `&` operator (e.g.
            /// [`ops::BitAnd`]), as in `flags & other`.
            ///
            /// [`ops::BitAnd`]: https://doc.rust-lang.org/std/ops/trait.BitAnd.html
            #[inline]
            #[must_use]
            pub const fn intersection(self, other: Self) -> Self {
                Self(self.0.intersection(other.0))
            }
            /// Returns the union of between the flags in `self` and `other`.
            ///
            /// Specifically, the returned set contains all flags which are
            /// present in *either* `self` *or* `other`, including any which are
            /// present in both (see [`Self::symmetric_difference`] if that
            /// is undesirable).
            ///
            /// This is equivalent to using the `|` operator (e.g.
            /// [`ops::BitOr`]), as in `flags | other`.
            ///
            /// [`ops::BitOr`]: https://doc.rust-lang.org/std/ops/trait.BitOr.html
            #[inline]
            #[must_use]
            pub const fn union(self, other: Self) -> Self {
                Self(self.0.union(other.0))
            }
            /// Returns the difference between the flags in `self` and `other`.
            ///
            /// Specifically, the returned set contains all flags present in
            /// `self`, except for the ones present in `other`.
            ///
            /// It is also conceptually equivalent to the "bit-clear" operation:
            /// `flags & !other` (and this syntax is also supported).
            ///
            /// This is equivalent to using the `-` operator (e.g.
            /// [`ops::Sub`]), as in `flags - other`.
            ///
            /// [`ops::Sub`]: https://doc.rust-lang.org/std/ops/trait.Sub.html
            #[inline]
            #[must_use]
            pub const fn difference(self, other: Self) -> Self {
                Self(self.0.difference(other.0))
            }
            /// Returns the [symmetric difference][sym-diff] between the flags
            /// in `self` and `other`.
            ///
            /// Specifically, the returned set contains the flags present which
            /// are present in `self` or `other`, but that are not present in
            /// both. Equivalently, it contains the flags present in *exactly
            /// one* of the sets `self` and `other`.
            ///
            /// This is equivalent to using the `^` operator (e.g.
            /// [`ops::BitXor`]), as in `flags ^ other`.
            ///
            /// [sym-diff]: https://en.wikipedia.org/wiki/Symmetric_difference
            /// [`ops::BitXor`]: https://doc.rust-lang.org/std/ops/trait.BitXor.html
            #[inline]
            #[must_use]
            pub const fn symmetric_difference(self, other: Self) -> Self {
                Self(self.0.symmetric_difference(other.0))
            }
            /// Returns the complement of this set of flags.
            ///
            /// Specifically, the returned set contains all the flags which are
            /// not set in `self`, but which are allowed for this type.
            ///
            /// Alternatively, it can be thought of as the set difference
            /// between [`Self::all()`] and `self` (e.g. `Self::all() - self`)
            ///
            /// This is equivalent to using the `!` operator (e.g.
            /// [`ops::Not`]), as in `!flags`.
            ///
            /// [`Self::all()`]: Self::all
            /// [`ops::Not`]: https://doc.rust-lang.org/std/ops/trait.Not.html
            #[inline]
            #[must_use]
            pub const fn complement(self) -> Self {
                Self(self.0.complement())
            }
        }
        impl ::bitflags::__private::core::ops::BitOr for Permissions {
            type Output = Self;
            /// Returns the union of the two sets of flags.
            #[inline]
            fn bitor(self, other: Permissions) -> Self {
                self.union(other)
            }
        }
        impl ::bitflags::__private::core::ops::BitOrAssign for Permissions {
            /// Adds the set of flags.
            #[inline]
            fn bitor_assign(&mut self, other: Self) {
                self.0 = self.0.union(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::BitXor for Permissions {
            type Output = Self;
            /// Returns the left flags, but with all the right flags toggled.
            #[inline]
            fn bitxor(self, other: Self) -> Self {
                self.symmetric_difference(other)
            }
        }
        impl ::bitflags::__private::core::ops::BitXorAssign for Permissions {
            /// Toggles the set of flags.
            #[inline]
            fn bitxor_assign(&mut self, other: Self) {
                self.0 = self.0.symmetric_difference(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::BitAnd for Permissions {
            type Output = Self;
            /// Returns the intersection between the two sets of flags.
            #[inline]
            fn bitand(self, other: Self) -> Self {
                self.intersection(other)
            }
        }
        impl ::bitflags::__private::core::ops::BitAndAssign for Permissions {
            /// Disables all flags disabled in the set.
            #[inline]
            fn bitand_assign(&mut self, other: Self) {
                self.0 = self.0.intersection(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::Sub for Permissions {
            type Output = Self;
            /// Returns the set difference of the two sets of flags.
            #[inline]
            fn sub(self, other: Self) -> Self {
                self.difference(other)
            }
        }
        impl ::bitflags::__private::core::ops::SubAssign for Permissions {
            /// Disables all flags enabled in the set.
            #[inline]
            fn sub_assign(&mut self, other: Self) {
                self.0 = self.0.difference(other.0);
            }
        }
        impl ::bitflags::__private::core::ops::Not for Permissions {
            type Output = Self;
            /// Returns the complement of this set of flags.
            #[inline]
            fn not(self) -> Self {
                self.complement()
            }
        }
        impl ::bitflags::__private::core::iter::Extend<Permissions> for Permissions {
            fn extend<T: ::bitflags::__private::core::iter::IntoIterator<Item = Self>>(
                &mut self,
                iterator: T,
            ) {
                for item in iterator {
                    self.insert(item)
                }
            }
        }
        impl ::bitflags::__private::core::iter::FromIterator<Permissions>
        for Permissions {
            fn from_iter<
                T: ::bitflags::__private::core::iter::IntoIterator<Item = Self>,
            >(iterator: T) -> Self {
                use ::bitflags::__private::core::iter::Extend;
                let mut result = Self::empty();
                result.extend(iterator);
                result
            }
        }
        impl ::bitflags::__private::core::iter::IntoIterator for Permissions {
            type Item = Self;
            type IntoIter = Iter;
            fn into_iter(self) -> Self::IntoIter {
                self.0.iter()
            }
        }
        impl ::bitflags::BitFlags for Permissions {
            type Bits = u8;
            type Iter = Iter;
            type IterNames = IterRaw;
            fn empty() -> Self {
                Permissions::empty()
            }
            fn all() -> Self {
                Permissions::all()
            }
            fn bits(&self) -> u8 {
                Permissions::bits(self)
            }
            fn from_bits(
                bits: u8,
            ) -> ::bitflags::__private::core::option::Option<Permissions> {
                Permissions::from_bits(bits)
            }
            fn from_bits_truncate(bits: u8) -> Permissions {
                Permissions::from_bits_truncate(bits)
            }
            fn from_bits_retain(bits: u8) -> Permissions {
                Permissions::from_bits_retain(bits)
            }
            fn from_name(
                name: &str,
            ) -> ::bitflags::__private::core::option::Option<Permissions> {
                Permissions::from_name(name)
            }
            fn iter(&self) -> Self::Iter {
                Permissions::iter(self)
            }
            fn iter_names(&self) -> Self::IterNames {
                Permissions::iter_names(self)
            }
            fn is_empty(&self) -> bool {
                Permissions::is_empty(self)
            }
            fn is_all(&self) -> bool {
                Permissions::is_all(self)
            }
            fn intersects(&self, other: Permissions) -> bool {
                Permissions::intersects(self, other)
            }
            fn contains(&self, other: Permissions) -> bool {
                Permissions::contains(self, other)
            }
            fn insert(&mut self, other: Permissions) {
                Permissions::insert(self, other)
            }
            fn remove(&mut self, other: Permissions) {
                Permissions::remove(self, other)
            }
            fn toggle(&mut self, other: Permissions) {
                Permissions::toggle(self, other)
            }
            fn set(&mut self, other: Permissions, value: bool) {
                Permissions::set(self, other, value)
            }
        }
        impl ::bitflags::__private::ImplementedByBitFlagsMacro for Permissions {}
    };
    /// similar to `variant`, but no type payloads
    #[repr(u8)]
    pub enum Errno {
        TooBig,
        TooSmall,
        TooFast,
        TooSlow,
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Errno {
        #[inline]
        fn clone(&self) -> Errno {
            *self
        }
    }
    #[automatically_derived]
    impl ::core::marker::Copy for Errno {}
    #[automatically_derived]
    impl ::core::marker::StructuralPartialEq for Errno {}
    #[automatically_derived]
    impl ::core::cmp::PartialEq for Errno {
        #[inline]
        fn eq(&self, other: &Errno) -> bool {
            let __self_tag = ::core::intrinsics::discriminant_value(self);
            let __arg1_tag = ::core::intrinsics::discriminant_value(other);
            __self_tag == __arg1_tag
        }
    }
    #[automatically_derived]
    impl ::core::marker::StructuralEq for Errno {}
    #[automatically_derived]
    impl ::core::cmp::Eq for Errno {
        #[inline]
        #[doc(hidden)]
        #[no_coverage]
        fn assert_receiver_is_total_eq(&self) -> () {}
    }
    impl core::fmt::Debug for Errno {
        fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
            match self {
                Errno::TooBig => f.debug_tuple("Errno::TooBig").finish(),
                Errno::TooSmall => f.debug_tuple("Errno::TooSmall").finish(),
                Errno::TooFast => f.debug_tuple("Errno::TooFast").finish(),
                Errno::TooSlow => f.debug_tuple("Errno::TooSlow").finish(),
            }
        }
    }
    pub type T7 = Result<char, Errno>;
    pub trait TypesExport {}
}
#[allow(clippy::all)]
pub mod api {
    pub struct Errno {
        pub a_u1: u64,
        /// A list of signed 64-bit integers
        pub list_s1: wit_bindgen::rt::vec::Vec<i64>,
        pub str: Option<wit_bindgen::rt::string::String>,
        pub c: Option<char>,
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Errno {
        #[inline]
        fn clone(&self) -> Errno {
            Errno {
                a_u1: ::core::clone::Clone::clone(&self.a_u1),
                list_s1: ::core::clone::Clone::clone(&self.list_s1),
                str: ::core::clone::Clone::clone(&self.str),
                c: ::core::clone::Clone::clone(&self.c),
            }
        }
    }
    impl core::fmt::Debug for Errno {
        fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
            f.debug_struct("Errno")
                .field("a-u1", &self.a_u1)
                .field("list-s1", &self.list_s1)
                .field("str", &self.str)
                .field("c", &self.c)
                .finish()
        }
    }
    /// Comment for t5 in api
    pub type T5 = Result<(), Option<Errno>>;
    pub trait Api {
        /// Comment for export function
        fn f1() -> ((i32,), wit_bindgen::rt::string::String);
        fn class(break_: Option<Option<T5>>) -> ();
        fn continue_(abstract_: Option<Result<(), Errno>>, extends: ()) -> Option<()>;
    }
    #[doc(hidden)]
    pub unsafe fn call_f1<T: Api>() -> i32 {
        #[allow(unused_imports)]
        use wit_bindgen::rt::{alloc, vec::Vec, string::String};
        let (result0_0, result0_1) = T::f1();
        let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
        let (t2_0,) = result0_0;
        *((ptr1 + 0) as *mut i32) = wit_bindgen::rt::as_i32(t2_0);
        let vec3 = (result0_1.into_bytes()).into_boxed_slice();
        let ptr3 = vec3.as_ptr() as i32;
        let len3 = vec3.len() as i32;
        core::mem::forget(vec3);
        *((ptr1 + 8) as *mut i32) = len3;
        *((ptr1 + 4) as *mut i32) = ptr3;
        ptr1
    }
    #[doc(hidden)]
    pub unsafe fn post_return_f1<T: Api>(arg0: i32) {
        wit_bindgen::rt::dealloc(
            *((arg0 + 4) as *const i32),
            (*((arg0 + 8) as *const i32)) as usize,
            1,
        );
    }
    #[doc(hidden)]
    pub unsafe fn call_class<T: Api>(
        arg0: i32,
        arg1: i32,
        arg2: i32,
        arg3: i32,
        arg4: i64,
        arg5: i32,
        arg6: i32,
        arg7: i32,
        arg8: i32,
        arg9: i32,
        arg10: i32,
        arg11: i32,
    ) {
        #[allow(unused_imports)]
        use wit_bindgen::rt::{alloc, vec::Vec, string::String};
        let result2 = T::class(
            match arg0 {
                0 => None,
                1 => {
                    Some(
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => Ok(()),
                                        1 => {
                                            Err(
                                                match arg3 {
                                                    0 => None,
                                                    1 => {
                                                        Some({
                                                            let len0 = arg6 as usize;
                                                            Errno {
                                                                a_u1: arg4 as u64,
                                                                list_s1: Vec::from_raw_parts(arg5 as *mut _, len0, len0),
                                                                str: match arg7 {
                                                                    0 => None,
                                                                    1 => {
                                                                        Some({
                                                                            let len1 = arg9 as usize;
                                                                            {
                                                                                #[cfg(debug_assertions)]
                                                                                {
                                                                                    String::from_utf8(
                                                                                            Vec::from_raw_parts(arg8 as *mut _, len1, len1),
                                                                                        )
                                                                                        .unwrap()
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        )
                                                                    }
                                                                },
                                                                c: match arg10 {
                                                                    0 => None,
                                                                    1 => {
                                                                        Some({
                                                                            #[cfg(debug_assertions)]
                                                                            { core::char::from_u32(arg11 as u32).unwrap() }
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        )
                                                                    }
                                                                },
                                                            }
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        )
                                                    }
                                                },
                                            )
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid enum discriminant"),
                                            )
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                )
                            }
                        },
                    )
                }
                #[cfg(debug_assertions)]
                _ => {
                    ::core::panicking::panic_fmt(
                        format_args!("invalid enum discriminant"),
                    )
                }
            },
        );
        let () = result2;
    }
    #[doc(hidden)]
    pub unsafe fn call_continue<T: Api>(
        arg0: i32,
        arg1: i32,
        arg2: i64,
        arg3: i32,
        arg4: i32,
        arg5: i32,
        arg6: i32,
        arg7: i32,
        arg8: i32,
        arg9: i32,
    ) -> i32 {
        #[allow(unused_imports)]
        use wit_bindgen::rt::{alloc, vec::Vec, string::String};
        let result2 = T::continue_(
            match arg0 {
                0 => None,
                1 => {
                    Some(
                        match arg1 {
                            0 => Ok(()),
                            1 => {
                                Err({
                                    let len0 = arg4 as usize;
                                    Errno {
                                        a_u1: arg2 as u64,
                                        list_s1: Vec::from_raw_parts(arg3 as *mut _, len0, len0),
                                        str: match arg5 {
                                            0 => None,
                                            1 => {
                                                Some({
                                                    let len1 = arg7 as usize;
                                                    {
                                                        #[cfg(debug_assertions)]
                                                        {
                                                            String::from_utf8(
                                                                    Vec::from_raw_parts(arg6 as *mut _, len1, len1),
                                                                )
                                                                .unwrap()
                                                        }
                                                    }
                                                })
                                            }
                                            #[cfg(debug_assertions)]
                                            _ => {
                                                ::core::panicking::panic_fmt(
                                                    format_args!("invalid enum discriminant"),
                                                )
                                            }
                                        },
                                        c: match arg8 {
                                            0 => None,
                                            1 => {
                                                Some({
                                                    #[cfg(debug_assertions)]
                                                    { core::char::from_u32(arg9 as u32).unwrap() }
                                                })
                                            }
                                            #[cfg(debug_assertions)]
                                            _ => {
                                                ::core::panicking::panic_fmt(
                                                    format_args!("invalid enum discriminant"),
                                                )
                                            }
                                        },
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                )
                            }
                        },
                    )
                }
                #[cfg(debug_assertions)]
                _ => {
                    ::core::panicking::panic_fmt(
                        format_args!("invalid enum discriminant"),
                    )
                }
            },
            (),
        );
        let result4 = match result2 {
            Some(e) => {
                let () = e;
                1i32
            }
            None => 0i32,
        };
        result4
    }
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    #[repr(align(4))]
    struct _RetArea([u8; 12]);
    static mut _RET_AREA: _RetArea = _RetArea([0; 12]);
}
pub trait TypesExample {
    fn f_f1(typedef: T10) -> T10;
    fn f1(
        f: f32,
        f_list: wit_bindgen::rt::vec::Vec<(char, f64)>,
    ) -> (i64, wit_bindgen::rt::string::String);
    /// t2 has been renamed with `use self.types-interface.{t2 as t2-renamed}`
    fn re_named(perm: Option<Permissions>, e: Option<Empty>) -> T2Renamed;
    fn re_named2(tup: (wit_bindgen::rt::vec::Vec<u16>,), e: Empty) -> (Option<u8>, i8);
}
#[doc(hidden)]
pub unsafe fn call_f_f1<T: TypesExample>(arg0: i32, arg1: i32) -> i32 {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    let base1 = arg0;
    let len1 = arg1;
    let mut result1 = Vec::with_capacity(len1 as usize);
    for i in 0..len1 {
        let base = base1 + i * 8;
        result1
            .push({
                let len0 = *((base + 4) as *const i32) as usize;
                {
                    #[cfg(debug_assertions)]
                    {
                        String::from_utf8(
                                Vec::from_raw_parts(
                                    *((base + 0) as *const i32) as *mut _,
                                    len0,
                                    len0,
                                ),
                            )
                            .unwrap()
                    }
                }
            });
    }
    wit_bindgen::rt::dealloc(base1, (len1 as usize) * 8, 4);
    let result2 = T::f_f1(result1);
    let ptr3 = _RET_AREA.0.as_mut_ptr() as i32;
    let vec5 = result2;
    let len5 = vec5.len() as i32;
    let layout5 = alloc::Layout::from_size_align_unchecked(vec5.len() * 8, 4);
    let result5 = if layout5.size() != 0 {
        let ptr = alloc::alloc(layout5);
        if ptr.is_null() {
            alloc::handle_alloc_error(layout5);
        }
        ptr
    } else {
        core::ptr::null_mut()
    };
    for (i, e) in vec5.into_iter().enumerate() {
        let base = result5 as i32 + (i as i32) * 8;
        {
            let vec4 = (e.into_bytes()).into_boxed_slice();
            let ptr4 = vec4.as_ptr() as i32;
            let len4 = vec4.len() as i32;
            core::mem::forget(vec4);
            *((base + 4) as *mut i32) = len4;
            *((base + 0) as *mut i32) = ptr4;
        }
    }
    *((ptr3 + 4) as *mut i32) = len5;
    *((ptr3 + 0) as *mut i32) = result5 as i32;
    ptr3
}
#[doc(hidden)]
pub unsafe fn post_return_f_f1<T: TypesExample>(arg0: i32) {
    let base0 = *((arg0 + 0) as *const i32);
    let len0 = *((arg0 + 4) as *const i32);
    for i in 0..len0 {
        let base = base0 + i * 8;
        {
            wit_bindgen::rt::dealloc(
                *((base + 0) as *const i32),
                (*((base + 4) as *const i32)) as usize,
                1,
            );
        }
    }
    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 8, 4);
}
#[doc(hidden)]
pub unsafe fn call_f1<T: TypesExample>(arg0: f32, arg1: i32, arg2: i32) -> i32 {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    let base0 = arg1;
    let len0 = arg2;
    let mut result0 = Vec::with_capacity(len0 as usize);
    for i in 0..len0 {
        let base = base0 + i * 16;
        result0
            .push((
                {
                    #[cfg(debug_assertions)]
                    { core::char::from_u32(*((base + 0) as *const i32) as u32).unwrap() }
                },
                *((base + 8) as *const f64),
            ));
    }
    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 16, 8);
    let (result1_0, result1_1) = T::f1(arg0, result0);
    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
    *((ptr2 + 0) as *mut i64) = wit_bindgen::rt::as_i64(result1_0);
    let vec3 = (result1_1.into_bytes()).into_boxed_slice();
    let ptr3 = vec3.as_ptr() as i32;
    let len3 = vec3.len() as i32;
    core::mem::forget(vec3);
    *((ptr2 + 12) as *mut i32) = len3;
    *((ptr2 + 8) as *mut i32) = ptr3;
    ptr2
}
#[doc(hidden)]
pub unsafe fn post_return_f1<T: TypesExample>(arg0: i32) {
    wit_bindgen::rt::dealloc(
        *((arg0 + 8) as *const i32),
        (*((arg0 + 12) as *const i32)) as usize,
        1,
    );
}
#[doc(hidden)]
pub unsafe fn call_re_named<T: TypesExample>(arg0: i32, arg1: i32, arg2: i32) -> i32 {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    let result0 = T::re_named(
        match arg0 {
            0 => None,
            1 => {
                Some(
                    types_export::Permissions::empty()
                        | types_export::Permissions::from_bits_retain(
                            ((arg1 as u8) << 0) as _,
                        ),
                )
            }
            #[cfg(debug_assertions)]
            _ => ::core::panicking::panic_fmt(format_args!("invalid enum discriminant")),
        },
        match arg2 {
            0 => None,
            1 => Some(Empty {}),
            #[cfg(debug_assertions)]
            _ => ::core::panicking::panic_fmt(format_args!("invalid enum discriminant")),
        },
    );
    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
    let (t2_0, t2_1) = result0;
    *((ptr1 + 0) as *mut i32) = wit_bindgen::rt::as_i32(t2_0);
    *((ptr1 + 8) as *mut i64) = wit_bindgen::rt::as_i64(t2_1);
    ptr1
}
#[doc(hidden)]
pub unsafe fn call_re_named2<T: TypesExample>(arg0: i32, arg1: i32) -> i32 {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    let len0 = arg1 as usize;
    let result1 = T::re_named2(
        (Vec::from_raw_parts(arg0 as *mut _, len0, len0),),
        Empty {},
    );
    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
    let (t3_0, t3_1) = result1;
    match t3_0 {
        Some(e) => {
            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
            *((ptr2 + 1) as *mut u8) = (wit_bindgen::rt::as_i32(e)) as u8;
        }
        None => {
            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
        }
    };
    *((ptr2 + 2) as *mut u8) = (wit_bindgen::rt::as_i32(t3_1)) as u8;
    ptr2
}
#[allow(unused_imports)]
use wit_bindgen::rt::{alloc, vec::Vec, string::String};
#[repr(align(8))]
struct _RetArea([u8; 16]);
static mut _RET_AREA: _RetArea = _RetArea([0; 16]);
const _: &str = "default world host {\n  import print: func(msg: string)\n\n  record record-test {\n    a: u32,\n    b: string,\n    c: float64,\n  }\n\n  export run: func()\n  export get: func() -> record-test\n  export map: func(rec: record-test) -> record-test\n  export map-i: func(rec: record-test, i: float32) -> record-test\n  export receive-i: func(rec: record-test, i: float32)\n}";
const _: &str = "default interface types-interface {\n  /// \"package of named fields\"\n  record r {\n    a: u32,\n    b: string,\n    c: list<tuple<string, option<t4>>>\n  }\n\n  /// values of this type will be one of the specified cases\n  variant human {\n    baby,\n    /// type payload\n    child(u32), // optional type payload\n    adult,\n  }\n\n  /// similar to `variant`, but no type payloads\n  enum errno {\n    too-big,\n    too-small,\n    too-fast,\n    too-slow,\n  }\n\n  /// similar to `variant`, but doesn\'t require naming cases and all variants\n  /// have a type payload -- note that this is not a C union, it still has a\n  /// discriminant\n  union input {\n    u64,\n    string,\n  }\n\n  /// a bitflags type\n  flags permissions {\n    read,\n    write,\n    exec,\n  }\n\n  // type aliases are allowed to primitive types and additionally here are some\n  // examples of other types\n  type t1 = u32\n  type t2 = tuple<u32, u64>\n  type t3 = string\n  type t4 = option<u32>\n  /// no \"ok\" type\n  type t5 = result<_, errno>            // no \"ok\" type\n  type t6 = result<string>              // no \"err\" type\n  type t7 = result<char, errno>         // both types specified\n  type t8 = result                      // no \"ok\" or \"err\" type\n  type t9 = list<string>\n  type t10 = t9\n}\n\n/// Comment for import interface\ninterface api-imports {\n  use self.types-interface.{t7}\n\n  /// Same name as the type in `types-interface`, but this is a different type\n  variant human {\n    baby,\n    child(u64),\n    adult(tuple<string, option<option<string>>, tuple<s64>>),\n  }\n\n  api-a1-b2: func(arg: list<human>) -> (h1: t7, val2: human)\n}\n\ninterface api {\n  /// Comment for export function\n  f1: func() -> (val-one: tuple<s32>, val2: string)\n\n  /// Comment for t5 in api\n  type t5 = result<_, option<errno>>\n\n  record errno {\n    a-u1: u64,\n    /// A list of signed 64-bit integers\n    list-s1: list<s64>,\n    str: option<string>,\n    c: option<char>,\n  }\n\n  class: func(break: option<option<t5>>) -> tuple<>\n  continue: func(abstract: option<result<_, errno>>, extends: tuple<>) -> (%implements: option<tuple<>>)\n}\n\ndefault world types-example {\n    use self.types-interface.{t2 as t2-renamed, t10, permissions}\n\n    import imports: self.api-imports\n    import print: func(message: string, level: log-level)\n    /// Comment for import inline\n    import inline: interface {\n      /// Comment for import inline function\n      inline-imp: func(args: list<option<char>>) -> result<_, char>\n    }\n\n    export types-export: self.types-interface\n    export api: self.api\n\n    enum log-level {\n      /// lowest level\n      debug,\n      info,\n      warn,\n      error,\n    }\n\n    record empty {}\n\n    export f-f1: func(typedef: t10) -> t10\n    export f1: func(f: float32, f-list: list<tuple<char, float64>>) -> (val-p1: s64, val2: string)\n    /// t2 has been renamed with `use self.types-interface.{t2 as t2-renamed}`\n    export re-named: func(perm: option<permissions>, e: option<empty>) -> t2-renamed\n    export re-named2: func(tup: tuple<list<u16>>, e: empty) -> tuple<option<u8>, s8>\n}";
struct MyHost;
impl TypesExample for MyHost {
    fn f_f1(typedef: T10) -> T10 {
        ::core::panicking::panic("not yet implemented")
    }
    fn f1(f: f32, f_list: Vec<(char, f64)>) -> (i64, String) {
        ::core::panicking::panic("not yet implemented")
    }
    fn re_named(
        perm: Option<types_interface::Permissions>,
        e: Option<Empty>,
    ) -> T2Renamed {
        ::core::panicking::panic("not yet implemented")
    }
    fn re_named2(tup: (Vec<u16>,), e: Empty) -> (Option<u8>, i8) {
        ::core::panicking::panic("not yet implemented")
    }
}
