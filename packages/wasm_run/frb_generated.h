#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
// EXTRA BEGIN
typedef struct DartCObject *WireSyncRust2DartDco;
typedef struct WireSyncRust2DartSse {
  uint8_t *ptr;
  int32_t len;
} WireSyncRust2DartSse;

typedef int64_t DartPort;
typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);
void store_dart_post_cobject(DartPostCObjectFnType ptr);
// EXTRA END
typedef struct _Dart_Handle* Dart_Handle;

typedef struct wire_cst_atomics {
  uintptr_t field0;
} wire_cst_atomics;

typedef struct wire_cst_list_prim_u_8_loose {
  uint8_t *ptr;
  int32_t len;
} wire_cst_list_prim_u_8_loose;

typedef struct wire_cst_wasi_stack_limits {
  int64_t initial_value_stack_height;
  int64_t maximum_value_stack_height;
  int64_t maximum_recursion_depth;
} wire_cst_wasi_stack_limits;

typedef struct wire_cst_module_config_wasmi {
  struct wire_cst_wasi_stack_limits *stack_limits;
  int64_t *cached_stacks;
  bool *mutable_global;
  bool *sign_extension;
  bool *saturating_float_to_int;
  bool *tail_call;
  bool *extended_const;
  bool *floats;
} wire_cst_module_config_wasmi;

typedef struct wire_cst_module_config_wasmtime {
  bool *debug_info;
  bool *wasm_backtrace;
  bool *native_unwind_info;
  int64_t *max_wasm_stack;
  bool *wasm_threads;
  bool *wasm_simd;
  bool *wasm_relaxed_simd;
  bool *relaxed_simd_deterministic;
  bool *wasm_multi_memory;
  bool *wasm_memory64;
  uint64_t *static_memory_maximum_size;
  bool *static_memory_forced;
  uint64_t *static_memory_guard_size;
  bool *parallel_compilation;
  bool *generate_address_map;
} wire_cst_module_config_wasmtime;

typedef struct wire_cst_module_config {
  bool *multi_value;
  bool *bulk_memory;
  bool *reference_types;
  bool *consume_fuel;
  struct wire_cst_module_config_wasmi *wasmi;
  struct wire_cst_module_config_wasmtime *wasmtime;
} wire_cst_module_config;

typedef struct wire_cst_compiled_module {
  uintptr_t field0;
} wire_cst_compiled_module;

typedef struct wire_cst_memory_ty {
  bool shared;
  uint32_t minimum;
  uint32_t *maximum;
} wire_cst_memory_ty;

typedef struct wire_cst_list_prim_u_8_strict {
  uint8_t *ptr;
  int32_t len;
} wire_cst_list_prim_u_8_strict;

typedef struct wire_cst_list_String {
  struct wire_cst_list_prim_u_8_strict **ptr;
  int32_t len;
} wire_cst_list_String;

typedef struct wire_cst_env_variable {
  struct wire_cst_list_prim_u_8_strict *name;
  struct wire_cst_list_prim_u_8_strict *value;
} wire_cst_env_variable;

typedef struct wire_cst_list_env_variable {
  struct wire_cst_env_variable *ptr;
  int32_t len;
} wire_cst_list_env_variable;

typedef struct wire_cst_preopened_dir {
  struct wire_cst_list_prim_u_8_strict *wasm_guest_path;
  struct wire_cst_list_prim_u_8_strict *host_path;
} wire_cst_preopened_dir;

typedef struct wire_cst_list_preopened_dir {
  struct wire_cst_preopened_dir *ptr;
  int32_t len;
} wire_cst_list_preopened_dir;

typedef struct wire_cst_wasi_config_native {
  bool capture_stdout;
  bool capture_stderr;
  bool inherit_stdin;
  bool inherit_env;
  bool inherit_args;
  struct wire_cst_list_String *args;
  struct wire_cst_list_env_variable *env;
  struct wire_cst_list_String *preopened_files;
  struct wire_cst_list_preopened_dir *preopened_dirs;
} wire_cst_wasi_config_native;

typedef struct wire_cst_wasm_run_instance_id {
  uint32_t field0;
} wire_cst_wasm_run_instance_id;

typedef struct wire_cst_wasm_run_module_id {
  uint32_t field0;
  uintptr_t field1;
} wire_cst_wasm_run_module_id;

typedef struct wire_cst_WasmVal_i32 {
  int32_t field0;
} wire_cst_WasmVal_i32;

typedef struct wire_cst_WasmVal_i64 {
  int64_t field0;
} wire_cst_WasmVal_i64;

typedef struct wire_cst_WasmVal_f32 {
  float field0;
} wire_cst_WasmVal_f32;

typedef struct wire_cst_WasmVal_f64 {
  double field0;
} wire_cst_WasmVal_f64;

typedef struct wire_cst_WasmVal_v128 {
  struct wire_cst_list_prim_u_8_strict *field0;
} wire_cst_WasmVal_v128;

typedef struct wire_cst_WasmVal_funcRef {
  uintptr_t *field0;
} wire_cst_WasmVal_funcRef;

typedef struct wire_cst_WasmVal_externRef {
  uint32_t *field0;
} wire_cst_WasmVal_externRef;

typedef union WasmValKind {
  struct wire_cst_WasmVal_i32 i32;
  struct wire_cst_WasmVal_i64 i64;
  struct wire_cst_WasmVal_f32 f32;
  struct wire_cst_WasmVal_f64 f64;
  struct wire_cst_WasmVal_v128 v128;
  struct wire_cst_WasmVal_funcRef funcRef;
  struct wire_cst_WasmVal_externRef externRef;
} WasmValKind;

typedef struct wire_cst_wasm_val {
  int32_t tag;
  union WasmValKind kind;
} wire_cst_wasm_val;

typedef struct wire_cst_list_wasm_val {
  struct wire_cst_wasm_val *ptr;
  int32_t len;
} wire_cst_list_wasm_val;

typedef struct wire_cst_list_value_ty {
  int32_t *ptr;
  int32_t len;
} wire_cst_list_value_ty;

typedef struct wire_cst_table_args {
  uint32_t minimum;
  uint32_t *maximum;
} wire_cst_table_args;

typedef struct wire_cst_ExternalValue_Func {
  uintptr_t field0;
} wire_cst_ExternalValue_Func;

typedef struct wire_cst_ExternalValue_Global {
  uintptr_t field0;
} wire_cst_ExternalValue_Global;

typedef struct wire_cst_ExternalValue_Table {
  uintptr_t field0;
} wire_cst_ExternalValue_Table;

typedef struct wire_cst_ExternalValue_Memory {
  uintptr_t field0;
} wire_cst_ExternalValue_Memory;

typedef struct wire_cst_wasm_run_shared_memory {
  uintptr_t field0;
} wire_cst_wasm_run_shared_memory;

typedef struct wire_cst_ExternalValue_SharedMemory {
  struct wire_cst_wasm_run_shared_memory *field0;
} wire_cst_ExternalValue_SharedMemory;

typedef union ExternalValueKind {
  struct wire_cst_ExternalValue_Func Func;
  struct wire_cst_ExternalValue_Global Global;
  struct wire_cst_ExternalValue_Table Table;
  struct wire_cst_ExternalValue_Memory Memory;
  struct wire_cst_ExternalValue_SharedMemory SharedMemory;
} ExternalValueKind;

typedef struct wire_cst_external_value {
  int32_t tag;
  union ExternalValueKind kind;
} wire_cst_external_value;

typedef struct wire_cst_module_import {
  struct wire_cst_list_prim_u_8_strict *module;
  struct wire_cst_list_prim_u_8_strict *name;
  struct wire_cst_external_value value;
} wire_cst_module_import;

typedef struct wire_cst_list_module_import {
  struct wire_cst_module_import *ptr;
  int32_t len;
} wire_cst_list_module_import;

typedef struct wire_cst_func_ty {
  struct wire_cst_list_value_ty *parameters;
  struct wire_cst_list_value_ty *results;
} wire_cst_func_ty;

typedef struct wire_cst_function_call {
  struct wire_cst_list_wasm_val *args;
  uint32_t function_id;
  uintptr_t function_pointer;
  uintptr_t num_results;
  uintptr_t worker_index;
} wire_cst_function_call;

typedef struct wire_cst_global_ty {
  int32_t value;
  bool mutable_;
} wire_cst_global_ty;

typedef struct wire_cst_table_ty {
  int32_t element;
  uint32_t minimum;
  uint32_t *maximum;
} wire_cst_table_ty;

typedef struct wire_cst_wasm_wasi_features {
  bool io;
  bool filesystem;
  bool clocks;
  bool random;
  bool poll;
  bool machine_learning;
  bool crypto;
  bool threads;
} wire_cst_wasm_wasi_features;

typedef struct wire_cst_ExternalType_Func {
  struct wire_cst_func_ty *field0;
} wire_cst_ExternalType_Func;

typedef struct wire_cst_ExternalType_Global {
  struct wire_cst_global_ty *field0;
} wire_cst_ExternalType_Global;

typedef struct wire_cst_ExternalType_Table {
  struct wire_cst_table_ty *field0;
} wire_cst_ExternalType_Table;

typedef struct wire_cst_ExternalType_Memory {
  struct wire_cst_memory_ty *field0;
} wire_cst_ExternalType_Memory;

typedef union ExternalTypeKind {
  struct wire_cst_ExternalType_Func Func;
  struct wire_cst_ExternalType_Global Global;
  struct wire_cst_ExternalType_Table Table;
  struct wire_cst_ExternalType_Memory Memory;
} ExternalTypeKind;

typedef struct wire_cst_external_type {
  int32_t tag;
  union ExternalTypeKind kind;
} wire_cst_external_type;

typedef struct wire_cst_module_export_desc {
  struct wire_cst_list_prim_u_8_strict *name;
  struct wire_cst_external_type ty;
} wire_cst_module_export_desc;

typedef struct wire_cst_list_module_export_desc {
  struct wire_cst_module_export_desc *ptr;
  int32_t len;
} wire_cst_list_module_export_desc;

typedef struct wire_cst_module_export_value {
  struct wire_cst_module_export_desc desc;
  struct wire_cst_external_value value;
} wire_cst_module_export_value;

typedef struct wire_cst_list_module_export_value {
  struct wire_cst_module_export_value *ptr;
  int32_t len;
} wire_cst_list_module_export_value;

typedef struct wire_cst_module_import_desc {
  struct wire_cst_list_prim_u_8_strict *module;
  struct wire_cst_list_prim_u_8_strict *name;
  struct wire_cst_external_type ty;
} wire_cst_module_import_desc;

typedef struct wire_cst_list_module_import_desc {
  struct wire_cst_module_import_desc *ptr;
  int32_t len;
} wire_cst_list_module_import_desc;

typedef struct wire_cst_compare_exchange_result {
  bool success;
  int64_t value;
} wire_cst_compare_exchange_result;

typedef struct wire_cst_ParallelExec_Ok {
  struct wire_cst_list_wasm_val *field0;
} wire_cst_ParallelExec_Ok;

typedef struct wire_cst_ParallelExec_Err {
  struct wire_cst_list_prim_u_8_strict *field0;
} wire_cst_ParallelExec_Err;

typedef struct wire_cst_ParallelExec_Call {
  struct wire_cst_function_call *field0;
} wire_cst_ParallelExec_Call;

typedef union ParallelExecKind {
  struct wire_cst_ParallelExec_Ok Ok;
  struct wire_cst_ParallelExec_Err Err;
  struct wire_cst_ParallelExec_Call Call;
} ParallelExecKind;

typedef struct wire_cst_parallel_exec {
  int32_t tag;
  union ParallelExecKind kind;
} wire_cst_parallel_exec;

typedef struct wire_cst_pointer_and_length {
  int64_t pointer;
  int64_t length;
} wire_cst_pointer_and_length;

typedef struct wire_cst_wasm_features {
  bool mutable_global;
  bool saturating_float_to_int;
  bool sign_extension;
  bool reference_types;
  bool multi_value;
  bool bulk_memory;
  bool simd;
  bool relaxed_simd;
  bool threads;
  bool tail_call;
  bool floats;
  bool multi_memory;
  bool exceptions;
  bool memory64;
  bool extended_const;
  bool component_model;
  bool memory_control;
  bool garbage_collection;
  bool type_reflection;
  struct wire_cst_wasm_wasi_features *wasi_features;
} wire_cst_wasm_features;

typedef struct wire_cst_wasm_runtime_features {
  struct wire_cst_list_prim_u_8_strict *name;
  struct wire_cst_list_prim_u_8_strict *version;
  bool is_browser;
  struct wire_cst_wasm_features supported_features;
  struct wire_cst_wasm_features default_features;
} wire_cst_wasm_runtime_features;

void frbgen_wasm_run_wire__crate__atomics__atomics_add(int64_t port_,
                                                       struct wire_cst_atomics *that,
                                                       int64_t offset,
                                                       int32_t kind,
                                                       int64_t val,
                                                       int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_and(int64_t port_,
                                                       struct wire_cst_atomics *that,
                                                       int64_t offset,
                                                       int32_t kind,
                                                       int64_t val,
                                                       int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_compare_exchange(int64_t port_,
                                                                    struct wire_cst_atomics *that,
                                                                    int64_t offset,
                                                                    int32_t kind,
                                                                    int64_t current,
                                                                    int64_t new_value,
                                                                    int32_t success,
                                                                    int32_t failure);

void frbgen_wasm_run_wire__crate__atomics__atomics_load(int64_t port_,
                                                        struct wire_cst_atomics *that,
                                                        int64_t offset,
                                                        int32_t kind,
                                                        int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_or(int64_t port_,
                                                      struct wire_cst_atomics *that,
                                                      int64_t offset,
                                                      int32_t kind,
                                                      int64_t val,
                                                      int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_store(int64_t port_,
                                                         struct wire_cst_atomics *that,
                                                         int64_t offset,
                                                         int32_t kind,
                                                         int64_t val,
                                                         int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_sub(int64_t port_,
                                                       struct wire_cst_atomics *that,
                                                       int64_t offset,
                                                       int32_t kind,
                                                       int64_t val,
                                                       int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_swap(int64_t port_,
                                                        struct wire_cst_atomics *that,
                                                        int64_t offset,
                                                        int32_t kind,
                                                        int64_t val,
                                                        int32_t order);

void frbgen_wasm_run_wire__crate__atomics__atomics_xor(int64_t port_,
                                                       struct wire_cst_atomics *that,
                                                       int64_t offset,
                                                       int32_t kind,
                                                       int64_t val,
                                                       int32_t order);

void frbgen_wasm_run_wire__crate__api__compile_wasm(int64_t port_,
                                                    struct wire_cst_list_prim_u_8_loose *module_wasm,
                                                    struct wire_cst_module_config *config);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__compile_wasm_sync(struct wire_cst_list_prim_u_8_loose *module_wasm,
                                                                         struct wire_cst_module_config *config);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__compiled_module_create_shared_memory(struct wire_cst_compiled_module *that,
                                                                                            struct wire_cst_memory_ty *memory_type);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__compiled_module_get_module_exports(struct wire_cst_compiled_module *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__compiled_module_get_module_imports(struct wire_cst_compiled_module *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__module_builder(struct wire_cst_compiled_module *module,
                                                                      uint32_t *num_threads,
                                                                      struct wire_cst_wasi_config_native *wasi_config);

void frbgen_wasm_run_wire__crate__api__parse_wat_format(int64_t port_,
                                                        struct wire_cst_list_prim_u_8_strict *wat);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_features_for_config(struct wire_cst_module_config *config);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_instance_id_exports(struct wire_cst_wasm_run_instance_id *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_add_fuel(struct wire_cst_wasm_run_module_id *that,
                                                                                   int64_t delta);

void frbgen_wasm_run_wire__crate__api__wasm_run_module_id_call_function_handle(int64_t port_,
                                                                               struct wire_cst_wasm_run_module_id *that,
                                                                               uintptr_t func,
                                                                               struct wire_cst_list_wasm_val *args);

void frbgen_wasm_run_wire__crate__api__wasm_run_module_id_call_function_handle_parallel(int64_t port_,
                                                                                        struct wire_cst_wasm_run_module_id *that,
                                                                                        struct wire_cst_list_prim_u_8_strict *func_name,
                                                                                        struct wire_cst_list_wasm_val *args,
                                                                                        uint32_t num_tasks,
                                                                                        struct wire_cst_list_prim_u_8_strict *function_stream);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_call_function_handle_sync(struct wire_cst_wasm_run_module_id *that,
                                                                                                    uintptr_t func,
                                                                                                    struct wire_cst_list_wasm_val *args);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_consume_fuel(struct wire_cst_wasm_run_module_id *that,
                                                                                       int64_t delta);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_function(struct wire_cst_wasm_run_module_id *that,
                                                                                          int64_t function_pointer,
                                                                                          uint32_t function_id,
                                                                                          struct wire_cst_list_value_ty *param_types,
                                                                                          struct wire_cst_list_value_ty *result_types);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_global(struct wire_cst_wasm_run_module_id *that,
                                                                                        struct wire_cst_wasm_val *value,
                                                                                        bool mutable_);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_memory(struct wire_cst_wasm_run_module_id *that,
                                                                                        struct wire_cst_memory_ty *memory_type);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_table(struct wire_cst_wasm_run_module_id *that,
                                                                                       struct wire_cst_wasm_val *value,
                                                                                       struct wire_cst_table_args *table_type);

void frbgen_wasm_run_wire__crate__api__wasm_run_module_id_dispose(int64_t port_,
                                                                  struct wire_cst_wasm_run_module_id *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_fill_table(struct wire_cst_wasm_run_module_id *that,
                                                                                     uintptr_t table,
                                                                                     uint32_t index,
                                                                                     struct wire_cst_wasm_val *value,
                                                                                     uint32_t len);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_fuel_consumed(struct wire_cst_wasm_run_module_id *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_function_type(struct wire_cst_wasm_run_module_id *that,
                                                                                            uintptr_t func);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_global_type(struct wire_cst_wasm_run_module_id *that,
                                                                                          uintptr_t global);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_global_value(struct wire_cst_wasm_run_module_id *that,
                                                                                           uintptr_t global);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_data(struct wire_cst_wasm_run_module_id *that,
                                                                                          uintptr_t memory);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_data_pointer(struct wire_cst_wasm_run_module_id *that,
                                                                                                  uintptr_t memory);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_data_pointer_and_length(struct wire_cst_wasm_run_module_id *that,
                                                                                                             uintptr_t memory);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_pages(struct wire_cst_wasm_run_module_id *that,
                                                                                           uintptr_t memory);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_type(struct wire_cst_wasm_run_module_id *that,
                                                                                          uintptr_t memory);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_table(struct wire_cst_wasm_run_module_id *that,
                                                                                    uintptr_t table,
                                                                                    uint32_t index);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_table_size(struct wire_cst_wasm_run_module_id *that,
                                                                                         uintptr_t table);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_table_type(struct wire_cst_wasm_run_module_id *that,
                                                                                         uintptr_t table);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_grow_memory(struct wire_cst_wasm_run_module_id *that,
                                                                                      uintptr_t memory,
                                                                                      uint32_t pages);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_grow_table(struct wire_cst_wasm_run_module_id *that,
                                                                                     uintptr_t table,
                                                                                     uint32_t delta,
                                                                                     struct wire_cst_wasm_val *value);

void frbgen_wasm_run_wire__crate__api__wasm_run_module_id_instantiate(int64_t port_,
                                                                      struct wire_cst_wasm_run_module_id *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_instantiate_sync(struct wire_cst_wasm_run_module_id *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_link_imports(struct wire_cst_wasm_run_module_id *that,
                                                                                       struct wire_cst_list_module_import *imports);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_read_memory(struct wire_cst_wasm_run_module_id *that,
                                                                                      uintptr_t memory,
                                                                                      uintptr_t offset,
                                                                                      uintptr_t bytes);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_set_global_value(struct wire_cst_wasm_run_module_id *that,
                                                                                           uintptr_t global,
                                                                                           struct wire_cst_wasm_val *value);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_set_table(struct wire_cst_wasm_run_module_id *that,
                                                                                    uintptr_t table,
                                                                                    uint32_t index,
                                                                                    struct wire_cst_wasm_val *value);

void frbgen_wasm_run_wire__crate__api__wasm_run_module_id_stdio_stream(int64_t port_,
                                                                       struct wire_cst_wasm_run_module_id *that,
                                                                       struct wire_cst_list_prim_u_8_strict *sink,
                                                                       int32_t kind);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_worker_execution(struct wire_cst_wasm_run_module_id *that,
                                                                                           uint32_t worker_index,
                                                                                           struct wire_cst_list_wasm_val *results);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_module_id_write_memory(struct wire_cst_wasm_run_module_id *that,
                                                                                       uintptr_t memory,
                                                                                       uintptr_t offset,
                                                                                       struct wire_cst_list_prim_u_8_loose *buffer);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomic_notify(struct wire_cst_wasm_run_shared_memory *that,
                                                                                            int64_t addr,
                                                                                            uint32_t count);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomic_wait32(struct wire_cst_wasm_run_shared_memory *that,
                                                                                            int64_t addr,
                                                                                            uint32_t expected);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomic_wait64(struct wire_cst_wasm_run_shared_memory *that,
                                                                                            int64_t addr,
                                                                                            int64_t expected);

void frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomics(int64_t port_,
                                                                      struct wire_cst_wasm_run_shared_memory *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_data_pointer(struct wire_cst_wasm_run_shared_memory *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_data_size(struct wire_cst_wasm_run_shared_memory *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_grow(struct wire_cst_wasm_run_shared_memory *that,
                                                                                   int64_t delta);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_size(struct wire_cst_wasm_run_shared_memory *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_ty(struct wire_cst_wasm_run_shared_memory *that);

WireSyncRust2DartDco frbgen_wasm_run_wire__crate__api__wasm_runtime_features(void);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_ArcRwLockSharedMemory(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_ArcRwLockSharedMemory(const void *ptr);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_ArcstdsyncMutexModule(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_ArcstdsyncMutexModule(const void *ptr);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_CallStack(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_CallStack(const void *ptr);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_Global(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_Global(const void *ptr);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_Memory(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_Memory(const void *ptr);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_Table(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_Table(const void *ptr);

void frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_WFunc(const void *ptr);

void frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_WFunc(const void *ptr);

uintptr_t *frbgen_wasm_run_cst_new_box_autoadd_RustOpaque_WFunc(uintptr_t value);

struct wire_cst_atomics *frbgen_wasm_run_cst_new_box_autoadd_atomics(void);

bool *frbgen_wasm_run_cst_new_box_autoadd_bool(bool value);

struct wire_cst_compiled_module *frbgen_wasm_run_cst_new_box_autoadd_compiled_module(void);

struct wire_cst_func_ty *frbgen_wasm_run_cst_new_box_autoadd_func_ty(void);

struct wire_cst_function_call *frbgen_wasm_run_cst_new_box_autoadd_function_call(void);

struct wire_cst_global_ty *frbgen_wasm_run_cst_new_box_autoadd_global_ty(void);

int64_t *frbgen_wasm_run_cst_new_box_autoadd_i_64(int64_t value);

struct wire_cst_memory_ty *frbgen_wasm_run_cst_new_box_autoadd_memory_ty(void);

struct wire_cst_module_config *frbgen_wasm_run_cst_new_box_autoadd_module_config(void);

struct wire_cst_module_config_wasmi *frbgen_wasm_run_cst_new_box_autoadd_module_config_wasmi(void);

struct wire_cst_module_config_wasmtime *frbgen_wasm_run_cst_new_box_autoadd_module_config_wasmtime(void);

struct wire_cst_table_args *frbgen_wasm_run_cst_new_box_autoadd_table_args(void);

struct wire_cst_table_ty *frbgen_wasm_run_cst_new_box_autoadd_table_ty(void);

uint32_t *frbgen_wasm_run_cst_new_box_autoadd_u_32(uint32_t value);

uint64_t *frbgen_wasm_run_cst_new_box_autoadd_u_64(uint64_t value);

struct wire_cst_wasi_config_native *frbgen_wasm_run_cst_new_box_autoadd_wasi_config_native(void);

struct wire_cst_wasi_stack_limits *frbgen_wasm_run_cst_new_box_autoadd_wasi_stack_limits(void);

struct wire_cst_wasm_run_instance_id *frbgen_wasm_run_cst_new_box_autoadd_wasm_run_instance_id(void);

struct wire_cst_wasm_run_module_id *frbgen_wasm_run_cst_new_box_autoadd_wasm_run_module_id(void);

struct wire_cst_wasm_run_shared_memory *frbgen_wasm_run_cst_new_box_autoadd_wasm_run_shared_memory(void);

struct wire_cst_wasm_val *frbgen_wasm_run_cst_new_box_autoadd_wasm_val(void);

struct wire_cst_wasm_wasi_features *frbgen_wasm_run_cst_new_box_autoadd_wasm_wasi_features(void);

struct wire_cst_list_String *frbgen_wasm_run_cst_new_list_String(int32_t len);

struct wire_cst_list_env_variable *frbgen_wasm_run_cst_new_list_env_variable(int32_t len);

struct wire_cst_list_module_export_desc *frbgen_wasm_run_cst_new_list_module_export_desc(int32_t len);

struct wire_cst_list_module_export_value *frbgen_wasm_run_cst_new_list_module_export_value(int32_t len);

struct wire_cst_list_module_import *frbgen_wasm_run_cst_new_list_module_import(int32_t len);

struct wire_cst_list_module_import_desc *frbgen_wasm_run_cst_new_list_module_import_desc(int32_t len);

struct wire_cst_list_preopened_dir *frbgen_wasm_run_cst_new_list_preopened_dir(int32_t len);

struct wire_cst_list_prim_u_8_loose *frbgen_wasm_run_cst_new_list_prim_u_8_loose(int32_t len);

struct wire_cst_list_prim_u_8_strict *frbgen_wasm_run_cst_new_list_prim_u_8_strict(int32_t len);

struct wire_cst_list_value_ty *frbgen_wasm_run_cst_new_list_value_ty(int32_t len);

struct wire_cst_list_wasm_val *frbgen_wasm_run_cst_new_list_wasm_val(int32_t len);
static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_RustOpaque_WFunc);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_atomics);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_bool);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_compiled_module);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_func_ty);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_function_call);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_global_ty);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_i_64);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_memory_ty);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_module_config);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_module_config_wasmi);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_module_config_wasmtime);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_table_args);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_table_ty);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_u_32);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_u_64);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasi_config_native);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasi_stack_limits);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasm_run_instance_id);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasm_run_module_id);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasm_run_shared_memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasm_val);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_box_autoadd_wasm_wasi_features);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_String);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_env_variable);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_module_export_desc);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_module_export_value);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_module_import);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_module_import_desc);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_preopened_dir);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_prim_u_8_loose);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_prim_u_8_strict);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_value_ty);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_cst_new_list_wasm_val);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_ArcRwLockSharedMemory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_ArcstdsyncMutexModule);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_CallStack);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_Global);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_Memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_Table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_decrement_strong_count_RustOpaque_WFunc);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_ArcRwLockSharedMemory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_ArcstdsyncMutexModule);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_CallStack);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_Global);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_Memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_Table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_rust_arc_increment_strong_count_RustOpaque_WFunc);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__compile_wasm);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__compile_wasm_sync);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__compiled_module_create_shared_memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__compiled_module_get_module_exports);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__compiled_module_get_module_imports);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__module_builder);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__parse_wat_format);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_features_for_config);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_instance_id_exports);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_add_fuel);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_call_function_handle);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_call_function_handle_parallel);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_call_function_handle_sync);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_consume_fuel);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_function);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_global);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_create_table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_dispose);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_fill_table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_fuel_consumed);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_function_type);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_global_type);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_global_value);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_data);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_data_pointer);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_data_pointer_and_length);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_pages);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_memory_type);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_table_size);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_get_table_type);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_grow_memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_grow_table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_instantiate);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_instantiate_sync);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_link_imports);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_read_memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_set_global_value);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_set_table);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_stdio_stream);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_worker_execution);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_module_id_write_memory);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomic_notify);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomic_wait32);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomic_wait64);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_atomics);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_data_pointer);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_data_size);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_grow);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_size);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_run_shared_memory_ty);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__api__wasm_runtime_features);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_add);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_and);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_compare_exchange);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_load);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_or);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_store);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_sub);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_swap);
    dummy_var ^= ((int64_t) (void*) frbgen_wasm_run_wire__crate__atomics__atomics_xor);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}
