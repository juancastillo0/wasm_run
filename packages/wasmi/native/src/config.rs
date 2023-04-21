#[derive(Debug)]
pub struct WasiConfig {
    pub capture_stdout: bool,
    pub capture_stderr: bool,
    // TODO: custom stdin
    pub inherit_stdin: bool,
    pub inherit_env: bool,
    pub inherit_args: bool,
    pub args: Vec<String>,
    pub env: Vec<EnvVariable>,
    pub preopened_files: Vec<String>,
    pub preopened_dirs: Vec<PreopenedDir>,
}

#[derive(Debug)]
#[allow(non_camel_case_types)]
pub enum StdIOKind {
    stdout,
    stderr,
}

impl WasiConfig {
    pub fn to_wasi_ctx(&self) -> anyhow::Result<wasi_common::WasiCtx> {
        #[cfg(not(feature = "wasmtime"))]
        use wasmi_wasi::{ambient_authority, WasiCtxBuilder};
        #[cfg(feature = "wasmtime")]
        use wasmtime_wasi::{ambient_authority, WasiCtxBuilder};

        // add wasi to linker
        let mut wasi_builder = WasiCtxBuilder::new();
        if self.inherit_args {
            wasi_builder = wasi_builder.inherit_args()?;
        }
        if self.inherit_env {
            wasi_builder = wasi_builder.inherit_env()?;
        }
        if self.inherit_stdin {
            wasi_builder = wasi_builder.inherit_stdin();
        }
        if !self.capture_stdout {
            wasi_builder = wasi_builder.inherit_stdout();
        }
        if !self.capture_stderr {
            wasi_builder = wasi_builder.inherit_stderr();
        }
        if !self.args.is_empty() {
            for value in &self.args {
                wasi_builder = wasi_builder.arg(value)?;
            }
        }
        if !self.env.is_empty() {
            for EnvVariable { name, value } in &self.env {
                wasi_builder = wasi_builder.env(name, value)?;
            }
        }
        if !self.preopened_dirs.is_empty() {
            for PreopenedDir {
                wasm_guest_path,
                host_path,
            } in &self.preopened_dirs
            {
                let dir = cap_std::fs::Dir::open_ambient_dir(host_path, ambient_authority())?;
                wasi_builder = wasi_builder.preopened_dir(dir, wasm_guest_path)?;
            }
        }

        Ok(wasi_builder.build())
    }
}

#[derive(Debug)]
pub struct EnvVariable {
    pub name: String,
    pub value: String,
}

#[derive(Debug)]
pub struct PreopenedDir {
    pub wasm_guest_path: String,
    pub host_path: String,
}

#[derive(Debug)]
pub struct ModuleConfig {
    /// Is `true` if the [`multi-value`] Wasm proposal is enabled.
    pub multi_value: Option<bool>,
    /// Is `true` if the [`bulk-memory`] Wasm proposal is enabled.
    pub bulk_memory: Option<bool>,
    /// Is `true` if the [`reference-types`] Wasm proposal is enabled.
    pub reference_types: Option<bool>,
    /// Is `true` if `wasmi` executions shall consume fuel.
    pub consume_fuel: Option<bool>,
    /// Wasmi config
    pub wasmi: Option<ModuleConfigWasmi>,
    /// Wasmtime config
    pub wasmtime: Option<ModuleConfigWasmtime>,
}

#[cfg(feature = "wasmtime")]
impl From<ModuleConfig> for wasmtime::Config {
    fn from(c: ModuleConfig) -> Self {
        let mut config = Self::new();
        c.multi_value.map(|v| config.wasm_multi_value(v));
        c.bulk_memory.map(|v| config.wasm_bulk_memory(v));
        c.reference_types.map(|v| config.wasm_reference_types(v));
        c.consume_fuel.map(|v| config.consume_fuel(v));
        if let Some(wtc) = c.wasmtime {
            // TODO: feature incremental-cache
            // wtc.enable_incremental_compilation.map(|v| config.enable_incremental_compilation(v));
            // wtc.async_support.map(|v| config.async_support(v));
            wtc.debug_info.map(|v| config.debug_info(v));
            wtc.wasm_backtrace.map(|v| config.wasm_backtrace(v));
            wtc.native_unwind_info.map(|v| config.native_unwind_info(v));
            wtc.epoch_interruption.map(|v| config.epoch_interruption(v));
            wtc.max_wasm_stack.map(|v| config.max_wasm_stack(v));
            wtc.wasm_simd.map(|v| config.wasm_simd(v));
            wtc.wasm_threads.map(|v| config.wasm_threads(v));
            wtc.wasm_multi_memory.map(|v| config.wasm_multi_memory(v));
            // TODO: wtc.tail_call.map(|v| config.wasm_tail_call(v));
            wtc.wasm_memory64.map(|v| config.wasm_memory64(v));
            // TODO: feature component-model
            // wtc.wasm_component_model.map(|v| config.wasm_component_model(v));
            wtc.static_memory_maximum_size
                .map(|v| config.static_memory_maximum_size(v));
            wtc.static_memory_forced
                .map(|v| config.static_memory_forced(v));
            wtc.static_memory_guard_size
                .map(|v| config.static_memory_guard_size(v));
            wtc.parallel_compilation
                .map(|v| config.parallel_compilation(v));
            wtc.generate_address_map
                .map(|v| config.generate_address_map(v));
            wtc.wasm_relaxed_simd.map(|v| config.wasm_relaxed_simd(v));
        }
        config
    }
}

#[cfg(not(feature = "wasmtime"))]
impl From<ModuleConfig> for wasmi::Config {
    fn from(c: ModuleConfig) -> Self {
        let mut config = Self::default();
        c.multi_value.map(|v| config.wasm_multi_value(v));
        c.bulk_memory.map(|v| config.wasm_bulk_memory(v));
        c.reference_types.map(|v| config.wasm_reference_types(v));
        c.consume_fuel.map(|v| config.consume_fuel(v));
        if let Some(wic) = c.wasmi {
            wic.stack_limits
                .map(|v| config.set_stack_limits(v.try_into().unwrap()));
            wic.cached_stacks.map(|v| config.set_cached_stacks(v));
            wic.mutable_global.map(|v| config.wasm_mutable_global(v));
            wic.sign_extension.map(|v| config.wasm_sign_extension(v));
            wic.saturating_float_to_int
                .map(|v| config.wasm_saturating_float_to_int(v));
            wic.tail_call.map(|v| config.wasm_tail_call(v));
            wic.extended_const.map(|v| config.wasm_extended_const(v));
            wic.floats.map(|v| config.floats(v));
            // config.set_fuel_costs(wic.flue_costs);
        }
        config
    }
}

#[derive(Debug)]
pub struct ModuleConfigWasmi {
    /// WASMI
    //

    /// The limits set on the value stack and call stack.
    pub stack_limits: Option<WasiStackLimits>,
    /// The amount of Wasm stacks to keep in cache at most.
    pub cached_stacks: Option<usize>,
    /// Is `true` if the `mutable-global` Wasm proposal is enabled.
    pub mutable_global: Option<bool>,
    /// Is `true` if the `sign-extension` Wasm proposal is enabled.
    pub sign_extension: Option<bool>,
    /// Is `true` if the `saturating-float-to-int` Wasm proposal is enabled.
    pub saturating_float_to_int: Option<bool>,
    /// Is `true` if the [`tail-call`] Wasm proposal is enabled.
    pub tail_call: Option<bool>, // wasmtime disabled
    /// Is `true` if the [`extended-const`] Wasm proposal is enabled.
    pub extended_const: Option<bool>,
    /// Is `true` if Wasm instructions on `f32` and `f64` types are allowed.
    pub floats: Option<bool>,
    // /// The fuel consumption mode of the `wasmi` [`Engine`](crate::Engine).
    // // TODO: pub fuel_consumption_mode: FuelConsumptionMode,
    // /// The configured fuel costs of all `wasmi` bytecode instructions.
    // // pub fuel_costs: FuelCosts,
}

/// The configured limits of the Wasm stack.
#[derive(Debug, Copy, Clone)]
pub struct WasiStackLimits {
    /// The initial value stack height that the Wasm stack prepares.
    pub initial_value_stack_height: usize,
    /// The maximum value stack height in use that the Wasm stack allows.
    pub maximum_value_stack_height: usize,
    /// The maximum number of nested calls that the Wasm stack allows.
    pub maximum_recursion_depth: usize,
}

#[cfg(not(feature = "wasmtime"))]
impl TryFrom<WasiStackLimits> for wasmi::StackLimits {
    type Error = anyhow::Error;

    fn try_from(value: WasiStackLimits) -> std::result::Result<Self, Self::Error> {
        use crate::types::to_anyhow;

        Self::new(
            value.initial_value_stack_height,
            value.maximum_value_stack_height,
            value.maximum_recursion_depth,
        )
        .map_err(to_anyhow)
    }
}

#[derive(Debug)]
pub struct ModuleConfigWasmtime {
    // TODO: pub enable_incremental_compilation: Option<bool>, incremental-cache feature
    // TODO: pub async_support: Option<bool>,                  async feature
    /// Configures whether DWARF debug information will be emitted during
    /// compilation.
    pub debug_info: Option<bool>,
    pub wasm_backtrace: Option<bool>,
    pub native_unwind_info: Option<bool>,
    // TODO: pub wasm_backtrace_details: WasmBacktraceDetails, // Or WASMTIME_BACKTRACE_DETAILS env var
    //
    pub epoch_interruption: Option<bool>, // vs consume_fuel
    pub max_wasm_stack: Option<usize>,
    //
    pub wasm_threads: Option<bool>, // false
    pub wasm_simd: Option<bool>,
    pub wasm_multi_memory: Option<bool>, // false
    pub wasm_memory64: Option<bool>,     // false
    // TODO: pub wasm_component_model: Option<bool>, // false
    //
    // pub strategy: Strategy,
    // TODO: pub profiler: ProfilingStrategy,
    // TODO: pub allocation_strategy: OnDemand, // vs Polling feature flag
    pub static_memory_maximum_size: Option<u64>,
    pub static_memory_forced: Option<bool>,
    pub static_memory_guard_size: Option<u64>,
    pub parallel_compilation: Option<bool>,
    pub generate_address_map: Option<bool>,

    pub wasm_relaxed_simd: Option<bool>,
}

/// https://docs.wasmtime.dev/stability-wasm-proposals-support.html
pub struct WasmFeatures {
    /// The WebAssembly `mutable-global` proposal (enabled by default)
    pub mutable_global: bool,
    /// The WebAssembly `nontrapping-float-to-int-conversions` proposal (enabled by default)
    pub saturating_float_to_int: bool,
    /// The WebAssembly `sign-extension-ops` proposal (enabled by default)
    pub sign_extension: bool,
    /// The WebAssembly reference types proposal (enabled by default)
    pub reference_types: bool,
    /// The WebAssembly multi-value proposal (enabled by default)
    pub multi_value: bool,
    /// The WebAssembly bulk memory operations proposal (enabled by default)
    pub bulk_memory: bool,
    /// The WebAssembly SIMD proposal
    pub simd: bool,
    /// The WebAssembly Relaxed SIMD proposal
    pub relaxed_simd: bool,
    /// The WebAssembly threads proposal, shared memory and atomics
    /// https://docs.rs/wasmtime/8.0.0/wasmtime/struct.Config.html#method.wasm_threads
    pub threads: bool,
    /// The WebAssembly tail-call proposal
    pub tail_call: bool,
    /// Whether or not floating-point instructions are enabled.
    ///
    /// This is enabled by default can be used to disallow floating-point
    /// operators and types.
    ///
    /// This does not correspond to a WebAssembly proposal but is instead
    /// intended for embeddings which have stricter-than-usual requirements
    /// about execution. Floats in WebAssembly can have different NaN patterns
    /// across hosts which can lead to host-dependent execution which some
    /// runtimes may not desire.
    pub floats: bool,
    /// The WebAssembly multi memory proposal
    pub multi_memory: bool,
    /// The WebAssembly exception handling proposal
    pub exceptions: bool,
    /// The WebAssembly memory64 proposal
    pub memory64: bool,
    /// The WebAssembly extended_const proposal
    pub extended_const: bool,
    /// The WebAssembly component model proposal
    pub component_model: bool,
    /// The WebAssembly memory control proposal
    pub memory_control: bool,
    /// The WebAssembly System Interface proposal
    pub wasi_features: Option<WasmWasiFeatures>,
    /// The WebAssembly garbage collection (GC) proposal
    pub garbage_collection: bool,
    // TODO:
    //   final bool moduleLinking;
}

/// https://docs.wasmtime.dev/stability-wasi-proposals-support.html
pub struct WasmWasiFeatures {
    // TODO: pub snapshot_preview1: bool,
    pub io: bool,
    pub filesystem: bool,
    pub clocks: bool,
    pub random: bool,
    pub poll: bool,
    /// wasi-nn
    pub machine_learning: bool,
    /// wasi-crypto
    pub crypto: bool,
    /// WASM threads with ability to spawn
    /// https://github.com/WebAssembly/wasi-threads
    pub threads: bool,
}

impl WasmWasiFeatures {
    /// Returns the default set of Wasi features.
    pub fn default() -> WasmWasiFeatures {
        WasmWasiFeatures {
            io: true,
            filesystem: true,
            clocks: true,
            random: true,
            poll: true,
            // TODO: implement through separate libraries
            machine_learning: false,
            crypto: false,
            // Unsupported
            threads: false,
        }
    }

    pub fn supported() -> WasmWasiFeatures {
        WasmWasiFeatures::default()
    }
}

impl WasmFeatures {
    /// Returns the default set of Wasm features.
    pub fn default() -> WasmFeatures {
        #[cfg(feature = "wasmtime")]
        {
            return WasmFeatures {
                multi_value: true,
                bulk_memory: true,
                reference_types: true,
                mutable_global: true,
                saturating_float_to_int: true,
                sign_extension: true,
                extended_const: true,
                floats: true,
                simd: true,
                relaxed_simd: false,
                threads: false,      // Default false
                multi_memory: false, // Default false
                memory64: false,     // Default false
                // Unsupported
                component_model: false, // Feature
                garbage_collection: false,
                tail_call: false,
                exceptions: false,
                memory_control: false,
                wasi_features: Some(WasmWasiFeatures::default()),
            };
        }
        // TODO: use features crate
        #[allow(unreachable_code)]
        WasmFeatures {
            multi_value: true,
            bulk_memory: true,
            reference_types: true,
            mutable_global: true,
            saturating_float_to_int: true,
            sign_extension: true,
            tail_call: false,      // Default false
            extended_const: false, // Default false
            floats: true,
            // Unsupported
            component_model: false,
            garbage_collection: false,
            simd: false,
            relaxed_simd: false,
            threads: false,
            multi_memory: false,
            exceptions: false,
            memory64: false,
            memory_control: false,
            wasi_features: Some(WasmWasiFeatures::default()),
        }
    }

    pub fn supported() -> WasmFeatures {
        #[cfg(feature = "wasmtime")]
        {
            return WasmFeatures {
                multi_value: true,
                bulk_memory: true,
                reference_types: true,
                mutable_global: true,
                saturating_float_to_int: true,
                sign_extension: true,
                extended_const: true,
                floats: true,
                simd: true,
                relaxed_simd: true,
                threads: true,
                multi_memory: true,
                memory64: true,
                // Unsupported
                component_model: false, // Feature
                garbage_collection: false,
                exceptions: false,
                tail_call: false,
                memory_control: false,
                wasi_features: Some(WasmWasiFeatures::supported()),
            };
        }
        // TODO: use features crate
        #[allow(unreachable_code)]
        WasmFeatures {
            multi_value: true,
            bulk_memory: true,
            reference_types: true,
            mutable_global: true,
            saturating_float_to_int: true,
            sign_extension: true,
            tail_call: true,
            extended_const: true,
            floats: true,
            // Unsupported
            component_model: false,
            garbage_collection: false,
            simd: false,
            relaxed_simd: false,
            threads: false,
            multi_memory: false,
            exceptions: false,
            memory64: false,
            memory_control: false,
            wasi_features: Some(WasmWasiFeatures::supported()),
        }
    }
}

impl ModuleConfig {
    /// Returns the [`WasmFeatures`] represented by the [`ModuleConfig`].
    // TODO: use features crate
    #[allow(unreachable_code)]
    pub fn wasm_features(&self) -> WasmFeatures {
        #[cfg(feature = "wasmtime")]
        {
            let w = self.wasmtime.as_ref();
            let def = WasmFeatures::default();
            return WasmFeatures {
                multi_value: self.multi_value.unwrap_or(def.multi_value),
                bulk_memory: self.bulk_memory.unwrap_or(def.bulk_memory),
                reference_types: self.reference_types.unwrap_or(def.reference_types),
                // True by default, can't be configured
                mutable_global: true,
                saturating_float_to_int: true,
                sign_extension: true,
                extended_const: true,
                floats: true,

                simd: w.and_then(|w| w.wasm_simd).unwrap_or(def.simd),
                threads: w.and_then(|w| w.wasm_threads).unwrap_or(def.threads),
                multi_memory: w
                    .and_then(|w| w.wasm_multi_memory)
                    .unwrap_or(def.multi_memory),
                memory64: w.and_then(|w| w.wasm_memory64).unwrap_or(def.memory64),
                relaxed_simd: w
                    .and_then(|w| w.wasm_relaxed_simd)
                    .unwrap_or(def.relaxed_simd),
                // Unsupported
                component_model: false, // Feature
                garbage_collection: false,
                tail_call: false,
                exceptions: false,
                memory_control: false,
                wasi_features: Some(WasmWasiFeatures::default()),
            };
        }
        let w = self.wasmi.as_ref();
        let def = WasmFeatures::default();
        WasmFeatures {
            multi_value: self.multi_value.unwrap_or(def.multi_value),
            bulk_memory: self.bulk_memory.unwrap_or(def.bulk_memory),
            reference_types: self.reference_types.unwrap_or(def.reference_types),
            mutable_global: w
                .and_then(|w| w.mutable_global)
                .unwrap_or(def.mutable_global),
            saturating_float_to_int: w
                .and_then(|w| w.saturating_float_to_int)
                .unwrap_or(def.saturating_float_to_int),
            sign_extension: w
                .and_then(|w| w.sign_extension)
                .unwrap_or(def.sign_extension),
            tail_call: w.and_then(|w| w.tail_call).unwrap_or(def.tail_call),
            extended_const: w
                .and_then(|w| w.extended_const)
                .unwrap_or(def.extended_const),
            floats: w.and_then(|w| w.floats).unwrap_or(def.floats),
            // Unsupported
            garbage_collection: false,
            component_model: false,
            simd: false,
            relaxed_simd: false,
            threads: false,
            multi_memory: false,
            exceptions: false,
            memory64: false,
            memory_control: false,
            wasi_features: Some(WasmWasiFeatures::default()),
        }
    }
}
