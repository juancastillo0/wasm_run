use std::{ffi::c_char, fs::Metadata, time::SystemTime};

#[no_mangle]
pub extern "C" fn print_hello() {
    println!("Hello, world! 2");
}

#[no_mangle]
pub extern "C" fn stderr_log(msg_utf16: *const u16, msg_utf16_length: u32) {
    let msg = String::from_utf16(unsafe {
        std::slice::from_raw_parts(msg_utf16, msg_utf16_length.try_into().unwrap())
    })
    .unwrap();
    let flt = unsafe { translate(msg_utf16_length.try_into().unwrap()) };
    eprintln!("{} {}", flt, msg);
}

#[no_mangle]
pub extern "C" fn read_file_size(path: *const c_char) -> u64 {
    // String::from_raw_parts(buf, length, capacity);
    let path = unsafe { std::ffi::CStr::from_ptr(path) };
    // let path = String::from_utf16(path).unwrap();
    let metadata = std::fs::metadata(path.to_str().unwrap()).unwrap();

    metadata.len()
}

// TODO: test default -> Rust FileData -> memory bytes pointer -> Dart FileData
// #[no_mangle]
// pub extern "C" fn file_data(path_utf8: *const u8, path_utf8_length: u32) -> FileData {
//     let path = std::str::from_utf8(unsafe {
//         std::slice::from_raw_parts(path_utf8, path_utf8_length.try_into().unwrap())
//     })
//     .unwrap();

//     let metadata = std::fs::metadata(path).unwrap();
//     metadata.into()
// }

#[no_mangle]
pub extern "C" fn file_data_raw(path_utf8: *const u8, path_utf8_length: u32) -> *const u8 {
    let path = std::str::from_utf8(unsafe {
        std::slice::from_raw_parts(path_utf8, path_utf8_length.try_into().unwrap())
    })
    .unwrap();

    let metadata = std::fs::metadata(path).unwrap();
    let data: FileData = metadata.into();
    let mut bytes = Vec::new();
    data.append_bytes(&mut bytes);
    forget_and_return_pointer(bytes)
}

pub struct FileData {
    pub size: u64,
    pub read_only: bool,
    pub modified: Option<u64>,
    pub accessed: Option<u64>,
    pub created: Option<u64>,
}

impl From<Metadata> for FileData {
    fn from(metadata: Metadata) -> Self {
        Self {
            size: metadata.len(),
            read_only: metadata.permissions().readonly(),
            modified: metadata.modified().ok().as_ref().map(timestamp),
            accessed: metadata.accessed().ok().as_ref().map(timestamp),
            created: metadata.created().ok().as_ref().map(timestamp),
        }
    }
}

impl FileData {
    fn append_bytes(&self, bytes: &mut Vec<u8>) {
        bytes.extend(self.size.to_ne_bytes());
        bytes.push(if self.read_only { 1 } else { 0 });
        append_option(bytes, &self.modified, |bytes, a| {
            bytes.extend(a.to_ne_bytes())
        });
        append_option(bytes, &self.accessed, |bytes, a| {
            bytes.extend(a.to_ne_bytes())
        });
        append_option(bytes, &self.created, |bytes, a| {
            bytes.extend(a.to_ne_bytes())
        });
    }
}

// final bool captureStdout;
// final bool captureStderr;
// final bool inheritStdin;
#[no_mangle]
pub extern "C" fn current_time() -> u64 {
    timestamp(&std::time::SystemTime::now())
}

#[no_mangle]
pub extern "C" fn get_args() -> *const u8 {
    // Vec::from_raw_parts(ptr, length, capacity);
    let mut bytes = Vec::new();
    bytes.extend(vec_size(std::env::args()));
    std::env::args().for_each(|arg| {
        append_str(&mut bytes, &arg);
    });
    forget_and_return_pointer(bytes)
}

#[no_mangle]
pub unsafe extern "C" fn dealloc(pointer: *mut u8, bytes: usize) {
    let data = Vec::from_raw_parts(pointer, bytes, bytes);

    std::mem::drop(data);
}

#[no_mangle]
pub unsafe extern "C" fn alloc(bytes: usize) -> *mut u8 {
    let mut data = Vec::with_capacity(bytes);
    let pointer = data.as_mut_ptr();
    std::mem::forget(data);
    pointer
}

#[no_mangle]
pub extern "C" fn get_env_vars() -> *const u8 {
    let mut bytes = Vec::new();
    bytes.extend(vec_size(std::env::vars()));
    let iter =
        std::env::vars().flat_map(|(name, value)| -> Vec<u8> { EnvVar { name, value }.into() });
    bytes.extend(iter);
    forget_and_return_pointer(bytes)
}

pub struct EnvVar {
    name: String,
    value: String,
}

impl From<EnvVar> for Vec<u8> {
    fn from(env_var: EnvVar) -> Self {
        let mut bytes = Vec::new();
        append_str(&mut bytes, &env_var.name);
        append_str(&mut bytes, &env_var.value);
        bytes
    }
}

fn forget_and_return_pointer(bytes: Vec<u8>) -> *const u8 {
    let bytes = bytes.into_boxed_slice();
    let pointer = bytes.as_ptr();
    std::mem::forget(bytes);
    pointer
}

fn timestamp(time: &SystemTime) -> u64 {
    u64::try_from(
        time.duration_since(std::time::UNIX_EPOCH)
            .unwrap()
            .as_millis(),
    )
    .unwrap()
}

fn vec_size(v: impl Iterator) -> [u8; 4] {
    let size = v.count();
    println!("size {}", size);
    u32::try_from(size).unwrap().to_ne_bytes()
}

fn append_str(bytes: &mut Vec<u8>, value: &str) {
    println!("value {}", value);
    bytes.extend(u32::try_from(value.len()).unwrap().to_ne_bytes());
    bytes.extend(value.as_bytes());
}

fn append_option<T: Copy>(
    bytes: &mut Vec<u8>,
    option: &Option<T>,
    append: impl Fn(&mut Vec<u8>, &T),
) {
    bytes.push(if option.is_some() { 1 } else { 0 });
    if let Some(value) = option {
        append(bytes, value);
    }
}

pub struct MyStruct {
    pub name: String,
    pub list: Vec<u8>,
    pub list_double: Option<f32>,
    pub opt: Option<bool>,
    pub int_v: i32,
}

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

#[link(wasm_import_module = "example_imports")]
extern "C" {
    // functions can have integer/float arguments/return values
    fn translate(a: i32) -> f64;

    // Note that the ABI of Rust and wasm is somewhat in flux, so while this
    // works, it's recommended to rely on raw integer/float values where
    // possible.
    // pub fn translate_fancy(my_struct: MyStruct) -> u32;

    // you can also explicitly specify the name to import, this imports `bar`
    // instead of `baz` from `example_imports`.
    // #[link_name = "bar"]
    // fn baz();
}
