// use js_sys::{Array, Uint8Array};
// use wasm_bindgen::{prelude::wasm_bindgen, JsCast, JsValue};

// #[no_mangle]
// pub extern "C" fn print_hello() {
//     println!("Hello, world!");
// }

// #[wasm_bindgen]
// pub fn read_file_size(path: String) -> u64 {
//     let metadata = std::fs::metadata(path).unwrap();

//     metadata.len()
// }
// // permissions
// // modified
// // accessed
// // created

// // final bool captureStdout;
// // final bool captureStderr;
// // final bool inheritStdin;

// #[wasm_bindgen]
// pub fn current_time() -> u64 {
//     u64::try_from(
//         std::time::SystemTime::now()
//             .duration_since(std::time::UNIX_EPOCH)
//             .unwrap()
//             .as_millis(),
//     )
//     .unwrap()
// }

// #[wasm_bindgen]
// pub fn get_args() -> ArrayString {
//     std::env::args()
//         .map(JsValue::from)
//         .collect::<Array>()
//         .unchecked_into::<ArrayString>()
// }

// #[wasm_bindgen]
// pub fn get_env_vars() -> ArrayEnvVar {
//     std::env::vars()
//         .map(|(name, value)| EnvVar { name, value })
//         .map(JsValue::from)
//         .collect::<Array>()
//         .unchecked_into::<ArrayEnvVar>()
// }

// #[wasm_bindgen]
// pub struct EnvVar {
//     name: String,
//     value: String,
// }

// #[wasm_bindgen]
// impl EnvVar {
//     #[wasm_bindgen(getter)]
//     pub fn name(&self) -> String {
//         self.name.clone()
//     }

//     #[wasm_bindgen(getter)]
//     pub fn value(&self) -> String {
//         self.value.clone()
//     }
// }

// #[wasm_bindgen]
// pub struct MyStruct {
//     name: String,
//     list: Vec<u8>,
//     pub list_double: Option<f32>,
//     pub opt: Option<bool>,
//     pub int_v: i32,
// }

// #[wasm_bindgen]
// impl MyStruct {
//     #[wasm_bindgen(getter)]
//     pub fn name(&self) -> String {
//         self.name.clone()
//     }

//     #[wasm_bindgen(getter)]
//     pub fn list(&self) -> Uint8Array {
//         Uint8Array::from(self.list.as_slice())
//     }
// }

// #[wasm_bindgen]
// #[link(wasm_import_module = "the-wasm-import-module")]
// extern "C" {
//     #[wasm_bindgen(typescript_type = "Array<string>")]
//     pub type ArrayString;

//     #[wasm_bindgen(typescript_type = "Array<EnvVar>")]
//     pub type ArrayEnvVar;

//     // imports the name `foo` from `the-wasm-import-module`
//     fn foo();

//     // functions can have integer/float arguments/return values
//     fn translate(a: i32) -> f32;

//     // Note that the ABI of Rust and wasm is somewhat in flux, so while this
//     // works, it's recommended to rely on raw integer/float values where
//     // possible.
//     fn translate_fancy(my_struct: MyStruct) -> u32;

//     // you can also explicitly specify the name to import, this imports `bar`
//     // instead of `baz` from `the-wasm-import-module`.
//     #[link_name = "bar"]
//     fn baz();
// }
