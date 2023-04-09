#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct DartCObject *WireSyncReturn;

typedef struct wire_Value2_I32 {
  int32_t field0;
} wire_Value2_I32;

typedef struct wire_Value2_I64 {
  int64_t field0;
} wire_Value2_I64;

typedef struct wire_Value2_F32 {
  float field0;
} wire_Value2_F32;

typedef struct wire_Value2_F64 {
  double field0;
} wire_Value2_F64;

typedef struct wire_Value2_FuncRef {
  uint32_t field0;
} wire_Value2_FuncRef;

typedef struct wire_Value2_ExternRef {
  uint32_t field0;
} wire_Value2_ExternRef;

typedef union Value2Kind {
  struct wire_Value2_I32 *I32;
  struct wire_Value2_I64 *I64;
  struct wire_Value2_F32 *F32;
  struct wire_Value2_F64 *F64;
  struct wire_Value2_FuncRef *FuncRef;
  struct wire_Value2_ExternRef *ExternRef;
} Value2Kind;

typedef struct wire_Value2 {
  int32_t tag;
  union Value2Kind *kind;
} wire_Value2;

typedef struct wire_list_value_2 {
  struct wire_Value2 *ptr;
  int32_t len;
} wire_list_value_2;

typedef struct wire_WasmiInstanceId {
  uint32_t field0;
} wire_WasmiInstanceId;

typedef struct wire_WasmiModuleId {
  uint32_t field0;
} wire_WasmiModuleId;

typedef struct wire_list_value_ty {
  int32_t *ptr;
  int32_t len;
} wire_list_value_ty;

typedef struct wire_WasmMemoryType {
  uint32_t initial_pages;
  uint32_t *maximum_pages;
} wire_WasmMemoryType;

typedef struct wire_TableType2 {
  uint32_t min;
  uint32_t *max;
} wire_TableType2;

typedef struct wire_Global {
  const void *ptr;
} wire_Global;

typedef struct wire_Memory {
  const void *ptr;
} wire_Memory;

typedef struct wire_Table {
  const void *ptr;
} wire_Table;

typedef struct wire_Func {
  const void *ptr;
} wire_Func;

typedef struct wire_ExternalValue_Func {
  struct wire_Func field0;
} wire_ExternalValue_Func;

typedef struct wire_ExternalValue_Global {
  struct wire_Global field0;
} wire_ExternalValue_Global;

typedef struct wire_ExternalValue_Table {
  struct wire_Table field0;
} wire_ExternalValue_Table;

typedef struct wire_ExternalValue_Memory {
  struct wire_Memory field0;
} wire_ExternalValue_Memory;

typedef union ExternalValueKind {
  struct wire_ExternalValue_Func *Func;
  struct wire_ExternalValue_Global *Global;
  struct wire_ExternalValue_Table *Table;
  struct wire_ExternalValue_Memory *Memory;
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

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_parse_wat_format(int64_t port_, struct wire_uint_8_list *wat);

WireSyncReturn wire_run_function(int64_t pointer);

WireSyncReturn wire_run_wasm_func(uintptr_t pointer, struct wire_list_value_2 *params);

WireSyncReturn wire_run_wasm_func_mut(uintptr_t pointer, struct wire_list_value_2 *params);

WireSyncReturn wire_run_wasm_func_void(uintptr_t pointer, struct wire_list_value_2 *params);

WireSyncReturn wire_compile_wasm_sync(struct wire_uint_8_list *module_wasm);

void wire_compile_wasm(int64_t port_, struct wire_uint_8_list *module_wasm);

void wire_call_wasm(int64_t port_);

void wire_add(int64_t port_, int64_t a, int64_t b);

void wire_call_function__method__WasmiInstanceId(int64_t port_,
                                                 struct wire_WasmiInstanceId *that,
                                                 struct wire_uint_8_list *name);

WireSyncReturn wire_call_function_with_args_sync__method__WasmiInstanceId(struct wire_WasmiInstanceId *that,
                                                                          struct wire_uint_8_list *name,
                                                                          struct wire_list_value_2 *args);

void wire_call_function_with_args__method__WasmiInstanceId(int64_t port_,
                                                           struct wire_WasmiInstanceId *that,
                                                           struct wire_uint_8_list *name,
                                                           struct wire_list_value_2 *args);

WireSyncReturn wire_exports__method__WasmiInstanceId(struct wire_WasmiInstanceId *that);

WireSyncReturn wire_instantiate_sync__method__WasmiModuleId(struct wire_WasmiModuleId *that);

void wire_instantiate__method__WasmiModuleId(int64_t port_, struct wire_WasmiModuleId *that);

WireSyncReturn wire_get_module_imports__method__WasmiModuleId(struct wire_WasmiModuleId *that);

WireSyncReturn wire_get_module_exports__method__WasmiModuleId(struct wire_WasmiModuleId *that);

void wire_executions__method__WasmiModuleId(int64_t port_, struct wire_WasmiModuleId *that);

void wire_dispose__method__WasmiModuleId(int64_t port_, struct wire_WasmiModuleId *that);

WireSyncReturn wire_create_function__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                           uintptr_t function_pointer,
                                                           struct wire_list_value_ty *param_types);

WireSyncReturn wire_create_memory__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                         struct wire_WasmMemoryType *memory_type);

WireSyncReturn wire_create_global__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                         struct wire_Value2 *value,
                                                         int32_t mutability);

WireSyncReturn wire_create_table__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                        struct wire_Value2 *value,
                                                        struct wire_TableType2 *table_type);

WireSyncReturn wire_get_global_type__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                           struct wire_Global global);

WireSyncReturn wire_get_global_value__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                            struct wire_Global global);

WireSyncReturn wire_set_global_value__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                            struct wire_Global global,
                                                            struct wire_Value2 *value);

WireSyncReturn wire_get_memory_type__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                           struct wire_Memory memory);

WireSyncReturn wire_get_memory_data__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                           struct wire_Memory memory);

WireSyncReturn wire_read_memory__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                       struct wire_Memory memory,
                                                       uintptr_t offset,
                                                       struct wire_uint_8_list *buffer);

WireSyncReturn wire_get_memory_pages__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                            struct wire_Memory memory);

WireSyncReturn wire_write_memory__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                        struct wire_Memory memory,
                                                        uintptr_t offset,
                                                        struct wire_uint_8_list *buffer);

WireSyncReturn wire_grow_memory__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                       struct wire_Memory memory,
                                                       uint32_t pages);

WireSyncReturn wire_get_table_size__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                          struct wire_Table table);

WireSyncReturn wire_get_table_type__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                          struct wire_Table table);

WireSyncReturn wire_grow_table__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                      struct wire_Table table,
                                                      uint32_t delta,
                                                      struct wire_Value2 *value);

WireSyncReturn wire_get_table__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                     struct wire_Table table,
                                                     uint32_t index);

WireSyncReturn wire_set_table__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                     struct wire_Table table,
                                                     uint32_t index,
                                                     struct wire_Value2 *value);

WireSyncReturn wire_fill_table__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                      struct wire_Table table,
                                                      uint32_t index,
                                                      struct wire_Value2 *value,
                                                      uint32_t len);

WireSyncReturn wire_link_imports__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                        struct wire_list_module_import *imports);

struct wire_Func new_Func(void);

struct wire_Global new_Global(void);

struct wire_Memory new_Memory(void);

struct wire_Table new_Table(void);

struct wire_TableType2 *new_box_autoadd_table_type_2_0(void);

uint32_t *new_box_autoadd_u32_0(uint32_t value);

struct wire_Value2 *new_box_autoadd_value_2_0(void);

struct wire_WasmMemoryType *new_box_autoadd_wasm_memory_type_0(void);

struct wire_WasmiInstanceId *new_box_autoadd_wasmi_instance_id_0(void);

struct wire_WasmiModuleId *new_box_autoadd_wasmi_module_id_0(void);

struct wire_list_module_import *new_list_module_import_0(int32_t len);

struct wire_list_value_2 *new_list_value_2_0(int32_t len);

struct wire_list_value_ty *new_list_value_ty_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void drop_opaque_Func(const void *ptr);

const void *share_opaque_Func(const void *ptr);

void drop_opaque_Global(const void *ptr);

const void *share_opaque_Global(const void *ptr);

void drop_opaque_Memory(const void *ptr);

const void *share_opaque_Memory(const void *ptr);

void drop_opaque_Table(const void *ptr);

const void *share_opaque_Table(const void *ptr);

union ExternalValueKind *inflate_ExternalValue_Func(void);

union ExternalValueKind *inflate_ExternalValue_Global(void);

union ExternalValueKind *inflate_ExternalValue_Table(void);

union ExternalValueKind *inflate_ExternalValue_Memory(void);

union Value2Kind *inflate_Value2_I32(void);

union Value2Kind *inflate_Value2_I64(void);

union Value2Kind *inflate_Value2_F32(void);

union Value2Kind *inflate_Value2_F64(void);

union Value2Kind *inflate_Value2_FuncRef(void);

union Value2Kind *inflate_Value2_ExternRef(void);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_parse_wat_format);
    dummy_var ^= ((int64_t) (void*) wire_run_function);
    dummy_var ^= ((int64_t) (void*) wire_run_wasm_func);
    dummy_var ^= ((int64_t) (void*) wire_run_wasm_func_mut);
    dummy_var ^= ((int64_t) (void*) wire_run_wasm_func_void);
    dummy_var ^= ((int64_t) (void*) wire_compile_wasm_sync);
    dummy_var ^= ((int64_t) (void*) wire_compile_wasm);
    dummy_var ^= ((int64_t) (void*) wire_call_wasm);
    dummy_var ^= ((int64_t) (void*) wire_add);
    dummy_var ^= ((int64_t) (void*) wire_call_function__method__WasmiInstanceId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_with_args_sync__method__WasmiInstanceId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_with_args__method__WasmiInstanceId);
    dummy_var ^= ((int64_t) (void*) wire_exports__method__WasmiInstanceId);
    dummy_var ^= ((int64_t) (void*) wire_instantiate_sync__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_instantiate__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_module_imports__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_module_exports__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_executions__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_dispose__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_function__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_memory__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_global__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_create_table__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_global_type__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_global_value__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_set_global_value__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_type__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_data__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_read_memory__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_memory_pages__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_write_memory__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_grow_memory__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_table_size__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_table_type__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_grow_table__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_table__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_set_table__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_fill_table__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_link_imports__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) new_Func);
    dummy_var ^= ((int64_t) (void*) new_Global);
    dummy_var ^= ((int64_t) (void*) new_Memory);
    dummy_var ^= ((int64_t) (void*) new_Table);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_table_type_2_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u32_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_value_2_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasm_memory_type_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasmi_instance_id_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasmi_module_id_0);
    dummy_var ^= ((int64_t) (void*) new_list_module_import_0);
    dummy_var ^= ((int64_t) (void*) new_list_value_2_0);
    dummy_var ^= ((int64_t) (void*) new_list_value_ty_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Func);
    dummy_var ^= ((int64_t) (void*) share_opaque_Func);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Global);
    dummy_var ^= ((int64_t) (void*) share_opaque_Global);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Memory);
    dummy_var ^= ((int64_t) (void*) share_opaque_Memory);
    dummy_var ^= ((int64_t) (void*) drop_opaque_Table);
    dummy_var ^= ((int64_t) (void*) share_opaque_Table);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Func);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Global);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Table);
    dummy_var ^= ((int64_t) (void*) inflate_ExternalValue_Memory);
    dummy_var ^= ((int64_t) (void*) inflate_Value2_I32);
    dummy_var ^= ((int64_t) (void*) inflate_Value2_I64);
    dummy_var ^= ((int64_t) (void*) inflate_Value2_F32);
    dummy_var ^= ((int64_t) (void*) inflate_Value2_F64);
    dummy_var ^= ((int64_t) (void*) inflate_Value2_FuncRef);
    dummy_var ^= ((int64_t) (void*) inflate_Value2_ExternRef);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
