mod function;
pub mod generate;
mod types;
mod strings;

// Use a procedural macro to generate bindings for the world we specified in
// `host.wit`
wit_bindgen::generate!("host");

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necesssary exported interfaces for this
// component.
struct MyHost;

impl Host for MyHost {
    fn run() {
        print("Hello, world!");
    }

    fn get() -> RecordTest {
        RecordTest {
            a: 3,
            b: "".to_string(),
            c: 3.0,
        }
    }

    fn map(rec: RecordTest) -> RecordTest {
        rec
    }

    fn map_i(rec: RecordTest, i: f32) -> RecordTest {
        rec
    }

    fn receive_i(rec: RecordTest, i: f32) {}
}

export_host!(MyHost);
