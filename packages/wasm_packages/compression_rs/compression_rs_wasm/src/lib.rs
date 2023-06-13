// Use a procedural macro to generate bindings for the world we specified in `compression-rs.wit`
wit_bindgen::generate!("compression-rs");

// Comment out the following lines to include other generated interfaces
// use exports::compression_rs_namespace::compression_rs::*;
// use compression_rs_namespace::compression_rs::interface_name;

// Define a custom type and implement the generated trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct WitImplementation;

export_compression_rs!(WitImplementation);

impl CompressionRs for WitImplementation {
    fn run(value: Model) -> Result<f64, String> {
        let mapped = map_integer(value.integer);
        if mapped.is_nan() {
            Err("NaN returned from map_integer".to_string())
        } else {
            Ok(mapped)
        }
    }
}
