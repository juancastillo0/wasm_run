//! Centralized error messages for unsupported features.
//!
//! This module provides detailed, informative error messages when users
//! attempt to use features not supported by their chosen runtime.

/// Error messages for wasmi runtime limitations.
pub mod wasmi_limitations {
    /// Error message for shared memory not being supported.
    pub const SHARED_MEMORY: &str =
        "Shared memory is not supported in the wasmi runtime. \
         SharedMemory requires the WebAssembly threads proposal which wasmi \
         does not implement. For shared memory support, use the wasmtime runtime \
         by enabling the 'wasmtime' feature.";

    /// Error message for multi-threading not being supported.
    pub const THREADS: &str =
        "Multi-threading is not supported in the wasmi runtime. \
         wasmi is a pure interpreter that does not support the WebAssembly \
         threads proposal (shared memory, atomics). If you need multi-threaded \
         execution, use the wasmtime runtime by enabling the 'wasmtime' feature.";

    /// Error message for atomic operations not being supported.
    pub const ATOMICS: &str =
        "Atomic operations are not supported in the wasmi runtime. \
         Atomics require shared memory (WebAssembly threads proposal) which \
         wasmi does not support. Use wasmtime for atomic operations.";

    /// Error message for parallel execution not being supported.
    pub const PARALLEL_EXEC: &str =
        "Parallel execution is not supported in the wasmi runtime. \
         The wasmi interpreter does not support multi-threading or shared memory. \
         If you need parallel execution, consider using the wasmtime runtime instead \
         by enabling the 'wasmtime' feature.";

    /// Error message for GC (garbage collection) not being supported.
    pub const GC: &str =
        "Garbage Collection (WasmGC) is not supported in the wasmi runtime. \
         Types like anyref, structref, and arrayref require the GC proposal. \
         For WasmGC support, use the wasmtime runtime by enabling the 'wasmtime' feature.";

    /// Error message for exception handling not being supported.
    pub const EXCEPTION_HANDLING: &str =
        "Exception handling (exnref) is not supported in the wasmi runtime. \
         For exception handling support, use the wasmtime runtime by enabling the 'wasmtime' feature.";

    /// Error message for stack switching/continuations not being supported.
    pub const CONTINUATIONS: &str =
        "Continuation references (contref) are not supported in the wasmi runtime. \
         Stack switching requires the typed continuations proposal which wasmi does not implement. \
         For stack switching support, use the wasmtime runtime by enabling the 'wasmtime' feature.";

    /// Error message for Component Model / WASI Preview2 not being supported.
    pub const COMPONENT_MODEL: &str =
        "The WebAssembly Component Model is not supported in the wasmi runtime. \
         Components and WASI Preview2 require the component-model proposal which wasmi \
         does not implement. For Component Model support, use the wasmtime runtime \
         by enabling the 'wasmtime' feature. Note: All current toolchains (Rust wasm32-wasi, \
         wasi-sdk, Go, AssemblyScript) produce core modules that work with wasmi.";
}

/// Error messages for wasmtime runtime limitations.
pub mod wasmtime_limitations {
    /// Error message for continuation references not being fully supported yet.
    pub const CONTINUATIONS: &str =
        "Continuation references (contref) are not yet fully supported in wasmtime. \
         The stack switching proposal is still experimental. See wasmtime issue #10248.";
}
