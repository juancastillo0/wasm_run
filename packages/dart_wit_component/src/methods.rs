use crate::{strings::Normalize, types::Parsed};
use wit_parser::*;

pub trait GeneratedMethodsTrait {
    fn to_wasm(&self, name: &str, p: &Parsed) -> String;
    fn to_json(&self, name: &str, p: &Parsed) -> String;
    fn from_json(&self, name: &str, p: &Parsed) -> Option<String>;
    fn to_string(&self, name: &str, p: &Parsed) -> Option<String>;
    fn copy_with(&self, name: &str, p: &Parsed) -> Option<String>;
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> Option<String>;
}

impl GeneratedMethodsTrait for Record {
    fn to_wasm(&self, _name: &str, p: &Parsed) -> String {
        let props = self
            .fields
            .iter()
            .map(|f| p.type_to_wasm(&f.name.as_var(), &f.ty))
            .collect::<Vec<_>>()
            .join(",");
        format!("List<Object?> toWasm() => [{props}];")
    }
    fn to_json(&self, name: &str, p: &Parsed) -> String {
        let content = self
            .fields
            .iter()
            .map(|f| format!("'{}': {},", f.name, p.type_to_json(&f.name.as_var(), &f.ty)))
            .collect::<String>();
        format!("Map<String, Object?> toJson() => {{'runtimeType': '{name}', {content}}};")
    }
    fn from_json(&self, name: &str, p: &Parsed) -> Option<String> {
        if self.fields.is_empty() {
            Some(format!(
                "factory {name}.fromJson(Object? _) => const {name}();\n"
            ))
        } else {
            let spread = self
                .fields
                .iter()
                .map(|f| format!("final {}", f.name.as_var()))
                .collect::<Vec<_>>()
                .join(",");
            let s_comma = if self.fields.len() == 1 { "," } else { "" };
            let from_json_items = self
                .fields
                .iter()
                .map(|f| {
                    format!(
                        "{}: {},",
                        f.name.as_var(),
                        p.type_from_json(&f.name.as_var(), &f.ty)
                    )
                })
                .collect::<String>();

            Some(format!(
                "factory {name}.fromJson(Object? json_) {{
                final json = json_ is Map ? _spec.fields.map((f) => json_[f.label]).toList(growable: false) : json_;
                return switch (json) {{
                    [{spread}] || ({spread}{s_comma}) => {name}({from_json_items}),
                    _ => throw Exception('Invalid JSON $json_')}};
                }}",
            ))
        }
    }
    fn to_string(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!("
        @override\nString toString() => '{name}${{Map.fromIterables(_spec.fields.map((f) => f.label), _props)}}';\n"
        ))
    }
    fn copy_with(&self, name: &str, p: &Parsed) -> Option<String> {
        let copy_with_params = if self.fields.is_empty() {
            "".to_string()
        } else {
            let params = self
                .fields
                .iter()
                .map(|f| {
                    let mut tt = p.type_to_str(&f.ty);
                    if tt.ends_with("?") {
                        tt.pop();
                        format!("Option<{tt}>? {},", f.name.as_var(),)
                    } else {
                        format!(
                            "{tt}{} {},",
                            if tt.ends_with("?") { "" } else { "?" },
                            f.name.as_var(),
                        )
                    }
                })
                .collect::<String>();
            format!("{{{params}}}",)
        };
        let copy_with_content = if self.fields.is_empty() {
            "".to_string()
        } else {
            self.fields
                .iter()
                .map(|f| {
                    let field = f.name.as_var();
                    if let (true, true) = (p.2.use_null_for_option, p.is_option(&f.ty)) {
                        format!("{field}: {field} != null ? {field}.value : this.{field}")
                    } else {
                        format!("{field}: {field} ?? this.{field}")
                    }
                })
                .collect::<Vec<_>>()
                .join(",")
        };

        Some(format!(
            "{name} copyWith({copy_with_params}) => {name}({copy_with_content});"
        ))
    }
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> Option<String> {
        let comparator = p.comparator();
        Some(format!("
        @override\nbool operator ==(Object other) => identical(this, other) || other is {name} && {comparator}.arePropsEqual(_props, other._props);
        @override\nint get hashCode => {comparator}.hashProps(_props);\n
        "))
    }
}

impl GeneratedMethodsTrait for Enum {
    fn to_wasm(&self, _name: &str, _p: &Parsed) -> String {
        "int toWasm() => index;".to_string()
    }
    fn to_json(&self, name: &str, _p: &Parsed) -> String {
        format!("Map<String, Object?> toJson() => {{'runtimeType':'{name}', _spec.labels[index]: null}};\n")
    }
    fn from_json(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!(
            "factory {name}.fromJson(Object? json) {{
                return ToJsonSerializable.enumFromJson(json, values, _spec);
            }}",
        ))
    }
    fn to_string(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn copy_with(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn equality_hash_code(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
}

fn base_string_case(data: &(usize, &Case), name: &str, p: &Parsed) -> String {
    let self_ = data.1;
    let comparator = p.comparator();
    if let Some(ty) = self_.ty {
        format!(
    "Map<String, Object?> toJson() => {{'runtimeType':'{name}','{}': {}}};
    @override String toString() => '{name}($value)';
    @override bool operator ==(Object other) => other is {name} && {comparator}.areEqual(other.value, value);
    @override int get hashCode => {comparator}.hashValue(value);", self_.name,  p.type_to_json("value", &ty)
)
    } else {
        format!(
            "Map<String, Object?> toJson() => {{'runtimeType':'{name}','{}': null}};
    @override String toString() => '{name}()';
    @override bool operator ==(Object other) => other is {name};
    @override int get hashCode => ({name}).hashCode;",
            self_.name,
        )
    }
}

impl GeneratedMethodsTrait for (usize, &Case) {
    fn to_wasm(&self, _name: &str, p: &Parsed) -> String {
        let index = self.0;
        if let Some(ty) = self.1.ty {
            format!(
                "@override (int, Object?) toWasm() => ({index}, {});",
                p.type_to_wasm("value", &ty)
            )
        } else {
            format!("@override (int, Object?) toWasm() => ({index}, null);")
        }
    }
    fn to_json(&self, name: &str, p: &Parsed) -> String {
        base_string_case(self, name, p)
            .split("\n")
            .nth(0)
            .unwrap()
            .to_string()
    }
    fn from_json(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn to_string(&self, name: &str, p: &Parsed) -> Option<String> {
        Some(
            base_string_case(self, name, p)
                .split("\n")
                .nth(1)
                .unwrap()
                .to_string(),
        )
    }
    fn copy_with(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> Option<String> {
        Some(
            base_string_case(self, name, p)
                .split("\n")
                .skip(2)
                .collect(),
        )
    }
}

impl GeneratedMethodsTrait for (usize, &UnionCase) {
    fn to_wasm(&self, _name: &str, p: &Parsed) -> String {
        let override_ = if p.2.same_class_union {
            ""
        } else {
            "@override "
        };
        format!(
            "{override_}(int, Object?) toWasm() => ({}, {});",
            self.0,
            p.type_to_wasm("value", &self.1.ty)
        )
    }
    fn to_json(&self, name: &str, p: &Parsed) -> String {
        format!(
            "\nMap<String, Object?> toJson() => {{'runtimeType':'{name}','{}': {}}};",
            self.0,
            p.type_to_json("value", &self.1.ty)
        )
    }
    fn from_json(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn to_string(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!("@override\nString toString() => '{name}($value)';"))
    }
    fn copy_with(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> Option<String> {
        let comparator = p.comparator();
        Some(
            format!("
            @override\nbool operator ==(Object other) => other is {name} && {comparator}.areEqual(other.value, value);
            @override\nint get hashCode => {comparator}.hashValue(value);",)
        )
    }
}

impl GeneratedMethodsTrait for Flags {
    fn to_wasm(&self, _name: &str, _p: &Parsed) -> String {
        "Uint32List toWasm() => Uint32List.sublistView(flagsBits.data);".to_string()
    }
    fn to_json(&self, name: &str, _p: &Parsed) -> String {
        format!("Map<String, Object?> toJson() => flagsBits.toJson()..['runtimeType'] = '{name}';")
    }
    fn from_json(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!(
            "factory {name}.fromJson(Object? json) {{
                final flagsBits = FlagsBits.fromJson(json, flagsKeys: _spec.labels);
                return {name}(flagsBits);
            }}"
        ))
    }
    fn to_string(&self, name: &str, _p: &Parsed) -> Option<String> {
        let to_string_content = self
            .flags
            .iter()
            .map(|v| format!("if ({}) '{}',", v.name.as_var(), v.name.as_var()))
            .collect::<String>();
        Some(format!(
            "@override\nString toString() => '{name}(${{[{to_string_content}].join(', ')}})';",
        ))
    }
    fn copy_with(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> Option<String> {
        let comparator = p.comparator();
        Some(
            format!("
            @override\nbool operator ==(Object other) => other is {name} && {comparator}.areEqual(flagsBits, other.flagsBits);
            @override\nint get hashCode => {comparator}.hashValue(flagsBits);",)
        )
    }
}
