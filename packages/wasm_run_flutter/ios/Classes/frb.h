#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct DartCObject *WireSyncReturn;

typedef struct wire_ArcStdSyncMutexModule {
  const void *ptr;
} wire_ArcStdSyncMutexModule;

typedef struct wire_CompiledModule {
  struct wire_ArcStdSyncMutexModule field0;
} wire_CompiledModule;

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_StringList {
  struct wire_uint_8_list **ptr;
  int32_t len;
} wire_StringList;

typedef struct wire_EnvVariable {
  struct wire_uint_8_list *name;
  struct wire_uint_8_list *value;
} wire_EnvVariable;

typedef struct wire_list_env_variable {
  struct wire_EnvVariable *ptr;
  int32_t len;
} wire_list_env_variable;

typedef struct wire_PreopenedDir {
  struct wire_uint_8_list *wasm_guest_path;
  struct wire_uint_8_list *host_path;
} wire_PreopenedDir;

typedef struct wire_list_preopened_dir {
  struct wire_PreopenedDir *ptr;
  int32_t len;
} wire_list_preopened_dir;

typedef struct wire_WasiConfigNative {
  bool capture_stdout;
  bool capture_stderr;
  bool inherit_stdin;
  bool inherit_env;
  bool inherit_args;
  struct wire_StringList *args;
  struct wire_list_env_variable *env;
  struct wire_StringList *preopened_files;
  struct wire_list_preopened_dir *preopened_dirs;
} wire_WasiConfigNative;

typedef struct wire_WasiStackLimits {
  uintptr_t initial_value_stack_height;
  uintptr_t maximum_value_stack_height;
  uintptr_t maximum_recursion_depth;
} wire_WasiStackLimits;

typedef struct wire_ModuleConfigWasmi {
  struct wire_WasiStackLimits *stack_limits;
  uintptr_t *cached_stacks;
  bool *mutable_global;
  bool *sign_extension;
  bool *saturating_float_to_int;
  bool *tail_call;
  bool *extended_const;
  bool *floats;
} wire_ModuleConfigWasmi;

typedef struct wire_ModuleConfigWasmtime {
  bool *debug_info;
  bool *wasm_backtrace;
  bool *native_unwind_info;
  uintptr_t *max_wasm_stack;
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
} wire_ModuleConfigWasmtime;

typedef struct wire_ModuleConfig {
  bool *multi_value;
  bool *bulk_memory;
  bool *reference_types;
  bool *consume_fuel;
  struct wire_ModuleConfigWasmi *wasmi;
  struct wire_ModuleConfigWasmtime *wasmtime;
} wire_ModuleConfig;

typedef struct wire_WasmRunInstanceId {
  uint32_t field0;
} wire_WasmRunInstanceId;

typedef struct wire_WasmRunModuleId {
  uint32_t field0;
} wire_WasmRunModuleId;

typedef struct wire_WFunc {
  const void *ptr;
} wire_WFunc;

typedef struct wire_ExternalValue_Func {
  struct wire_WFunc field0;
} wire_ExternalValue_Func;

typedef struct wire_Global {
  const void *ptr;
} wire_Global;

typedef struct wire_ExternalValue_Global {
  struct wire_Global field0;
} wire_ExternalValue_Global;

typedef struct wire_Table {
  const void *ptr;
} wire_Table;

typedef struct wire_ExternalValue_Table {
  struct wire_Table field0;
} wire_ExternalValue_Table;

typedef struct wire_Memory {
  const void *ptr;
} wire_Memory;

typedef struct wire_ExternalValue_Memory {
  struct wire_Memory field0;
} wire_ExternalValue_Memory;

typedef struct wire_ArcRwLockSharedMemory {
  const void *ptr;
} wire_ArcRwLockSharedMemory;

typedef struct wire_WasmRunSharedMemory {
  struct wire_ArcRwLockSharedMemory field0;
} wire_WasmRunSharedMemory;

typedef struct wire_ExternalValue_SharedMemory {
  struct wire_WasmRunSharedMemory *field0;
} wire_ExternalValue_SharedMemory;

typedef union ExternalValueKind {
  struct wire_ExternalValue_Func *Func;
  struct wire_ExternalValue_Global *Global;
  struct wire_ExternalValue_Table *Table;
  struct wire_ExternalValue_Memory *Memory;
  struct wire_ExternalValue_SharedMemory *SharedMemory;
} ExternalValueKind;

typedef struct wire_ExternalValue {
  int32_t tag;
  union ExternalValueKind *kind;
} wire_ExternalValue;

typedef struct wire_ModuleImport {
  struct wire_uint_8_list *module;
  struct wire_uint_8_list *name;
  struct wire_ExternalValue value;
} wire_ModuleImport;

typedef struct wire_list_module_import {
  struct wire_ModuleImport *ptr;
  int32_t len;
} wire_list_module_import;

typedef struct wire_WasmVal_i32 {
  int32_t field0;
} wire_WasmVal_i32;

typedef struct wire_WasmVal_i64 {
  int64_t field0;
} wire_WasmVal_i64;

typedef struct wire_WasmVal_f32 {
  float field0;
} wire_WasmVal_f32;

typedef struct wire_WasmVal_f64 {
  double field0;
} wire_WasmVal_f64;

typedef struct wire_WasmVal_v128 {
  struct wire_uint_8_list *field0;
} wire_WasmVal_v128;

typedef struct wire_WasmVal_funcRef {
  struct wire_WFunc *field0;
} wire_WasmVal_funcRef;

typedef struct wire_WasmVal_externRef {
  uint32_t *field0;
} wire_WasmVal_externRef;

typedef union WasmValKind {
  struct wire_WasmVal_i32 *i32;
  struct wire_WasmVal_i64 *i64;
  struct wire_WasmVal_f32 *f32;
  struct wire_WasmVal_f64 *f64;
  struct wire_WasmVal_v128 *v128;
  struct wire_WasmVal_funcRef *funcRef;
  struct wire_WasmVal_externRef *externRef;
} WasmValKind;

typedef struct wire_WasmVal {
  int32_t tag;
  union WasmValKind *kind;
} wire_WasmVal;

typedef struct wire_list_wasm_val {
  struct wire_WasmVal *ptr;
  int32_t len;
} wire_list_wasm_val;

typedef struct wire_list_value_ty {
  int32_t *ptr;
  int32_t len;
} wire_list_value_ty;

typedef struct wire_MemoryTy {
  bool shared;
  uint32_t minimum;
  uint32_t *maximum;
} wire_MemoryTy;

typedef struct wire_TableArgs {
  uint32_t minimum;
  uint32_t *maximum;
} wire_TableArgs;

typedef struct wire_Atomics {
  uintptr_t field0;
} wire_Atomics;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

WireSyncReturn wire_module_builder(struct wire_CompiledModule *module,
                                   uintptr_t *num_threads,
                                   struct wire_WasiConfigNative *wasi_config);

void wire_parse_wat_format(int64_t port_, struct wire_uint_8_list *wat);

void wire_compile_wasm(int64_t port_,
                       struct wire_uint_8_list *module_wasm,
                       struct wire_ModuleConfig *config);

WireSyncReturn wire_compile_wasm_sync(struct wire_uint_8_list *module_wasm,
                                      struct wire_ModuleConfig *config);

WireSyncReturn wire_wasm_features_for_config(struct wire_ModuleConfig *config);

WireSyncReturn wire_wasm_runtime_features(void);

WireSyncReturn wire_exports__method__WasmRunInstanceId(struct wire_WasmRunInstanceId *that);

WireSyncReturn wire_instantiate_sync__method__WasmRunModuleId(struct wire_WasmRunModuleId *that);

void wire_instantiate__method__WasmRunModuleId(int64_t port_, struct wire_WasmRunModuleId *that);

WireSyncReturn wire_link_imports__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                          struct wire_list_module_import *imports);

void wire_stdio_stream__method__WasmRunModuleId(int64_t port_,
                                                struct wire_WasmRunModuleId *that,
                                                int32_t kind);

void wire_dispose__method__WasmRunModuleId(int64_t port_, struct wire_WasmRunModuleId *that);

WireSyncReturn wire_call_function_handle_sync__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                                       struct wire_WFunc func,
                                                                       struct wire_list_wasm_val *args);

void wire_call_function_handle__method__WasmRunModuleId(int64_t port_,
                                                        struct wire_WasmRunModuleId *that,
                                                        struct wire_WFunc func,
                                                        struct wire_list_wasm_val *args);

void wire_call_function_handle_parallel__method__WasmRunModuleId(int64_t port_,
                                                                 struct wire_WasmRunModuleId *that,
                                                                 struct wire_uint_8_list *func_name,
                                                                 struct wire_list_wasm_val *args,
                                                                 uintptr_t num_tasks);

WireSyncReturn wire_worker_execution__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                              uintptr_t worker_index,
                                                              struct wire_list_wasm_val *results);

WireSyncReturn wire_get_function_type__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                               struct wire_WFunc func);

WireSyncReturn wire_create_function__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                             uintptr_t function_pointer,
                                                             uint32_t function_id,
                                                             struct wire_list_value_ty *param_types,
                                                             struct wire_list_value_ty *result_types);

WireSyncReturn wire_create_memory__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                           struct wire_MemoryTy *memory_type);

WireSyncReturn wire_create_global__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                           struct wire_WasmVal *value,
                                                           bool mutable_);

WireSyncReturn wire_create_table__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                          struct wire_WasmVal *value,
                                                          struct wire_TableArgs *table_type);

WireSyncReturn wire_get_global_type__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                             struct wire_Global global);

WireSyncReturn wire_get_global_value__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                              struct wire_Global global);

WireSyncReturn wire_set_global_value__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                              struct wire_Global global,
                                                              struct wire_WasmVal *value);

WireSyncReturn wire_get_memory_type__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                             struct wire_Memory memory);

WireSyncReturn wire_get_memory_data__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                             struct wire_Memory memory);

WireSyncReturn wire_get_memory_data_pointer__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                                     struct wire_Memory memory);

WireSyncReturn wire_get_memory_data_pointer_and_length__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                                                struct wire_Memory memory);

WireSyncReturn wire_read_memory__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                         struct wire_Memory memory,
                                                         uintptr_t offset,
                                                         uintptr_t bytes);

WireSyncReturn wire_get_memory_pages__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                              struct wire_Memory memory);

WireSyncReturn wire_write_memory__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                          struct wire_Memory memory,
                                                          uintptr_t offset,
                                                          struct wire_uint_8_list *buffer);

WireSyncReturn wire_grow_memory__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                         struct wire_Memory memory,
                                                         uint32_t pages);

WireSyncReturn wire_get_table_size__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                            struct wire_Table table);

WireSyncReturn wire_get_table_type__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                            struct wire_Table table);

WireSyncReturn wire_grow_table__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                        struct wire_Table table,
                                                        uint32_t delta,
                                                        struct wire_WasmVal *value);

WireSyncReturn wire_get_table__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                       struct wire_Table table,
                                                       uint32_t index);

WireSyncReturn wire_set_table__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                       struct wire_Table table,
                                                       uint32_t index,
                                                       struct wire_WasmVal *value);

WireSyncReturn wire_fill_table__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                        struct wire_Table table,
                                                        uint32_t index,
                                                        struct wire_WasmVal *value,
                                                        uint32_t len);

WireSyncReturn wire_add_fuel__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                      uint64_t delta);

WireSyncReturn wire_fuel_consumed__method__WasmRunModuleId(struct wire_WasmRunModuleId *that);

WireSyncReturn wire_consume_fuel__method__WasmRunModuleId(struct wire_WasmRunModuleId *that,
                                                          uint64_t delta);

WireSyncReturn wire_create_shared_memory__method__CompiledModule(struct wire_CompiledModule *that,
                                                                 struct wire_MemoryTy *memory_type);

WireSyncReturn wire_get_module_imports__method__CompiledModule(struct wire_CompiledModule *that);

WireSyncReturn wire_get_module_exports__method__CompiledModule(struct wire_CompiledModule *that);

WireSyncReturn wire_ty__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that);

WireSyncReturn wire_size__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that);

WireSyncReturn wire_data_size__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that);

WireSyncReturn wire_data_pointer__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that);

WireSyncReturn wire_grow__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that,
                                                      uint64_t delta);

void wire_atomics__method__WasmRunSharedMemory(int64_t port_,
                                               struct wire_WasmRunSharedMemory *that);

WireSyncReturn wire_atomic_notify__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that,
                                                               uint64_t addr,
                                                               uint32_t count);

WireSyncReturn wire_atomic_wait32__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that,
                                                               uint64_t addr,
                                                               uint32_t expected);

WireSyncReturn wire_atomic_wait64__method__WasmRunSharedMemory(struct wire_WasmRunSharedMemory *that,
                                                               uint64_t addr,
                                                               uint64_t expected);

void wire_add__method__Atomics(int64_t port_,
                               struct wire_Atomics *that,
                               uintptr_t offset,
                               int32_t kind,
                               int64_t val,
                               int32_t order);

void wire_load__method__Atomics(int64_t port_,
                                struct wire_Atomics *that,
                                uintptr_t offset,
                                int32_t kind,
                                int32_t order);

void wire_store__method__Atomics(int64_t port_,
                                 struct wire_Atomics *that,
                                 uintptr_t offset,
                                 int32_t kind,
                                 int64_t val,
                                 int32_t order);

void wire_swap__method__Atomics(int64_t port_,
                                struct wire_Atomics *that,
                                uintptr_t offset,
                                int32_t kind,
                                int64_t val,
                                int32_t order);

void wire_compare_exchange__method__Atomics(int64_t port_,
                                            struct wire_Atomics *that,
                                            uintptr_t offset,
                                            int32_t kind,
                                            int64_t current,
                                            int64_t new_value,
                                            int32_t success,
                                            int32_t failure);

void wire_sub__method__Atomics(int64_t port_,
                               struct wire_Atomics *that,
                               uintptr_t offset,
                               int32_t kind,
                               int64_t val,
                               int32_t order);

void wire_and__method__Atomics(int64_t port_,
                               struct wire_Atomics *that,
                               uintptr_t offset,
                               int32_t kind,
                               int64_t val,
                               int32_t order);

void wire_or__method__Atomics(int64_t port_,
                              struct wire_Atomics *that,
                              uintptr_t offset,
                              int32_t kind,
                              int64_t val,
                              int32_t order);

void wire_xor__method__Atomics(int64_t port_,
                               struct wire_Atomics *that,
                               uintptr_t offset,
                               int32_t kind,
                               int64_t val,
                               int32_t order);

struct wire_ArcRwLockSharedMemory new_ArcRwLockSharedMemory(void);

struct wire_ArcStdSyncMutexModule new_ArcStdSyncMutexModule(void);

struct wire_Global new_Global(void);

struct wire_Memory new_Memory(void);

struct wire_StringList *new_StringList_0(int32_t len);

struct wire_Table new_Table(void);

struct wire_WFunc new_WFunc(void);

struct wire_WFunc *new_box_autoadd_WFunc_0(void);

struct wire_Atomics *new_box_autoadd_atomics_0(void);

bool *new_box_autoadd_bool_0(bool value);

struct wire_CompiledModule *new_box_autoadd_compiled_module_0(void);

struct wire_MemoryTy *new_box_autoadd_memory_ty_0(void);

struct wire_ModuleConfig *new_box_autoadd_module_config_0(void);

struct wire_ModuleConfigWasmi *new_box_autoadd_module_config_wasmi_0(void);

struct wire_ModuleConfigWasmtime *new_box_autoadd_module_config_wasmtime_0(void);

struct wire_TableArgs *new_box_autoadd_table_args_0(void);

uint32_t *new_box_autoadd_u32_0(uint32_t value);

uint64_t *new_box_autoadd_u64_0(uint64_t value);

uintptr_t *new_box_autoadd_usize_0(uintptr_t value);

struct wire_WasiConfigNative *new_box_autoadd_wasi_config_native_0(void);

struct wire_WasiStackLimits *new_box_autoadd_wasi_stack_limits_0(void);

struct wire_WasmRunInstanceId *new_box_autoadd_wasm_run_instance_id_0(void);

struct wire_WasmRunModuleId *new_box_autoadd_wasm_run_module_id_0(void);

struct wire_WasmRunSharedMemory *new_box_autoadd_wasm_run_shared_memory_0(void);

struct wire_WasmVal *new_box_autoadd_wasm_val_0(void);

struct wire_list_env_variable *new_list_env_variable_0(int32_t len);

struct wire_list_module_import *new_list_module_import_0(int32_t len);

struct wire_list_preopened_dir *new_list_preopened_dir_0(int32_t len);

struct wire_list_value_ty *new_list_value_ty_0(int32_t len);

struct wire_list_wasm_val *new_list_wasm_val_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void drop_opaque_ArcRwLockSharedMemory(const void *ptr);

const void *share_opaque_ArcRwLockSharedMemory(const void *ptr);

void drop_opaque_ArcStdSyncMutexModule(const void *ptr);

const void *share_opaque_ArcStdSyncMutexModule(const void *ptr);

void drop_opaque_Global(const void *ptr);

const void *share_opaque_Global(const void *ptr);

void drop_opaque_Memory(const void *ptr);

const void *share_opaque_Memory(const void *ptr);

void drop_opaque_Table(const void *ptr);

const void *share_opaque_Table(const void *ptr);

void drop_opaque_WFunc(const void *ptr);

const void *share_opaque_WFunc(const void *ptr);

union ExternalValueKind *inflate_ExternalValue_Func(void);

union ExternalValueKind *inflate_ExternalValue_Global(void);

union ExternalValueKind *inflate_ExternalValue_Table(void);

union ExternalValueKind *inflate_ExternalValue_Memory(void);

union ExternalValueKind *inflate_ExternalValue_SharedMemory(void);

union WasmValKind *inflate_WasmVal_i32(void);

union WasmValKind *inflate_WasmVal_i64(void);

union WasmValKind *inflate_WasmVal_f32(void);

union WasmValKind *inflate_WasmVal_f64(void);

union WasmValKind *inflate_WasmVal_v128(void);

union WasmValKind *inflate_WasmVal_funcRef(void);

union WasmValKind *inflate_WasmVal_externRef(void);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_module_builder);
    dummy_var ^= ((int64_t) (void*) wire_parse_wat_format);
    dummy_var ^= ((int64_t) (void*) wire_compile_wasm);
    dummy_var ^= ((int64_t) (void*) wire_compile_wasm_sync);
    dummy_var ^= ((int64_t) (void*) wire_wasm_features_for_config);
    dummy_var ^= ((int64_t) (void*) wire_wasm_runtime_features);
    dummy_var ^= ((int64_t) (void*) wire_exports__method__WasmRunInstanceId);
    dummy_var ^= ((int64_t) (void*) wire_instantiate_sync__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_instantiate__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_link_imports__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_stdio_stream__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_dispose__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_handle_sync__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_handle__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_handle_parallel__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_worker_execution__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_function_type__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_function__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_memory__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_global__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_table__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_global_type__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_global_value__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_set_global_value__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_type__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_data__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_data_pointer__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_data_pointer_and_length__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_read_memory__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_pages__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_write_memory__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_grow_memory__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_table_size__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_table_type__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_grow_table__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_table__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_set_table__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_fill_table__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_add_fuel__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_fuel_consumed__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_consume_fuel__method__WasmRunModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_shared_memory__method__CompiledModule);
    dummy_var ^= ((int64_t) (void*) wire_get_module_imports__method__CompiledModule);
    dummy_var ^= ((int64_t) (void*) wire_get_module_exports__method__CompiledModule);
    dummy_var ^= ((int64_t) (void*) wire_ty__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_size__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_data_size__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_data_pointer__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_grow__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_atomics__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_atomic_notify__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_atomic_wait32__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_atomic_wait64__method__WasmRunSharedMemory);
    dummy_var ^= ((int64_t) (void*) wire_add__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_load__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_store__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_swap__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_compare_exchange__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_sub__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_and__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_or__method__Atomics);
    dummy_var ^= ((int64_t) (void*) wire_xor__method__Atomics);
    dummy_var ^= ((int64_t) (void*) new_ArcRwLockSharedMemory);
    dummy_var ^= ((int64_t) (void*) new_ArcStdSyncMutexModule);
    dummy_var ^= ((int64_t) (void*) new_Global);
    dummy_var ^= ((int64_t) (void*) new_Memory);
    dummy_var ^= ((int64_t) (void*) new_StringList_0);
    dummy_var ^= ((int64_t) (void*) new_Table);
    dummy_var ^= ((int64_t) (void*) new_WFunc);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_WFunc_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_atomics_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_bool_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_compiled_module_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_memory_ty_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_module_config_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_module_config_wasmi_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_module_config_wasmtime_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_table_args_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u32_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u64_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_usize_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasi_config_native_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasi_stack_limits_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasm_run_instance_id_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasm_run_module_id_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasm_run_shared_memory_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasm_val_0);
    dummy_var ^= ((int64_t) (void*) new_list_env_variable_0);
    dummy_var ^= ((int64_t) (void*) new_list_module_import_0);
    dummy_var ^= ((int64_t) (void*) new_list_preopened_dir_0);
    dummy_var ^= ((int64_t) (void*) new_list_value_ty_0);
    dummy_var ^= ((int64_t) (void*) new_list_wasm_val_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) drop_opaque_ArcRwLockSharedMemory);
    dummy_var ^= ((int64_t) (void*) share_opaque_ArcRwLockSharedMemory);
    dummy_var ^= ((int64_t) (void*) drop_opaque_ArcStdSyncMutexModule);
    dummy_var ^= ((int64_t) (void*) share_opaque_ArcStdSyncMutexModule);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Global);
    dummy_var ^= ((int64_t) (void*) share_opaque_Global);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Memory);
    dummy_var ^= ((int64_t) (void*) share_opaque_Memory);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Table);
    dummy_var ^= ((int64_t) (void*) share_opaque_Table);
    dummy_var ^= ((int64_t) (void*) drop_opaque_WFunc);
    dummy_var ^= ((int64_t) (void*) share_opaque_WFunc);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Func);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Global);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Table);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Memory);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_SharedMemory);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_i32);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_i64);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_f32);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_f64);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_v128);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_funcRef);
    dummy_var ^= ((int64_t) (void*) inflate_WasmVal_externRef);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
