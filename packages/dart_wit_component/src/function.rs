use wit_parser::*;

use crate::{generate::add_docs, strings::Normalize, types::Parsed};

pub enum FuncKind {
    MethodCall,
    Method,
    Field,
}

impl Parsed<'_> {
    pub fn function_import(&self, key: Option<&WorldKey>, id: &str, f: &Function) -> String {
        let interface_name_m = match key {
            Some(k) => self.0.name_world_key(k),
            None => "$root".to_string(),
        };
        let interface_name = key.map(|key| self.world_key_type_name(key));
        let getter = format!(
            "imports.{}{}",
            interface_name
                .map(|v| format!("{}.", v.as_var()))
                .unwrap_or("".to_string()),
            id.as_var(),
        );
        format!(
            "{{
                const ft = {ft};
                {exec}
                final lowered = loweredImportFunction(r'{interface_name_m}#{id}', ft, exec{exec_name}, getLib);
                builder.addImport(r'{interface_name_m}', '{id}', lowered);
            }}",
            ft = self.function_spec(f),
            exec = self.function_exec(&getter, f,),
            exec_name = getter.as_fn_suffix(),
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
            n = getter.as_fn_suffix(),
            results_def = if function.results.len() == 0 {
                ""
            } else {
                "final results = "
            },
            args = function
                .params
                .iter()
                .enumerate()
                .map(|(i, (_name, _ty))| format!("final args{i} = args[{i}];"))
                .collect::<String>(),
            args_from_json = function
                .params
                .iter()
                .enumerate()
                .map(|(i, (name, ty))| format!(
                    "{}: {}",
                    name.as_var(),
                    self.type_from_json(&format!("args{i}"), ty)
                ))
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
                                .map(|(name, ty)| self
                                    .type_to_json(&format!("results.{}", name.as_var()), ty))
                                .collect::<Vec<_>>()
                                .join(", ")
                        )
                    },
            }
        )
    }

    pub fn world_key_type_name<'a>(&'a self, key: &'a WorldKey) -> &'a str {
        match key {
            WorldKey::Name(name) => name,
            WorldKey::Interface(id) => {
                let interface = self.0.interfaces.get(*id).unwrap();
                interface.name.as_ref().unwrap()
            }
        }
    }

    pub fn add_interfaces(
        &self,
        mut s: &mut String,
        map: &mut dyn Iterator<Item = (&WorldKey, &WorldItem)>,
        is_export: bool,
        mut func_imports: Option<&mut String>,
    ) {
        map.for_each(|(key, item)| match item {
            WorldItem::Interface(interface_id) => {
                let interface = self.0.interfaces.get(*interface_id).unwrap();
                self.add_interface(&mut s, key, interface, is_export, &mut func_imports)
            }
            _ => {}
        });
    }

    pub fn add_interface(
        &self,
        mut s: &mut String,
        key: &WorldKey,
        interface: &Interface,
        is_export: bool,
        func_imports: &mut Option<&mut String>,
    ) {
        let world_prefix = self.0.name_world_key(key);
        let interface_id = self.world_key_type_name(key);
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
                            "_{} = library.getComponentFunction('{world_prefix}#{id}', const {},)!",
                            id.as_var(),
                            self.function_spec(f)
                        ));
                        if index != interface.functions.len() - 1 {
                            s.push_str(",");
                        }
                    });
                s.push_str(";");
            }

            interface.functions.iter().for_each(|(_id, f)| {
                self.add_function(&mut s, f, FuncKind::MethodCall);
            });
            s.push_str("}");
        } else {
            if interface.functions.is_empty() {
                return;
            }
            s.push_str(&format!("abstract class {name}Import {{",));
            interface.functions.iter().for_each(|(id, f)| {
                self.add_function(&mut s, f, FuncKind::Method);
                if let Some(func_imports) = func_imports {
                    func_imports.push_str(&self.function_import(Some(key), id, f));
                }
            });
            s.push_str("}");
        }
    }

    pub fn is_option(&self, ty: &Type) -> bool {
        match ty {
            Type::Id(ty_id) => {
                let ty_def = self.0.types.get(*ty_id).unwrap();
                matches!(ty_def.kind, TypeDefKind::Option(_))
            }
            _ => false,
        }
    }

    pub fn type_param(&self, name: &str, ty: &Type, is_constructor: bool) -> String {
        let type_or_this = if is_constructor {
            "this.".to_string()
        } else {
            self.type_to_str(ty)
        };
        if !self.2.required_option && self.is_option(ty) {
            if self.2.use_null_for_option {
                format!("{type_or_this} {},", name.as_var())
            } else {
                format!("{type_or_this} {} = const None(),", name.as_var())
            }
        } else {
            format!("required {type_or_this} {},", name.as_var())
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
            .map(|(name, ty)| self.type_param(name, ty, false))
            .collect::<String>();
        if params.len() > 0 {
            params = format!("{{{}}}", params);
        }

        let results = match &f.results {
            Results::Anon(ty) => self.type_to_str(ty),
            Results::Named(list) => {
                if list.is_empty() {
                    "void".to_string()
                } else {
                    format!(
                        "({{{}}})",
                        list.iter()
                            .map(|(name, ty)| {
                                format!("{} {}", self.type_to_str(ty), name.as_var(),)
                            })
                            .collect::<Vec<_>>()
                            .join(",")
                    )
                }
            }
        };

        let name = &f.name.as_fn();
        match kind {
            FuncKind::Field => {
                add_docs(&mut s, &f.docs);
                s.push_str(&format!("final {results} Function({params}) {name};",))
            }
            FuncKind::Method => {
                add_docs(&mut s, &f.docs);
                s.push_str(&format!("{results} {name}({params});",))
            }
            FuncKind::MethodCall => {
                // s.push_str(&format!("late final _{} = lookup('{}');", f.name, f.name));
                s.push_str(&format!("final ListValue Function(ListValue) _{name};"));

                add_docs(&mut s, &f.docs);
                s.push_str(&format!("{results} {name}({params}) {{"));
                s.push_str(&format!(
                    "{}_{name}([{params}]);{ret}",
                    if f.results.len() == 0
                        || (f.results.len() == 1
                            && self.is_unit(f.results.iter_types().next().unwrap()))
                    {
                        ""
                    } else {
                        "final results = "
                    },
                    params = f
                        .params
                        .iter()
                        .map(|(name, ty)| self.type_to_json(&name.as_var(), ty))
                        .collect::<Vec<_>>()
                        .join(", "),
                    ret = match &f.results {
                        Results::Anon(a) => {
                            if self.is_unit(&a) {
                                "return ();".to_string()
                            } else {
                                format!(
                                    "final result = results[0];return {};",
                                    self.type_from_json("result", a)
                                )
                            }
                        }
                        Results::Named(results) =>
                            if results.is_empty() {
                                "".to_string()
                            } else {
                                format!(
                                    "{}return ({},);",
                                    (0..results.len())
                                        .map(|i| format!("final r{i} = results[{i}];"))
                                        .collect::<String>(),
                                    results
                                        .iter()
                                        .enumerate()
                                        .map(|(i, (name, ty))| format!(
                                            "{}: {}",
                                            name.as_var(),
                                            self.type_from_json(&format!("r{i}"), ty),
                                        ),)
                                        .collect::<Vec<_>>()
                                        .join(", ")
                                )
                            },
                    }
                ));
                s.push_str("}");
            }
        }
    }
}
