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

typedef struct wire_WasmiModuleId {
  uintptr_t field0;
} wire_WasmiModuleId;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_parse_wat_format(int64_t port_, struct wire_uint_8_list *wat);

WireSyncReturn wire_run_function(int64_t pointer);

WireSyncReturn wire_run_wasm_func(uintptr_t pointer, struct wire_list_value_2 *params);

WireSyncReturn wire_run_wasm_func_void(uintptr_t pointer, struct wire_list_value_2 *params);

void wire_compile_wasm(int64_t port_, struct wire_uint_8_list *module_wasm);

void wire_call_wasm(int64_t port_);

void wire_add(int64_t port_, int64_t a, int64_t b);

void wire_call_function__method__WasmiModuleId(int64_t port_,
                                               struct wire_WasmiModuleId *that,
                                               struct wire_uint_8_list *name);

void wire_call_function_with_args__method__WasmiModuleId(int64_t port_,
                                                         struct wire_WasmiModuleId *that,
                                                         struct wire_uint_8_list *name,
                                                         struct wire_list_value_2 *args);

void wire_get_exports__method__WasmiModuleId(int64_t port_, struct wire_WasmiModuleId *that);

void wire_get_module_exports__method__WasmiModuleId(int64_t port_, struct wire_WasmiModuleId *that);

void wire_executions__method__WasmiModuleId(int64_t port_, struct wire_WasmiModuleId *that);

WireSyncReturn wire_call_function_with_args_sync__method__WasmiModuleId(struct wire_WasmiModuleId *that,
                                                                        struct wire_uint_8_list *name,
                                                                        struct wire_list_value_2 *args);

struct wire_WasmiModuleId *new_box_autoadd_wasmi_module_id_0(void);

struct wire_list_value_2 *new_list_value_2_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

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
    dummy_var ^= ((int64_t) (void*) wire_run_wasm_func_void);
    dummy_var ^= ((int64_t) (void*) wire_compile_wasm);
    dummy_var ^= ((int64_t) (void*) wire_call_wasm);
    dummy_var ^= ((int64_t) (void*) wire_add);
    dummy_var ^= ((int64_t) (void*) wire_call_function__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_with_args__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_exports__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_get_module_exports__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_executions__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) wire_call_function_with_args_sync__method__WasmiModuleId);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_wasmi_module_id_0);
    dummy_var ^= ((int64_t) (void*) new_list_value_2_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
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
