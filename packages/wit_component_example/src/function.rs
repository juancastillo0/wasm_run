use wit_parser::*;

use crate::{
    generate::add_docs,
    types::{FuncKind, Parsed},
};

impl Parsed<'_> {
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
