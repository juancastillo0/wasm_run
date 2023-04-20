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

    pub wasmi: Option<ModuleConfigWasmi>,
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

        Ok(Self::new(
            value.initial_value_stack_height,
            value.maximum_value_stack_height,
            value.maximum_recursion_depth,
        )
        .map_err(to_anyhow)?)
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
}

// impl ModuleConfig {
//     /// Returns the [`WasmFeatures`] represented by the [`Config`].
//     pub fn wasm_features(&self) -> WasmFeatures {
//         WasmFeatures {
//             multi_value: self.multi_value,
//             mutable_global: self.mutable_global,
//             saturating_float_to_int: self.saturating_float_to_int,
//             sign_extension: self.sign_extension,
//             bulk_memory: self.bulk_memory,
//             reference_types: self.reference_types,
//             tail_call: self.tail_call,
//             extended_const: self.extended_const,
//             floats: self.floats,
//             component_model: false,
//             simd: false,
//             relaxed_simd: false,
//             threads: false,
//             multi_memory: false,
//             exceptions: false,
//             memory64: false,
//             memory_control: false,
//         }
//     }
// }
