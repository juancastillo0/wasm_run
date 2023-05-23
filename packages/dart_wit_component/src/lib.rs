use std::{path::Path, vec};

mod function;
pub mod generate;
mod strings;
mod types;

// Use a procedural macro to generate bindings for the world we specified in
// `host.wit`
wit_bindgen::generate!("dart-wit-generator");

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct GeneratorImpl;

impl DartWitGenerator for GeneratorImpl {
    fn generate(config: WitGeneratorConfig) -> Result<Vec<WitFile>, String> {
        let files = match config.inputs {
            WitGeneratorInput::WitFileList(inputs) => {
                let mut files = vec![];
                for input in inputs {
                    let pkg = wit_parser::UnresolvedPackage::parse(
                        Path::new(&input.path),
                        &input.content,
                    )
                    .map_err(|e| e.to_string())?;
                    files.push((input.path, pkg));
                }
                files
            }
            WitGeneratorInput::WitGeneratorPaths(p) => {
                let parsed = wit_parser::UnresolvedPackage::parse_path(Path::new(&p.input_path))
                    .map_err(|e| e.to_string())?;

                vec![(p.input_path, parsed)]
            }
        };
        let output_files = files
            .into_iter()
            .map(|(path, pkg)| {
                let content = generate::document_to_dart(&pkg);
                WitFile { path, content }
            })
            .collect::<Vec<_>>();
        Ok(output_files)
    }
}

export_dart_wit_generator!(GeneratorImpl);
