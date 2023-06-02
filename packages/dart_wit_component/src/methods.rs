use crate::{strings::Normalize, types::Parsed};
use wit_parser::*;

pub trait GeneratedMethodsTrait {
    fn to_json(&self, name: &str, p: &Parsed) -> String;
    fn from_json(&self, name: &str, p: &Parsed) -> Option<String>;
    fn to_string(&self, name: &str, p: &Parsed) -> Option<String>;
    fn copy_with(&self, name: &str, p: &Parsed) -> Option<String>;
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> Option<String>;
}

impl GeneratedMethodsTrait for Record {
    fn to_json(&self, _name: &str, p: &Parsed) -> String {
        format!(
            "Map<String, Object?> toJson() => {{{}}};",
            self.fields
                .iter()
                .map(|f| format!("'{}': {},", f.name, p.type_to_json(&f.name.as_var(), &f.ty)))
                .collect::<String>(),
        )
    }
    fn from_json(&self, name: &str, p: &Parsed) -> Option<String> {
        if self.fields.is_empty() {
            // TODO: add comments
            Some(format!(
                "\n\nfactory {name}.fromJson(Object? _) => const {name}();\n"
            ))
        } else {
            let spread = self
                .fields
                .iter()
                .map(|f| format!("final {}", f.name.as_var()))
                .collect::<Vec<_>>()
                .join(",");
            let s_comma = if self.fields.len() == 1 { "," } else { "" };
            Some(format!(
                "\n\nfactory {name}.fromJson(Object? json_) {{
                final json = json_ is Map ? _spec.fields.map((f) => json_[f.label]).toList(growable: false) : json_;
                return switch (json) {{
                    [{spread}] || ({spread}{s_comma}) => {name}({}),
                    _ => throw Exception('Invalid JSON $json_')}};
                }}",
                self.fields
                    .iter()
                    .map(|f| format!(
                        "{}: {},",
                        f.name.as_var(),
                        p.type_from_json(&f.name.as_var(), &f.ty)
                    ))
                    .collect::<String>(),
            ))
        }
    }
    fn to_string(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!("
        @override\nString toString() => '{name}${{Map.fromIterables(_spec.fields.map((f) => f.label), _props)}}';\n"
        ))
    }
    fn copy_with(&self, name: &str, p: &Parsed) -> Option<String> {
        Some(format!(
            "{name} copyWith({copy_with_params}) => {name}({copy_with_content});",
            copy_with_params = if self.fields.is_empty() {
                "".to_string()
            } else {
                format!(
                    "{{{}}}",
                    self.fields
                        .iter()
                        .map(|f| format!("{}? {},", p.type_to_str(&f.ty), f.name.as_var(),))
                        .collect::<String>()
                )
            },
            copy_with_content = if self.fields.is_empty() {
                "".to_string()
            } else {
                self.fields
                    .iter()
                    .map(|f| {
                        format!(
                            "{}: {} ?? this.{}",
                            f.name.as_var(),
                            f.name.as_var(),
                            f.name.as_var()
                        )
                    })
                    .collect::<Vec<_>>()
                    .join(",")
            },
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
    fn to_json(&self, _name: &str, _p: &Parsed) -> String {
        "\nObject? toJson() => _spec.labels[index];\n".to_string()
    }
    fn from_json(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!(
            "factory {name}.fromJson(Object? json_) {{
                final json = json_ is Map ? json_.keys.first : json_;
                if (json is String) {{
                    final index = _spec.labels.indexOf(json);
                    return index != -1 ? values[index] : values.byName(json);
                }}
                return values[json! as int];}}",
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

fn base_string_case(self_: &Case, name: &str, p: &Parsed) -> String {
    if let Some(ty) = self_.ty {
        format!(
    "@override Map<String, Object?> toJson() => {{'{}': {}}};
    @override String toString() => '{name}($value)';
    @override bool operator ==(Object other) => other is {name} && comparator.areEqual(other.value, value);
    @override int get hashCode => comparator.hashValue(value);", self_.name,  p.type_to_json("value", &ty)
)
    } else {
        format!(
            "@override Map<String, Object?> toJson() => {{'{}': null}};
    @override String toString() => '{name}()';
    @override bool operator ==(Object other) => other is {name};
    @override int get hashCode => ({name}).hashCode;",
            self_.name,
        )
    }
}

impl GeneratedMethodsTrait for Case {
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
    fn to_json(&self, _name: &str, p: &Parsed) -> String {
        format!(
            "@override\nMap<String, Object?> toJson() => {{'{}': {}}};",
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
    fn equality_hash_code(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(
            format!("
            @override\nbool operator ==(Object other) => other is {name} && comparator.areEqual(other.value, value);
            @override\nint get hashCode => comparator.hashValue(value);",)
        )
    }
}

impl GeneratedMethodsTrait for Flags {
    fn to_json(&self, _name: &str, _p: &Parsed) -> String {
        "Object toJson() => flagsBits.toJson();".to_string()
    }
    fn from_json(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!(
            "
            factory {name}.fromJson(Object? json) {{
                final flagsBits = FlagsBits.fromJson(json, flagsKeys: _spec.labels);
                return {name}(flagsBits);
            }}"
        ))
    }
    fn to_string(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(format!(
            "@override\nString toString() => '{name}(${{[{to_string_content}].join(', ')}})';",
            to_string_content = self
                .flags
                .iter()
                .map(|v| format!("if ({}) '{}',", v.name.as_var(), v.name.as_var()))
                .collect::<String>(),
        ))
    }
    fn copy_with(&self, _name: &str, _p: &Parsed) -> Option<String> {
        None
    }
    fn equality_hash_code(&self, name: &str, _p: &Parsed) -> Option<String> {
        Some(
            format!("
            @override\nbool operator ==(Object other) => other is {name} && comparator.areEqual(flagsBits, other.flagsBits);
            @override\nint get hashCode => comparator.hashValue(flagsBits);",)
        )
    }
}
