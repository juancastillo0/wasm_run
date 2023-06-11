use std::collections::HashMap;

use crate::{generate::*, strings::Normalize, Int64TypeConfig, WitGeneratorConfig};
use wit_parser::*;

pub struct Parsed<'a>(
    pub &'a Resolve,
    pub HashMap<&'a str, Vec<&'a TypeDef>>,
    pub WitGeneratorConfig,
);

const FROM_JSON_COMMENT: &str = "/// Returns a new instance from a JSON value.
/// May throw if the value does not have the expected structure.\n";
const TO_JSON_COMMENT: &str = "/// Returns this as a serializable JSON value.\n";
const TO_WASM_COMMENT: &str = "/// Returns this as a WASM canonical abi value.\n";
const COPY_WITH_COMMENT: &str =
    "/// Returns a new instance by overriding the values passed as arguments\n";

enum MethodComment {
    FromJson,
    ToJson,
    ToWasm,
    CopyWith,
}

fn mapper_func(getter: &str, current: &str, is_required: bool) -> String {
    let func_params = format!("({getter})");
    if current == getter {
        if is_required {
            "null".to_string()
        } else {
            "".to_string()
        }
    } else if current.ends_with(&func_params) {
        let current_func = current.trim_end_matches(&func_params);
        current_func.to_string()
    } else {
        format!("{func_params} => {current}")
    }
}

impl Parsed<'_> {
    pub fn type_to_str(&self, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();

                if let (TypeDefKind::Option(ty), true) = (&ty_def.kind, self.2.use_null_for_option)
                {
                    let value = format!("{}?", self.type_to_str_inner(ty));
                    // TODO: remove when this ships https://github.com/dart-lang/sdk/issues/52591
                    if value == "()?" {
                        "Object?".to_string()
                    } else {
                        value
                    }
                } else {
                    self.type_def_to_name(ty_def, true)
                }
            }
            _ => self.type_to_str_inner(ty),
        }
    }
    fn type_to_str_inner(&self, ty: &Type) -> String {
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

    fn list_typed_data(&self, ty: &Type) -> Option<String> {
        if !self.2.typed_number_lists {
            return None;
        }
        match ty {
            Type::Float32 => Some("Float32List".to_string()),
            Type::Float64 => Some("Float64List".to_string()),
            Type::S8 => Some("Int8List".to_string()),
            Type::S16 => Some("Int16List".to_string()),
            Type::S32 => Some("Int32List".to_string()),
            Type::U8 => Some("Uint8List".to_string()),
            Type::U16 => Some("Uint16List".to_string()),
            Type::U32 => Some("Uint32List".to_string()),
            _ => None,
        }
    }

    pub fn type_to_json(&self, getter: &str, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                self.type_def_to_json(getter, ty_def)
            }
            _ => self.type_to_json_inner(getter, ty),
        }
    }

    fn type_to_json_inner(&self, getter: &str, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                self.type_def_to_json_inner(getter, ty_def)
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

    fn type_def_to_json(&self, getter: &str, ty: &TypeDef) -> String {
        match &ty.kind {
            TypeDefKind::Option(ty) => {
                let mapped = self.type_to_json_inner("some", &ty);
                let mapped = mapper_func("some", &mapped, false);
                if self.2.use_null_for_option {
                    format!("({getter} == null ? const None().toJson() : Option.fromValue({getter}).toJson({mapped}))")
                } else {
                    format!("{getter}.toJson({mapped})")
                }
            }
            _ => self.type_def_to_json_inner(getter, ty),
        }
    }

    fn type_def_to_json_inner(&self, getter: &str, ty: &TypeDef) -> String {
        match &ty.kind {
            TypeDefKind::Record(_record) => format!("{getter}.toJson()"),
            TypeDefKind::Enum(_enum_) => format!("{getter}.toJson()"),
            TypeDefKind::Union(_union) => format!("{getter}.toJson()"),
            TypeDefKind::Flags(_flags) => format!("{getter}.toJson()"),
            TypeDefKind::Variant(_variant) => format!("{getter}.toJson()"),
            TypeDefKind::Option(ty) => {
                let inner = self.type_to_json_inner("some", &ty);
                let inner = mapper_func("some", &inner, false);
                format!("{getter}.toJson({inner})")
            }
            TypeDefKind::Result(r) => {
                let map_ok = r.ok.map_or_else(
                    || "null".to_string(),
                    |ok| {
                        let to_json = self.type_to_json("ok", &ok);
                        mapper_func("ok", &to_json, true)
                    },
                );
                let map_err = r.err.map_or_else(
                    || "null".to_string(),
                    |error| {
                        let to_json = self.type_to_json("error", &error);
                        mapper_func("error", &to_json, true)
                    },
                );
                format!("{getter}.toJson({map_ok}, {map_err})")
            }
            TypeDefKind::Tuple(t) => {
                let list = t
                    .types
                    .iter()
                    .enumerate()
                    .map(|(i, t)| self.type_to_json(&format!("{getter}.${ind}", ind = i + 1), t))
                    .collect::<Vec<_>>()
                    .join(", ");
                format!("[{list}]")
            }
            TypeDefKind::List(ty) => {
                let inner = self.type_to_json("e", &ty);
                if inner == "e" {
                    format!("{getter}.toList()")
                } else {
                    let inner = mapper_func("e", &inner, true);
                    format!("{getter}.map({inner}).toList()")
                }
            }
            TypeDefKind::Future(_ty) => unreachable!("Future"),
            TypeDefKind::Stream(_s) => unreachable!("Stream"),
            TypeDefKind::Type(ty) => self.type_to_json_inner(getter, &ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
        }
    }

    pub fn type_to_wasm(&self, getter: &str, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                self.type_def_to_wasm(getter, ty_def)
            }
            _ => self.type_to_wasm_inner(getter, ty),
        }
    }

    fn type_to_wasm_inner(&self, getter: &str, ty: &Type) -> String {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                self.type_def_to_wasm_inner(getter, ty_def)
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

    fn type_def_to_wasm(&self, getter: &str, ty: &TypeDef) -> String {
        match &ty.kind {
            TypeDefKind::Option(ty) => {
                let mapper = self.type_to_wasm_inner("some", &ty);
                let mapper = mapper_func("some", &mapper, false);
                if self.2.use_null_for_option {
                    format!("({getter} == null ? const None().toWasm() : Option.fromValue({getter}).toWasm({mapper}))")
                } else {
                    format!("{getter}.toWasm({mapper})")
                }
            }
            _ => self.type_def_to_wasm_inner(getter, ty),
        }
    }

    fn type_def_to_wasm_inner(&self, getter: &str, ty: &TypeDef) -> String {
        match &ty.kind {
            TypeDefKind::Record(_record) => format!("{getter}.toWasm()"),
            TypeDefKind::Enum(_enum_) => format!("{getter}.toWasm()"),
            TypeDefKind::Union(_union) => format!("{getter}.toWasm()"),
            TypeDefKind::Flags(_flags) => format!("{getter}.toWasm()"),
            TypeDefKind::Variant(_variant) => format!("{getter}.toWasm()"),
            TypeDefKind::Option(ty) => {
                format!(
                    "{getter}.toWasm({})",
                    mapper_func("some", &self.type_to_wasm_inner("some", &ty), false)
                )
            }
            TypeDefKind::Result(r) => {
                let map_ok = r.ok.map_or_else(
                    || "null".to_string(),
                    |ok| {
                        let to_wasm = self.type_to_wasm("ok", &ok);
                        mapper_func("ok", &to_wasm, true)
                    },
                );
                let map_err = r.err.map_or_else(
                    || "null".to_string(),
                    |error| {
                        let to_wasm = self.type_to_wasm("error", &error);
                        mapper_func("error", &to_wasm, true)
                    },
                );
                format!("{getter}.toWasm({map_ok}, {map_err})")
            }
            TypeDefKind::Tuple(t) => {
                let list = t
                    .types
                    .iter()
                    .enumerate()
                    .map(|(i, t)| self.type_to_wasm(&format!("{getter}.${ind}", ind = i + 1), t))
                    .collect::<Vec<_>>()
                    .join(", ");
                format!("[{list}]")
            }
            TypeDefKind::List(ty) => {
                let inner = self.type_to_wasm("e", &ty);
                // In toJson() we use toList(), but in toWasm() we just use the list directly
                // If we need to map, we use toList(growable: false).
                if inner == "e" {
                    format!("{getter}")
                } else {
                    let inner = mapper_func("e", &inner, true);
                    format!("{getter}.map({inner}).toList(growable: false)")
                }
            }
            TypeDefKind::Future(_ty) => unreachable!("Future"),
            TypeDefKind::Stream(_s) => unreachable!("Stream"),
            TypeDefKind::Type(ty) => self.type_to_wasm_inner(getter, &ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
        }
    }

    fn type_class_name(&self, ty: &Type) -> Option<String> {
        if let Type::Id(ty_id) = ty {
            let ty_def = self.0.types.get(*ty_id).unwrap();
            if let (
                Some(name),
                TypeDefKind::Record(_)
                | TypeDefKind::Enum(_)
                | TypeDefKind::Union(_)
                | TypeDefKind::Variant(_)
                | TypeDefKind::Flags(_),
            ) = (self.type_def_to_name_definition(ty_def), &ty_def.kind)
            {
                return Some(name);
            }
        }
        None
    }

    pub fn type_to_spec(&self, ty: &Type) -> String {
        if let Some(name) = self.type_class_name(ty) {
            format!("{name}._spec")
        } else {
            self.type_to_spec_inner(ty)
        }
    }

    fn type_to_spec_inner(&self, ty: &Type) -> String {
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
            TypeDefKind::Record(record) => {
                let fields = record
                    .fields
                    .iter()
                    .map(|t| format!("(label: '{}', t: {})", t.name, self.type_to_spec(&t.ty)))
                    .collect::<Vec<_>>()
                    .join(", ");
                format!("RecordType([{fields}])")
            }
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
            TypeDefKind::Variant(variant) => {
                let options = variant
                    .cases
                    .iter()
                    .map(|t| format!("Case('{}', {})", t.name, self.type_def_to_spec_option(t.ty)))
                    .collect::<Vec<_>>()
                    .join(", ");
                format!("Variant([{options}])")
            }
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

                match &ty_def.kind {
                    TypeDefKind::Option(_ty) => {
                        let val = self.type_def_from_json(getter, ty_def);
                        if self.2.use_null_for_option {
                            format!("{val}.value")
                        } else {
                            val
                        }
                    }
                    _ => self.type_def_from_json(getter, ty_def),
                }
            }
            _ => self.type_from_json_inner(getter, ty),
        }
    }

    fn type_from_json_inner(&self, getter: &str, ty: &Type) -> String {
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

    fn type_def_from_json_option(&self, getter: &str, r: Option<Type>) -> String {
        r.map(|ty| self.type_from_json(getter, &ty))
            .unwrap_or("null".to_string())
    }

    fn type_def_from_json(&self, getter: &str, ty: &TypeDef) -> String {
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
                    let length = t.types.len();
                    let values =  t.types
                            .iter()
                            .enumerate()
                            .map(|(i, t)| self.type_from_json(&format!("v{i}"), t))
                            .collect::<Vec<_>>()
                            .join(", ");

                    format!(
                        "(() {{final l = {getter} is Map
                        ? List.generate({length}, (i) => {getter}[i.toString()], growable: false)
                        : {getter};
                        return switch (l) {{
                            [{spread}] || ({spread}{s_comma}) => ({values},),
                            _ => throw Exception('Invalid JSON ${getter}')}};
                        }})()"
                    )
                }
            }
            TypeDefKind::Option(ty) => format!(
                "Option.fromJson({getter}, (some) => {})",
                self.type_from_json_inner("some", &ty)
            ),
            TypeDefKind::Result(r) => format!(
                "Result.fromJson({getter}, (ok) => {}, (error) => {})",
                self.type_def_from_json_option("ok", r.ok),
                self.type_def_from_json_option("error", r.err),
            ),
            // TypeDefKind::Option(ty) => format!(
            //     "{getter} == null ? none : {}",
            //     self.type_from_json_inner(getter, &ty)
            // ),
            // TypeDefKind::Result(r) => format!(
            //     "({getter} as Map).containsKey('ok') ? Ok({}) : Err({})",
            //     self.type_def_from_json_option(&format!("({getter} as Map)['ok']"), r.ok),
            //     self.type_def_from_json_option(&format!("({getter} as Map)['error']"), r.err),
            // ),
            TypeDefKind::List(ty) => self
                .list_typed_data(ty)
                .map(|type_data|
                    format!("({getter} is {type_data} ? {getter} : {type_data}.fromList(({getter}! as List).cast()))")
                )
                .unwrap_or_else(|| {
                    let inner = self.type_from_json("e", &ty);
                    if inner == "e" {
                        format!("({getter}! as Iterable).toList()")
                    } else {
                        let inner = mapper_func("e", &inner, true);
                        format!("({getter}! as Iterable).map({inner}).toList()")
                    }
                }),
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
            TypeDefKind::Type(ty) => self.type_from_json_inner(getter, &ty),
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

    fn type_def_to_name(&self, ty: &TypeDef, allow_alias: bool) -> String {
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
                let values = t
                    .types
                    .iter()
                    .map(|t| {
                        let mut s = self.type_to_str(t);
                        s.push_str(", ");
                        s
                    })
                    .collect::<String>();
                format!("({values})")
            }
            TypeDefKind::Option(ty) => format!("Option<{}>", self.type_to_str_inner(&ty)),
            TypeDefKind::Result(r) => format!(
                "Result<{}, {}>",
                r.ok.map(|ty| self.type_to_str(&ty))
                    .unwrap_or("void".to_string()),
                r.err
                    .map(|ty| self.type_to_str(&ty))
                    .unwrap_or("void".to_string())
            ),
            TypeDefKind::List(ty) => self
                .list_typed_data(ty)
                .unwrap_or_else(|| format!("List<{}>", self.type_to_str(&ty))),
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
            TypeDefKind::Type(ty) => self.type_to_str_inner(&ty),
            TypeDefKind::Unknown => unimplemented!("Unknown type"),
        }
    }

    pub fn type_def_to_name_definition(&self, ty: &TypeDef) -> Option<String> {
        if let Some(v) = &ty.name {
            let defined = self.1.get(v as &str);
            if let Some(def) = defined {
                let owner = match ty.owner {
                    TypeOwner::World(id) => Some(self.0.worlds.get(id).unwrap().name.clone()),
                    TypeOwner::Interface(id) => self.0.interfaces.get(id).unwrap().name.clone(),
                    TypeOwner::None => None,
                };
                let name = format!(
                    "{v}-{}",
                    owner.unwrap_or_else(|| def
                        .iter()
                        .position(|e| (*e).eq(ty))
                        .unwrap()
                        .to_string())
                );
                Some(heck::AsPascalCase(name).to_string())
            } else {
                Some(heck::AsPascalCase(v).to_string())
            }
        } else {
            None
        }
    }

    fn method_comment(&self, comment: MethodComment) -> &str {
        if self.2.generate_docs {
            match comment {
                MethodComment::CopyWith => COPY_WITH_COMMENT,
                MethodComment::ToJson => TO_JSON_COMMENT,
                MethodComment::ToWasm => TO_WASM_COMMENT,
                MethodComment::FromJson => FROM_JSON_COMMENT,
            }
        } else {
            ""
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
                s.push_str(self.method_comment(MethodComment::FromJson));
                s.push_str(&m);
            }
            s.push_str(self.method_comment(MethodComment::ToJson));
            s.push_str(&methods.to_json(name, self));
        }

        s.push_str(self.method_comment(MethodComment::ToWasm));
        s.push_str(&methods.to_wasm(name, self));

        if self.2.to_string {
            if let Some(m) = methods.to_string(name, self) {
                s.push_str(&m);
            }
        }
        if self.2.copy_with {
            if let Some(m) = methods.copy_with(name, self) {
                s.push_str(self.method_comment(MethodComment::CopyWith));
                s.push_str(&m);
            }
        }
        if self.2.equality_and_hash_code {
            if let Some(m) = methods.equality_hash_code(name, self) {
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
                add_docs(&mut s, &ty.docs);
                if r.fields.is_empty() {
                    s.push_str(&format!("const {name}();",));
                } else {
                    s.push_str(&format!("const {name}({{",));
                    r.fields.iter().for_each(|f| {
                        s.push_str(&self.type_param(&f.name, &f.ty, true));
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
                let from_json_comment = self.method_comment(MethodComment::FromJson);
                let switch_cases = u
                    .cases
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
                    .collect::<String>();

                s.push_str(&format!(
                    "sealed class {name} {{
                    {from_json_comment}factory {name}.fromJson(Object? json_) {{
                        Object? json = json_;
                        if (json is Map) {{
                            final k = json.keys.first;
                            json = (k is int ? k : int.parse(k! as String), json.values.first);
                        }}
                        return switch (json) {{ {switch_cases} _ => throw Exception('Invalid JSON $json_'), }};
                    }}",
                ));

                let mut cases_string = String::new();
                u.cases.iter().enumerate().for_each(|(i, v)| {
                    // TODO: should we use the docs from the union's inner type?
                    let docs = extract_dart_docs(&v.docs).unwrap_or("".to_string());
                    cases_string.push_str(&docs);
                    let ty = self.type_to_str(&v.ty);
                    let inner_name = heck::AsPascalCase(&ty);
                    let class_name = format!("{name}{inner_name}");
                    cases_string.push_str(&format!(
                        "class {class_name} implements {name} {{ final {ty} value; {docs}const {class_name}(this.value);",
                    ));

                    add_docs(&mut cases_string, &v.docs);
                    self.add_methods_trait(&mut cases_string, &class_name, &(i, v));
                    cases_string.push_str("}");
                    s.push_str(&format!("{docs}const factory {name}.{}({ty} value) = {class_name};", ty.as_var()));
                });

                s.push_str(self.method_comment(MethodComment::ToJson));
                s.push_str("Map<String, Object?> toJson();\n");
                s.push_str(self.method_comment(MethodComment::ToWasm));
                s.push_str("(int, Object?) toWasm();\n");

                s.push_str(&format!(
                    "// ignore: unused_field\nstatic const _spec = {};",
                    self.type_def_to_spec(&ty)
                ));
                s.push_str("}"); // close sealed union class
                s.push_str(&cases_string);
                s
            }
            TypeDefKind::Variant(a) => {
                let from_json_comment = self.method_comment(MethodComment::FromJson);
                let name = name.unwrap();
                let switch_value =  a.cases
                    .iter()
                    .enumerate()
                    .map(|(i, v)| {
                        let inner_name = heck::AsPascalCase(&v.name);
                        match v.ty {
                            Some(ty) => format!(
                                "({i}, final value) || [{i}, final value] => {name}{inner_name}({}),",
                                self.type_from_json("value", &ty),
                            ),
                            None => format!("({i}, null) || [{i}, null] => const {name}{inner_name}(),",),
                        }
                    })
                    .collect::<String>();

                s.push_str(&format!(
                    "sealed class {name} {{ {from_json_comment}factory {name}.fromJson(Object? json_) {{
                    Object? json = json_;
                    if (json is Map) {{
                        final k = json.keys.first;
                        json = (
                          k is int ? k : _spec.cases.indexWhere((c) => c.label == k),
                          json.values.first
                        );
                    }}
                    return switch (json) {{ {switch_value} _ => throw Exception('Invalid JSON $json_'), }};
                }}",
                ));
                let mut cases_string = String::new();
                a.cases.iter().enumerate().for_each(|(i, v)| {
                let docs = extract_dart_docs(&v.docs).unwrap_or("".to_string());
                cases_string.push_str(&docs);
                    let inner_name =  heck::AsPascalCase(&v.name);
                    let class_name = format!("{name}{inner_name}");
                    if let Some(ty) = v.ty {
                        let ty_str =self.type_to_str(&ty);
                        cases_string.push_str(&format!(
                            "class {class_name} implements {name} {{ final {ty_str} value; {docs}const {class_name}(this.value);"));
                        s.push_str(&format!("const factory {name}.{}({ty_str} value) = {class_name};", v.name.as_var()));
                    } else {
                        cases_string.push_str(&format!("class {class_name} implements {name} {{ {docs}const {class_name}();" ));
                        s.push_str(&format!("const factory {name}.{}() = {class_name};", v.name.as_var()));
                    }
                    self.add_methods_trait(&mut cases_string, &class_name,&(i, v));
                    cases_string.push_str("}");
                });
                s.push_str(self.method_comment(MethodComment::ToJson));
                s.push_str("Map<String, Object?> toJson();\n");
                s.push_str(self.method_comment(MethodComment::ToWasm));
                s.push_str("(int, Object?) toWasm();\n");
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
                let num_flags = f.flags.len();
                let from_bool = f
                    .flags
                    .iter()
                    .map(|v| format!("bool {} = false", v.name.as_var()))
                    .collect::<Vec<_>>()
                    .join(", ");
                let from_bool_content = f
                    .flags
                    .iter()
                    .map(|v| {
                        format!(
                            "if ({}) value_.{} = true;",
                            v.name.as_var(),
                            v.name.as_var()
                        )
                    })
                    .collect::<String>();
                s.push_str(&format!(
                    "class {name} {{ 
                    /// The flags represented as a set of bits.
                    final FlagsBits flagsBits; 
                    /// Creates an instance where the flags are represented by [flagsBits].
                    /// The number of flags must match the number of flags in the type ({num_flags}).
                    {name}(this.flagsBits): assert(flagsBits.numFlags == {num_flags});
                    /// An instance where all flags are set to `false`.
                    {name}.none(): flagsBits = FlagsBits.none(numFlags: {num_flags});
                    /// An instance where all flags are set to `true`.
                    {name}.all(): flagsBits = FlagsBits.all(numFlags: {num_flags});
                    /// Creates an instance with flags booleans passed as arguments.
                    factory {name}.fromBool({{{from_bool}}}) {{
                        final value_ = {name}.none();
                        {from_bool_content}
                        return value_;
                    }}"
                ));
                self.add_methods_trait(&mut s, &name, f);

                s.push_str(&format!(
                    "
/// Returns the bitwise AND of the flags in this and [other].
{name} operator &({name} other) => {name}(flagsBits & other.flagsBits);
/// Returns the bitwise OR of the flags in this and [other].
{name} operator |({name} other) => {name}(flagsBits | other.flagsBits);
/// Returns the bitwise XOR of the flags in this and [other].
{name} operator ^({name} other) => {name}(flagsBits ^ other.flagsBits);
/// Returns the flags inverted (negated).
{name} operator ~() => {name}(~flagsBits);"
                ));

                f.flags.iter().enumerate().for_each(|(i, v)| {
                    let property = v.name.as_var();
                    add_docs(&mut s, &v.docs);
                    s.push_str(&format!(
                        "bool get {property} => flagsBits[{i}];
                         set {property}(bool enable) => flagsBits[{i}] = enable;"
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
