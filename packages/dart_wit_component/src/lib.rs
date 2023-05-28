use std::path::Path;

mod function;
pub mod generate;
mod strings;
mod types;

// Use a procedural macro to generate bindings for the world we specified in
// `with/dart-wit-generator.wit`
wit_bindgen::generate!("dart-wit-generator");

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct GeneratorImpl;

impl DartWitGenerator for GeneratorImpl {
    fn generate(config: WitGeneratorConfig) -> Result<WitFile, String> {
        let (path, pkg) = match config.inputs {
            WitGeneratorInput::InMemoryFiles(inputs) => {
                let mut source_map = wit_parser::SourceMap::new();
                let world_path = inputs.world_file.path.clone();
                for input in inputs.pkg_files.into_iter().chain([inputs.world_file]) {
                    let path = Path::new(&input.path);
                    source_map.push(&path, input.contents);
                }
                let parsed = source_map.parse().map_err(|e| e.to_string())?;
                (world_path, parsed)
            }
            WitGeneratorInput::FileSystemPaths(p) => {
                let parsed = wit_parser::UnresolvedPackage::parse_path(Path::new(&p.input_path))
                    .map_err(|e| e.to_string())?;
                (p.input_path, parsed)
            }
        };
        let contents = generate::document_to_dart(&pkg);
        Ok(WitFile { path, contents })
    }
}

export_dart_wit_generator!(GeneratorImpl);
