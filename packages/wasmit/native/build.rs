use std::io::Write;

use lib_flutter_rust_bridge_codegen::{
    config_parse, frb_codegen, get_symbols_if_no_duplicates, RawOpts,
};

const RUST_INPUT: &str = "src/api.rs";
const DART_OUTPUT: &str = "../lib/src/bridge_generated.dart";

const IOS_C_OUTPUT: &str = "../../flutter_wasmit/ios/Classes/frb.h";
const MACOS_C_OUTPUT_DIR: &str = "../../flutter_wasmit/macos/Classes/";

fn main() {
    // Tell Cargo that if the input Rust code changes, rerun this build script
    println!("cargo:rerun-if-changed={}", RUST_INPUT);

    let _ = std::fs::remove_file("../example/test/main_test.bootstrap.isolate.dart");

    // Options for frb_codegen
    let raw_opts = RawOpts {
        rust_input: vec![RUST_INPUT.to_string()],
        dart_output: vec![DART_OUTPUT.to_string()],
        c_output: Some(vec![IOS_C_OUTPUT.to_string()]),
        extra_c_output_path: Some(vec![MACOS_C_OUTPUT_DIR.to_string()]),
        inline_rust: true,
        wasm: true,
        ..Default::default()
    };

    // Generate Rust & Dart ffi bridges
    let configs = config_parse(raw_opts);
    let all_symbols = get_symbols_if_no_duplicates(&configs).unwrap();
    for config in configs.iter() {
        frb_codegen(config, &all_symbols).unwrap();
    }
    let mut generated = std::fs::File::options()
        .append(true)
        .open("../lib/src/bridge_generated.dart")
        .unwrap();

    generated
        .write_all(
            "
extension WasmitDartImplPlatform on WasmitDartImpl {
    WasmitDartPlatform get platform => _platform;
}
"
            .as_bytes(),
        )
        .unwrap();

    // Format the generated Dart code
    _ = std::process::Command::new("flutter")
        .arg("format")
        .arg("..")
        .spawn();
}
