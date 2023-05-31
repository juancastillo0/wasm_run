use std::collections::HashMap;

use crate::{generate::*, strings::Normalize, Int64TypeConfig, WitGeneratorConfig};
use wit_parser::*;

pub struct Parsed<'a>(
    pub &'a Resolve,
    pub HashMap<&'a str, Vec<&'a TypeDef>>,
    pub WitGeneratorConfig,
);

impl Parsed<'_> {
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
            Type::S64 => match self.2.int64_type {
                Int64TypeConfig::BigInt => "BigInt /*S64*/".to_string(),
                Int64TypeConfig::NativeObject => "Object /*S64*/".to_string(),
                Int64TypeConfig::BigIntUnsignedOnly => "int /*S64*/".to_string(),
                Int64TypeConfig::CoreInt => "int /*S64*/".to_string(),
            },
            Type::U8 => "int /*U8*/".to_string(),
            Type::U16 => "int /*U16*/".to_string(),
            Type::U32 => "int /*U32*/".to_string(),
            Type::U64 => match self.2.int64_type {
                Int64TypeConfig::BigInt => "BigInt /*U64*/".to_string(),
                Int64TypeConfig::NativeObject => "Object /*U64*/".to_string(),
                Int64TypeConfig::BigIntUnsignedOnly => "BigInt /*U64*/".to_string(),
                Int64TypeConfig::CoreInt => "int /*U64*/".to_string(),
            },
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
            Type::S64 => match self.2.int64_type {
                Int64TypeConfig::BigInt => format!("{getter}.toString()"),
                Int64TypeConfig::NativeObject => format!("i64.toBigInt({getter}).toString()"),
                Int64TypeConfig::BigIntUnsignedOnly => getter.to_string(),
                Int64TypeConfig::CoreInt => getter.to_string(),
            },
            Type::U8 => getter.to_string(),
            Type::U16 => getter.to_string(),
            Type::U32 => getter.to_string(),
            Type::U64 => match self.2.int64_type {
                Int64TypeConfig::BigInt => format!("{getter}.toString()"),
                Int64TypeConfig::NativeObject => format!("i64.toBigInt({getter}).toString()"),
                Int64TypeConfig::BigIntUnsignedOnly => format!("{getter}.toString()"),
                Int64TypeConfig::CoreInt => getter.to_string(),
            },
        }
    }

    pub fn type_def_to_json(&self, getter: &str, ty: &TypeDef) -> String {
        match &ty.kind {
            TypeDefKind::Record(_record) => format!("{getter}.toJson()"),
            TypeDefKind::Enum(_enum_) => format!("{getter}.toJson()"),
            TypeDefKind::Union(_union) => format!("{getter}.toJson()"),
            TypeDefKind::Flags(_flags) => format!("{getter}.toJson()"),
            TypeDefKind::Variant(_variant) => format!("{getter}.toJson()"),
            TypeDefKind::Option(ty) => format!(
                "{getter}.toJson((some) => {})",
                self.type_to_json("some", &ty)
            ),
            TypeDefKind::Result(r) => format!(
                "{getter}.toJson({}, {})",
                r.ok.map_or_else(
                    || "null".to_string(),
                    |ok| {
                        let to_json = self.type_to_json("ok", &ok);
                        if to_json == "ok" {
                            return "null".to_string();
                        }
                        format!("(ok) => {to_json}")
                    }
                ),
                r.err.map_or_else(
                    || "null".to_string(),
                    |error| {
                        let to_json = self.type_to_json("error", &error);
                        if to_json == "error" {
                            return "null".to_string();
                        }
                        format!("(error) => {to_json}")
                    }
                )
            ),
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
                // TODO: if {} is just e, maybe don't copy
                "{getter}.map((e) => {}).toList()",
                self.type_to_json("e", &ty)
            ),
            TypeDefKind::Future(_ty) => unreachable!("Future"),
            TypeDefKind::Stream(_s) => unreachable!("Stream"),
            TypeDefKind::Type(ty) => self.type_to_json(getter, &ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
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
        r.map(|ty| self.type_to_spec(&ty))
            .unwrap_or("null".to_string())
    }

    pub fn type_def_to_spec(&self, ty: &TypeDef) -> String {
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
            Type::Bool => format!("{getter}! as bool"),
            Type::String => {
                format!("{getter} is String ? {getter} : ({getter}! as ParsedString).value")
            }
            Type::Char => format!("{getter}! as String"),
            Type::Float32 => format!("{getter}! as double"),
            Type::Float64 => format!("{getter}! as double"),
            Type::S8 => format!("{getter}! as int"),
            Type::S16 => format!("{getter}! as int"),
            Type::S32 => format!("{getter}! as int"),
            Type::S64 => match self.2.int64_type {
                Int64TypeConfig::BigInt => format!("bigIntFromJson({getter})"),
                Int64TypeConfig::NativeObject => format!("{getter}!"),
                Int64TypeConfig::BigIntUnsignedOnly => format!("{getter}! as int"),
                Int64TypeConfig::CoreInt => format!("{getter}! as int"),
            },
            Type::U8 => format!("{getter}! as int"),
            Type::U16 => format!("{getter}! as int"),
            Type::U32 => format!("{getter}! as int"),
            Type::U64 => match self.2.int64_type {
                Int64TypeConfig::BigInt => format!("bigIntFromJson({getter})"),
                Int64TypeConfig::NativeObject => format!("{getter}!"),
                Int64TypeConfig::BigIntUnsignedOnly => format!("bigIntFromJson({getter})"),
                Int64TypeConfig::CoreInt => format!("{getter}! as int"),
            },
        }
    }

    pub fn type_def_from_json_option(&self, getter: &str, r: Option<Type>) -> String {
        r.map(|ty| self.type_from_json(getter, &ty))
            .unwrap_or("null".to_string())
    }

    pub fn type_def_from_json(&self, getter: &str, ty: &TypeDef) -> String {
        let name = self.type_def_to_name_definition(ty);
        match &ty.kind {
            TypeDefKind::Record(_record) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Enum(_enum_) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Union(_union) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Flags(_flags) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Variant(_variant) => format!("{}.fromJson({getter})", name.unwrap()),
            TypeDefKind::Tuple(t) => {
                if t.types.len() == 0 {
                    format!("()")
                } else {
                    let spread = (0..t.types.len())
                        .map(|i| format!("final v{i}"))
                        .collect::<Vec<_>>()
                        .join(",");
                    let s_comma = if t.types.len() == 1 { "," } else { "" };
                    format!(
                        "(() {{final l = {getter} is Map
                        ? List.generate({length}, (i) => {getter}[i.toString()], growable: false)
                        : {getter};
                        return switch (l) {{
                            [{spread}] || ({spread}{s_comma}) => ({},),
                            _ => throw Exception('Invalid JSON ${getter}')}};
                        }})()",
                        t.types
                            .iter()
                            .enumerate()
                            .map(|(i, t)| self.type_from_json(&format!("v{i}"), t))
                            .collect::<Vec<_>>()
                            .join(", "),
                        length = t.types.len(),
                    )
                }
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
                "({getter}! as Iterable).map((e) => {}).toList()",
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

    pub fn type_def_to_name_definition(&self, ty: &TypeDef) -> Option<String> {
        if let Some(v) = &ty.name {
            let defined = self.1.get(v as &str);
            if let Some(def) = defined {
                let owner = match ty.owner {
                    TypeOwner::World(id) => Some(&self.0.worlds.get(id).unwrap().name),
                    TypeOwner::Interface(id) => self.0.interfaces.get(id).unwrap().name.as_ref(),
                    TypeOwner::None => None,
                };
                let name = format!(
                    "{v}-{}",
                    owner.unwrap_or(&def.iter().position(|e| (*e).eq(ty)).unwrap().to_string())
                );
                Some(heck::AsPascalCase(name).to_string())
            } else {
                Some(heck::AsPascalCase(v).to_string())
            }
        } else {
            None
        }
    }

    fn add_methods_trait<T: crate::methods::GeneratedMethodsTrait>(
        &self,
        s: &mut String,
        name: &str,
        methods: &T,
    ) {
        if self.2.json_serialization {
            if let Some(m) = methods.from_json(name, self) {
                s.push_str(&m);
            }
            s.push_str(&methods.to_json(name, self));
        }
        if self.2.copy_with {
            if let Some(m) = methods.copy_with(name, self) {
                s.push_str(&m);
            }
        }
        if self.2.equality_and_hash_code {
            if let Some(m) = methods.equality_hash_code(name, self) {
                s.push_str(&m);
            }
        }
        if self.2.to_string {
            if let Some(m) = methods.to_string(name, self) {
                s.push_str(&m);
            }
        }
    }

    pub fn comparator(&self) -> &str {
        self.2.object_comparator.as_deref().unwrap_or("comparator")
    }

    pub fn type_def_to_definition(&self, ty: &TypeDef) -> String {
        let name = self.type_def_to_name_definition(ty);

        let mut s = String::new();
        add_docs(&mut s, &ty.docs);
        match &ty.kind {
            TypeDefKind::Record(r) => {
                let name = name.unwrap();
                s.push_str(&format!("class {name} {{"));
                r.fields.iter().for_each(|f| {
                    add_docs(&mut s, &f.docs);
                    s.push_str(&format!(
                        "final {} {};",
                        self.type_to_str(&f.ty),
                        f.name.as_var()
                    ));
                });
                if r.fields.is_empty() {
                    s.push_str(&format!("\n\nconst {name}();",));
                } else {
                    s.push_str(&format!("\n\nconst {name}({{",));
                    r.fields.iter().for_each(|f| {
                        s.push_str(&format!("required this.{},", f.name.as_var()));
                    });
                    s.push_str("});");
                }

                self.add_methods_trait(&mut s, &name, r);

                s.push_str(&format!(
                    "// ignore: unused_field
                    List<Object?> get _props => [{fields}];",
                    fields = r
                        .fields
                        .iter()
                        .map(|f| f.name.as_var())
                        .collect::<Vec<_>>()
                        .join(","),
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
                        v.name.as_var(),
                        if i == e.cases.len() - 1 { ";" } else { "," }
                    ));
                });

                self.add_methods_trait(&mut s, &name, e);

                s.push_str(&format!(
                    "static const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}");
                s
            }
            TypeDefKind::Union(u) => {
                let name = name.unwrap();
                s.push_str(&format!(
                    "sealed class {name} {{
                    factory {name}.fromJson(Object? json_) {{
                        Object? json = json_;
                        if (json is Map) {{
                            final k = json.keys.first;
                            json = (k is int ? k : int.parse(k! as String), json.values.first);
                        }}
                        return switch (json) {{ {} _ => throw Exception('Invalid JSON $json_'), }};
                    }}",
                    u.cases
                        .iter()
                        .enumerate()
                        .map(|(i, v)| {
                            let ty = self.type_to_str(&v.ty);
                            let inner_name = heck::AsPascalCase(&ty);
                            format!(
                                "({i}, final value) || [{i}, final value] => {name}{inner_name}({}),",
                                self.type_from_json("value", &v.ty),
                            )
                        })
                        .collect::<String>()
                ));

                let mut cases_string = String::new();
                u.cases.iter().enumerate().for_each(|(i, v)| {
                    add_docs(&mut cases_string, &v.docs);
                    let ty = self.type_to_str(&v.ty);
                    let inner_name = heck::AsPascalCase(&ty);
                    let class_name = format!("{name}{inner_name}");
                    cases_string.push_str(&format!(
                        "class {class_name} implements {name} {{ final {ty} value; const {class_name}(this.value);
                         @override\nMap<String, Object?> toJson() => {{'{i}': {}}};
                         @override\nString toString() => '{class_name}($value)';
                         @override\nbool operator ==(Object other) => other is {class_name} && comparator.areEqual(other.value, value);
                         @override\nint get hashCode => comparator.hashValue(value);
                        }}",
                         self.type_to_json("value", &v.ty)
                    ));
                    s.push_str(&format!("const factory {name}.{}({ty} value) = {class_name};", ty.as_var()));
                });

                s.push_str("\n\nMap<String, Object?> toJson();\n");

                s.push_str(&format!(
                    "// ignore: unused_field\nstatic const _spec = {};",
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
                        json = (
                          k is int ? k : _spec.cases.indexWhere((c) => c.label == k),
                          json.values.first
                        );
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
                                    "({i}, final value) => {name}{inner_name}({}),",
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
                            @override\nMap<String, Object?> toJson() => {{'{}': {}}};
                            @override\nString toString() => '{class_name}($value)';
                            @override\nbool operator ==(Object other) => other is {class_name} && comparator.areEqual(other.value, value);
                            @override\nint get hashCode => comparator.hashValue(value);
                         }}", v.name, self.type_to_json("value", &ty)
                        ));
                        s.push_str(&format!("const factory {name}.{}({ty_str} value) = {class_name};", v.name.as_var()));
                    } else {
                        cases_string.push_str(&format!(
                            "class {class_name} implements {name} {{ const {class_name}();
                            @override\nMap<String, Object?> toJson() => {{'{}': null}};
                            @override\nString toString() => '{class_name}()';
                            @override\nbool operator ==(Object other) => other is {class_name};
                            @override\nint get hashCode => ({class_name}).hashCode;
                        }}", v.name,
                        ));
                        s.push_str(&format!("const factory {name}.{}() = {class_name};", v.name.as_var()));
                    }
                });
                s.push_str("\n\nMap<String, Object?> toJson();\n");
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
                    "class {name} {{ final ByteData flagBits; const {name}(this.flagBits);
                    {name}.none(): flagBits = ByteData({num_bytes});
                    {name}.all(): flagBits = flagBitsFromJson(
                        Map.fromIterables(
                          _spec.labels,
                          List.filled(_spec.labels.length, true),
                        ),
                        _spec,
                      );
                    factory {name}.fromBool({{{from_bool}}}) {{
                        final value_ = {name}.none();
                        {from_bool_content}
                        return value_;
                    }}

                    factory {name}.fromJson(Object? json) {{
                        final flagBits = flagBitsFromJson(json, _spec);
                        return {name}(flagBits);
                    }}

                    Object toJson() => Uint32List.sublistView(flagBits);
                    @override\nString toString() => '{name}(${{[{to_string_content}].join(', ')}})';
                    @override\nbool operator ==(Object other) => other is {name} 
                        && comparator.areEqual(Uint32List.sublistView(flagBits), Uint32List.sublistView(other.flagBits));
                    @override\nint get hashCode => comparator.hashValue(Uint32List.sublistView(flagBits));
                    
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
                    from_bool = f.flags.iter().map(|v| format!("bool {} = false", v.name.as_var())).collect::<Vec<_>>().join(", "),
                    from_bool_content = f.flags.iter().map(|v| format!("if ({}) value_.{} = true;", v.name.as_var(), v.name.as_var())).collect::<String>(),
                    to_string_content = f.flags.iter().map(|v| format!("if ({}) '{}',", v.name.as_var(), v.name.as_var())).collect::<String>(),
                ));
                f.flags.iter().enumerate().for_each(|(i, v)| {
                    let property = v.name.as_var();
                    let index = (i / 32) * 4;
                    let flag = 2_u32.pow(i.try_into().unwrap());
                    let getter = format!("_index({index})");
                    // s.push_str(&format!(
                    //     "\n\nstatic const {property}IndexAndFlag = (index:{index}, flag:{flag});"
                    // ));

                    add_docs(&mut s, &v.docs);
                    s.push_str(&format!("bool get {property} => ({getter} & {flag}) != 0;"));
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
            TypeDefKind::List(_)
            | TypeDefKind::Tuple(_)
            | TypeDefKind::Option(_)
            | TypeDefKind::Result(_)
            | TypeDefKind::Future(_)
            | TypeDefKind::Stream(_) => {
                if let Some(name) = name {
                    s.push_str(&format!(
                        "typedef {name} = {};",
                        self.type_def_to_name(ty, false)
                    ));
                }
                s
            }
            TypeDefKind::Unknown => todo!(),
        }
    }
}
