use crate::{strings::Normalize, types::Parsed};
use wit_parser::*;

pub trait GeneratedMethodsTrait {
    fn to_json(&self, name: &str, p: &Parsed) -> String;
    fn from_json(&self, name: &str, p: &Parsed) -> String;
    fn to_string(&self, name: &str, p: &Parsed) -> String;
    fn copy_with(&self, name: &str, p: &Parsed) -> String;
    fn equality_hash_code(&self, name: &str, p: &Parsed) -> String;
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

    fn from_json(&self, name: &str, p: &Parsed) -> String {
        if self.fields.is_empty() {
            // TODO: add comments
            format!("\n\nfactory {name}.fromJson(Object? _) => const {name}();\n")
        } else {
            let spread = self
                .fields
                .iter()
                .map(|f| format!("final {}", f.name.as_var()))
                .collect::<Vec<_>>()
                .join(",");
            let s_comma = if self.fields.len() == 1 { "," } else { "" };
            format!(
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
            )
        }
    }

    fn to_string(&self, name: &str, _p: &Parsed) -> String {
        format!("
        @override\nString toString() => '{name}${{Map.fromIterables(_spec.fields.map((f) => f.label), _props)}}';\n"
    )
    }

    fn copy_with(&self, name: &str, p: &Parsed) -> String {
        format!(
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
        )
    }

    fn equality_hash_code(&self, name: &str, p: &Parsed) -> String {
        let comparator = p.comparator();
        format!("
        @override\nbool operator ==(Object other) => identical(this, other) || other is {name} && {comparator}.arePropsEqual(_props, other._props);
        @override\nint get hashCode => {comparator}.hashProps(_props);\n
        ")
    }
}
