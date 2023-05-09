mod function;
pub mod generate;
mod strings;
mod types;

// Use a procedural macro to generate bindings for the world we specified in
// `host.wit`
wit_bindgen::generate!("types-example");

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necesssary exported interfaces for this
// component.
struct MyHost;

impl TypesExample for MyHost {
    fn f_f1(typedef: T10) -> T10 {
        todo!()
    }

    fn f1(f: f32, f_list: Vec<(char, f64)>) -> (i64, String) {
        todo!()
    }

    fn re_named(perm: Option<types_interface::Permissions>, e: Option<Empty>) -> T2Renamed {
        todo!()
    }

    fn re_named2(tup: (Vec<u16>,), e: Empty) -> (Option<u8>, i8) {
        todo!()
    }
}

export_host!(MyHost);
