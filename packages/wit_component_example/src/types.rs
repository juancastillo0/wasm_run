use std::fmt::format;

use crate::generate::*;
use wit_parser::*;

pub struct DartType {
    pub name: String,
    pub ty: Type,
    pub ffi_ty: String,
    pub is_pointer: bool,
}

pub enum FuncKind {
    MethodCall,
    Method,
    Field,
}

pub struct Parsed<'a>(pub &'a UnresolvedPackage);

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
            // Type::USize => "usize".to_string(),
            // Type::Alias(alias) => alias.type_.ffi_type(),
            // Type::Handle(_resource_name) => self.as_lang(),
            // Type::ConstPtr(_pointee) => _pointee.as_lang(),
            // Type::MutPtr(_pointee) => _pointee.as_lang(),
            // Type::Option(_) => todo!(),
            // Type::Result(_) => todo!(),
            // Type::Void => "Void".to_string(),
        }
    }

    pub fn type_to_str(&self, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                self.type_def_to_name(ty_def)
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
        let name = ty.name.as_ref().map(heck::AsPascalCase);
        match &ty.kind {
            TypeDefKind::Record(record) => format!("{getter}.toJson()"),
            TypeDefKind::Enum(enum_) => format!("{getter}.toJson()"),
            TypeDefKind::Union(union) => format!("{getter}.toJson()"),
            TypeDefKind::Flags(flags) => format!("{getter}.toJson()"),
            TypeDefKind::Variant(variant) => format!("{getter}.toJson()"),
            TypeDefKind::Option(variant) => format!("{getter}.toJson()"),
            TypeDefKind::Result(variant) => format!("{getter}.toJson()"),
            TypeDefKind::Tuple(t) => {
                format!(
                    "[{}]",
                    t.types
                        .iter()
                        .enumerate()
                        .map(|(i, t)| self.type_to_json(&format!("{getter}.${ind}", ind = i + 1), t))
                        .collect::<Vec<_>>()
                        .join(", "),
                )
            }
            TypeDefKind::List(ty) => format!(
                "{getter}.map((e) => {}).toList()",
                self.type_to_json("e", &ty)
            ),
            TypeDefKind::Future(ty) => unreachable!("Future"),
            TypeDefKind::Stream(s) => unreachable!("Stream"),
            TypeDefKind::Type(ty) => self.type_to_json(getter, &ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
        }
    }

    pub fn function_import(&self, interface_name: Option<&str>, id: &str, f: &Function) -> String {
        let interface_name_m = interface_name.unwrap_or("$root");
        let getter = format!(
            "imports.{}{}",
            interface_name
                .map(|v| format!("{v}."))
                .unwrap_or("".to_string()),
            heck::AsLowerCamelCase(id),
        );
        format!(
            "{{
                const ft = {ft};
                {exec}
                final lowered = loweredImportFunction(ft, exec{exec_name}, getLib);
                builder.addImport(r'{interface_name_m}', '{id}', lowered);
            }}",
            ft = self.function_spec(f),
            exec = self.function_exec(&getter, f,),
            exec_name = heck::AsPascalCase(&getter),
        )
    }

    pub fn function_spec(&self, function: &Function) -> String {
        format!(
            "FuncType([{}], [{}])",
            function
                .params
                .iter()
                .map(|(name, ty)| format!("('{name}', {})", self.type_to_spec(ty)))
                .collect::<Vec<_>>()
                .join(", "),
            match &function.results {
                Results::Anon(a) => format!("('', {})", self.type_to_spec(a)),
                Results::Named(results) => results
                    .iter()
                    .map(|(name, ty)| format!("('{name}', {})", self.type_to_spec(ty)))
                    .collect::<Vec<_>>()
                    .join(", "),
            }
        )
    }

    pub fn function_exec(&self, getter: &str, function: &Function) -> String {
        // TODO: post function
        format!(
            "
        (ListValue, void Function()) exec{n}(ListValue args) {{
        {args}
        {results_def}{getter}({args_from_json});
        return ({ret}, () {{}});
        }}
        ",
            n = heck::AsPascalCase(getter),
            results_def = if function.results.len() == 0 {
                ""
            } else {
                "final results = "
            },
            args = function
                .params
                .iter()
                .enumerate()
                .map(|(i, (_name, ty))| format!("final args{i} = args[{i}];"))
                .collect::<String>(),
            args_from_json = function
                .params
                .iter()
                .enumerate()
                .map(|(i, (_name, ty))| self.type_from_json(&format!("args{i}"), ty))
                .collect::<Vec<_>>()
                .join(", "),
            ret = match &function.results {
                Results::Anon(a) => format!("[{}]", self.type_to_json("results", a)),
                Results::Named(results) =>
                    if results.is_empty() {
                        "const []".to_string()
                    } else {
                        format!(
                            "[{}]",
                            results
                                .iter()
                                .map(|(name, ty)| self.type_to_json(
                                    &format!("results.{}", heck::AsLowerCamelCase(name)),
                                    ty
                                ))
                                .collect::<Vec<_>>()
                                .join(", ")
                        )
                    },
            }
        )
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
        r.map(|ty| self.type_to_spec(&ty))
            .unwrap_or("null".to_string())
    }

    pub fn type_def_to_spec(&self, ty: &TypeDef) -> String {
        let name = ty.name.as_ref().map(heck::AsPascalCase);
        match &ty.kind {
            TypeDefKind::Record(record) => format!(
                "Record([{}])",
                record
                    .fields
                    .iter()
                    .map(|t| format!("(label: '{}', t: {})", t.name, self.type_to_spec(&t.ty)))
                    .collect::<Vec<_>>()
                    .join(", ")
            ),
            TypeDefKind::Enum(enum_) => format!(
                "EnumType(['{}'])",
                enum_
                    .cases
                    .iter()
                    .map(|t| t.name.clone())
                    .collect::<Vec<_>>()
                    .join("', '")
            ),
            TypeDefKind::Union(union) => format!(
                "Union([{}])",
                union
                    .cases
                    .iter()
                    .map(|t| self.type_to_spec(&t.ty))
                    .collect::<Vec<_>>()
                    .join(", ")
            ),
            TypeDefKind::Flags(flags) => format!(
                "Flags(['{}'])",
                flags
                    .flags
                    .iter()
                    .map(|t| t.name.clone())
                    .collect::<Vec<_>>()
                    .join("', '")
            ),
            TypeDefKind::Variant(variant) => format!(
                "Variant([{}])",
                variant
                    .cases
                    .iter()
                    .map(|t| format!("Case('{}', {})", t.name, self.type_def_to_spec_option(t.ty)))
                    .collect::<Vec<_>>()
                    .join(", ")
            ),
            TypeDefKind::Tuple(t) => {
                format!(
                    "Tuple([{}])",
                    t.types
                        .iter()
                        .map(|t| self.type_to_spec(t))
                        .collect::<Vec<_>>()
                        .join(", ")
                )
            }
            TypeDefKind::Option(ty) => format!("OptionType({})", self.type_to_spec(&ty)),
            TypeDefKind::Result(r) => format!(
                "ResultType({}, {})",
                self.type_def_to_spec_option(r.ok),
                self.type_def_to_spec_option(r.err),
            ),
            TypeDefKind::List(ty) => format!("ListType({})", self.type_to_spec(&ty)),
            TypeDefKind::Future(ty) => format!("FutureType({})", self.type_def_to_spec_option(*ty)),
            TypeDefKind::Stream(s) => format!(
                "StreamType({})",
                // TODO: stream.end
                self.type_def_to_spec_option(s.element),
            ),
            TypeDefKind::Type(ty) => self.type_to_spec(&ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
        }
    }

    pub fn type_from_json(&self, getter: &str, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                self.type_def_from_json(getter, ty_def)
            }
            Type::Bool => format!("{getter} as bool"),
            Type::String => {
                format!("{getter} is String ? {getter} : ({getter} as ParsedString).value")
            }
            Type::Char => format!("{getter} as String"),
            Type::Float32 => format!("{getter} as double"),
            Type::Float64 => format!("{getter} as double"),
            Type::S8 => format!("{getter} as int"),
            Type::S16 => format!("{getter} as int"),
            Type::S32 => format!("{getter} as int"),
            Type::S64 => format!("{getter} as int"),
            Type::U8 => format!("{getter} as int"),
            Type::U16 => format!("{getter} as int"),
            Type::U32 => format!("{getter} as int"),
            Type::U64 => format!("{getter} as int"),
        }
    }

    pub fn type_def_from_json_option(&self, getter: &str, r: Option<Type>) -> String {
        r.map(|ty| self.type_from_json(getter, &ty))
            .unwrap_or("null".to_string())
    }

    pub fn type_def_from_json(&self, getter: &str, ty: &TypeDef) -> String {
        let name = ty.name.as_ref().map(heck::AsPascalCase);
        match &ty.kind {
            TypeDefKind::Record(record) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Enum(enum_) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Union(union) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Flags(flags) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Variant(variant) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Tuple(t) => {
                format!(
                    "(() {{final l = {getter} is Map
                        ? Iterable.generate({getter}.length, (i) => {getter}[i.toString()])
                        : {getter} as Iterable;
                        final it = l.iterator;\n{}
                        return ({},);}})()",
                    (0..t.types.len())
                        .map(|i| format!("final v{i} = (it..moveNext()).current;\n"))
                        .collect::<String>(),
                    t.types
                        .iter()
                        .enumerate()
                        .map(|(i, t)| self.type_from_json(&format!("v{i}"), t))
                        .collect::<Vec<_>>()
                        .join(", "),
                )
            }
            TypeDefKind::Option(ty) => format!(
                "Option.fromJson({getter}, (some) => {})",
                self.type_from_json("some", &ty)
            ),
            TypeDefKind::Result(r) => format!(
                "Result.fromJson({getter}, (ok) => {}, (error) => {})",
                self.type_def_from_json_option("ok", r.ok),
                self.type_def_from_json_option("error", r.err),
            ),
            // TypeDefKind::Option(ty) => format!(
            //     "{getter} == null ? none : {}",
            //     self.type_from_json(getter, &ty)
            // ),
            // TypeDefKind::Result(r) => format!(
            //     "({getter} as Map).containsKey('ok') ? Ok({}) : Err({})",
            //     self.type_def_from_json_option(&format!("({getter} as Map)['ok']"), r.ok),
            //     self.type_def_from_json_option(&format!("({getter} as Map)['error']"), r.err),
            // ),
            TypeDefKind::List(ty) => format!(
                "({getter} as Iterable).map((e) => {}).toList()",
                self.type_from_json("e", &ty)
            ),
            TypeDefKind::Future(ty) => {
                format!(
                    "FutureType({})",
                    self.type_def_from_json_option(getter, *ty)
                )
            }
            TypeDefKind::Stream(s) => format!(
                "StreamType({})",
                // TODO: stream.end
                self.type_def_from_json_option(getter, s.element),
            ),
            TypeDefKind::Type(ty) => self.type_from_json(getter, &ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
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

    pub fn type_def_to_name(&self, ty: &TypeDef) -> String {
        let name = ty.name.as_ref().map(heck::AsPascalCase);
        match &ty.kind {
            TypeDefKind::Record(_record) => name.unwrap().to_string(),
            TypeDefKind::Enum(_enum) => name.unwrap().to_string(),
            TypeDefKind::Union(_union) => name.unwrap().to_string(),
            TypeDefKind::Flags(_flags) => name.unwrap().to_string(),
            TypeDefKind::Variant(_variant) => name.unwrap().to_string(),
            TypeDefKind::Tuple(t) => {
                format!(
                    "({})",
                    t.types
                        .iter()
                        .map(|t| {
                            let mut s = self.type_to_str(t);
                            s.push_str(", ");
                            s
                        })
                        .collect::<String>()
                )
            }
            TypeDefKind::Option(ty) => format!("Option<{}>", self.type_to_str(&ty)),
            TypeDefKind::Result(r) => format!(
                "Result<{}, {}>",
                r.ok.map(|ty| self.type_to_str(&ty))
                    .unwrap_or("void".to_string()),
                r.err
                    .map(|ty| self.type_to_str(&ty))
                    .unwrap_or("void".to_string())
            ),
            TypeDefKind::List(ty) => format!("List<{}>", self.type_to_str(&ty)),
            TypeDefKind::Future(ty) => format!(
                "Future<{}>",
                ty.map(|ty| self.type_to_str(&ty))
                    .unwrap_or("void".to_string())
            ),
            TypeDefKind::Stream(s) => format!(
                "Stream<{}>",
                // TODO: stream.end
                s.element
                    .map(|ty| self.type_to_str(&ty))
                    .unwrap_or("void".to_string()),
            ),
            TypeDefKind::Type(ty) => self.type_to_str(&ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
        }
    }

    pub fn type_def_to_definition(&self, ty: &TypeDef) -> String {
        let name = ty.name.as_ref().map(heck::AsPascalCase);

        let mut s = String::new();
        add_docs(&mut s, &ty.docs);
        match &ty.kind {
            TypeDefKind::Record(r) => {
                let name = name.unwrap();
                s.push_str(&format!("class {name} {{"));
                r.fields.iter().for_each(|f| {
                    add_docs(&mut s, &f.docs);
                    s.push_str(&format!("final {} {};", self.type_to_str(&f.ty), f.name));
                });
                if r.fields.is_empty() {
                    s.push_str(&format!("\n\nconst {name}();",));
                } else {
                    s.push_str(&format!("\n\nconst {name}({{",));
                    r.fields.iter().for_each(|f| {
                        s.push_str(&format!("required this.{},", f.name));
                    });
                    s.push_str("});");
                }
                s.push_str(&format!(
                    "\n\nfactory {name}.fromJson(Object? json) {{
                        final _json = json as Map; {} return {name}({});}}",
                    r.fields
                        .iter()
                        .map(|f| format!("final {} = _json['{}'];", f.name, f.name))
                        .collect::<String>(),
                    r.fields
                        .iter()
                        .map(|f| format!("{}: {},", f.name, self.type_from_json(&f.name, &f.ty)))
                        .collect::<String>()
                ));
                s.push_str(&format!(
                    "\nObject? toJson() => {{{}}};\n",
                    r.fields
                        .iter()
                        .map(|f| format!("'{}': {},", f.name, self.type_to_json(&f.name, &f.ty)))
                        .collect::<String>()
                ));

                s.push_str(&format!(
                    "static const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}");
                s
            }
            TypeDefKind::Enum(e) => {
                let name = name.unwrap();
                s.push_str(&format!("enum {name} {{"));
                e.cases.iter().enumerate().for_each(|(i, v)| {
                    add_docs(&mut s, &v.docs);
                    s.push_str(&format!(
                        "{}{}",
                        heck::AsLowerCamelCase(&v.name),
                        if i == e.cases.len() - 1 { ";" } else { "," }
                    ));
                });

                s.push_str(&format!(
                    "factory {name}.fromJson(Object? json_) {{
                        final json = json_ is Map ? json_.keys.first : json_;
                        if (json is String) {{
                            final index = _spec.labels.indexOf(json);
                            return index != -1 ? values[index] : values.byName(json);
                        }}
                        return values[json as int];}}",
                ));
                s.push_str("\nObject? toJson() => _spec.labels[index];\n");

                s.push_str(&format!(
                    "static const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}");
                s
            }
            TypeDefKind::Union(u) => {
                let name = name.unwrap();
                s.push_str(
                    &format!("sealed class {name} {{
                    factory {name}.fromJson(Object? json_) {{
                        Object? json = json_;
                        if (json is Map) json = (int.parse(json.keys.first as String), json.values.first);
                        return switch (json) {{ {} _ => throw Exception('Invalid JSON $json_'), }};
                    }}", 
                    u.cases.iter().enumerate().map(|(i, v)| {
                        let ty = self.type_to_str(&v.ty);
                        let inner_name = heck::AsPascalCase(&ty);
                        format!(
                            "({i}, Object? value) => {name}{inner_name}({}),",
                            self.type_from_json("value", &v.ty),
                        )
                    }).collect::<String>()),
                );

                let mut cases_string = String::new();
                u.cases.iter().enumerate().for_each(|(i, v)| {
                    add_docs(&mut cases_string, &v.docs);
                    let ty = self.type_to_str(&v.ty);
                    let inner_name = heck::AsPascalCase(&ty);
                    let class_name = format!("{name}{inner_name}");
                    cases_string.push_str(&format!(
                        "class {class_name} implements {name} {{ final {ty} value; const {class_name}(this.value);
                         @override\nObject? toJson() => {{'{i}': {}}}; }}",
                         self.type_to_json("value", &v.ty)
                    ));
                    s.push_str(&format!("const factory {name}.{}({ty} value) = {class_name};", heck::AsLowerCamelCase(&ty)));
                });

                s.push_str("\n\nObject? toJson();\n");

                s.push_str(&format!(
                    "static const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}"); // close sealed union class
                s.push_str(&cases_string);
                s
            }
            TypeDefKind::Variant(a) => {
                let name = name.unwrap();
                s.push_str(&format!(
                    "sealed class {name} {{ factory {name}.fromJson(Object? json_) {{
                    Object? json = json_;
                    if (json is Map) {{
                        final k = json.keys.first;
                        if (k is int)
                            json = (k, json.values.first);
                        else
                            json = (_spec.cases.indexWhere((c) => c.label == k), json.values.first);
                    }}
                    return switch (json) {{ {} _ => throw Exception('Invalid JSON $json_'), }};
                }}",
                    a.cases
                        .iter()
                        .enumerate()
                        .map(|(i, v)| {
                            let inner_name = heck::AsPascalCase(&v.name);
                            match v.ty {
                                Some(ty) => format!(
                                    "({i}, Object? value) => {name}{inner_name}({}),",
                                    self.type_from_json("value", &ty),
                                ),
                                None => format!("({i}, null) => const {name}{inner_name}(),",),
                            }
                        })
                        .collect::<String>()
                ));
                let mut cases_string = String::new();
                a.cases.iter().for_each(|v| {
                    add_docs(&mut cases_string, &v.docs);
                    let inner_name =  heck::AsPascalCase(&v.name);
                    let class_name = format!("{name}{inner_name}");
                    if let Some(ty) = v.ty {
                        let ty_str =self.type_to_str(&ty);
                        cases_string.push_str(&format!(
                            "class {class_name} implements {name} {{ final {ty_str} value; const {class_name}(this.value);
                            @override\nObject? toJson() => {{'{}': {}}};
                         }}", v.name, self.type_to_json("value", &ty)
                        ));
                        s.push_str(&format!("const factory {name}.{}({ty_str} value) = {class_name};", heck::AsLowerCamelCase(&v.name)));
                    } else {
                        cases_string.push_str(&format!(
                            "class {class_name} implements {name} {{ const {class_name}();
                            @override\nObject? toJson() => {{'{}': null}}; }}", v.name,
                        ));
                        s.push_str(&format!("const factory {name}.{}() = {class_name};", heck::AsLowerCamelCase(&v.name)));
                    }
                });
                s.push_str("\n\nObject? toJson();\n");
                s.push_str(&format!(
                    "static const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}"); // close sealed union class
                s.push_str(&cases_string);
                s
            }
            TypeDefKind::Flags(f) => {
                let name = name.unwrap();
                let num_bytes = ((f.flags.len() + 32 - 1) / 32) * 4;
                s.push_str(&format!(
                    "class {name} {{ final ByteData flagBits; const {name}(this.flagBits); {name}.none(): flagBits = ByteData({num_bytes});
                    {name}.all(): flagBits = (Uint8List({num_bytes})..fillRange(0, {num_bytes}, 255)).buffer.asByteData();

                    factory {name}.fromJson(Object? json) {{
                        final flagBits = flagBitsFromJson(json, _spec);
                        return {name}(flagBits);
                    }}

                    Object toJson() => Uint32List.view(flagBits.buffer);
                    
                    int _index(int i) => flagBits.getUint32(i, Endian.little);
                    void _setIndex(int i, int flag, bool enable) {{
                        final currentValue = _index(i);
                        flagBits.setUint32(
                        i,
                        enable ? (flag | currentValue) : ((~flag) & currentValue),
                        Endian.little,
                    );
                    }}
                    ",
                ));
                f.flags.iter().enumerate().for_each(|(i, v)| {
                    let property = heck::AsLowerCamelCase(&v.name);

                    let index = (i / 32) * 4;
                    let flag = 2_u32.pow(i.try_into().unwrap());
                    let getter = format!("_index({index})");

                    s.push_str(&format!(
                        "\n\nstatic const {property}IndexAndFlag = (index:{index}, flag:{flag});"
                    ));

                    add_docs(&mut s, &v.docs);
                    s.push_str(&format!("bool get {property} => ({getter} & {flag}) != 0;"));
                    add_docs(&mut s, &v.docs);
                    s.push_str(&format!(
                        "set {property}(bool enable) => _setIndex({index}, {flag}, enable);",
                    ));
                });
                s.push_str(&format!(
                    "static const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}");
                s
            }
            TypeDefKind::Type(ty) => self.type_to_dart_definition(ty),
            TypeDefKind::List(_) => s,
            TypeDefKind::Tuple(_) => s,
            TypeDefKind::Option(_) => s,
            TypeDefKind::Result(_) => s,
            TypeDefKind::Future(_) => s,
            TypeDefKind::Stream(_) => s,
            TypeDefKind::Unknown => todo!(),
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
                self.add_interface(&mut s, id, interface, is_export, &mut func_imports)
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
            s.push_str(&format!("class {name} {{ {name}(WasmLibrary library)"));
            if interface.functions.is_empty() {
                s.push_str(";");
            } else {
                s.push_str(":");
                interface
                    .functions
                    .iter()
                    .enumerate()
                    .for_each(|(index, (id, f))| {
                        s.push_str(&format!(
                            "_{id} = library.lookupComponentFunction('{id}', const {},)!",
                            self.function_spec(f)
                        ));
                        if index != interface.functions.len() - 1 {
                            s.push_str(",");
                        }
                    });
                s.push_str(";");
            }

            interface.functions.iter().for_each(|(id, f)| {
                self.add_function(&mut s, f, FuncKind::MethodCall);
            });
            s.push_str("}");
        } else {
            s.push_str(&format!(
                "abstract class {} {{",
                name, // interface.name.as_ref().unwrap())
            ));
            interface.functions.iter().for_each(|(id, f)| {
                self.add_function(&mut s, f, FuncKind::Method);
                if let Some(func_imports) = func_imports {
                    func_imports.push_str(&self.function_import(Some(interface_id), id, f));
                }
            });
            s.push_str("}");
        }
    }

    pub fn add_function(&self, mut s: &mut String, f: &Function, kind: FuncKind) {
        let params = f
            .params
            .iter()
            .map(|(name, ty)| format!("{} {}", self.type_to_str(ty), heck::AsLowerCamelCase(name)))
            .collect::<Vec<_>>()
            .join(",");

        let mut results = match &f.results {
            Results::Anon(ty) => self.type_to_str(ty),
            Results::Named(list) => {
                if list.is_empty() {
                    "void".to_string()
                } else {
                    format!(
                        "({{{}}})",
                        list.iter()
                            .map(|(name, ty)| {
                                format!(
                                    "{} {}",
                                    self.type_to_str(ty),
                                    heck::AsLowerCamelCase(name),
                                )
                            })
                            .collect::<Vec<_>>()
                            .join(",")
                    )
                }
            }
        };

        add_docs(&mut s, &f.docs);
        let name = heck::AsLowerCamelCase(&f.name);
        match kind {
            FuncKind::Field => s.push_str(&format!("final {results} Function({params}) {name};",)),
            FuncKind::Method => s.push_str(&format!("{results} {name}({params});",)),
            FuncKind::MethodCall => {
                // s.push_str(&format!("late final _{} = lookup('{}');", f.name, f.name));
                s.push_str(&format!("{results} {name}({params}) {{"));
                s.push_str(&format!(
                    "{}_{name}([{params}]);{ret}",
                    if f.results.len() == 0 {
                        ""
                    } else {
                        "final results = "
                    },
                    params = f
                        .params
                        .iter()
                        .map(|(name, ty)| self
                            .type_to_json(&heck::AsLowerCamelCase(name).to_string(), ty))
                        .collect::<Vec<_>>()
                        .join(", "),
                    ret = match &f.results {
                        Results::Anon(a) => format!(
                            "final result = results[0];return {};",
                            self.type_from_json("result", a)
                        ),
                        Results::Named(results) =>
                            if results.is_empty() {
                                "".to_string()
                            } else {
                                format!(
                                    "{}return ({},);",
                                    (0..results.len())
                                        .map(|i| format!("final r{i}= results[{i}];"))
                                        .collect::<String>(),
                                    results
                                        .iter()
                                        .enumerate()
                                        .map(|(i, (name, ty))| format!(
                                            "{}: {}",
                                            heck::AsLowerCamelCase(name),
                                            self.type_from_json(&format!("r{i}"), ty),
                                        ),)
                                        .collect::<Vec<_>>()
                                        .join(", ")
                                )
                            },
                    }
                ));
                s.push_str("}");

                s.push_str(&format!("final ListValue Function(ListValue) _{name};"));
            }
        }
    }
}
