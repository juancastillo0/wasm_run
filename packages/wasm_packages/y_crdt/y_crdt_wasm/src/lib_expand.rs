#![feature(prelude_import)]
#[prelude_import]
use std::prelude::rust_2021::*;
#[macro_use]
extern crate std;
/// A record is a class with named fields
/// There are enum, list, variant, option, result, tuple and union types
#[repr(C)]
pub struct Model {
    /// Comment for a field
    pub integer: i32,
}
#[automatically_derived]
impl ::core::marker::Copy for Model {}
#[automatically_derived]
impl ::core::clone::Clone for Model {
    #[inline]
    fn clone(&self) -> Model {
        let _: ::core::clone::AssertParamIsClone<i32>;
        *self
    }
}
impl ::core::fmt::Debug for Model {
    fn fmt(&self, f: &mut ::core::fmt::Formatter<'_>) -> ::core::fmt::Result {
        f.debug_struct("Model").field("integer", &self.integer).finish()
    }
}
#[allow(clippy::all)]
/// An import is a function that is provided by the host environment (Dart)
pub fn map_integer(value: i32) -> f64 {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    unsafe {
        #[link(wasm_import_module = "$root")]
        extern "C" {
            #[link_name = "$root_map-integer"]
            fn wit_import(_: i32) -> f64;
        }
        let ret = wit_import(wit_bindgen::rt::as_i32(value));
        ret
    }
}
pub trait YCrdt {
    /// export
    fn run(value: Model) -> Result<f64, wit_bindgen::rt::string::String>;
}
#[doc(hidden)]
pub unsafe fn call_run<T: YCrdt>(arg0: i32) -> i32 {
    #[allow(unused_imports)]
    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
    let result0 = T::run(Model { integer: arg0 });
    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
    match result0 {
        Ok(e) => {
            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
            *((ptr1 + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
        }
        Err(e) => {
            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
            let vec2 = (e.into_bytes()).into_boxed_slice();
            let ptr2 = vec2.as_ptr() as i32;
            let len2 = vec2.len() as i32;
            ::core::mem::forget(vec2);
            *((ptr1 + 12) as *mut i32) = len2;
            *((ptr1 + 8) as *mut i32) = ptr2;
        }
    };
    ptr1
}
#[doc(hidden)]
pub unsafe fn post_return_run<T: YCrdt>(arg0: i32) {
    match i32::from(*((arg0 + 0) as *const u8)) {
        0 => {}
        _ => {
            wit_bindgen::rt::dealloc(
                *((arg0 + 8) as *const i32),
                (*((arg0 + 12) as *const i32)) as usize,
                1,
            );
        }
    }
}
#[allow(unused_imports)]
use wit_bindgen::rt::{alloc, vec::Vec, string::String};
#[repr(align(8))]
struct _RetArea([u8; 16]);
static mut _RET_AREA: _RetArea = _RetArea([0; 16]);
pub mod exports {
    pub mod y_crdt_namespace {
        pub mod y_crdt {
            #[allow(clippy::all)]
            pub mod y_doc_methods {
                #[repr(C)]
                pub struct YXmlText {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YXmlText {}
                #[automatically_derived]
                impl ::core::clone::Clone for YXmlText {
                    #[inline]
                    fn clone(&self) -> YXmlText {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YXmlText {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YXmlText").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct YXmlFragment {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YXmlFragment {}
                #[automatically_derived]
                impl ::core::clone::Clone for YXmlFragment {
                    #[inline]
                    fn clone(&self) -> YXmlFragment {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YXmlFragment {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YXmlFragment").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct YXmlElement {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YXmlElement {}
                #[automatically_derived]
                impl ::core::clone::Clone for YXmlElement {
                    #[inline]
                    fn clone(&self) -> YXmlElement {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YXmlElement {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YXmlElement").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct YText {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YText {}
                #[automatically_derived]
                impl ::core::clone::Clone for YText {
                    #[inline]
                    fn clone(&self) -> YText {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YText {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YText").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct YMap {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YMap {}
                #[automatically_derived]
                impl ::core::clone::Clone for YMap {
                    #[inline]
                    fn clone(&self) -> YMap {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YMap {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YMap").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct YDoc {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YDoc {}
                #[automatically_derived]
                impl ::core::clone::Clone for YDoc {
                    #[inline]
                    fn clone(&self) -> YDoc {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YDoc {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YDoc").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct YArray {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YArray {}
                #[automatically_derived]
                impl ::core::clone::Clone for YArray {
                    #[inline]
                    fn clone(&self) -> YArray {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for YArray {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YArray").field("ref", &self.ref_).finish()
                    }
                }
                #[repr(C)]
                pub struct WriteTransaction {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for WriteTransaction {}
                #[automatically_derived]
                impl ::core::clone::Clone for WriteTransaction {
                    #[inline]
                    fn clone(&self) -> WriteTransaction {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for WriteTransaction {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("WriteTransaction")
                            .field("ref", &self.ref_)
                            .finish()
                    }
                }
                #[repr(C)]
                pub struct ReadTransaction {
                    pub ref_: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for ReadTransaction {}
                #[automatically_derived]
                impl ::core::clone::Clone for ReadTransaction {
                    #[inline]
                    fn clone(&self) -> ReadTransaction {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for ReadTransaction {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("ReadTransaction")
                            .field("ref", &self.ref_)
                            .finish()
                    }
                }
                pub enum YTransaction {
                    ReadTransaction(ReadTransaction),
                    WriteTransaction(WriteTransaction),
                }
                #[automatically_derived]
                impl ::core::clone::Clone for YTransaction {
                    #[inline]
                    fn clone(&self) -> YTransaction {
                        let _: ::core::clone::AssertParamIsClone<ReadTransaction>;
                        let _: ::core::clone::AssertParamIsClone<WriteTransaction>;
                        *self
                    }
                }
                #[automatically_derived]
                impl ::core::marker::Copy for YTransaction {}
                impl ::core::fmt::Debug for YTransaction {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        match self {
                            YTransaction::ReadTransaction(e) => {
                                f.debug_tuple("YTransaction::ReadTransaction")
                                    .field(e)
                                    .finish()
                            }
                            YTransaction::WriteTransaction(e) => {
                                f.debug_tuple("YTransaction::WriteTransaction")
                                    .field(e)
                                    .finish()
                            }
                        }
                    }
                }
                pub type Origin = wit_bindgen::rt::vec::Vec<u8>;
                #[repr(u8)]
                pub enum OffsetKind {
                    /// Compute editable strings length and offset using UTF-8 byte count.
                    Bytes,
                    /// Compute editable strings length and offset using UTF-16 chars count.
                    Utf16,
                    /// Compute editable strings length and offset using Unicode code points number.
                    Utf32,
                }
                #[automatically_derived]
                impl ::core::clone::Clone for OffsetKind {
                    #[inline]
                    fn clone(&self) -> OffsetKind {
                        *self
                    }
                }
                #[automatically_derived]
                impl ::core::marker::Copy for OffsetKind {}
                #[automatically_derived]
                impl ::core::marker::StructuralPartialEq for OffsetKind {}
                #[automatically_derived]
                impl ::core::cmp::PartialEq for OffsetKind {
                    #[inline]
                    fn eq(&self, other: &OffsetKind) -> bool {
                        let __self_tag = ::core::intrinsics::discriminant_value(self);
                        let __arg1_tag = ::core::intrinsics::discriminant_value(other);
                        __self_tag == __arg1_tag
                    }
                }
                #[automatically_derived]
                impl ::core::marker::StructuralEq for OffsetKind {}
                #[automatically_derived]
                impl ::core::cmp::Eq for OffsetKind {
                    #[inline]
                    #[doc(hidden)]
                    #[no_coverage]
                    fn assert_receiver_is_total_eq(&self) -> () {}
                }
                impl ::core::fmt::Debug for OffsetKind {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        match self {
                            OffsetKind::Bytes => {
                                f.debug_tuple("OffsetKind::Bytes").finish()
                            }
                            OffsetKind::Utf16 => {
                                f.debug_tuple("OffsetKind::Utf16").finish()
                            }
                            OffsetKind::Utf32 => {
                                f.debug_tuple("OffsetKind::Utf32").finish()
                            }
                        }
                    }
                }
                pub struct YDocOptions {
                    /// Globally unique client identifier. This value must be unique across all active collaborating
                    /// peers, otherwise a update collisions will happen, causing document store state to be corrupted.
                    ///
                    /// Default value: randomly generated.
                    pub client_id: u64,
                    /// A globally unique identifier for this document.
                    ///
                    /// Default value: randomly generated UUID v4.
                    pub guid: wit_bindgen::rt::string::String,
                    /// Associate this document with a collection. This only plays a role if your provider has
                    /// a concept of collection.
                    ///
                    /// Default value: `None`.
                    pub collection_id: Option<wit_bindgen::rt::string::String>,
                    /// How to we count offsets and lengths used in text operations.
                    ///
                    /// Default value: [OffsetKind::Bytes].
                    pub offset_kind: OffsetKind,
                    /// Determines if transactions commits should try to perform GC-ing of deleted items.
                    ///
                    /// Default value: `false`.
                    pub skip_gc: bool,
                    /// If a subdocument, automatically load document. If this is a subdocument, remote peers will
                    /// load the document as well automatically.
                    ///
                    /// Default value: `false`.
                    pub auto_load: bool,
                    /// Whether the document should be synced by the provider now.
                    /// This is toggled to true when you call ydoc.load().
                    ///
                    /// Default value: `true`.
                    pub should_load: bool,
                }
                #[automatically_derived]
                impl ::core::clone::Clone for YDocOptions {
                    #[inline]
                    fn clone(&self) -> YDocOptions {
                        YDocOptions {
                            client_id: ::core::clone::Clone::clone(&self.client_id),
                            guid: ::core::clone::Clone::clone(&self.guid),
                            collection_id: ::core::clone::Clone::clone(
                                &self.collection_id,
                            ),
                            offset_kind: ::core::clone::Clone::clone(&self.offset_kind),
                            skip_gc: ::core::clone::Clone::clone(&self.skip_gc),
                            auto_load: ::core::clone::Clone::clone(&self.auto_load),
                            should_load: ::core::clone::Clone::clone(&self.should_load),
                        }
                    }
                }
                impl ::core::fmt::Debug for YDocOptions {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("YDocOptions")
                            .field("client-id", &self.client_id)
                            .field("guid", &self.guid)
                            .field("collection-id", &self.collection_id)
                            .field("offset-kind", &self.offset_kind)
                            .field("skip-gc", &self.skip_gc)
                            .field("auto-load", &self.auto_load)
                            .field("should-load", &self.should_load)
                            .finish()
                    }
                }
                #[repr(C)]
                pub struct JsonMapRef {
                    pub index: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for JsonMapRef {}
                #[automatically_derived]
                impl ::core::clone::Clone for JsonMapRef {
                    #[inline]
                    fn clone(&self) -> JsonMapRef {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for JsonMapRef {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("JsonMapRef").field("index", &self.index).finish()
                    }
                }
                #[repr(C)]
                pub struct JsonArrayRef {
                    pub index: u32,
                }
                #[automatically_derived]
                impl ::core::marker::Copy for JsonArrayRef {}
                #[automatically_derived]
                impl ::core::clone::Clone for JsonArrayRef {
                    #[inline]
                    fn clone(&self) -> JsonArrayRef {
                        let _: ::core::clone::AssertParamIsClone<u32>;
                        *self
                    }
                }
                impl ::core::fmt::Debug for JsonArrayRef {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("JsonArrayRef")
                            .field("index", &self.index)
                            .finish()
                    }
                }
                pub enum JsonValue {
                    Null,
                    Undefined,
                    Boolean(bool),
                    Number(f64),
                    BigInt(i64),
                    Str(wit_bindgen::rt::string::String),
                    Buffer(wit_bindgen::rt::vec::Vec<u8>),
                    /// TODO: use json-array-ref
                    Array(JsonArrayRef),
                    Map(JsonMapRef),
                }
                #[automatically_derived]
                impl ::core::clone::Clone for JsonValue {
                    #[inline]
                    fn clone(&self) -> JsonValue {
                        match self {
                            JsonValue::Null => JsonValue::Null,
                            JsonValue::Undefined => JsonValue::Undefined,
                            JsonValue::Boolean(__self_0) => {
                                JsonValue::Boolean(::core::clone::Clone::clone(__self_0))
                            }
                            JsonValue::Number(__self_0) => {
                                JsonValue::Number(::core::clone::Clone::clone(__self_0))
                            }
                            JsonValue::BigInt(__self_0) => {
                                JsonValue::BigInt(::core::clone::Clone::clone(__self_0))
                            }
                            JsonValue::Str(__self_0) => {
                                JsonValue::Str(::core::clone::Clone::clone(__self_0))
                            }
                            JsonValue::Buffer(__self_0) => {
                                JsonValue::Buffer(::core::clone::Clone::clone(__self_0))
                            }
                            JsonValue::Array(__self_0) => {
                                JsonValue::Array(::core::clone::Clone::clone(__self_0))
                            }
                            JsonValue::Map(__self_0) => {
                                JsonValue::Map(::core::clone::Clone::clone(__self_0))
                            }
                        }
                    }
                }
                impl ::core::fmt::Debug for JsonValue {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        match self {
                            JsonValue::Null => f.debug_tuple("JsonValue::Null").finish(),
                            JsonValue::Undefined => {
                                f.debug_tuple("JsonValue::Undefined").finish()
                            }
                            JsonValue::Boolean(e) => {
                                f.debug_tuple("JsonValue::Boolean").field(e).finish()
                            }
                            JsonValue::Number(e) => {
                                f.debug_tuple("JsonValue::Number").field(e).finish()
                            }
                            JsonValue::BigInt(e) => {
                                f.debug_tuple("JsonValue::BigInt").field(e).finish()
                            }
                            JsonValue::Str(e) => {
                                f.debug_tuple("JsonValue::Str").field(e).finish()
                            }
                            JsonValue::Buffer(e) => {
                                f.debug_tuple("JsonValue::Buffer").field(e).finish()
                            }
                            JsonValue::Array(e) => {
                                f.debug_tuple("JsonValue::Array").field(e).finish()
                            }
                            JsonValue::Map(e) => {
                                f.debug_tuple("JsonValue::Map").field(e).finish()
                            }
                        }
                    }
                }
                pub struct JsonValueItem {
                    pub item: JsonValue,
                    pub array_references: wit_bindgen::rt::vec::Vec<
                        wit_bindgen::rt::vec::Vec<JsonValue>,
                    >,
                    pub map_references: wit_bindgen::rt::vec::Vec<
                        wit_bindgen::rt::vec::Vec<
                            (wit_bindgen::rt::string::String, JsonValue),
                        >,
                    >,
                }
                #[automatically_derived]
                impl ::core::clone::Clone for JsonValueItem {
                    #[inline]
                    fn clone(&self) -> JsonValueItem {
                        JsonValueItem {
                            item: ::core::clone::Clone::clone(&self.item),
                            array_references: ::core::clone::Clone::clone(
                                &self.array_references,
                            ),
                            map_references: ::core::clone::Clone::clone(
                                &self.map_references,
                            ),
                        }
                    }
                }
                impl ::core::fmt::Debug for JsonValueItem {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        f.debug_struct("JsonValueItem")
                            .field("item", &self.item)
                            .field("array-references", &self.array_references)
                            .field("map-references", &self.map_references)
                            .finish()
                    }
                }
                pub enum YValue {
                    JsonValueItem(JsonValueItem),
                    YText(YText),
                    YArray(YArray),
                    YMap(YMap),
                    YXmlFragment(YXmlFragment),
                    YXmlElement(YXmlElement),
                    YXmlText(YXmlText),
                    YDoc(YDoc),
                }
                #[automatically_derived]
                impl ::core::clone::Clone for YValue {
                    #[inline]
                    fn clone(&self) -> YValue {
                        match self {
                            YValue::JsonValueItem(__self_0) => {
                                YValue::JsonValueItem(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YText(__self_0) => {
                                YValue::YText(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YArray(__self_0) => {
                                YValue::YArray(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YMap(__self_0) => {
                                YValue::YMap(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YXmlFragment(__self_0) => {
                                YValue::YXmlFragment(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YXmlElement(__self_0) => {
                                YValue::YXmlElement(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YXmlText(__self_0) => {
                                YValue::YXmlText(::core::clone::Clone::clone(__self_0))
                            }
                            YValue::YDoc(__self_0) => {
                                YValue::YDoc(::core::clone::Clone::clone(__self_0))
                            }
                        }
                    }
                }
                impl ::core::fmt::Debug for YValue {
                    fn fmt(
                        &self,
                        f: &mut ::core::fmt::Formatter<'_>,
                    ) -> ::core::fmt::Result {
                        match self {
                            YValue::JsonValueItem(e) => {
                                f.debug_tuple("YValue::JsonValueItem").field(e).finish()
                            }
                            YValue::YText(e) => {
                                f.debug_tuple("YValue::YText").field(e).finish()
                            }
                            YValue::YArray(e) => {
                                f.debug_tuple("YValue::YArray").field(e).finish()
                            }
                            YValue::YMap(e) => {
                                f.debug_tuple("YValue::YMap").field(e).finish()
                            }
                            YValue::YXmlFragment(e) => {
                                f.debug_tuple("YValue::YXmlFragment").field(e).finish()
                            }
                            YValue::YXmlElement(e) => {
                                f.debug_tuple("YValue::YXmlElement").field(e).finish()
                            }
                            YValue::YXmlText(e) => {
                                f.debug_tuple("YValue::YXmlText").field(e).finish()
                            }
                            YValue::YDoc(e) => {
                                f.debug_tuple("YValue::YDoc").field(e).finish()
                            }
                        }
                    }
                }
                pub type JsonObject = JsonValueItem;
                pub type TextAttrs = JsonObject;
                pub type JsonArray = JsonValueItem;
                pub type ImplicitTransaction = Option<YTransaction>;
                pub type Error = wit_bindgen::rt::string::String;
                pub trait YDocMethods {
                    fn y_doc_new(options: Option<YDocOptions>) -> YDoc;
                    fn y_doc_parent_doc(ref_: YDoc) -> Option<YDoc>;
                    fn y_doc_id(ref_: YDoc) -> u64;
                    fn y_doc_guid(ref_: YDoc) -> wit_bindgen::rt::string::String;
                    fn y_doc_read_transaction(ref_: YDoc) -> ReadTransaction;
                    fn y_doc_write_transaction(
                        ref_: YDoc,
                        origin: Origin,
                    ) -> WriteTransaction;
                    fn y_doc_text(
                        ref_: YDoc,
                        name: wit_bindgen::rt::string::String,
                    ) -> YText;
                    fn y_doc_array(
                        ref_: YDoc,
                        name: wit_bindgen::rt::string::String,
                    ) -> YArray;
                    fn y_doc_map(
                        ref_: YDoc,
                        name: wit_bindgen::rt::string::String,
                    ) -> YMap;
                    fn y_doc_xml_fragment(
                        ref_: YDoc,
                        name: wit_bindgen::rt::string::String,
                    ) -> YXmlFragment;
                    fn y_doc_xml_element(
                        ref_: YDoc,
                        name: wit_bindgen::rt::string::String,
                    ) -> YXmlElement;
                    fn y_doc_xml_text(
                        ref_: YDoc,
                        name: wit_bindgen::rt::string::String,
                    ) -> YXmlText;
                    fn y_doc_on_update_v1(ref_: YDoc, function_id: u32);
                    fn subdocs(
                        ref_: YDoc,
                        txn: YTransaction,
                    ) -> wit_bindgen::rt::vec::Vec<wit_bindgen::rt::string::String>;
                    fn subdoc_guids(
                        ref_: YDoc,
                        txn: YTransaction,
                    ) -> wit_bindgen::rt::vec::Vec<wit_bindgen::rt::string::String>;
                    fn encode_state_vector(ref_: YDoc) -> wit_bindgen::rt::vec::Vec<u8>;
                    fn encode_state_as_update(
                        ref_: YDoc,
                        vector: Option<wit_bindgen::rt::vec::Vec<u8>>,
                    ) -> Result<wit_bindgen::rt::vec::Vec<u8>, Error>;
                    fn encode_state_as_update_v2(
                        ref_: YDoc,
                        vector: Option<wit_bindgen::rt::vec::Vec<u8>>,
                    ) -> Result<wit_bindgen::rt::vec::Vec<u8>, Error>;
                    fn apply_update(
                        ref_: YDoc,
                        diff: wit_bindgen::rt::vec::Vec<u8>,
                        origin: Origin,
                    ) -> Result<(), Error>;
                    fn apply_update_v2(
                        ref_: YDoc,
                        diff: wit_bindgen::rt::vec::Vec<u8>,
                        origin: Origin,
                    ) -> Result<(), Error>;
                    fn transaction_is_readonly(txn: YTransaction) -> bool;
                    fn transaction_is_writeable(txn: YTransaction) -> bool;
                    fn transaction_origin(txn: YTransaction) -> Option<Origin>;
                    fn transaction_commit(txn: YTransaction);
                    fn transaction_state_vector_v1(
                        txn: YTransaction,
                    ) -> wit_bindgen::rt::vec::Vec<u8>;
                    fn transaction_diff_v1(
                        txn: YTransaction,
                        vector: Option<wit_bindgen::rt::vec::Vec<u8>>,
                    ) -> Result<wit_bindgen::rt::vec::Vec<u8>, Error>;
                    fn transaction_diff_v2(
                        txn: YTransaction,
                        vector: Option<wit_bindgen::rt::vec::Vec<u8>>,
                    ) -> Result<wit_bindgen::rt::vec::Vec<u8>, Error>;
                    fn transaction_apply_v2(
                        txn: YTransaction,
                        diff: wit_bindgen::rt::vec::Vec<u8>,
                    ) -> Result<(), Error>;
                    fn transaction_encode_update(
                        txn: YTransaction,
                    ) -> wit_bindgen::rt::vec::Vec<u8>;
                    fn transaction_encode_update_v2(
                        txn: YTransaction,
                    ) -> wit_bindgen::rt::vec::Vec<u8>;
                    fn y_text_new(
                        init: Option<wit_bindgen::rt::string::String>,
                    ) -> YText;
                    fn y_text_prelim(ref_: YText) -> bool;
                    fn y_text_length(ref_: YText, txn: ImplicitTransaction) -> u32;
                    fn y_text_to_string(
                        ref_: YText,
                        txn: ImplicitTransaction,
                    ) -> wit_bindgen::rt::string::String;
                    fn y_text_to_json(
                        ref_: YText,
                        txn: ImplicitTransaction,
                    ) -> wit_bindgen::rt::string::String;
                    fn y_text_insert(
                        ref_: YText,
                        index: u32,
                        chunk: wit_bindgen::rt::string::String,
                        attributes: Option<TextAttrs>,
                        txn: ImplicitTransaction,
                    );
                    fn y_text_insert_embed(
                        ref_: YText,
                        index: u32,
                        embed: JsonValueItem,
                        attributes: Option<TextAttrs>,
                        txn: ImplicitTransaction,
                    );
                    fn y_text_format(
                        ref_: YText,
                        index: u32,
                        length: u32,
                        attributes: TextAttrs,
                        txn: ImplicitTransaction,
                    );
                    fn y_text_push(
                        ref_: YText,
                        chunk: wit_bindgen::rt::string::String,
                        attributes: Option<TextAttrs>,
                        txn: ImplicitTransaction,
                    );
                    fn y_text_delete(
                        ref_: YText,
                        index: u32,
                        length: u32,
                        txn: ImplicitTransaction,
                    );
                    fn y_text_observe(ref_: YText, function_id: u32);
                    fn y_text_observe_deep(ref_: YText, function_id: u32);
                    fn y_array_new(init: Option<JsonArray>) -> YArray;
                    fn y_array_prelim(ref_: YArray) -> bool;
                    fn y_array_length(ref_: YArray, txn: ImplicitTransaction) -> u32;
                    fn y_array_to_json(
                        ref_: YArray,
                        txn: ImplicitTransaction,
                    ) -> JsonValueItem;
                    fn y_array_insert(
                        ref_: YArray,
                        index: u32,
                        items: JsonArray,
                        txn: ImplicitTransaction,
                    );
                    fn y_array_push(
                        ref_: YArray,
                        items: JsonArray,
                        txn: ImplicitTransaction,
                    );
                    fn y_array_delete(
                        ref_: YArray,
                        index: u32,
                        length: u32,
                        txn: ImplicitTransaction,
                    );
                    fn y_array_move_content(
                        ref_: YArray,
                        source: u32,
                        target: u32,
                        txn: ImplicitTransaction,
                    );
                    fn y_array_get(
                        ref_: YArray,
                        index: u32,
                        txn: ImplicitTransaction,
                    ) -> Result<YValue, Error>;
                    fn y_array_observe(ref_: YArray, function_id: u32);
                    fn y_array_observe_deep(ref_: YArray, function_id: u32);
                    fn y_map_new(init: Option<JsonObject>) -> YMap;
                    fn y_map_prelim(ref_: YMap) -> bool;
                    fn y_map_length(ref_: YMap, txn: ImplicitTransaction) -> u32;
                    fn y_map_to_json(
                        ref_: YMap,
                        txn: ImplicitTransaction,
                    ) -> JsonValueItem;
                    fn y_map_set(
                        ref_: YMap,
                        key: wit_bindgen::rt::string::String,
                        value: JsonValueItem,
                        txn: ImplicitTransaction,
                    );
                    fn y_map_delete(
                        ref_: YMap,
                        key: wit_bindgen::rt::string::String,
                        txn: ImplicitTransaction,
                    );
                    fn y_map_get(
                        ref_: YMap,
                        key: wit_bindgen::rt::string::String,
                        txn: ImplicitTransaction,
                    ) -> Option<YValue>;
                    fn y_map_observe(ref_: YMap, function_id: u32);
                    fn y_map_observe_deep(ref_: YMap, function_id: u32);
                    fn y_xml_element_name(
                        ref_: YXmlElement,
                    ) -> Option<wit_bindgen::rt::string::String>;
                    fn y_xml_element_length(
                        ref_: YXmlElement,
                        txn: ImplicitTransaction,
                    ) -> u32;
                    fn y_xml_element_insert_xml_element(
                        ref_: YXmlElement,
                        index: u32,
                        name: wit_bindgen::rt::string::String,
                        txn: ImplicitTransaction,
                    ) -> YXmlElement;
                    fn y_xml_element_insert_xml_text(
                        ref_: YXmlElement,
                        index: u32,
                        txn: ImplicitTransaction,
                    ) -> YXmlText;
                    fn y_xml_element_delete(
                        ref_: YXmlElement,
                        index: u32,
                        length: u32,
                        txn: ImplicitTransaction,
                    );
                    fn y_xml_fragment_name(
                        ref_: YXmlFragment,
                    ) -> Option<wit_bindgen::rt::string::String>;
                    fn y_xml_fragment_length(
                        ref_: YXmlFragment,
                        txn: ImplicitTransaction,
                    ) -> u32;
                    fn y_xml_text_length(
                        ref_: YXmlText,
                        txn: ImplicitTransaction,
                    ) -> u32;
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_new<T: YDocMethods>(
                    arg0: i32,
                    arg1: i64,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result2 = T::y_doc_new(
                        match arg0 {
                            0 => None,
                            1 => {
                                Some({
                                    let len0 = arg3 as usize;
                                    YDocOptions {
                                        client_id: arg1 as u64,
                                        guid: {
                                            #[cfg(debug_assertions)]
                                            {
                                                String::from_utf8(
                                                        Vec::from_raw_parts(arg2 as *mut _, len0, len0),
                                                    )
                                                    .unwrap()
                                            }
                                        },
                                        collection_id: match arg4 {
                                            0 => None,
                                            1 => {
                                                Some({
                                                    let len1 = arg6 as usize;
                                                    {
                                                        #[cfg(debug_assertions)]
                                                        {
                                                            String::from_utf8(
                                                                    Vec::from_raw_parts(arg5 as *mut _, len1, len1),
                                                                )
                                                                .unwrap()
                                                        }
                                                    }
                                                })
                                            }
                                            #[cfg(debug_assertions)]
                                            _ => {
                                                ::core::panicking::panic_fmt(
                                                    format_args!("invalid enum discriminant"),
                                                );
                                            }
                                        },
                                        offset_kind: {
                                            #[cfg(debug_assertions)]
                                            {
                                                match arg7 {
                                                    0 => OffsetKind::Bytes,
                                                    1 => OffsetKind::Utf16,
                                                    2 => OffsetKind::Utf32,
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        skip_gc: {
                                            #[cfg(debug_assertions)]
                                            {
                                                match arg8 {
                                                    0 => false,
                                                    1 => true,
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid bool discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        auto_load: {
                                            #[cfg(debug_assertions)]
                                            {
                                                match arg9 {
                                                    0 => false,
                                                    1 => true,
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid bool discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        should_load: {
                                            #[cfg(debug_assertions)]
                                            {
                                                match arg10 {
                                                    0 => false,
                                                    1 => true,
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid bool discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let YDoc { ref_: ref_3 } = result2;
                    wit_bindgen::rt::as_i32(ref_3)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_parent_doc<T: YDocMethods>(arg0: i32) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_doc_parent_doc(YDoc { ref_: arg0 as u32 });
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result0 {
                        Some(e) => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                            let YDoc { ref_: ref_2 } = e;
                            *((ptr1 + 4) as *mut i32) = wit_bindgen::rt::as_i32(ref_2);
                        }
                        None => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                        }
                    };
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_id<T: YDocMethods>(arg0: i32) -> i64 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_doc_id(YDoc { ref_: arg0 as u32 });
                    wit_bindgen::rt::as_i64(result0)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_guid<T: YDocMethods>(arg0: i32) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_doc_guid(YDoc { ref_: arg0 as u32 });
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0.into_bytes()).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_doc_guid<T: YDocMethods>(arg0: i32) {
                    wit_bindgen::rt::dealloc(
                        *((arg0 + 0) as *const i32),
                        (*((arg0 + 4) as *const i32)) as usize,
                        1,
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_read_transaction<T: YDocMethods>(
                    arg0: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_doc_read_transaction(YDoc { ref_: arg0 as u32 });
                    let ReadTransaction { ref_: ref_1 } = result0;
                    wit_bindgen::rt::as_i32(ref_1)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_write_transaction<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_write_transaction(
                        YDoc { ref_: arg0 as u32 },
                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                    );
                    let WriteTransaction { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_text<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_text(
                        YDoc { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                    );
                    let YText { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_array<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_array(
                        YDoc { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                    );
                    let YArray { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_map<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_map(
                        YDoc { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                    );
                    let YMap { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_xml_fragment<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_xml_fragment(
                        YDoc { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                    );
                    let YXmlFragment { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_xml_element<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_xml_element(
                        YDoc { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                    );
                    let YXmlElement { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_xml_text<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_doc_xml_text(
                        YDoc { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                    );
                    let YXmlText { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_doc_on_update_v1<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_doc_on_update_v1(YDoc { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_subdocs<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::subdocs(
                        YDoc { ref_: arg0 as u32 },
                        match arg1 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg2 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg2 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec3 = result0;
                    let len3 = vec3.len() as i32;
                    let layout3 = alloc::Layout::from_size_align_unchecked(
                        vec3.len() * 8,
                        4,
                    );
                    let result3 = if layout3.size() != 0 {
                        let ptr = alloc::alloc(layout3);
                        if ptr.is_null() {
                            alloc::handle_alloc_error(layout3);
                        }
                        ptr
                    } else {
                        ::core::ptr::null_mut()
                    };
                    for (i, e) in vec3.into_iter().enumerate() {
                        let base = result3 as i32 + (i as i32) * 8;
                        {
                            let vec2 = (e.into_bytes()).into_boxed_slice();
                            let ptr2 = vec2.as_ptr() as i32;
                            let len2 = vec2.len() as i32;
                            ::core::mem::forget(vec2);
                            *((base + 4) as *mut i32) = len2;
                            *((base + 0) as *mut i32) = ptr2;
                        }
                    }
                    *((ptr1 + 4) as *mut i32) = len3;
                    *((ptr1 + 0) as *mut i32) = result3 as i32;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_subdocs<T: YDocMethods>(arg0: i32) {
                    let base0 = *((arg0 + 0) as *const i32);
                    let len0 = *((arg0 + 4) as *const i32);
                    for i in 0..len0 {
                        let base = base0 + i * 8;
                        {
                            wit_bindgen::rt::dealloc(
                                *((base + 0) as *const i32),
                                (*((base + 4) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 8, 4);
                }
                #[doc(hidden)]
                pub unsafe fn call_subdoc_guids<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::subdoc_guids(
                        YDoc { ref_: arg0 as u32 },
                        match arg1 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg2 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg2 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec3 = result0;
                    let len3 = vec3.len() as i32;
                    let layout3 = alloc::Layout::from_size_align_unchecked(
                        vec3.len() * 8,
                        4,
                    );
                    let result3 = if layout3.size() != 0 {
                        let ptr = alloc::alloc(layout3);
                        if ptr.is_null() {
                            alloc::handle_alloc_error(layout3);
                        }
                        ptr
                    } else {
                        ::core::ptr::null_mut()
                    };
                    for (i, e) in vec3.into_iter().enumerate() {
                        let base = result3 as i32 + (i as i32) * 8;
                        {
                            let vec2 = (e.into_bytes()).into_boxed_slice();
                            let ptr2 = vec2.as_ptr() as i32;
                            let len2 = vec2.len() as i32;
                            ::core::mem::forget(vec2);
                            *((base + 4) as *mut i32) = len2;
                            *((base + 0) as *mut i32) = ptr2;
                        }
                    }
                    *((ptr1 + 4) as *mut i32) = len3;
                    *((ptr1 + 0) as *mut i32) = result3 as i32;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_subdoc_guids<T: YDocMethods>(arg0: i32) {
                    let base0 = *((arg0 + 0) as *const i32);
                    let len0 = *((arg0 + 4) as *const i32);
                    for i in 0..len0 {
                        let base = base0 + i * 8;
                        {
                            wit_bindgen::rt::dealloc(
                                *((base + 0) as *const i32),
                                (*((base + 4) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 8, 4);
                }
                #[doc(hidden)]
                pub unsafe fn call_encode_state_vector<T: YDocMethods>(
                    arg0: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::encode_state_vector(YDoc { ref_: arg0 as u32 });
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_encode_state_vector<T: YDocMethods>(
                    arg0: i32,
                ) {
                    let base0 = *((arg0 + 0) as *const i32);
                    let len0 = *((arg0 + 4) as *const i32);
                    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                }
                #[doc(hidden)]
                pub unsafe fn call_encode_state_as_update<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result1 = T::encode_state_as_update(
                        YDoc { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some({
                                    let len0 = arg3 as usize;
                                    Vec::from_raw_parts(arg2 as *mut _, len0, len0)
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result1 {
                        Ok(e) => {
                            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
                            let vec3 = (e).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr2 + 8) as *mut i32) = len3;
                            *((ptr2 + 4) as *mut i32) = ptr3;
                        }
                        Err(e) => {
                            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
                            let vec4 = (e.into_bytes()).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr2 + 8) as *mut i32) = len4;
                            *((ptr2 + 4) as *mut i32) = ptr4;
                        }
                    };
                    ptr2
                }
                #[doc(hidden)]
                pub unsafe fn post_return_encode_state_as_update<T: YDocMethods>(
                    arg0: i32,
                ) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {
                            let base0 = *((arg0 + 4) as *const i32);
                            let len0 = *((arg0 + 8) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_encode_state_as_update_v2<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result1 = T::encode_state_as_update_v2(
                        YDoc { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some({
                                    let len0 = arg3 as usize;
                                    Vec::from_raw_parts(arg2 as *mut _, len0, len0)
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result1 {
                        Ok(e) => {
                            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
                            let vec3 = (e).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr2 + 8) as *mut i32) = len3;
                            *((ptr2 + 4) as *mut i32) = ptr3;
                        }
                        Err(e) => {
                            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
                            let vec4 = (e.into_bytes()).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr2 + 8) as *mut i32) = len4;
                            *((ptr2 + 4) as *mut i32) = ptr4;
                        }
                    };
                    ptr2
                }
                #[doc(hidden)]
                pub unsafe fn post_return_encode_state_as_update_v2<T: YDocMethods>(
                    arg0: i32,
                ) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {
                            let base0 = *((arg0 + 4) as *const i32);
                            let len0 = *((arg0 + 8) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_apply_update<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let len1 = arg4 as usize;
                    let result2 = T::apply_update(
                        YDoc { ref_: arg0 as u32 },
                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                        Vec::from_raw_parts(arg3 as *mut _, len1, len1),
                    );
                    let ptr3 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result2 {
                        Ok(_) => {
                            *((ptr3 + 0) as *mut u8) = (0i32) as u8;
                        }
                        Err(e) => {
                            *((ptr3 + 0) as *mut u8) = (1i32) as u8;
                            let vec4 = (e.into_bytes()).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr3 + 8) as *mut i32) = len4;
                            *((ptr3 + 4) as *mut i32) = ptr4;
                        }
                    };
                    ptr3
                }
                #[doc(hidden)]
                pub unsafe fn post_return_apply_update<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_apply_update_v2<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let len1 = arg4 as usize;
                    let result2 = T::apply_update_v2(
                        YDoc { ref_: arg0 as u32 },
                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                        Vec::from_raw_parts(arg3 as *mut _, len1, len1),
                    );
                    let ptr3 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result2 {
                        Ok(_) => {
                            *((ptr3 + 0) as *mut u8) = (0i32) as u8;
                        }
                        Err(e) => {
                            *((ptr3 + 0) as *mut u8) = (1i32) as u8;
                            let vec4 = (e.into_bytes()).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr3 + 8) as *mut i32) = len4;
                            *((ptr3 + 4) as *mut i32) = ptr4;
                        }
                    };
                    ptr3
                }
                #[doc(hidden)]
                pub unsafe fn post_return_apply_update_v2<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_is_readonly<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::transaction_is_readonly(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    match result0 {
                        true => 1,
                        false => 0,
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_is_writeable<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::transaction_is_writeable(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    match result0 {
                        true => 1,
                        false => 0,
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_origin<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::transaction_origin(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result0 {
                        Some(e) => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                            let vec2 = (e).into_boxed_slice();
                            let ptr2 = vec2.as_ptr() as i32;
                            let len2 = vec2.len() as i32;
                            ::core::mem::forget(vec2);
                            *((ptr1 + 8) as *mut i32) = len2;
                            *((ptr1 + 4) as *mut i32) = ptr2;
                        }
                        None => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                        }
                    };
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_origin<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            let base0 = *((arg0 + 4) as *const i32);
                            let len0 = *((arg0 + 8) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_commit<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::transaction_commit(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_state_vector_v1<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::transaction_state_vector_v1(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_state_vector_v1<T: YDocMethods>(
                    arg0: i32,
                ) {
                    let base0 = *((arg0 + 0) as *const i32);
                    let len0 = *((arg0 + 4) as *const i32);
                    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_diff_v1<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result1 = T::transaction_diff_v1(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                        match arg2 {
                            0 => None,
                            1 => {
                                Some({
                                    let len0 = arg4 as usize;
                                    Vec::from_raw_parts(arg3 as *mut _, len0, len0)
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result1 {
                        Ok(e) => {
                            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
                            let vec3 = (e).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr2 + 8) as *mut i32) = len3;
                            *((ptr2 + 4) as *mut i32) = ptr3;
                        }
                        Err(e) => {
                            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
                            let vec4 = (e.into_bytes()).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr2 + 8) as *mut i32) = len4;
                            *((ptr2 + 4) as *mut i32) = ptr4;
                        }
                    };
                    ptr2
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_diff_v1<T: YDocMethods>(
                    arg0: i32,
                ) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {
                            let base0 = *((arg0 + 4) as *const i32);
                            let len0 = *((arg0 + 8) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_diff_v2<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result1 = T::transaction_diff_v2(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                        match arg2 {
                            0 => None,
                            1 => {
                                Some({
                                    let len0 = arg4 as usize;
                                    Vec::from_raw_parts(arg3 as *mut _, len0, len0)
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result1 {
                        Ok(e) => {
                            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
                            let vec3 = (e).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr2 + 8) as *mut i32) = len3;
                            *((ptr2 + 4) as *mut i32) = ptr3;
                        }
                        Err(e) => {
                            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
                            let vec4 = (e.into_bytes()).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr2 + 8) as *mut i32) = len4;
                            *((ptr2 + 4) as *mut i32) = ptr4;
                        }
                    };
                    ptr2
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_diff_v2<T: YDocMethods>(
                    arg0: i32,
                ) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {
                            let base0 = *((arg0 + 4) as *const i32);
                            let len0 = *((arg0 + 8) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_apply_v2<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg3 as usize;
                    let result1 = T::transaction_apply_v2(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                        Vec::from_raw_parts(arg2 as *mut _, len0, len0),
                    );
                    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result1 {
                        Ok(_) => {
                            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
                        }
                        Err(e) => {
                            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
                            let vec3 = (e.into_bytes()).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr2 + 8) as *mut i32) = len3;
                            *((ptr2 + 4) as *mut i32) = ptr3;
                        }
                    };
                    ptr2
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_apply_v2<T: YDocMethods>(
                    arg0: i32,
                ) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_encode_update<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::transaction_encode_update(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_encode_update<T: YDocMethods>(
                    arg0: i32,
                ) {
                    let base0 = *((arg0 + 0) as *const i32);
                    let len0 = *((arg0 + 4) as *const i32);
                    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                }
                #[doc(hidden)]
                pub unsafe fn call_transaction_encode_update_v2<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::transaction_encode_update_v2(
                        match arg0 {
                            0 => {
                                YTransaction::ReadTransaction(ReadTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            1 => {
                                YTransaction::WriteTransaction(WriteTransaction {
                                    ref_: arg1 as u32,
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid union discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_transaction_encode_update_v2<T: YDocMethods>(
                    arg0: i32,
                ) {
                    let base0 = *((arg0 + 0) as *const i32);
                    let len0 = *((arg0 + 4) as *const i32);
                    wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_new<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result1 = T::y_text_new(
                        match arg0 {
                            0 => None,
                            1 => {
                                Some({
                                    let len0 = arg2 as usize;
                                    {
                                        #[cfg(debug_assertions)]
                                        {
                                            String::from_utf8(
                                                    Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                                )
                                                .unwrap()
                                        }
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let YText { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_prelim<T: YDocMethods>(arg0: i32) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_text_prelim(YText { ref_: arg0 as u32 });
                    match result0 {
                        true => 1,
                        false => 0,
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_length<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_text_length(
                        YText { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::as_i32(result0)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_to_string<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_text_to_string(
                        YText { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0.into_bytes()).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_text_to_string<T: YDocMethods>(arg0: i32) {
                    wit_bindgen::rt::dealloc(
                        *((arg0 + 0) as *const i32),
                        (*((arg0 + 4) as *const i32)) as usize,
                        1,
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_to_json<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_text_to_json(
                        YText { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let vec2 = (result0.into_bytes()).into_boxed_slice();
                    let ptr2 = vec2.as_ptr() as i32;
                    let len2 = vec2.len() as i32;
                    ::core::mem::forget(vec2);
                    *((ptr1 + 4) as *mut i32) = len2;
                    *((ptr1 + 0) as *mut i32) = ptr2;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_text_to_json<T: YDocMethods>(arg0: i32) {
                    wit_bindgen::rt::dealloc(
                        *((arg0 + 0) as *const i32),
                        (*((arg0 + 4) as *const i32)) as usize,
                        1,
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_insert<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                    arg6: i64,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                    arg11: i32,
                    arg12: i32,
                    arg13: i32,
                    arg14: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg3 as usize;
                    T::y_text_insert(
                        YText { ref_: arg0 as u32 },
                        arg1 as u32,
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg2 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                        match arg4 {
                            0 => None,
                            1 => {
                                Some({
                                    let base6 = arg8;
                                    let len6 = arg9;
                                    let mut result6 = Vec::with_capacity(len6 as usize);
                                    for i in 0..len6 {
                                        let base = base6 + i * 8;
                                        result6
                                            .push({
                                                let base5 = *((base + 0) as *const i32);
                                                let len5 = *((base + 4) as *const i32);
                                                let mut result5 = Vec::with_capacity(len5 as usize);
                                                for i in 0..len5 {
                                                    let base = base5 + i * 16;
                                                    result5
                                                        .push({
                                                            {
                                                                match i32::from(*((base + 0) as *const u8)) {
                                                                    0 => JsonValue::Null,
                                                                    1 => JsonValue::Undefined,
                                                                    2 => {
                                                                        JsonValue::Boolean({
                                                                            #[cfg(debug_assertions)]
                                                                            {
                                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                                    0 => false,
                                                                                    1 => true,
                                                                                    _ => {
                                                                                        ::core::panicking::panic_fmt(
                                                                                            format_args!("invalid bool discriminant"),
                                                                                        );
                                                                                    }
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                                    5 => {
                                                                        JsonValue::Str({
                                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                                            {
                                                                                #[cfg(debug_assertions)]
                                                                                {
                                                                                    String::from_utf8(
                                                                                            Vec::from_raw_parts(
                                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                                len3,
                                                                                                len3,
                                                                                            ),
                                                                                        )
                                                                                        .unwrap()
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    6 => {
                                                                        JsonValue::Buffer({
                                                                            let len4 = *((base + 12) as *const i32) as usize;
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len4,
                                                                                len4,
                                                                            )
                                                                        })
                                                                    }
                                                                    7 => {
                                                                        JsonValue::Array(JsonArrayRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    8 => {
                                                                        JsonValue::Map(JsonMapRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base5, (len5 as usize) * 16, 8);
                                                result5
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                                    let base11 = arg10;
                                    let len11 = arg11;
                                    let mut result11 = Vec::with_capacity(len11 as usize);
                                    for i in 0..len11 {
                                        let base = base11 + i * 8;
                                        result11
                                            .push({
                                                let base10 = *((base + 0) as *const i32);
                                                let len10 = *((base + 4) as *const i32);
                                                let mut result10 = Vec::with_capacity(len10 as usize);
                                                for i in 0..len10 {
                                                    let base = base10 + i * 24;
                                                    result10
                                                        .push({
                                                            let len7 = *((base + 4) as *const i32) as usize;
                                                            (
                                                                {
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        String::from_utf8(
                                                                                Vec::from_raw_parts(
                                                                                    *((base + 0) as *const i32) as *mut _,
                                                                                    len7,
                                                                                    len7,
                                                                                ),
                                                                            )
                                                                            .unwrap()
                                                                    }
                                                                },
                                                                {
                                                                    {
                                                                        match i32::from(*((base + 8) as *const u8)) {
                                                                            0 => JsonValue::Null,
                                                                            1 => JsonValue::Undefined,
                                                                            2 => {
                                                                                JsonValue::Boolean({
                                                                                    #[cfg(debug_assertions)]
                                                                                    {
                                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                                            0 => false,
                                                                                            1 => true,
                                                                                            _ => {
                                                                                                ::core::panicking::panic_fmt(
                                                                                                    format_args!("invalid bool discriminant"),
                                                                                                );
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                                            5 => {
                                                                                JsonValue::Str({
                                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                                    {
                                                                                        #[cfg(debug_assertions)]
                                                                                        {
                                                                                            String::from_utf8(
                                                                                                    Vec::from_raw_parts(
                                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                                        len8,
                                                                                                        len8,
                                                                                                    ),
                                                                                                )
                                                                                                .unwrap()
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            6 => {
                                                                                JsonValue::Buffer({
                                                                                    let len9 = *((base + 20) as *const i32) as usize;
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len9,
                                                                                        len9,
                                                                                    )
                                                                                })
                                                                            }
                                                                            7 => {
                                                                                JsonValue::Array(JsonArrayRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            8 => {
                                                                                JsonValue::Map(JsonMapRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid enum discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                },
                                                            )
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base10, (len10 as usize) * 24, 8);
                                                result10
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base11, (len11 as usize) * 8, 4);
                                    JsonValueItem {
                                        item: {
                                            {
                                                match arg5 {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match arg6 as i32 {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(f64::from_bits(arg6 as u64)),
                                                    4 => JsonValue::BigInt(arg6),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len1 = arg7 as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(arg6 as i32 as *mut _, len1, len1),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len2 = arg7 as usize;
                                                            Vec::from_raw_parts(arg6 as i32 as *mut _, len2, len2)
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: arg6 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: arg6 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        array_references: result6,
                                        map_references: result11,
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                        match arg12 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg13 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg14 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg14 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_insert_embed<T: YDocMethods>(arg0: i32) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let base5 = *((arg0 + 24) as *const i32);
                    let len5 = *((arg0 + 28) as *const i32);
                    let mut result5 = Vec::with_capacity(len5 as usize);
                    for i in 0..len5 {
                        let base = base5 + i * 8;
                        result5
                            .push({
                                let base4 = *((base + 0) as *const i32);
                                let len4 = *((base + 4) as *const i32);
                                let mut result4 = Vec::with_capacity(len4 as usize);
                                for i in 0..len4 {
                                    let base = base4 + i * 16;
                                    result4
                                        .push({
                                            {
                                                match i32::from(*((base + 0) as *const u8)) {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len2 = *((base + 12) as *const i32) as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len2,
                                                                                len2,
                                                                            ),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                            Vec::from_raw_parts(
                                                                *((base + 8) as *const i32) as *mut _,
                                                                len3,
                                                                len3,
                                                            )
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        });
                                }
                                wit_bindgen::rt::dealloc(base4, (len4 as usize) * 16, 8);
                                result4
                            });
                    }
                    wit_bindgen::rt::dealloc(base5, (len5 as usize) * 8, 4);
                    let base10 = *((arg0 + 32) as *const i32);
                    let len10 = *((arg0 + 36) as *const i32);
                    let mut result10 = Vec::with_capacity(len10 as usize);
                    for i in 0..len10 {
                        let base = base10 + i * 8;
                        result10
                            .push({
                                let base9 = *((base + 0) as *const i32);
                                let len9 = *((base + 4) as *const i32);
                                let mut result9 = Vec::with_capacity(len9 as usize);
                                for i in 0..len9 {
                                    let base = base9 + i * 24;
                                    result9
                                        .push({
                                            let len6 = *((base + 4) as *const i32) as usize;
                                            (
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(
                                                                    *((base + 0) as *const i32) as *mut _,
                                                                    len6,
                                                                    len6,
                                                                ),
                                                            )
                                                            .unwrap()
                                                    }
                                                },
                                                {
                                                    {
                                                        match i32::from(*((base + 8) as *const u8)) {
                                                            0 => JsonValue::Null,
                                                            1 => JsonValue::Undefined,
                                                            2 => {
                                                                JsonValue::Boolean({
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                            0 => false,
                                                                            1 => true,
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid bool discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                            5 => {
                                                                JsonValue::Str({
                                                                    let len7 = *((base + 20) as *const i32) as usize;
                                                                    {
                                                                        #[cfg(debug_assertions)]
                                                                        {
                                                                            String::from_utf8(
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len7,
                                                                                        len7,
                                                                                    ),
                                                                                )
                                                                                .unwrap()
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            6 => {
                                                                JsonValue::Buffer({
                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                    Vec::from_raw_parts(
                                                                        *((base + 16) as *const i32) as *mut _,
                                                                        len8,
                                                                        len8,
                                                                    )
                                                                })
                                                            }
                                                            7 => {
                                                                JsonValue::Array(JsonArrayRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            8 => {
                                                                JsonValue::Map(JsonMapRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            _ => {
                                                                ::core::panicking::panic_fmt(
                                                                    format_args!("invalid enum discriminant"),
                                                                );
                                                            }
                                                        }
                                                    }
                                                },
                                            )
                                        });
                                }
                                wit_bindgen::rt::dealloc(base9, (len9 as usize) * 24, 8);
                                result9
                            });
                    }
                    wit_bindgen::rt::dealloc(base10, (len10 as usize) * 8, 4);
                    T::y_text_insert_embed(
                        YText {
                            ref_: *((arg0 + 0) as *const i32) as u32,
                        },
                        *((arg0 + 4) as *const i32) as u32,
                        JsonValueItem {
                            item: {
                                {
                                    match i32::from(*((arg0 + 8) as *const u8)) {
                                        0 => JsonValue::Null,
                                        1 => JsonValue::Undefined,
                                        2 => {
                                            JsonValue::Boolean({
                                                #[cfg(debug_assertions)]
                                                {
                                                    match i32::from(*((arg0 + 16) as *const u8)) {
                                                        0 => false,
                                                        1 => true,
                                                        _ => {
                                                            ::core::panicking::panic_fmt(
                                                                format_args!("invalid bool discriminant"),
                                                            );
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                        3 => JsonValue::Number(*((arg0 + 16) as *const f64)),
                                        4 => JsonValue::BigInt(*((arg0 + 16) as *const i64)),
                                        5 => {
                                            JsonValue::Str({
                                                let len0 = *((arg0 + 20) as *const i32) as usize;
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(
                                                                    *((arg0 + 16) as *const i32) as *mut _,
                                                                    len0,
                                                                    len0,
                                                                ),
                                                            )
                                                            .unwrap()
                                                    }
                                                }
                                            })
                                        }
                                        6 => {
                                            JsonValue::Buffer({
                                                let len1 = *((arg0 + 20) as *const i32) as usize;
                                                Vec::from_raw_parts(
                                                    *((arg0 + 16) as *const i32) as *mut _,
                                                    len1,
                                                    len1,
                                                )
                                            })
                                        }
                                        7 => {
                                            JsonValue::Array(JsonArrayRef {
                                                index: *((arg0 + 16) as *const i32) as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        8 => {
                                            JsonValue::Map(JsonMapRef {
                                                index: *((arg0 + 16) as *const i32) as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid enum discriminant"),
                                            );
                                        }
                                    }
                                }
                            },
                            array_references: result5,
                            map_references: result10,
                        },
                        match i32::from(*((arg0 + 40) as *const u8)) {
                            0 => None,
                            1 => {
                                Some({
                                    let base16 = *((arg0 + 64) as *const i32);
                                    let len16 = *((arg0 + 68) as *const i32);
                                    let mut result16 = Vec::with_capacity(len16 as usize);
                                    for i in 0..len16 {
                                        let base = base16 + i * 8;
                                        result16
                                            .push({
                                                let base15 = *((base + 0) as *const i32);
                                                let len15 = *((base + 4) as *const i32);
                                                let mut result15 = Vec::with_capacity(len15 as usize);
                                                for i in 0..len15 {
                                                    let base = base15 + i * 16;
                                                    result15
                                                        .push({
                                                            {
                                                                match i32::from(*((base + 0) as *const u8)) {
                                                                    0 => JsonValue::Null,
                                                                    1 => JsonValue::Undefined,
                                                                    2 => {
                                                                        JsonValue::Boolean({
                                                                            #[cfg(debug_assertions)]
                                                                            {
                                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                                    0 => false,
                                                                                    1 => true,
                                                                                    _ => {
                                                                                        ::core::panicking::panic_fmt(
                                                                                            format_args!("invalid bool discriminant"),
                                                                                        );
                                                                                    }
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                                    5 => {
                                                                        JsonValue::Str({
                                                                            let len13 = *((base + 12) as *const i32) as usize;
                                                                            {
                                                                                #[cfg(debug_assertions)]
                                                                                {
                                                                                    String::from_utf8(
                                                                                            Vec::from_raw_parts(
                                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                                len13,
                                                                                                len13,
                                                                                            ),
                                                                                        )
                                                                                        .unwrap()
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    6 => {
                                                                        JsonValue::Buffer({
                                                                            let len14 = *((base + 12) as *const i32) as usize;
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len14,
                                                                                len14,
                                                                            )
                                                                        })
                                                                    }
                                                                    7 => {
                                                                        JsonValue::Array(JsonArrayRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    8 => {
                                                                        JsonValue::Map(JsonMapRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base15, (len15 as usize) * 16, 8);
                                                result15
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base16, (len16 as usize) * 8, 4);
                                    let base21 = *((arg0 + 72) as *const i32);
                                    let len21 = *((arg0 + 76) as *const i32);
                                    let mut result21 = Vec::with_capacity(len21 as usize);
                                    for i in 0..len21 {
                                        let base = base21 + i * 8;
                                        result21
                                            .push({
                                                let base20 = *((base + 0) as *const i32);
                                                let len20 = *((base + 4) as *const i32);
                                                let mut result20 = Vec::with_capacity(len20 as usize);
                                                for i in 0..len20 {
                                                    let base = base20 + i * 24;
                                                    result20
                                                        .push({
                                                            let len17 = *((base + 4) as *const i32) as usize;
                                                            (
                                                                {
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        String::from_utf8(
                                                                                Vec::from_raw_parts(
                                                                                    *((base + 0) as *const i32) as *mut _,
                                                                                    len17,
                                                                                    len17,
                                                                                ),
                                                                            )
                                                                            .unwrap()
                                                                    }
                                                                },
                                                                {
                                                                    {
                                                                        match i32::from(*((base + 8) as *const u8)) {
                                                                            0 => JsonValue::Null,
                                                                            1 => JsonValue::Undefined,
                                                                            2 => {
                                                                                JsonValue::Boolean({
                                                                                    #[cfg(debug_assertions)]
                                                                                    {
                                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                                            0 => false,
                                                                                            1 => true,
                                                                                            _ => {
                                                                                                ::core::panicking::panic_fmt(
                                                                                                    format_args!("invalid bool discriminant"),
                                                                                                );
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                                            5 => {
                                                                                JsonValue::Str({
                                                                                    let len18 = *((base + 20) as *const i32) as usize;
                                                                                    {
                                                                                        #[cfg(debug_assertions)]
                                                                                        {
                                                                                            String::from_utf8(
                                                                                                    Vec::from_raw_parts(
                                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                                        len18,
                                                                                                        len18,
                                                                                                    ),
                                                                                                )
                                                                                                .unwrap()
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            6 => {
                                                                                JsonValue::Buffer({
                                                                                    let len19 = *((base + 20) as *const i32) as usize;
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len19,
                                                                                        len19,
                                                                                    )
                                                                                })
                                                                            }
                                                                            7 => {
                                                                                JsonValue::Array(JsonArrayRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            8 => {
                                                                                JsonValue::Map(JsonMapRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid enum discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                },
                                                            )
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base20, (len20 as usize) * 24, 8);
                                                result20
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base21, (len21 as usize) * 8, 4);
                                    JsonValueItem {
                                        item: {
                                            {
                                                match i32::from(*((arg0 + 48) as *const u8)) {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match i32::from(*((arg0 + 56) as *const u8)) {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(*((arg0 + 56) as *const f64)),
                                                    4 => JsonValue::BigInt(*((arg0 + 56) as *const i64)),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len11 = *((arg0 + 60) as *const i32) as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(
                                                                                *((arg0 + 56) as *const i32) as *mut _,
                                                                                len11,
                                                                                len11,
                                                                            ),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len12 = *((arg0 + 60) as *const i32) as usize;
                                                            Vec::from_raw_parts(
                                                                *((arg0 + 56) as *const i32) as *mut _,
                                                                len12,
                                                                len12,
                                                            )
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: *((arg0 + 56) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: *((arg0 + 56) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        array_references: result16,
                                        map_references: result21,
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                        match i32::from(*((arg0 + 80) as *const u8)) {
                            0 => None,
                            1 => {
                                Some(
                                    match i32::from(*((arg0 + 84) as *const u8)) {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: *((arg0 + 88) as *const i32) as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: *((arg0 + 88) as *const i32) as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::dealloc(arg0, 96, 8);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_format<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i64,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                    arg11: i32,
                    arg12: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let base5 = arg6;
                    let len5 = arg7;
                    let mut result5 = Vec::with_capacity(len5 as usize);
                    for i in 0..len5 {
                        let base = base5 + i * 8;
                        result5
                            .push({
                                let base4 = *((base + 0) as *const i32);
                                let len4 = *((base + 4) as *const i32);
                                let mut result4 = Vec::with_capacity(len4 as usize);
                                for i in 0..len4 {
                                    let base = base4 + i * 16;
                                    result4
                                        .push({
                                            {
                                                match i32::from(*((base + 0) as *const u8)) {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len2 = *((base + 12) as *const i32) as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len2,
                                                                                len2,
                                                                            ),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                            Vec::from_raw_parts(
                                                                *((base + 8) as *const i32) as *mut _,
                                                                len3,
                                                                len3,
                                                            )
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        });
                                }
                                wit_bindgen::rt::dealloc(base4, (len4 as usize) * 16, 8);
                                result4
                            });
                    }
                    wit_bindgen::rt::dealloc(base5, (len5 as usize) * 8, 4);
                    let base10 = arg8;
                    let len10 = arg9;
                    let mut result10 = Vec::with_capacity(len10 as usize);
                    for i in 0..len10 {
                        let base = base10 + i * 8;
                        result10
                            .push({
                                let base9 = *((base + 0) as *const i32);
                                let len9 = *((base + 4) as *const i32);
                                let mut result9 = Vec::with_capacity(len9 as usize);
                                for i in 0..len9 {
                                    let base = base9 + i * 24;
                                    result9
                                        .push({
                                            let len6 = *((base + 4) as *const i32) as usize;
                                            (
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(
                                                                    *((base + 0) as *const i32) as *mut _,
                                                                    len6,
                                                                    len6,
                                                                ),
                                                            )
                                                            .unwrap()
                                                    }
                                                },
                                                {
                                                    {
                                                        match i32::from(*((base + 8) as *const u8)) {
                                                            0 => JsonValue::Null,
                                                            1 => JsonValue::Undefined,
                                                            2 => {
                                                                JsonValue::Boolean({
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                            0 => false,
                                                                            1 => true,
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid bool discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                            5 => {
                                                                JsonValue::Str({
                                                                    let len7 = *((base + 20) as *const i32) as usize;
                                                                    {
                                                                        #[cfg(debug_assertions)]
                                                                        {
                                                                            String::from_utf8(
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len7,
                                                                                        len7,
                                                                                    ),
                                                                                )
                                                                                .unwrap()
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            6 => {
                                                                JsonValue::Buffer({
                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                    Vec::from_raw_parts(
                                                                        *((base + 16) as *const i32) as *mut _,
                                                                        len8,
                                                                        len8,
                                                                    )
                                                                })
                                                            }
                                                            7 => {
                                                                JsonValue::Array(JsonArrayRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            8 => {
                                                                JsonValue::Map(JsonMapRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            _ => {
                                                                ::core::panicking::panic_fmt(
                                                                    format_args!("invalid enum discriminant"),
                                                                );
                                                            }
                                                        }
                                                    }
                                                },
                                            )
                                        });
                                }
                                wit_bindgen::rt::dealloc(base9, (len9 as usize) * 24, 8);
                                result9
                            });
                    }
                    wit_bindgen::rt::dealloc(base10, (len10 as usize) * 8, 4);
                    T::y_text_format(
                        YText { ref_: arg0 as u32 },
                        arg1 as u32,
                        arg2 as u32,
                        JsonValueItem {
                            item: {
                                {
                                    match arg3 {
                                        0 => JsonValue::Null,
                                        1 => JsonValue::Undefined,
                                        2 => {
                                            JsonValue::Boolean({
                                                #[cfg(debug_assertions)]
                                                {
                                                    match arg4 as i32 {
                                                        0 => false,
                                                        1 => true,
                                                        _ => {
                                                            ::core::panicking::panic_fmt(
                                                                format_args!("invalid bool discriminant"),
                                                            );
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                        3 => JsonValue::Number(f64::from_bits(arg4 as u64)),
                                        4 => JsonValue::BigInt(arg4),
                                        5 => {
                                            JsonValue::Str({
                                                let len0 = arg5 as usize;
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(arg4 as i32 as *mut _, len0, len0),
                                                            )
                                                            .unwrap()
                                                    }
                                                }
                                            })
                                        }
                                        6 => {
                                            JsonValue::Buffer({
                                                let len1 = arg5 as usize;
                                                Vec::from_raw_parts(arg4 as i32 as *mut _, len1, len1)
                                            })
                                        }
                                        7 => {
                                            JsonValue::Array(JsonArrayRef {
                                                index: arg4 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        8 => {
                                            JsonValue::Map(JsonMapRef {
                                                index: arg4 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid enum discriminant"),
                                            );
                                        }
                                    }
                                }
                            },
                            array_references: result5,
                            map_references: result10,
                        },
                        match arg10 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg11 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg12 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg12 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_push<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i64,
                    arg6: i32,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                    arg11: i32,
                    arg12: i32,
                    arg13: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    T::y_text_push(
                        YText { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                        match arg3 {
                            0 => None,
                            1 => {
                                Some({
                                    let base6 = arg7;
                                    let len6 = arg8;
                                    let mut result6 = Vec::with_capacity(len6 as usize);
                                    for i in 0..len6 {
                                        let base = base6 + i * 8;
                                        result6
                                            .push({
                                                let base5 = *((base + 0) as *const i32);
                                                let len5 = *((base + 4) as *const i32);
                                                let mut result5 = Vec::with_capacity(len5 as usize);
                                                for i in 0..len5 {
                                                    let base = base5 + i * 16;
                                                    result5
                                                        .push({
                                                            {
                                                                match i32::from(*((base + 0) as *const u8)) {
                                                                    0 => JsonValue::Null,
                                                                    1 => JsonValue::Undefined,
                                                                    2 => {
                                                                        JsonValue::Boolean({
                                                                            #[cfg(debug_assertions)]
                                                                            {
                                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                                    0 => false,
                                                                                    1 => true,
                                                                                    _ => {
                                                                                        ::core::panicking::panic_fmt(
                                                                                            format_args!("invalid bool discriminant"),
                                                                                        );
                                                                                    }
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                                    5 => {
                                                                        JsonValue::Str({
                                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                                            {
                                                                                #[cfg(debug_assertions)]
                                                                                {
                                                                                    String::from_utf8(
                                                                                            Vec::from_raw_parts(
                                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                                len3,
                                                                                                len3,
                                                                                            ),
                                                                                        )
                                                                                        .unwrap()
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    6 => {
                                                                        JsonValue::Buffer({
                                                                            let len4 = *((base + 12) as *const i32) as usize;
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len4,
                                                                                len4,
                                                                            )
                                                                        })
                                                                    }
                                                                    7 => {
                                                                        JsonValue::Array(JsonArrayRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    8 => {
                                                                        JsonValue::Map(JsonMapRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base5, (len5 as usize) * 16, 8);
                                                result5
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                                    let base11 = arg9;
                                    let len11 = arg10;
                                    let mut result11 = Vec::with_capacity(len11 as usize);
                                    for i in 0..len11 {
                                        let base = base11 + i * 8;
                                        result11
                                            .push({
                                                let base10 = *((base + 0) as *const i32);
                                                let len10 = *((base + 4) as *const i32);
                                                let mut result10 = Vec::with_capacity(len10 as usize);
                                                for i in 0..len10 {
                                                    let base = base10 + i * 24;
                                                    result10
                                                        .push({
                                                            let len7 = *((base + 4) as *const i32) as usize;
                                                            (
                                                                {
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        String::from_utf8(
                                                                                Vec::from_raw_parts(
                                                                                    *((base + 0) as *const i32) as *mut _,
                                                                                    len7,
                                                                                    len7,
                                                                                ),
                                                                            )
                                                                            .unwrap()
                                                                    }
                                                                },
                                                                {
                                                                    {
                                                                        match i32::from(*((base + 8) as *const u8)) {
                                                                            0 => JsonValue::Null,
                                                                            1 => JsonValue::Undefined,
                                                                            2 => {
                                                                                JsonValue::Boolean({
                                                                                    #[cfg(debug_assertions)]
                                                                                    {
                                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                                            0 => false,
                                                                                            1 => true,
                                                                                            _ => {
                                                                                                ::core::panicking::panic_fmt(
                                                                                                    format_args!("invalid bool discriminant"),
                                                                                                );
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                                            5 => {
                                                                                JsonValue::Str({
                                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                                    {
                                                                                        #[cfg(debug_assertions)]
                                                                                        {
                                                                                            String::from_utf8(
                                                                                                    Vec::from_raw_parts(
                                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                                        len8,
                                                                                                        len8,
                                                                                                    ),
                                                                                                )
                                                                                                .unwrap()
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            6 => {
                                                                                JsonValue::Buffer({
                                                                                    let len9 = *((base + 20) as *const i32) as usize;
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len9,
                                                                                        len9,
                                                                                    )
                                                                                })
                                                                            }
                                                                            7 => {
                                                                                JsonValue::Array(JsonArrayRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            8 => {
                                                                                JsonValue::Map(JsonMapRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid enum discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                },
                                                            )
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base10, (len10 as usize) * 24, 8);
                                                result10
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base11, (len11 as usize) * 8, 4);
                                    JsonValueItem {
                                        item: {
                                            {
                                                match arg4 {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match arg5 as i32 {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(f64::from_bits(arg5 as u64)),
                                                    4 => JsonValue::BigInt(arg5),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len1 = arg6 as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(arg5 as i32 as *mut _, len1, len1),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len2 = arg6 as usize;
                                                            Vec::from_raw_parts(arg5 as i32 as *mut _, len2, len2)
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: arg5 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: arg5 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        array_references: result6,
                                        map_references: result11,
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                        match arg11 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg12 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg13 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg13 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_delete<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_text_delete(
                        YText { ref_: arg0 as u32 },
                        arg1 as u32,
                        arg2 as u32,
                        match arg3 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg4 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_observe<T: YDocMethods>(arg0: i32, arg1: i32) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_text_observe(YText { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_text_observe_deep<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_text_observe_deep(YText { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_new<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i64,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result11 = T::y_array_new(
                        match arg0 {
                            0 => None,
                            1 => {
                                Some({
                                    let base5 = arg4;
                                    let len5 = arg5;
                                    let mut result5 = Vec::with_capacity(len5 as usize);
                                    for i in 0..len5 {
                                        let base = base5 + i * 8;
                                        result5
                                            .push({
                                                let base4 = *((base + 0) as *const i32);
                                                let len4 = *((base + 4) as *const i32);
                                                let mut result4 = Vec::with_capacity(len4 as usize);
                                                for i in 0..len4 {
                                                    let base = base4 + i * 16;
                                                    result4
                                                        .push({
                                                            {
                                                                match i32::from(*((base + 0) as *const u8)) {
                                                                    0 => JsonValue::Null,
                                                                    1 => JsonValue::Undefined,
                                                                    2 => {
                                                                        JsonValue::Boolean({
                                                                            #[cfg(debug_assertions)]
                                                                            {
                                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                                    0 => false,
                                                                                    1 => true,
                                                                                    _ => {
                                                                                        ::core::panicking::panic_fmt(
                                                                                            format_args!("invalid bool discriminant"),
                                                                                        );
                                                                                    }
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                                    5 => {
                                                                        JsonValue::Str({
                                                                            let len2 = *((base + 12) as *const i32) as usize;
                                                                            {
                                                                                #[cfg(debug_assertions)]
                                                                                {
                                                                                    String::from_utf8(
                                                                                            Vec::from_raw_parts(
                                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                                len2,
                                                                                                len2,
                                                                                            ),
                                                                                        )
                                                                                        .unwrap()
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    6 => {
                                                                        JsonValue::Buffer({
                                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len3,
                                                                                len3,
                                                                            )
                                                                        })
                                                                    }
                                                                    7 => {
                                                                        JsonValue::Array(JsonArrayRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    8 => {
                                                                        JsonValue::Map(JsonMapRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base4, (len4 as usize) * 16, 8);
                                                result4
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base5, (len5 as usize) * 8, 4);
                                    let base10 = arg6;
                                    let len10 = arg7;
                                    let mut result10 = Vec::with_capacity(len10 as usize);
                                    for i in 0..len10 {
                                        let base = base10 + i * 8;
                                        result10
                                            .push({
                                                let base9 = *((base + 0) as *const i32);
                                                let len9 = *((base + 4) as *const i32);
                                                let mut result9 = Vec::with_capacity(len9 as usize);
                                                for i in 0..len9 {
                                                    let base = base9 + i * 24;
                                                    result9
                                                        .push({
                                                            let len6 = *((base + 4) as *const i32) as usize;
                                                            (
                                                                {
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        String::from_utf8(
                                                                                Vec::from_raw_parts(
                                                                                    *((base + 0) as *const i32) as *mut _,
                                                                                    len6,
                                                                                    len6,
                                                                                ),
                                                                            )
                                                                            .unwrap()
                                                                    }
                                                                },
                                                                {
                                                                    {
                                                                        match i32::from(*((base + 8) as *const u8)) {
                                                                            0 => JsonValue::Null,
                                                                            1 => JsonValue::Undefined,
                                                                            2 => {
                                                                                JsonValue::Boolean({
                                                                                    #[cfg(debug_assertions)]
                                                                                    {
                                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                                            0 => false,
                                                                                            1 => true,
                                                                                            _ => {
                                                                                                ::core::panicking::panic_fmt(
                                                                                                    format_args!("invalid bool discriminant"),
                                                                                                );
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                                            5 => {
                                                                                JsonValue::Str({
                                                                                    let len7 = *((base + 20) as *const i32) as usize;
                                                                                    {
                                                                                        #[cfg(debug_assertions)]
                                                                                        {
                                                                                            String::from_utf8(
                                                                                                    Vec::from_raw_parts(
                                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                                        len7,
                                                                                                        len7,
                                                                                                    ),
                                                                                                )
                                                                                                .unwrap()
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            6 => {
                                                                                JsonValue::Buffer({
                                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len8,
                                                                                        len8,
                                                                                    )
                                                                                })
                                                                            }
                                                                            7 => {
                                                                                JsonValue::Array(JsonArrayRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            8 => {
                                                                                JsonValue::Map(JsonMapRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid enum discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                },
                                                            )
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base9, (len9 as usize) * 24, 8);
                                                result9
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base10, (len10 as usize) * 8, 4);
                                    JsonValueItem {
                                        item: {
                                            {
                                                match arg1 {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match arg2 as i32 {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(f64::from_bits(arg2 as u64)),
                                                    4 => JsonValue::BigInt(arg2),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len0 = arg3 as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(arg2 as i32 as *mut _, len0, len0),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len1 = arg3 as usize;
                                                            Vec::from_raw_parts(arg2 as i32 as *mut _, len1, len1)
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: arg2 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: arg2 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        array_references: result5,
                                        map_references: result10,
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let YArray { ref_: ref_12 } = result11;
                    wit_bindgen::rt::as_i32(ref_12)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_prelim<T: YDocMethods>(arg0: i32) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_array_prelim(YArray { ref_: arg0 as u32 });
                    match result0 {
                        true => 1,
                        false => 0,
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_length<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_array_length(
                        YArray { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::as_i32(result0)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_to_json<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_array_to_json(
                        YArray { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let JsonValueItem {
                        item: item2,
                        array_references: array_references2,
                        map_references: map_references2,
                    } = result0;
                    match item2 {
                        JsonValue::Null => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                        }
                        JsonValue::Undefined => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                        }
                        JsonValue::Boolean(e) => {
                            *((ptr1 + 0) as *mut u8) = (2i32) as u8;
                            *((ptr1 + 8)
                                as *mut u8) = (match e {
                                true => 1,
                                false => 0,
                            }) as u8;
                        }
                        JsonValue::Number(e) => {
                            *((ptr1 + 0) as *mut u8) = (3i32) as u8;
                            *((ptr1 + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
                        }
                        JsonValue::BigInt(e) => {
                            *((ptr1 + 0) as *mut u8) = (4i32) as u8;
                            *((ptr1 + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                        }
                        JsonValue::Str(e) => {
                            *((ptr1 + 0) as *mut u8) = (5i32) as u8;
                            let vec3 = (e.into_bytes()).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr1 + 12) as *mut i32) = len3;
                            *((ptr1 + 8) as *mut i32) = ptr3;
                        }
                        JsonValue::Buffer(e) => {
                            *((ptr1 + 0) as *mut u8) = (6i32) as u8;
                            let vec4 = (e).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr1 + 12) as *mut i32) = len4;
                            *((ptr1 + 8) as *mut i32) = ptr4;
                        }
                        JsonValue::Array(e) => {
                            *((ptr1 + 0) as *mut u8) = (7i32) as u8;
                            let JsonArrayRef { index: index5 } = e;
                            *((ptr1 + 8) as *mut i32) = wit_bindgen::rt::as_i32(index5);
                        }
                        JsonValue::Map(e) => {
                            *((ptr1 + 0) as *mut u8) = (8i32) as u8;
                            let JsonMapRef { index: index6 } = e;
                            *((ptr1 + 8) as *mut i32) = wit_bindgen::rt::as_i32(index6);
                        }
                    };
                    let vec12 = array_references2;
                    let len12 = vec12.len() as i32;
                    let layout12 = alloc::Layout::from_size_align_unchecked(
                        vec12.len() * 8,
                        4,
                    );
                    let result12 = if layout12.size() != 0 {
                        let ptr = alloc::alloc(layout12);
                        if ptr.is_null() {
                            alloc::handle_alloc_error(layout12);
                        }
                        ptr
                    } else {
                        ::core::ptr::null_mut()
                    };
                    for (i, e) in vec12.into_iter().enumerate() {
                        let base = result12 as i32 + (i as i32) * 8;
                        {
                            let vec11 = e;
                            let len11 = vec11.len() as i32;
                            let layout11 = alloc::Layout::from_size_align_unchecked(
                                vec11.len() * 16,
                                8,
                            );
                            let result11 = if layout11.size() != 0 {
                                let ptr = alloc::alloc(layout11);
                                if ptr.is_null() {
                                    alloc::handle_alloc_error(layout11);
                                }
                                ptr
                            } else {
                                ::core::ptr::null_mut()
                            };
                            for (i, e) in vec11.into_iter().enumerate() {
                                let base = result11 as i32 + (i as i32) * 16;
                                {
                                    match e {
                                        JsonValue::Null => {
                                            *((base + 0) as *mut u8) = (0i32) as u8;
                                        }
                                        JsonValue::Undefined => {
                                            *((base + 0) as *mut u8) = (1i32) as u8;
                                        }
                                        JsonValue::Boolean(e) => {
                                            *((base + 0) as *mut u8) = (2i32) as u8;
                                            *((base + 8)
                                                as *mut u8) = (match e {
                                                true => 1,
                                                false => 0,
                                            }) as u8;
                                        }
                                        JsonValue::Number(e) => {
                                            *((base + 0) as *mut u8) = (3i32) as u8;
                                            *((base + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                        }
                                        JsonValue::BigInt(e) => {
                                            *((base + 0) as *mut u8) = (4i32) as u8;
                                            *((base + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                        }
                                        JsonValue::Str(e) => {
                                            *((base + 0) as *mut u8) = (5i32) as u8;
                                            let vec7 = (e.into_bytes()).into_boxed_slice();
                                            let ptr7 = vec7.as_ptr() as i32;
                                            let len7 = vec7.len() as i32;
                                            ::core::mem::forget(vec7);
                                            *((base + 12) as *mut i32) = len7;
                                            *((base + 8) as *mut i32) = ptr7;
                                        }
                                        JsonValue::Buffer(e) => {
                                            *((base + 0) as *mut u8) = (6i32) as u8;
                                            let vec8 = (e).into_boxed_slice();
                                            let ptr8 = vec8.as_ptr() as i32;
                                            let len8 = vec8.len() as i32;
                                            ::core::mem::forget(vec8);
                                            *((base + 12) as *mut i32) = len8;
                                            *((base + 8) as *mut i32) = ptr8;
                                        }
                                        JsonValue::Array(e) => {
                                            *((base + 0) as *mut u8) = (7i32) as u8;
                                            let JsonArrayRef { index: index9 } = e;
                                            *((base + 8) as *mut i32) = wit_bindgen::rt::as_i32(index9);
                                        }
                                        JsonValue::Map(e) => {
                                            *((base + 0) as *mut u8) = (8i32) as u8;
                                            let JsonMapRef { index: index10 } = e;
                                            *((base + 8)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index10);
                                        }
                                    };
                                }
                            }
                            *((base + 4) as *mut i32) = len11;
                            *((base + 0) as *mut i32) = result11 as i32;
                        }
                    }
                    *((ptr1 + 20) as *mut i32) = len12;
                    *((ptr1 + 16) as *mut i32) = result12 as i32;
                    let vec20 = map_references2;
                    let len20 = vec20.len() as i32;
                    let layout20 = alloc::Layout::from_size_align_unchecked(
                        vec20.len() * 8,
                        4,
                    );
                    let result20 = if layout20.size() != 0 {
                        let ptr = alloc::alloc(layout20);
                        if ptr.is_null() {
                            alloc::handle_alloc_error(layout20);
                        }
                        ptr
                    } else {
                        ::core::ptr::null_mut()
                    };
                    for (i, e) in vec20.into_iter().enumerate() {
                        let base = result20 as i32 + (i as i32) * 8;
                        {
                            let vec19 = e;
                            let len19 = vec19.len() as i32;
                            let layout19 = alloc::Layout::from_size_align_unchecked(
                                vec19.len() * 24,
                                8,
                            );
                            let result19 = if layout19.size() != 0 {
                                let ptr = alloc::alloc(layout19);
                                if ptr.is_null() {
                                    alloc::handle_alloc_error(layout19);
                                }
                                ptr
                            } else {
                                ::core::ptr::null_mut()
                            };
                            for (i, e) in vec19.into_iter().enumerate() {
                                let base = result19 as i32 + (i as i32) * 24;
                                {
                                    let (t13_0, t13_1) = e;
                                    let vec14 = (t13_0.into_bytes()).into_boxed_slice();
                                    let ptr14 = vec14.as_ptr() as i32;
                                    let len14 = vec14.len() as i32;
                                    ::core::mem::forget(vec14);
                                    *((base + 4) as *mut i32) = len14;
                                    *((base + 0) as *mut i32) = ptr14;
                                    match t13_1 {
                                        JsonValue::Null => {
                                            *((base + 8) as *mut u8) = (0i32) as u8;
                                        }
                                        JsonValue::Undefined => {
                                            *((base + 8) as *mut u8) = (1i32) as u8;
                                        }
                                        JsonValue::Boolean(e) => {
                                            *((base + 8) as *mut u8) = (2i32) as u8;
                                            *((base + 16)
                                                as *mut u8) = (match e {
                                                true => 1,
                                                false => 0,
                                            }) as u8;
                                        }
                                        JsonValue::Number(e) => {
                                            *((base + 8) as *mut u8) = (3i32) as u8;
                                            *((base + 16) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                        }
                                        JsonValue::BigInt(e) => {
                                            *((base + 8) as *mut u8) = (4i32) as u8;
                                            *((base + 16) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                        }
                                        JsonValue::Str(e) => {
                                            *((base + 8) as *mut u8) = (5i32) as u8;
                                            let vec15 = (e.into_bytes()).into_boxed_slice();
                                            let ptr15 = vec15.as_ptr() as i32;
                                            let len15 = vec15.len() as i32;
                                            ::core::mem::forget(vec15);
                                            *((base + 20) as *mut i32) = len15;
                                            *((base + 16) as *mut i32) = ptr15;
                                        }
                                        JsonValue::Buffer(e) => {
                                            *((base + 8) as *mut u8) = (6i32) as u8;
                                            let vec16 = (e).into_boxed_slice();
                                            let ptr16 = vec16.as_ptr() as i32;
                                            let len16 = vec16.len() as i32;
                                            ::core::mem::forget(vec16);
                                            *((base + 20) as *mut i32) = len16;
                                            *((base + 16) as *mut i32) = ptr16;
                                        }
                                        JsonValue::Array(e) => {
                                            *((base + 8) as *mut u8) = (7i32) as u8;
                                            let JsonArrayRef { index: index17 } = e;
                                            *((base + 16)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index17);
                                        }
                                        JsonValue::Map(e) => {
                                            *((base + 8) as *mut u8) = (8i32) as u8;
                                            let JsonMapRef { index: index18 } = e;
                                            *((base + 16)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index18);
                                        }
                                    };
                                }
                            }
                            *((base + 4) as *mut i32) = len19;
                            *((base + 0) as *mut i32) = result19 as i32;
                        }
                    }
                    *((ptr1 + 28) as *mut i32) = len20;
                    *((ptr1 + 24) as *mut i32) = result20 as i32;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_array_to_json<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        1 => {}
                        2 => {}
                        3 => {}
                        4 => {}
                        5 => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 8) as *const i32),
                                (*((arg0 + 12) as *const i32)) as usize,
                                1,
                            );
                        }
                        6 => {
                            let base0 = *((arg0 + 8) as *const i32);
                            let len0 = *((arg0 + 12) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                        7 => {}
                        _ => {}
                    }
                    let base3 = *((arg0 + 16) as *const i32);
                    let len3 = *((arg0 + 20) as *const i32);
                    for i in 0..len3 {
                        let base = base3 + i * 8;
                        {
                            let base2 = *((base + 0) as *const i32);
                            let len2 = *((base + 4) as *const i32);
                            for i in 0..len2 {
                                let base = base2 + i * 16;
                                {
                                    match i32::from(*((base + 0) as *const u8)) {
                                        0 => {}
                                        1 => {}
                                        2 => {}
                                        3 => {}
                                        4 => {}
                                        5 => {
                                            wit_bindgen::rt::dealloc(
                                                *((base + 8) as *const i32),
                                                (*((base + 12) as *const i32)) as usize,
                                                1,
                                            );
                                        }
                                        6 => {
                                            let base1 = *((base + 8) as *const i32);
                                            let len1 = *((base + 12) as *const i32);
                                            wit_bindgen::rt::dealloc(base1, (len1 as usize) * 1, 1);
                                        }
                                        7 => {}
                                        _ => {}
                                    }
                                }
                            }
                            wit_bindgen::rt::dealloc(base2, (len2 as usize) * 16, 8);
                        }
                    }
                    wit_bindgen::rt::dealloc(base3, (len3 as usize) * 8, 4);
                    let base6 = *((arg0 + 24) as *const i32);
                    let len6 = *((arg0 + 28) as *const i32);
                    for i in 0..len6 {
                        let base = base6 + i * 8;
                        {
                            let base5 = *((base + 0) as *const i32);
                            let len5 = *((base + 4) as *const i32);
                            for i in 0..len5 {
                                let base = base5 + i * 24;
                                {
                                    wit_bindgen::rt::dealloc(
                                        *((base + 0) as *const i32),
                                        (*((base + 4) as *const i32)) as usize,
                                        1,
                                    );
                                    match i32::from(*((base + 8) as *const u8)) {
                                        0 => {}
                                        1 => {}
                                        2 => {}
                                        3 => {}
                                        4 => {}
                                        5 => {
                                            wit_bindgen::rt::dealloc(
                                                *((base + 16) as *const i32),
                                                (*((base + 20) as *const i32)) as usize,
                                                1,
                                            );
                                        }
                                        6 => {
                                            let base4 = *((base + 16) as *const i32);
                                            let len4 = *((base + 20) as *const i32);
                                            wit_bindgen::rt::dealloc(base4, (len4 as usize) * 1, 1);
                                        }
                                        7 => {}
                                        _ => {}
                                    }
                                }
                            }
                            wit_bindgen::rt::dealloc(base5, (len5 as usize) * 24, 8);
                        }
                    }
                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_insert<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i64,
                    arg4: i32,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                    arg11: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let base5 = arg5;
                    let len5 = arg6;
                    let mut result5 = Vec::with_capacity(len5 as usize);
                    for i in 0..len5 {
                        let base = base5 + i * 8;
                        result5
                            .push({
                                let base4 = *((base + 0) as *const i32);
                                let len4 = *((base + 4) as *const i32);
                                let mut result4 = Vec::with_capacity(len4 as usize);
                                for i in 0..len4 {
                                    let base = base4 + i * 16;
                                    result4
                                        .push({
                                            {
                                                match i32::from(*((base + 0) as *const u8)) {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len2 = *((base + 12) as *const i32) as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len2,
                                                                                len2,
                                                                            ),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                            Vec::from_raw_parts(
                                                                *((base + 8) as *const i32) as *mut _,
                                                                len3,
                                                                len3,
                                                            )
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        });
                                }
                                wit_bindgen::rt::dealloc(base4, (len4 as usize) * 16, 8);
                                result4
                            });
                    }
                    wit_bindgen::rt::dealloc(base5, (len5 as usize) * 8, 4);
                    let base10 = arg7;
                    let len10 = arg8;
                    let mut result10 = Vec::with_capacity(len10 as usize);
                    for i in 0..len10 {
                        let base = base10 + i * 8;
                        result10
                            .push({
                                let base9 = *((base + 0) as *const i32);
                                let len9 = *((base + 4) as *const i32);
                                let mut result9 = Vec::with_capacity(len9 as usize);
                                for i in 0..len9 {
                                    let base = base9 + i * 24;
                                    result9
                                        .push({
                                            let len6 = *((base + 4) as *const i32) as usize;
                                            (
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(
                                                                    *((base + 0) as *const i32) as *mut _,
                                                                    len6,
                                                                    len6,
                                                                ),
                                                            )
                                                            .unwrap()
                                                    }
                                                },
                                                {
                                                    {
                                                        match i32::from(*((base + 8) as *const u8)) {
                                                            0 => JsonValue::Null,
                                                            1 => JsonValue::Undefined,
                                                            2 => {
                                                                JsonValue::Boolean({
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                            0 => false,
                                                                            1 => true,
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid bool discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                            5 => {
                                                                JsonValue::Str({
                                                                    let len7 = *((base + 20) as *const i32) as usize;
                                                                    {
                                                                        #[cfg(debug_assertions)]
                                                                        {
                                                                            String::from_utf8(
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len7,
                                                                                        len7,
                                                                                    ),
                                                                                )
                                                                                .unwrap()
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            6 => {
                                                                JsonValue::Buffer({
                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                    Vec::from_raw_parts(
                                                                        *((base + 16) as *const i32) as *mut _,
                                                                        len8,
                                                                        len8,
                                                                    )
                                                                })
                                                            }
                                                            7 => {
                                                                JsonValue::Array(JsonArrayRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            8 => {
                                                                JsonValue::Map(JsonMapRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            _ => {
                                                                ::core::panicking::panic_fmt(
                                                                    format_args!("invalid enum discriminant"),
                                                                );
                                                            }
                                                        }
                                                    }
                                                },
                                            )
                                        });
                                }
                                wit_bindgen::rt::dealloc(base9, (len9 as usize) * 24, 8);
                                result9
                            });
                    }
                    wit_bindgen::rt::dealloc(base10, (len10 as usize) * 8, 4);
                    T::y_array_insert(
                        YArray { ref_: arg0 as u32 },
                        arg1 as u32,
                        JsonValueItem {
                            item: {
                                {
                                    match arg2 {
                                        0 => JsonValue::Null,
                                        1 => JsonValue::Undefined,
                                        2 => {
                                            JsonValue::Boolean({
                                                #[cfg(debug_assertions)]
                                                {
                                                    match arg3 as i32 {
                                                        0 => false,
                                                        1 => true,
                                                        _ => {
                                                            ::core::panicking::panic_fmt(
                                                                format_args!("invalid bool discriminant"),
                                                            );
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                        3 => JsonValue::Number(f64::from_bits(arg3 as u64)),
                                        4 => JsonValue::BigInt(arg3),
                                        5 => {
                                            JsonValue::Str({
                                                let len0 = arg4 as usize;
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(arg3 as i32 as *mut _, len0, len0),
                                                            )
                                                            .unwrap()
                                                    }
                                                }
                                            })
                                        }
                                        6 => {
                                            JsonValue::Buffer({
                                                let len1 = arg4 as usize;
                                                Vec::from_raw_parts(arg3 as i32 as *mut _, len1, len1)
                                            })
                                        }
                                        7 => {
                                            JsonValue::Array(JsonArrayRef {
                                                index: arg3 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        8 => {
                                            JsonValue::Map(JsonMapRef {
                                                index: arg3 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid enum discriminant"),
                                            );
                                        }
                                    }
                                }
                            },
                            array_references: result5,
                            map_references: result10,
                        },
                        match arg9 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg10 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg11 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg11 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_push<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i64,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let base5 = arg4;
                    let len5 = arg5;
                    let mut result5 = Vec::with_capacity(len5 as usize);
                    for i in 0..len5 {
                        let base = base5 + i * 8;
                        result5
                            .push({
                                let base4 = *((base + 0) as *const i32);
                                let len4 = *((base + 4) as *const i32);
                                let mut result4 = Vec::with_capacity(len4 as usize);
                                for i in 0..len4 {
                                    let base = base4 + i * 16;
                                    result4
                                        .push({
                                            {
                                                match i32::from(*((base + 0) as *const u8)) {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len2 = *((base + 12) as *const i32) as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len2,
                                                                                len2,
                                                                            ),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                            Vec::from_raw_parts(
                                                                *((base + 8) as *const i32) as *mut _,
                                                                len3,
                                                                len3,
                                                            )
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        });
                                }
                                wit_bindgen::rt::dealloc(base4, (len4 as usize) * 16, 8);
                                result4
                            });
                    }
                    wit_bindgen::rt::dealloc(base5, (len5 as usize) * 8, 4);
                    let base10 = arg6;
                    let len10 = arg7;
                    let mut result10 = Vec::with_capacity(len10 as usize);
                    for i in 0..len10 {
                        let base = base10 + i * 8;
                        result10
                            .push({
                                let base9 = *((base + 0) as *const i32);
                                let len9 = *((base + 4) as *const i32);
                                let mut result9 = Vec::with_capacity(len9 as usize);
                                for i in 0..len9 {
                                    let base = base9 + i * 24;
                                    result9
                                        .push({
                                            let len6 = *((base + 4) as *const i32) as usize;
                                            (
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(
                                                                    *((base + 0) as *const i32) as *mut _,
                                                                    len6,
                                                                    len6,
                                                                ),
                                                            )
                                                            .unwrap()
                                                    }
                                                },
                                                {
                                                    {
                                                        match i32::from(*((base + 8) as *const u8)) {
                                                            0 => JsonValue::Null,
                                                            1 => JsonValue::Undefined,
                                                            2 => {
                                                                JsonValue::Boolean({
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                            0 => false,
                                                                            1 => true,
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid bool discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                            5 => {
                                                                JsonValue::Str({
                                                                    let len7 = *((base + 20) as *const i32) as usize;
                                                                    {
                                                                        #[cfg(debug_assertions)]
                                                                        {
                                                                            String::from_utf8(
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len7,
                                                                                        len7,
                                                                                    ),
                                                                                )
                                                                                .unwrap()
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            6 => {
                                                                JsonValue::Buffer({
                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                    Vec::from_raw_parts(
                                                                        *((base + 16) as *const i32) as *mut _,
                                                                        len8,
                                                                        len8,
                                                                    )
                                                                })
                                                            }
                                                            7 => {
                                                                JsonValue::Array(JsonArrayRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            8 => {
                                                                JsonValue::Map(JsonMapRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            _ => {
                                                                ::core::panicking::panic_fmt(
                                                                    format_args!("invalid enum discriminant"),
                                                                );
                                                            }
                                                        }
                                                    }
                                                },
                                            )
                                        });
                                }
                                wit_bindgen::rt::dealloc(base9, (len9 as usize) * 24, 8);
                                result9
                            });
                    }
                    wit_bindgen::rt::dealloc(base10, (len10 as usize) * 8, 4);
                    T::y_array_push(
                        YArray { ref_: arg0 as u32 },
                        JsonValueItem {
                            item: {
                                {
                                    match arg1 {
                                        0 => JsonValue::Null,
                                        1 => JsonValue::Undefined,
                                        2 => {
                                            JsonValue::Boolean({
                                                #[cfg(debug_assertions)]
                                                {
                                                    match arg2 as i32 {
                                                        0 => false,
                                                        1 => true,
                                                        _ => {
                                                            ::core::panicking::panic_fmt(
                                                                format_args!("invalid bool discriminant"),
                                                            );
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                        3 => JsonValue::Number(f64::from_bits(arg2 as u64)),
                                        4 => JsonValue::BigInt(arg2),
                                        5 => {
                                            JsonValue::Str({
                                                let len0 = arg3 as usize;
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(arg2 as i32 as *mut _, len0, len0),
                                                            )
                                                            .unwrap()
                                                    }
                                                }
                                            })
                                        }
                                        6 => {
                                            JsonValue::Buffer({
                                                let len1 = arg3 as usize;
                                                Vec::from_raw_parts(arg2 as i32 as *mut _, len1, len1)
                                            })
                                        }
                                        7 => {
                                            JsonValue::Array(JsonArrayRef {
                                                index: arg2 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        8 => {
                                            JsonValue::Map(JsonMapRef {
                                                index: arg2 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid enum discriminant"),
                                            );
                                        }
                                    }
                                }
                            },
                            array_references: result5,
                            map_references: result10,
                        },
                        match arg8 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg9 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg10 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg10 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_delete<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_array_delete(
                        YArray { ref_: arg0 as u32 },
                        arg1 as u32,
                        arg2 as u32,
                        match arg3 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg4 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_move_content<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_array_move_content(
                        YArray { ref_: arg0 as u32 },
                        arg1 as u32,
                        arg2 as u32,
                        match arg3 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg4 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_get<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_array_get(
                        YArray { ref_: arg0 as u32 },
                        arg1 as u32,
                        match arg2 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg3 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg4 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg4 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result0 {
                        Ok(e) => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                            match e {
                                YValue::JsonValueItem(e) => {
                                    *((ptr1 + 8) as *mut u8) = (0i32) as u8;
                                    let JsonValueItem {
                                        item: item2,
                                        array_references: array_references2,
                                        map_references: map_references2,
                                    } = e;
                                    match item2 {
                                        JsonValue::Null => {
                                            *((ptr1 + 16) as *mut u8) = (0i32) as u8;
                                        }
                                        JsonValue::Undefined => {
                                            *((ptr1 + 16) as *mut u8) = (1i32) as u8;
                                        }
                                        JsonValue::Boolean(e) => {
                                            *((ptr1 + 16) as *mut u8) = (2i32) as u8;
                                            *((ptr1 + 24)
                                                as *mut u8) = (match e {
                                                true => 1,
                                                false => 0,
                                            }) as u8;
                                        }
                                        JsonValue::Number(e) => {
                                            *((ptr1 + 16) as *mut u8) = (3i32) as u8;
                                            *((ptr1 + 24) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                        }
                                        JsonValue::BigInt(e) => {
                                            *((ptr1 + 16) as *mut u8) = (4i32) as u8;
                                            *((ptr1 + 24) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                        }
                                        JsonValue::Str(e) => {
                                            *((ptr1 + 16) as *mut u8) = (5i32) as u8;
                                            let vec3 = (e.into_bytes()).into_boxed_slice();
                                            let ptr3 = vec3.as_ptr() as i32;
                                            let len3 = vec3.len() as i32;
                                            ::core::mem::forget(vec3);
                                            *((ptr1 + 28) as *mut i32) = len3;
                                            *((ptr1 + 24) as *mut i32) = ptr3;
                                        }
                                        JsonValue::Buffer(e) => {
                                            *((ptr1 + 16) as *mut u8) = (6i32) as u8;
                                            let vec4 = (e).into_boxed_slice();
                                            let ptr4 = vec4.as_ptr() as i32;
                                            let len4 = vec4.len() as i32;
                                            ::core::mem::forget(vec4);
                                            *((ptr1 + 28) as *mut i32) = len4;
                                            *((ptr1 + 24) as *mut i32) = ptr4;
                                        }
                                        JsonValue::Array(e) => {
                                            *((ptr1 + 16) as *mut u8) = (7i32) as u8;
                                            let JsonArrayRef { index: index5 } = e;
                                            *((ptr1 + 24)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index5);
                                        }
                                        JsonValue::Map(e) => {
                                            *((ptr1 + 16) as *mut u8) = (8i32) as u8;
                                            let JsonMapRef { index: index6 } = e;
                                            *((ptr1 + 24)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index6);
                                        }
                                    };
                                    let vec12 = array_references2;
                                    let len12 = vec12.len() as i32;
                                    let layout12 = alloc::Layout::from_size_align_unchecked(
                                        vec12.len() * 8,
                                        4,
                                    );
                                    let result12 = if layout12.size() != 0 {
                                        let ptr = alloc::alloc(layout12);
                                        if ptr.is_null() {
                                            alloc::handle_alloc_error(layout12);
                                        }
                                        ptr
                                    } else {
                                        ::core::ptr::null_mut()
                                    };
                                    for (i, e) in vec12.into_iter().enumerate() {
                                        let base = result12 as i32 + (i as i32) * 8;
                                        {
                                            let vec11 = e;
                                            let len11 = vec11.len() as i32;
                                            let layout11 = alloc::Layout::from_size_align_unchecked(
                                                vec11.len() * 16,
                                                8,
                                            );
                                            let result11 = if layout11.size() != 0 {
                                                let ptr = alloc::alloc(layout11);
                                                if ptr.is_null() {
                                                    alloc::handle_alloc_error(layout11);
                                                }
                                                ptr
                                            } else {
                                                ::core::ptr::null_mut()
                                            };
                                            for (i, e) in vec11.into_iter().enumerate() {
                                                let base = result11 as i32 + (i as i32) * 16;
                                                {
                                                    match e {
                                                        JsonValue::Null => {
                                                            *((base + 0) as *mut u8) = (0i32) as u8;
                                                        }
                                                        JsonValue::Undefined => {
                                                            *((base + 0) as *mut u8) = (1i32) as u8;
                                                        }
                                                        JsonValue::Boolean(e) => {
                                                            *((base + 0) as *mut u8) = (2i32) as u8;
                                                            *((base + 8)
                                                                as *mut u8) = (match e {
                                                                true => 1,
                                                                false => 0,
                                                            }) as u8;
                                                        }
                                                        JsonValue::Number(e) => {
                                                            *((base + 0) as *mut u8) = (3i32) as u8;
                                                            *((base + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                                        }
                                                        JsonValue::BigInt(e) => {
                                                            *((base + 0) as *mut u8) = (4i32) as u8;
                                                            *((base + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                                        }
                                                        JsonValue::Str(e) => {
                                                            *((base + 0) as *mut u8) = (5i32) as u8;
                                                            let vec7 = (e.into_bytes()).into_boxed_slice();
                                                            let ptr7 = vec7.as_ptr() as i32;
                                                            let len7 = vec7.len() as i32;
                                                            ::core::mem::forget(vec7);
                                                            *((base + 12) as *mut i32) = len7;
                                                            *((base + 8) as *mut i32) = ptr7;
                                                        }
                                                        JsonValue::Buffer(e) => {
                                                            *((base + 0) as *mut u8) = (6i32) as u8;
                                                            let vec8 = (e).into_boxed_slice();
                                                            let ptr8 = vec8.as_ptr() as i32;
                                                            let len8 = vec8.len() as i32;
                                                            ::core::mem::forget(vec8);
                                                            *((base + 12) as *mut i32) = len8;
                                                            *((base + 8) as *mut i32) = ptr8;
                                                        }
                                                        JsonValue::Array(e) => {
                                                            *((base + 0) as *mut u8) = (7i32) as u8;
                                                            let JsonArrayRef { index: index9 } = e;
                                                            *((base + 8) as *mut i32) = wit_bindgen::rt::as_i32(index9);
                                                        }
                                                        JsonValue::Map(e) => {
                                                            *((base + 0) as *mut u8) = (8i32) as u8;
                                                            let JsonMapRef { index: index10 } = e;
                                                            *((base + 8)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index10);
                                                        }
                                                    };
                                                }
                                            }
                                            *((base + 4) as *mut i32) = len11;
                                            *((base + 0) as *mut i32) = result11 as i32;
                                        }
                                    }
                                    *((ptr1 + 36) as *mut i32) = len12;
                                    *((ptr1 + 32) as *mut i32) = result12 as i32;
                                    let vec20 = map_references2;
                                    let len20 = vec20.len() as i32;
                                    let layout20 = alloc::Layout::from_size_align_unchecked(
                                        vec20.len() * 8,
                                        4,
                                    );
                                    let result20 = if layout20.size() != 0 {
                                        let ptr = alloc::alloc(layout20);
                                        if ptr.is_null() {
                                            alloc::handle_alloc_error(layout20);
                                        }
                                        ptr
                                    } else {
                                        ::core::ptr::null_mut()
                                    };
                                    for (i, e) in vec20.into_iter().enumerate() {
                                        let base = result20 as i32 + (i as i32) * 8;
                                        {
                                            let vec19 = e;
                                            let len19 = vec19.len() as i32;
                                            let layout19 = alloc::Layout::from_size_align_unchecked(
                                                vec19.len() * 24,
                                                8,
                                            );
                                            let result19 = if layout19.size() != 0 {
                                                let ptr = alloc::alloc(layout19);
                                                if ptr.is_null() {
                                                    alloc::handle_alloc_error(layout19);
                                                }
                                                ptr
                                            } else {
                                                ::core::ptr::null_mut()
                                            };
                                            for (i, e) in vec19.into_iter().enumerate() {
                                                let base = result19 as i32 + (i as i32) * 24;
                                                {
                                                    let (t13_0, t13_1) = e;
                                                    let vec14 = (t13_0.into_bytes()).into_boxed_slice();
                                                    let ptr14 = vec14.as_ptr() as i32;
                                                    let len14 = vec14.len() as i32;
                                                    ::core::mem::forget(vec14);
                                                    *((base + 4) as *mut i32) = len14;
                                                    *((base + 0) as *mut i32) = ptr14;
                                                    match t13_1 {
                                                        JsonValue::Null => {
                                                            *((base + 8) as *mut u8) = (0i32) as u8;
                                                        }
                                                        JsonValue::Undefined => {
                                                            *((base + 8) as *mut u8) = (1i32) as u8;
                                                        }
                                                        JsonValue::Boolean(e) => {
                                                            *((base + 8) as *mut u8) = (2i32) as u8;
                                                            *((base + 16)
                                                                as *mut u8) = (match e {
                                                                true => 1,
                                                                false => 0,
                                                            }) as u8;
                                                        }
                                                        JsonValue::Number(e) => {
                                                            *((base + 8) as *mut u8) = (3i32) as u8;
                                                            *((base + 16) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                                        }
                                                        JsonValue::BigInt(e) => {
                                                            *((base + 8) as *mut u8) = (4i32) as u8;
                                                            *((base + 16) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                                        }
                                                        JsonValue::Str(e) => {
                                                            *((base + 8) as *mut u8) = (5i32) as u8;
                                                            let vec15 = (e.into_bytes()).into_boxed_slice();
                                                            let ptr15 = vec15.as_ptr() as i32;
                                                            let len15 = vec15.len() as i32;
                                                            ::core::mem::forget(vec15);
                                                            *((base + 20) as *mut i32) = len15;
                                                            *((base + 16) as *mut i32) = ptr15;
                                                        }
                                                        JsonValue::Buffer(e) => {
                                                            *((base + 8) as *mut u8) = (6i32) as u8;
                                                            let vec16 = (e).into_boxed_slice();
                                                            let ptr16 = vec16.as_ptr() as i32;
                                                            let len16 = vec16.len() as i32;
                                                            ::core::mem::forget(vec16);
                                                            *((base + 20) as *mut i32) = len16;
                                                            *((base + 16) as *mut i32) = ptr16;
                                                        }
                                                        JsonValue::Array(e) => {
                                                            *((base + 8) as *mut u8) = (7i32) as u8;
                                                            let JsonArrayRef { index: index17 } = e;
                                                            *((base + 16)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index17);
                                                        }
                                                        JsonValue::Map(e) => {
                                                            *((base + 8) as *mut u8) = (8i32) as u8;
                                                            let JsonMapRef { index: index18 } = e;
                                                            *((base + 16)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index18);
                                                        }
                                                    };
                                                }
                                            }
                                            *((base + 4) as *mut i32) = len19;
                                            *((base + 0) as *mut i32) = result19 as i32;
                                        }
                                    }
                                    *((ptr1 + 44) as *mut i32) = len20;
                                    *((ptr1 + 40) as *mut i32) = result20 as i32;
                                }
                                YValue::YText(e) => {
                                    *((ptr1 + 8) as *mut u8) = (1i32) as u8;
                                    let YText { ref_: ref_21 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_21);
                                }
                                YValue::YArray(e) => {
                                    *((ptr1 + 8) as *mut u8) = (2i32) as u8;
                                    let YArray { ref_: ref_22 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_22);
                                }
                                YValue::YMap(e) => {
                                    *((ptr1 + 8) as *mut u8) = (3i32) as u8;
                                    let YMap { ref_: ref_23 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_23);
                                }
                                YValue::YXmlFragment(e) => {
                                    *((ptr1 + 8) as *mut u8) = (4i32) as u8;
                                    let YXmlFragment { ref_: ref_24 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_24);
                                }
                                YValue::YXmlElement(e) => {
                                    *((ptr1 + 8) as *mut u8) = (5i32) as u8;
                                    let YXmlElement { ref_: ref_25 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_25);
                                }
                                YValue::YXmlText(e) => {
                                    *((ptr1 + 8) as *mut u8) = (6i32) as u8;
                                    let YXmlText { ref_: ref_26 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_26);
                                }
                                YValue::YDoc(e) => {
                                    *((ptr1 + 8) as *mut u8) = (7i32) as u8;
                                    let YDoc { ref_: ref_27 } = e;
                                    *((ptr1 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_27);
                                }
                            };
                        }
                        Err(e) => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                            let vec28 = (e.into_bytes()).into_boxed_slice();
                            let ptr28 = vec28.as_ptr() as i32;
                            let len28 = vec28.len() as i32;
                            ::core::mem::forget(vec28);
                            *((ptr1 + 12) as *mut i32) = len28;
                            *((ptr1 + 8) as *mut i32) = ptr28;
                        }
                    };
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_array_get<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {
                            match i32::from(*((arg0 + 8) as *const u8)) {
                                0 => {
                                    match i32::from(*((arg0 + 16) as *const u8)) {
                                        0 => {}
                                        1 => {}
                                        2 => {}
                                        3 => {}
                                        4 => {}
                                        5 => {
                                            wit_bindgen::rt::dealloc(
                                                *((arg0 + 24) as *const i32),
                                                (*((arg0 + 28) as *const i32)) as usize,
                                                1,
                                            );
                                        }
                                        6 => {
                                            let base0 = *((arg0 + 24) as *const i32);
                                            let len0 = *((arg0 + 28) as *const i32);
                                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                                        }
                                        7 => {}
                                        _ => {}
                                    }
                                    let base3 = *((arg0 + 32) as *const i32);
                                    let len3 = *((arg0 + 36) as *const i32);
                                    for i in 0..len3 {
                                        let base = base3 + i * 8;
                                        {
                                            let base2 = *((base + 0) as *const i32);
                                            let len2 = *((base + 4) as *const i32);
                                            for i in 0..len2 {
                                                let base = base2 + i * 16;
                                                {
                                                    match i32::from(*((base + 0) as *const u8)) {
                                                        0 => {}
                                                        1 => {}
                                                        2 => {}
                                                        3 => {}
                                                        4 => {}
                                                        5 => {
                                                            wit_bindgen::rt::dealloc(
                                                                *((base + 8) as *const i32),
                                                                (*((base + 12) as *const i32)) as usize,
                                                                1,
                                                            );
                                                        }
                                                        6 => {
                                                            let base1 = *((base + 8) as *const i32);
                                                            let len1 = *((base + 12) as *const i32);
                                                            wit_bindgen::rt::dealloc(base1, (len1 as usize) * 1, 1);
                                                        }
                                                        7 => {}
                                                        _ => {}
                                                    }
                                                }
                                            }
                                            wit_bindgen::rt::dealloc(base2, (len2 as usize) * 16, 8);
                                        }
                                    }
                                    wit_bindgen::rt::dealloc(base3, (len3 as usize) * 8, 4);
                                    let base6 = *((arg0 + 40) as *const i32);
                                    let len6 = *((arg0 + 44) as *const i32);
                                    for i in 0..len6 {
                                        let base = base6 + i * 8;
                                        {
                                            let base5 = *((base + 0) as *const i32);
                                            let len5 = *((base + 4) as *const i32);
                                            for i in 0..len5 {
                                                let base = base5 + i * 24;
                                                {
                                                    wit_bindgen::rt::dealloc(
                                                        *((base + 0) as *const i32),
                                                        (*((base + 4) as *const i32)) as usize,
                                                        1,
                                                    );
                                                    match i32::from(*((base + 8) as *const u8)) {
                                                        0 => {}
                                                        1 => {}
                                                        2 => {}
                                                        3 => {}
                                                        4 => {}
                                                        5 => {
                                                            wit_bindgen::rt::dealloc(
                                                                *((base + 16) as *const i32),
                                                                (*((base + 20) as *const i32)) as usize,
                                                                1,
                                                            );
                                                        }
                                                        6 => {
                                                            let base4 = *((base + 16) as *const i32);
                                                            let len4 = *((base + 20) as *const i32);
                                                            wit_bindgen::rt::dealloc(base4, (len4 as usize) * 1, 1);
                                                        }
                                                        7 => {}
                                                        _ => {}
                                                    }
                                                }
                                            }
                                            wit_bindgen::rt::dealloc(base5, (len5 as usize) * 24, 8);
                                        }
                                    }
                                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                                }
                                1 => {}
                                2 => {}
                                3 => {}
                                4 => {}
                                5 => {}
                                6 => {}
                                _ => {}
                            }
                        }
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 8) as *const i32),
                                (*((arg0 + 12) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_observe<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_array_observe(YArray { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_array_observe_deep<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_array_observe_deep(YArray { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_new<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i64,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result11 = T::y_map_new(
                        match arg0 {
                            0 => None,
                            1 => {
                                Some({
                                    let base5 = arg4;
                                    let len5 = arg5;
                                    let mut result5 = Vec::with_capacity(len5 as usize);
                                    for i in 0..len5 {
                                        let base = base5 + i * 8;
                                        result5
                                            .push({
                                                let base4 = *((base + 0) as *const i32);
                                                let len4 = *((base + 4) as *const i32);
                                                let mut result4 = Vec::with_capacity(len4 as usize);
                                                for i in 0..len4 {
                                                    let base = base4 + i * 16;
                                                    result4
                                                        .push({
                                                            {
                                                                match i32::from(*((base + 0) as *const u8)) {
                                                                    0 => JsonValue::Null,
                                                                    1 => JsonValue::Undefined,
                                                                    2 => {
                                                                        JsonValue::Boolean({
                                                                            #[cfg(debug_assertions)]
                                                                            {
                                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                                    0 => false,
                                                                                    1 => true,
                                                                                    _ => {
                                                                                        ::core::panicking::panic_fmt(
                                                                                            format_args!("invalid bool discriminant"),
                                                                                        );
                                                                                    }
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                                    5 => {
                                                                        JsonValue::Str({
                                                                            let len2 = *((base + 12) as *const i32) as usize;
                                                                            {
                                                                                #[cfg(debug_assertions)]
                                                                                {
                                                                                    String::from_utf8(
                                                                                            Vec::from_raw_parts(
                                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                                len2,
                                                                                                len2,
                                                                                            ),
                                                                                        )
                                                                                        .unwrap()
                                                                                }
                                                                            }
                                                                        })
                                                                    }
                                                                    6 => {
                                                                        JsonValue::Buffer({
                                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len3,
                                                                                len3,
                                                                            )
                                                                        })
                                                                    }
                                                                    7 => {
                                                                        JsonValue::Array(JsonArrayRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    8 => {
                                                                        JsonValue::Map(JsonMapRef {
                                                                            index: *((base + 8) as *const i32) as u32,
                                                                        })
                                                                    }
                                                                    #[cfg(debug_assertions)]
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid enum discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base4, (len4 as usize) * 16, 8);
                                                result4
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base5, (len5 as usize) * 8, 4);
                                    let base10 = arg6;
                                    let len10 = arg7;
                                    let mut result10 = Vec::with_capacity(len10 as usize);
                                    for i in 0..len10 {
                                        let base = base10 + i * 8;
                                        result10
                                            .push({
                                                let base9 = *((base + 0) as *const i32);
                                                let len9 = *((base + 4) as *const i32);
                                                let mut result9 = Vec::with_capacity(len9 as usize);
                                                for i in 0..len9 {
                                                    let base = base9 + i * 24;
                                                    result9
                                                        .push({
                                                            let len6 = *((base + 4) as *const i32) as usize;
                                                            (
                                                                {
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        String::from_utf8(
                                                                                Vec::from_raw_parts(
                                                                                    *((base + 0) as *const i32) as *mut _,
                                                                                    len6,
                                                                                    len6,
                                                                                ),
                                                                            )
                                                                            .unwrap()
                                                                    }
                                                                },
                                                                {
                                                                    {
                                                                        match i32::from(*((base + 8) as *const u8)) {
                                                                            0 => JsonValue::Null,
                                                                            1 => JsonValue::Undefined,
                                                                            2 => {
                                                                                JsonValue::Boolean({
                                                                                    #[cfg(debug_assertions)]
                                                                                    {
                                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                                            0 => false,
                                                                                            1 => true,
                                                                                            _ => {
                                                                                                ::core::panicking::panic_fmt(
                                                                                                    format_args!("invalid bool discriminant"),
                                                                                                );
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                                            5 => {
                                                                                JsonValue::Str({
                                                                                    let len7 = *((base + 20) as *const i32) as usize;
                                                                                    {
                                                                                        #[cfg(debug_assertions)]
                                                                                        {
                                                                                            String::from_utf8(
                                                                                                    Vec::from_raw_parts(
                                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                                        len7,
                                                                                                        len7,
                                                                                                    ),
                                                                                                )
                                                                                                .unwrap()
                                                                                        }
                                                                                    }
                                                                                })
                                                                            }
                                                                            6 => {
                                                                                JsonValue::Buffer({
                                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len8,
                                                                                        len8,
                                                                                    )
                                                                                })
                                                                            }
                                                                            7 => {
                                                                                JsonValue::Array(JsonArrayRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            8 => {
                                                                                JsonValue::Map(JsonMapRef {
                                                                                    index: *((base + 16) as *const i32) as u32,
                                                                                })
                                                                            }
                                                                            #[cfg(debug_assertions)]
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid enum discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                },
                                                            )
                                                        });
                                                }
                                                wit_bindgen::rt::dealloc(base9, (len9 as usize) * 24, 8);
                                                result9
                                            });
                                    }
                                    wit_bindgen::rt::dealloc(base10, (len10 as usize) * 8, 4);
                                    JsonValueItem {
                                        item: {
                                            {
                                                match arg1 {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match arg2 as i32 {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(f64::from_bits(arg2 as u64)),
                                                    4 => JsonValue::BigInt(arg2),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len0 = arg3 as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(arg2 as i32 as *mut _, len0, len0),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len1 = arg3 as usize;
                                                            Vec::from_raw_parts(arg2 as i32 as *mut _, len1, len1)
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: arg2 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: arg2 as i32 as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        },
                                        array_references: result5,
                                        map_references: result10,
                                    }
                                })
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let YMap { ref_: ref_12 } = result11;
                    wit_bindgen::rt::as_i32(ref_12)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_prelim<T: YDocMethods>(arg0: i32) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_map_prelim(YMap { ref_: arg0 as u32 });
                    match result0 {
                        true => 1,
                        false => 0,
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_length<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_map_length(
                        YMap { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::as_i32(result0)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_to_json<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_map_to_json(
                        YMap { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    let JsonValueItem {
                        item: item2,
                        array_references: array_references2,
                        map_references: map_references2,
                    } = result0;
                    match item2 {
                        JsonValue::Null => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                        }
                        JsonValue::Undefined => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                        }
                        JsonValue::Boolean(e) => {
                            *((ptr1 + 0) as *mut u8) = (2i32) as u8;
                            *((ptr1 + 8)
                                as *mut u8) = (match e {
                                true => 1,
                                false => 0,
                            }) as u8;
                        }
                        JsonValue::Number(e) => {
                            *((ptr1 + 0) as *mut u8) = (3i32) as u8;
                            *((ptr1 + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
                        }
                        JsonValue::BigInt(e) => {
                            *((ptr1 + 0) as *mut u8) = (4i32) as u8;
                            *((ptr1 + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                        }
                        JsonValue::Str(e) => {
                            *((ptr1 + 0) as *mut u8) = (5i32) as u8;
                            let vec3 = (e.into_bytes()).into_boxed_slice();
                            let ptr3 = vec3.as_ptr() as i32;
                            let len3 = vec3.len() as i32;
                            ::core::mem::forget(vec3);
                            *((ptr1 + 12) as *mut i32) = len3;
                            *((ptr1 + 8) as *mut i32) = ptr3;
                        }
                        JsonValue::Buffer(e) => {
                            *((ptr1 + 0) as *mut u8) = (6i32) as u8;
                            let vec4 = (e).into_boxed_slice();
                            let ptr4 = vec4.as_ptr() as i32;
                            let len4 = vec4.len() as i32;
                            ::core::mem::forget(vec4);
                            *((ptr1 + 12) as *mut i32) = len4;
                            *((ptr1 + 8) as *mut i32) = ptr4;
                        }
                        JsonValue::Array(e) => {
                            *((ptr1 + 0) as *mut u8) = (7i32) as u8;
                            let JsonArrayRef { index: index5 } = e;
                            *((ptr1 + 8) as *mut i32) = wit_bindgen::rt::as_i32(index5);
                        }
                        JsonValue::Map(e) => {
                            *((ptr1 + 0) as *mut u8) = (8i32) as u8;
                            let JsonMapRef { index: index6 } = e;
                            *((ptr1 + 8) as *mut i32) = wit_bindgen::rt::as_i32(index6);
                        }
                    };
                    let vec12 = array_references2;
                    let len12 = vec12.len() as i32;
                    let layout12 = alloc::Layout::from_size_align_unchecked(
                        vec12.len() * 8,
                        4,
                    );
                    let result12 = if layout12.size() != 0 {
                        let ptr = alloc::alloc(layout12);
                        if ptr.is_null() {
                            alloc::handle_alloc_error(layout12);
                        }
                        ptr
                    } else {
                        ::core::ptr::null_mut()
                    };
                    for (i, e) in vec12.into_iter().enumerate() {
                        let base = result12 as i32 + (i as i32) * 8;
                        {
                            let vec11 = e;
                            let len11 = vec11.len() as i32;
                            let layout11 = alloc::Layout::from_size_align_unchecked(
                                vec11.len() * 16,
                                8,
                            );
                            let result11 = if layout11.size() != 0 {
                                let ptr = alloc::alloc(layout11);
                                if ptr.is_null() {
                                    alloc::handle_alloc_error(layout11);
                                }
                                ptr
                            } else {
                                ::core::ptr::null_mut()
                            };
                            for (i, e) in vec11.into_iter().enumerate() {
                                let base = result11 as i32 + (i as i32) * 16;
                                {
                                    match e {
                                        JsonValue::Null => {
                                            *((base + 0) as *mut u8) = (0i32) as u8;
                                        }
                                        JsonValue::Undefined => {
                                            *((base + 0) as *mut u8) = (1i32) as u8;
                                        }
                                        JsonValue::Boolean(e) => {
                                            *((base + 0) as *mut u8) = (2i32) as u8;
                                            *((base + 8)
                                                as *mut u8) = (match e {
                                                true => 1,
                                                false => 0,
                                            }) as u8;
                                        }
                                        JsonValue::Number(e) => {
                                            *((base + 0) as *mut u8) = (3i32) as u8;
                                            *((base + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                        }
                                        JsonValue::BigInt(e) => {
                                            *((base + 0) as *mut u8) = (4i32) as u8;
                                            *((base + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                        }
                                        JsonValue::Str(e) => {
                                            *((base + 0) as *mut u8) = (5i32) as u8;
                                            let vec7 = (e.into_bytes()).into_boxed_slice();
                                            let ptr7 = vec7.as_ptr() as i32;
                                            let len7 = vec7.len() as i32;
                                            ::core::mem::forget(vec7);
                                            *((base + 12) as *mut i32) = len7;
                                            *((base + 8) as *mut i32) = ptr7;
                                        }
                                        JsonValue::Buffer(e) => {
                                            *((base + 0) as *mut u8) = (6i32) as u8;
                                            let vec8 = (e).into_boxed_slice();
                                            let ptr8 = vec8.as_ptr() as i32;
                                            let len8 = vec8.len() as i32;
                                            ::core::mem::forget(vec8);
                                            *((base + 12) as *mut i32) = len8;
                                            *((base + 8) as *mut i32) = ptr8;
                                        }
                                        JsonValue::Array(e) => {
                                            *((base + 0) as *mut u8) = (7i32) as u8;
                                            let JsonArrayRef { index: index9 } = e;
                                            *((base + 8) as *mut i32) = wit_bindgen::rt::as_i32(index9);
                                        }
                                        JsonValue::Map(e) => {
                                            *((base + 0) as *mut u8) = (8i32) as u8;
                                            let JsonMapRef { index: index10 } = e;
                                            *((base + 8)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index10);
                                        }
                                    };
                                }
                            }
                            *((base + 4) as *mut i32) = len11;
                            *((base + 0) as *mut i32) = result11 as i32;
                        }
                    }
                    *((ptr1 + 20) as *mut i32) = len12;
                    *((ptr1 + 16) as *mut i32) = result12 as i32;
                    let vec20 = map_references2;
                    let len20 = vec20.len() as i32;
                    let layout20 = alloc::Layout::from_size_align_unchecked(
                        vec20.len() * 8,
                        4,
                    );
                    let result20 = if layout20.size() != 0 {
                        let ptr = alloc::alloc(layout20);
                        if ptr.is_null() {
                            alloc::handle_alloc_error(layout20);
                        }
                        ptr
                    } else {
                        ::core::ptr::null_mut()
                    };
                    for (i, e) in vec20.into_iter().enumerate() {
                        let base = result20 as i32 + (i as i32) * 8;
                        {
                            let vec19 = e;
                            let len19 = vec19.len() as i32;
                            let layout19 = alloc::Layout::from_size_align_unchecked(
                                vec19.len() * 24,
                                8,
                            );
                            let result19 = if layout19.size() != 0 {
                                let ptr = alloc::alloc(layout19);
                                if ptr.is_null() {
                                    alloc::handle_alloc_error(layout19);
                                }
                                ptr
                            } else {
                                ::core::ptr::null_mut()
                            };
                            for (i, e) in vec19.into_iter().enumerate() {
                                let base = result19 as i32 + (i as i32) * 24;
                                {
                                    let (t13_0, t13_1) = e;
                                    let vec14 = (t13_0.into_bytes()).into_boxed_slice();
                                    let ptr14 = vec14.as_ptr() as i32;
                                    let len14 = vec14.len() as i32;
                                    ::core::mem::forget(vec14);
                                    *((base + 4) as *mut i32) = len14;
                                    *((base + 0) as *mut i32) = ptr14;
                                    match t13_1 {
                                        JsonValue::Null => {
                                            *((base + 8) as *mut u8) = (0i32) as u8;
                                        }
                                        JsonValue::Undefined => {
                                            *((base + 8) as *mut u8) = (1i32) as u8;
                                        }
                                        JsonValue::Boolean(e) => {
                                            *((base + 8) as *mut u8) = (2i32) as u8;
                                            *((base + 16)
                                                as *mut u8) = (match e {
                                                true => 1,
                                                false => 0,
                                            }) as u8;
                                        }
                                        JsonValue::Number(e) => {
                                            *((base + 8) as *mut u8) = (3i32) as u8;
                                            *((base + 16) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                        }
                                        JsonValue::BigInt(e) => {
                                            *((base + 8) as *mut u8) = (4i32) as u8;
                                            *((base + 16) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                        }
                                        JsonValue::Str(e) => {
                                            *((base + 8) as *mut u8) = (5i32) as u8;
                                            let vec15 = (e.into_bytes()).into_boxed_slice();
                                            let ptr15 = vec15.as_ptr() as i32;
                                            let len15 = vec15.len() as i32;
                                            ::core::mem::forget(vec15);
                                            *((base + 20) as *mut i32) = len15;
                                            *((base + 16) as *mut i32) = ptr15;
                                        }
                                        JsonValue::Buffer(e) => {
                                            *((base + 8) as *mut u8) = (6i32) as u8;
                                            let vec16 = (e).into_boxed_slice();
                                            let ptr16 = vec16.as_ptr() as i32;
                                            let len16 = vec16.len() as i32;
                                            ::core::mem::forget(vec16);
                                            *((base + 20) as *mut i32) = len16;
                                            *((base + 16) as *mut i32) = ptr16;
                                        }
                                        JsonValue::Array(e) => {
                                            *((base + 8) as *mut u8) = (7i32) as u8;
                                            let JsonArrayRef { index: index17 } = e;
                                            *((base + 16)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index17);
                                        }
                                        JsonValue::Map(e) => {
                                            *((base + 8) as *mut u8) = (8i32) as u8;
                                            let JsonMapRef { index: index18 } = e;
                                            *((base + 16)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index18);
                                        }
                                    };
                                }
                            }
                            *((base + 4) as *mut i32) = len19;
                            *((base + 0) as *mut i32) = result19 as i32;
                        }
                    }
                    *((ptr1 + 28) as *mut i32) = len20;
                    *((ptr1 + 24) as *mut i32) = result20 as i32;
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_map_to_json<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        1 => {}
                        2 => {}
                        3 => {}
                        4 => {}
                        5 => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 8) as *const i32),
                                (*((arg0 + 12) as *const i32)) as usize,
                                1,
                            );
                        }
                        6 => {
                            let base0 = *((arg0 + 8) as *const i32);
                            let len0 = *((arg0 + 12) as *const i32);
                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                        }
                        7 => {}
                        _ => {}
                    }
                    let base3 = *((arg0 + 16) as *const i32);
                    let len3 = *((arg0 + 20) as *const i32);
                    for i in 0..len3 {
                        let base = base3 + i * 8;
                        {
                            let base2 = *((base + 0) as *const i32);
                            let len2 = *((base + 4) as *const i32);
                            for i in 0..len2 {
                                let base = base2 + i * 16;
                                {
                                    match i32::from(*((base + 0) as *const u8)) {
                                        0 => {}
                                        1 => {}
                                        2 => {}
                                        3 => {}
                                        4 => {}
                                        5 => {
                                            wit_bindgen::rt::dealloc(
                                                *((base + 8) as *const i32),
                                                (*((base + 12) as *const i32)) as usize,
                                                1,
                                            );
                                        }
                                        6 => {
                                            let base1 = *((base + 8) as *const i32);
                                            let len1 = *((base + 12) as *const i32);
                                            wit_bindgen::rt::dealloc(base1, (len1 as usize) * 1, 1);
                                        }
                                        7 => {}
                                        _ => {}
                                    }
                                }
                            }
                            wit_bindgen::rt::dealloc(base2, (len2 as usize) * 16, 8);
                        }
                    }
                    wit_bindgen::rt::dealloc(base3, (len3 as usize) * 8, 4);
                    let base6 = *((arg0 + 24) as *const i32);
                    let len6 = *((arg0 + 28) as *const i32);
                    for i in 0..len6 {
                        let base = base6 + i * 8;
                        {
                            let base5 = *((base + 0) as *const i32);
                            let len5 = *((base + 4) as *const i32);
                            for i in 0..len5 {
                                let base = base5 + i * 24;
                                {
                                    wit_bindgen::rt::dealloc(
                                        *((base + 0) as *const i32),
                                        (*((base + 4) as *const i32)) as usize,
                                        1,
                                    );
                                    match i32::from(*((base + 8) as *const u8)) {
                                        0 => {}
                                        1 => {}
                                        2 => {}
                                        3 => {}
                                        4 => {}
                                        5 => {
                                            wit_bindgen::rt::dealloc(
                                                *((base + 16) as *const i32),
                                                (*((base + 20) as *const i32)) as usize,
                                                1,
                                            );
                                        }
                                        6 => {
                                            let base4 = *((base + 16) as *const i32);
                                            let len4 = *((base + 20) as *const i32);
                                            wit_bindgen::rt::dealloc(base4, (len4 as usize) * 1, 1);
                                        }
                                        7 => {}
                                        _ => {}
                                    }
                                }
                            }
                            wit_bindgen::rt::dealloc(base5, (len5 as usize) * 24, 8);
                        }
                    }
                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_set<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i64,
                    arg5: i32,
                    arg6: i32,
                    arg7: i32,
                    arg8: i32,
                    arg9: i32,
                    arg10: i32,
                    arg11: i32,
                    arg12: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let base6 = arg6;
                    let len6 = arg7;
                    let mut result6 = Vec::with_capacity(len6 as usize);
                    for i in 0..len6 {
                        let base = base6 + i * 8;
                        result6
                            .push({
                                let base5 = *((base + 0) as *const i32);
                                let len5 = *((base + 4) as *const i32);
                                let mut result5 = Vec::with_capacity(len5 as usize);
                                for i in 0..len5 {
                                    let base = base5 + i * 16;
                                    result5
                                        .push({
                                            {
                                                match i32::from(*((base + 0) as *const u8)) {
                                                    0 => JsonValue::Null,
                                                    1 => JsonValue::Undefined,
                                                    2 => {
                                                        JsonValue::Boolean({
                                                            #[cfg(debug_assertions)]
                                                            {
                                                                match i32::from(*((base + 8) as *const u8)) {
                                                                    0 => false,
                                                                    1 => true,
                                                                    _ => {
                                                                        ::core::panicking::panic_fmt(
                                                                            format_args!("invalid bool discriminant"),
                                                                        );
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }
                                                    3 => JsonValue::Number(*((base + 8) as *const f64)),
                                                    4 => JsonValue::BigInt(*((base + 8) as *const i64)),
                                                    5 => {
                                                        JsonValue::Str({
                                                            let len3 = *((base + 12) as *const i32) as usize;
                                                            {
                                                                #[cfg(debug_assertions)]
                                                                {
                                                                    String::from_utf8(
                                                                            Vec::from_raw_parts(
                                                                                *((base + 8) as *const i32) as *mut _,
                                                                                len3,
                                                                                len3,
                                                                            ),
                                                                        )
                                                                        .unwrap()
                                                                }
                                                            }
                                                        })
                                                    }
                                                    6 => {
                                                        JsonValue::Buffer({
                                                            let len4 = *((base + 12) as *const i32) as usize;
                                                            Vec::from_raw_parts(
                                                                *((base + 8) as *const i32) as *mut _,
                                                                len4,
                                                                len4,
                                                            )
                                                        })
                                                    }
                                                    7 => {
                                                        JsonValue::Array(JsonArrayRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    8 => {
                                                        JsonValue::Map(JsonMapRef {
                                                            index: *((base + 8) as *const i32) as u32,
                                                        })
                                                    }
                                                    #[cfg(debug_assertions)]
                                                    _ => {
                                                        ::core::panicking::panic_fmt(
                                                            format_args!("invalid enum discriminant"),
                                                        );
                                                    }
                                                }
                                            }
                                        });
                                }
                                wit_bindgen::rt::dealloc(base5, (len5 as usize) * 16, 8);
                                result5
                            });
                    }
                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                    let base11 = arg8;
                    let len11 = arg9;
                    let mut result11 = Vec::with_capacity(len11 as usize);
                    for i in 0..len11 {
                        let base = base11 + i * 8;
                        result11
                            .push({
                                let base10 = *((base + 0) as *const i32);
                                let len10 = *((base + 4) as *const i32);
                                let mut result10 = Vec::with_capacity(len10 as usize);
                                for i in 0..len10 {
                                    let base = base10 + i * 24;
                                    result10
                                        .push({
                                            let len7 = *((base + 4) as *const i32) as usize;
                                            (
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(
                                                                    *((base + 0) as *const i32) as *mut _,
                                                                    len7,
                                                                    len7,
                                                                ),
                                                            )
                                                            .unwrap()
                                                    }
                                                },
                                                {
                                                    {
                                                        match i32::from(*((base + 8) as *const u8)) {
                                                            0 => JsonValue::Null,
                                                            1 => JsonValue::Undefined,
                                                            2 => {
                                                                JsonValue::Boolean({
                                                                    #[cfg(debug_assertions)]
                                                                    {
                                                                        match i32::from(*((base + 16) as *const u8)) {
                                                                            0 => false,
                                                                            1 => true,
                                                                            _ => {
                                                                                ::core::panicking::panic_fmt(
                                                                                    format_args!("invalid bool discriminant"),
                                                                                );
                                                                            }
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            3 => JsonValue::Number(*((base + 16) as *const f64)),
                                                            4 => JsonValue::BigInt(*((base + 16) as *const i64)),
                                                            5 => {
                                                                JsonValue::Str({
                                                                    let len8 = *((base + 20) as *const i32) as usize;
                                                                    {
                                                                        #[cfg(debug_assertions)]
                                                                        {
                                                                            String::from_utf8(
                                                                                    Vec::from_raw_parts(
                                                                                        *((base + 16) as *const i32) as *mut _,
                                                                                        len8,
                                                                                        len8,
                                                                                    ),
                                                                                )
                                                                                .unwrap()
                                                                        }
                                                                    }
                                                                })
                                                            }
                                                            6 => {
                                                                JsonValue::Buffer({
                                                                    let len9 = *((base + 20) as *const i32) as usize;
                                                                    Vec::from_raw_parts(
                                                                        *((base + 16) as *const i32) as *mut _,
                                                                        len9,
                                                                        len9,
                                                                    )
                                                                })
                                                            }
                                                            7 => {
                                                                JsonValue::Array(JsonArrayRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            8 => {
                                                                JsonValue::Map(JsonMapRef {
                                                                    index: *((base + 16) as *const i32) as u32,
                                                                })
                                                            }
                                                            #[cfg(debug_assertions)]
                                                            _ => {
                                                                ::core::panicking::panic_fmt(
                                                                    format_args!("invalid enum discriminant"),
                                                                );
                                                            }
                                                        }
                                                    }
                                                },
                                            )
                                        });
                                }
                                wit_bindgen::rt::dealloc(base10, (len10 as usize) * 24, 8);
                                result10
                            });
                    }
                    wit_bindgen::rt::dealloc(base11, (len11 as usize) * 8, 4);
                    T::y_map_set(
                        YMap { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                        JsonValueItem {
                            item: {
                                {
                                    match arg3 {
                                        0 => JsonValue::Null,
                                        1 => JsonValue::Undefined,
                                        2 => {
                                            JsonValue::Boolean({
                                                #[cfg(debug_assertions)]
                                                {
                                                    match arg4 as i32 {
                                                        0 => false,
                                                        1 => true,
                                                        _ => {
                                                            ::core::panicking::panic_fmt(
                                                                format_args!("invalid bool discriminant"),
                                                            );
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                        3 => JsonValue::Number(f64::from_bits(arg4 as u64)),
                                        4 => JsonValue::BigInt(arg4),
                                        5 => {
                                            JsonValue::Str({
                                                let len1 = arg5 as usize;
                                                {
                                                    #[cfg(debug_assertions)]
                                                    {
                                                        String::from_utf8(
                                                                Vec::from_raw_parts(arg4 as i32 as *mut _, len1, len1),
                                                            )
                                                            .unwrap()
                                                    }
                                                }
                                            })
                                        }
                                        6 => {
                                            JsonValue::Buffer({
                                                let len2 = arg5 as usize;
                                                Vec::from_raw_parts(arg4 as i32 as *mut _, len2, len2)
                                            })
                                        }
                                        7 => {
                                            JsonValue::Array(JsonArrayRef {
                                                index: arg4 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        8 => {
                                            JsonValue::Map(JsonMapRef {
                                                index: arg4 as i32 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid enum discriminant"),
                                            );
                                        }
                                    }
                                }
                            },
                            array_references: result6,
                            map_references: result11,
                        },
                        match arg10 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg11 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg12 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg12 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_delete<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    T::y_map_delete(
                        YMap { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                        match arg3 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg4 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_get<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg2 as usize;
                    let result1 = T::y_map_get(
                        YMap { ref_: arg0 as u32 },
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg1 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                        match arg3 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg4 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let ptr2 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result1 {
                        Some(e) => {
                            *((ptr2 + 0) as *mut u8) = (1i32) as u8;
                            match e {
                                YValue::JsonValueItem(e) => {
                                    *((ptr2 + 8) as *mut u8) = (0i32) as u8;
                                    let JsonValueItem {
                                        item: item3,
                                        array_references: array_references3,
                                        map_references: map_references3,
                                    } = e;
                                    match item3 {
                                        JsonValue::Null => {
                                            *((ptr2 + 16) as *mut u8) = (0i32) as u8;
                                        }
                                        JsonValue::Undefined => {
                                            *((ptr2 + 16) as *mut u8) = (1i32) as u8;
                                        }
                                        JsonValue::Boolean(e) => {
                                            *((ptr2 + 16) as *mut u8) = (2i32) as u8;
                                            *((ptr2 + 24)
                                                as *mut u8) = (match e {
                                                true => 1,
                                                false => 0,
                                            }) as u8;
                                        }
                                        JsonValue::Number(e) => {
                                            *((ptr2 + 16) as *mut u8) = (3i32) as u8;
                                            *((ptr2 + 24) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                        }
                                        JsonValue::BigInt(e) => {
                                            *((ptr2 + 16) as *mut u8) = (4i32) as u8;
                                            *((ptr2 + 24) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                        }
                                        JsonValue::Str(e) => {
                                            *((ptr2 + 16) as *mut u8) = (5i32) as u8;
                                            let vec4 = (e.into_bytes()).into_boxed_slice();
                                            let ptr4 = vec4.as_ptr() as i32;
                                            let len4 = vec4.len() as i32;
                                            ::core::mem::forget(vec4);
                                            *((ptr2 + 28) as *mut i32) = len4;
                                            *((ptr2 + 24) as *mut i32) = ptr4;
                                        }
                                        JsonValue::Buffer(e) => {
                                            *((ptr2 + 16) as *mut u8) = (6i32) as u8;
                                            let vec5 = (e).into_boxed_slice();
                                            let ptr5 = vec5.as_ptr() as i32;
                                            let len5 = vec5.len() as i32;
                                            ::core::mem::forget(vec5);
                                            *((ptr2 + 28) as *mut i32) = len5;
                                            *((ptr2 + 24) as *mut i32) = ptr5;
                                        }
                                        JsonValue::Array(e) => {
                                            *((ptr2 + 16) as *mut u8) = (7i32) as u8;
                                            let JsonArrayRef { index: index6 } = e;
                                            *((ptr2 + 24)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index6);
                                        }
                                        JsonValue::Map(e) => {
                                            *((ptr2 + 16) as *mut u8) = (8i32) as u8;
                                            let JsonMapRef { index: index7 } = e;
                                            *((ptr2 + 24)
                                                as *mut i32) = wit_bindgen::rt::as_i32(index7);
                                        }
                                    };
                                    let vec13 = array_references3;
                                    let len13 = vec13.len() as i32;
                                    let layout13 = alloc::Layout::from_size_align_unchecked(
                                        vec13.len() * 8,
                                        4,
                                    );
                                    let result13 = if layout13.size() != 0 {
                                        let ptr = alloc::alloc(layout13);
                                        if ptr.is_null() {
                                            alloc::handle_alloc_error(layout13);
                                        }
                                        ptr
                                    } else {
                                        ::core::ptr::null_mut()
                                    };
                                    for (i, e) in vec13.into_iter().enumerate() {
                                        let base = result13 as i32 + (i as i32) * 8;
                                        {
                                            let vec12 = e;
                                            let len12 = vec12.len() as i32;
                                            let layout12 = alloc::Layout::from_size_align_unchecked(
                                                vec12.len() * 16,
                                                8,
                                            );
                                            let result12 = if layout12.size() != 0 {
                                                let ptr = alloc::alloc(layout12);
                                                if ptr.is_null() {
                                                    alloc::handle_alloc_error(layout12);
                                                }
                                                ptr
                                            } else {
                                                ::core::ptr::null_mut()
                                            };
                                            for (i, e) in vec12.into_iter().enumerate() {
                                                let base = result12 as i32 + (i as i32) * 16;
                                                {
                                                    match e {
                                                        JsonValue::Null => {
                                                            *((base + 0) as *mut u8) = (0i32) as u8;
                                                        }
                                                        JsonValue::Undefined => {
                                                            *((base + 0) as *mut u8) = (1i32) as u8;
                                                        }
                                                        JsonValue::Boolean(e) => {
                                                            *((base + 0) as *mut u8) = (2i32) as u8;
                                                            *((base + 8)
                                                                as *mut u8) = (match e {
                                                                true => 1,
                                                                false => 0,
                                                            }) as u8;
                                                        }
                                                        JsonValue::Number(e) => {
                                                            *((base + 0) as *mut u8) = (3i32) as u8;
                                                            *((base + 8) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                                        }
                                                        JsonValue::BigInt(e) => {
                                                            *((base + 0) as *mut u8) = (4i32) as u8;
                                                            *((base + 8) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                                        }
                                                        JsonValue::Str(e) => {
                                                            *((base + 0) as *mut u8) = (5i32) as u8;
                                                            let vec8 = (e.into_bytes()).into_boxed_slice();
                                                            let ptr8 = vec8.as_ptr() as i32;
                                                            let len8 = vec8.len() as i32;
                                                            ::core::mem::forget(vec8);
                                                            *((base + 12) as *mut i32) = len8;
                                                            *((base + 8) as *mut i32) = ptr8;
                                                        }
                                                        JsonValue::Buffer(e) => {
                                                            *((base + 0) as *mut u8) = (6i32) as u8;
                                                            let vec9 = (e).into_boxed_slice();
                                                            let ptr9 = vec9.as_ptr() as i32;
                                                            let len9 = vec9.len() as i32;
                                                            ::core::mem::forget(vec9);
                                                            *((base + 12) as *mut i32) = len9;
                                                            *((base + 8) as *mut i32) = ptr9;
                                                        }
                                                        JsonValue::Array(e) => {
                                                            *((base + 0) as *mut u8) = (7i32) as u8;
                                                            let JsonArrayRef { index: index10 } = e;
                                                            *((base + 8)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index10);
                                                        }
                                                        JsonValue::Map(e) => {
                                                            *((base + 0) as *mut u8) = (8i32) as u8;
                                                            let JsonMapRef { index: index11 } = e;
                                                            *((base + 8)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index11);
                                                        }
                                                    };
                                                }
                                            }
                                            *((base + 4) as *mut i32) = len12;
                                            *((base + 0) as *mut i32) = result12 as i32;
                                        }
                                    }
                                    *((ptr2 + 36) as *mut i32) = len13;
                                    *((ptr2 + 32) as *mut i32) = result13 as i32;
                                    let vec21 = map_references3;
                                    let len21 = vec21.len() as i32;
                                    let layout21 = alloc::Layout::from_size_align_unchecked(
                                        vec21.len() * 8,
                                        4,
                                    );
                                    let result21 = if layout21.size() != 0 {
                                        let ptr = alloc::alloc(layout21);
                                        if ptr.is_null() {
                                            alloc::handle_alloc_error(layout21);
                                        }
                                        ptr
                                    } else {
                                        ::core::ptr::null_mut()
                                    };
                                    for (i, e) in vec21.into_iter().enumerate() {
                                        let base = result21 as i32 + (i as i32) * 8;
                                        {
                                            let vec20 = e;
                                            let len20 = vec20.len() as i32;
                                            let layout20 = alloc::Layout::from_size_align_unchecked(
                                                vec20.len() * 24,
                                                8,
                                            );
                                            let result20 = if layout20.size() != 0 {
                                                let ptr = alloc::alloc(layout20);
                                                if ptr.is_null() {
                                                    alloc::handle_alloc_error(layout20);
                                                }
                                                ptr
                                            } else {
                                                ::core::ptr::null_mut()
                                            };
                                            for (i, e) in vec20.into_iter().enumerate() {
                                                let base = result20 as i32 + (i as i32) * 24;
                                                {
                                                    let (t14_0, t14_1) = e;
                                                    let vec15 = (t14_0.into_bytes()).into_boxed_slice();
                                                    let ptr15 = vec15.as_ptr() as i32;
                                                    let len15 = vec15.len() as i32;
                                                    ::core::mem::forget(vec15);
                                                    *((base + 4) as *mut i32) = len15;
                                                    *((base + 0) as *mut i32) = ptr15;
                                                    match t14_1 {
                                                        JsonValue::Null => {
                                                            *((base + 8) as *mut u8) = (0i32) as u8;
                                                        }
                                                        JsonValue::Undefined => {
                                                            *((base + 8) as *mut u8) = (1i32) as u8;
                                                        }
                                                        JsonValue::Boolean(e) => {
                                                            *((base + 8) as *mut u8) = (2i32) as u8;
                                                            *((base + 16)
                                                                as *mut u8) = (match e {
                                                                true => 1,
                                                                false => 0,
                                                            }) as u8;
                                                        }
                                                        JsonValue::Number(e) => {
                                                            *((base + 8) as *mut u8) = (3i32) as u8;
                                                            *((base + 16) as *mut f64) = wit_bindgen::rt::as_f64(e);
                                                        }
                                                        JsonValue::BigInt(e) => {
                                                            *((base + 8) as *mut u8) = (4i32) as u8;
                                                            *((base + 16) as *mut i64) = wit_bindgen::rt::as_i64(e);
                                                        }
                                                        JsonValue::Str(e) => {
                                                            *((base + 8) as *mut u8) = (5i32) as u8;
                                                            let vec16 = (e.into_bytes()).into_boxed_slice();
                                                            let ptr16 = vec16.as_ptr() as i32;
                                                            let len16 = vec16.len() as i32;
                                                            ::core::mem::forget(vec16);
                                                            *((base + 20) as *mut i32) = len16;
                                                            *((base + 16) as *mut i32) = ptr16;
                                                        }
                                                        JsonValue::Buffer(e) => {
                                                            *((base + 8) as *mut u8) = (6i32) as u8;
                                                            let vec17 = (e).into_boxed_slice();
                                                            let ptr17 = vec17.as_ptr() as i32;
                                                            let len17 = vec17.len() as i32;
                                                            ::core::mem::forget(vec17);
                                                            *((base + 20) as *mut i32) = len17;
                                                            *((base + 16) as *mut i32) = ptr17;
                                                        }
                                                        JsonValue::Array(e) => {
                                                            *((base + 8) as *mut u8) = (7i32) as u8;
                                                            let JsonArrayRef { index: index18 } = e;
                                                            *((base + 16)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index18);
                                                        }
                                                        JsonValue::Map(e) => {
                                                            *((base + 8) as *mut u8) = (8i32) as u8;
                                                            let JsonMapRef { index: index19 } = e;
                                                            *((base + 16)
                                                                as *mut i32) = wit_bindgen::rt::as_i32(index19);
                                                        }
                                                    };
                                                }
                                            }
                                            *((base + 4) as *mut i32) = len20;
                                            *((base + 0) as *mut i32) = result20 as i32;
                                        }
                                    }
                                    *((ptr2 + 44) as *mut i32) = len21;
                                    *((ptr2 + 40) as *mut i32) = result21 as i32;
                                }
                                YValue::YText(e) => {
                                    *((ptr2 + 8) as *mut u8) = (1i32) as u8;
                                    let YText { ref_: ref_22 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_22);
                                }
                                YValue::YArray(e) => {
                                    *((ptr2 + 8) as *mut u8) = (2i32) as u8;
                                    let YArray { ref_: ref_23 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_23);
                                }
                                YValue::YMap(e) => {
                                    *((ptr2 + 8) as *mut u8) = (3i32) as u8;
                                    let YMap { ref_: ref_24 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_24);
                                }
                                YValue::YXmlFragment(e) => {
                                    *((ptr2 + 8) as *mut u8) = (4i32) as u8;
                                    let YXmlFragment { ref_: ref_25 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_25);
                                }
                                YValue::YXmlElement(e) => {
                                    *((ptr2 + 8) as *mut u8) = (5i32) as u8;
                                    let YXmlElement { ref_: ref_26 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_26);
                                }
                                YValue::YXmlText(e) => {
                                    *((ptr2 + 8) as *mut u8) = (6i32) as u8;
                                    let YXmlText { ref_: ref_27 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_27);
                                }
                                YValue::YDoc(e) => {
                                    *((ptr2 + 8) as *mut u8) = (7i32) as u8;
                                    let YDoc { ref_: ref_28 } = e;
                                    *((ptr2 + 16)
                                        as *mut i32) = wit_bindgen::rt::as_i32(ref_28);
                                }
                            };
                        }
                        None => {
                            *((ptr2 + 0) as *mut u8) = (0i32) as u8;
                        }
                    };
                    ptr2
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_map_get<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            match i32::from(*((arg0 + 8) as *const u8)) {
                                0 => {
                                    match i32::from(*((arg0 + 16) as *const u8)) {
                                        0 => {}
                                        1 => {}
                                        2 => {}
                                        3 => {}
                                        4 => {}
                                        5 => {
                                            wit_bindgen::rt::dealloc(
                                                *((arg0 + 24) as *const i32),
                                                (*((arg0 + 28) as *const i32)) as usize,
                                                1,
                                            );
                                        }
                                        6 => {
                                            let base0 = *((arg0 + 24) as *const i32);
                                            let len0 = *((arg0 + 28) as *const i32);
                                            wit_bindgen::rt::dealloc(base0, (len0 as usize) * 1, 1);
                                        }
                                        7 => {}
                                        _ => {}
                                    }
                                    let base3 = *((arg0 + 32) as *const i32);
                                    let len3 = *((arg0 + 36) as *const i32);
                                    for i in 0..len3 {
                                        let base = base3 + i * 8;
                                        {
                                            let base2 = *((base + 0) as *const i32);
                                            let len2 = *((base + 4) as *const i32);
                                            for i in 0..len2 {
                                                let base = base2 + i * 16;
                                                {
                                                    match i32::from(*((base + 0) as *const u8)) {
                                                        0 => {}
                                                        1 => {}
                                                        2 => {}
                                                        3 => {}
                                                        4 => {}
                                                        5 => {
                                                            wit_bindgen::rt::dealloc(
                                                                *((base + 8) as *const i32),
                                                                (*((base + 12) as *const i32)) as usize,
                                                                1,
                                                            );
                                                        }
                                                        6 => {
                                                            let base1 = *((base + 8) as *const i32);
                                                            let len1 = *((base + 12) as *const i32);
                                                            wit_bindgen::rt::dealloc(base1, (len1 as usize) * 1, 1);
                                                        }
                                                        7 => {}
                                                        _ => {}
                                                    }
                                                }
                                            }
                                            wit_bindgen::rt::dealloc(base2, (len2 as usize) * 16, 8);
                                        }
                                    }
                                    wit_bindgen::rt::dealloc(base3, (len3 as usize) * 8, 4);
                                    let base6 = *((arg0 + 40) as *const i32);
                                    let len6 = *((arg0 + 44) as *const i32);
                                    for i in 0..len6 {
                                        let base = base6 + i * 8;
                                        {
                                            let base5 = *((base + 0) as *const i32);
                                            let len5 = *((base + 4) as *const i32);
                                            for i in 0..len5 {
                                                let base = base5 + i * 24;
                                                {
                                                    wit_bindgen::rt::dealloc(
                                                        *((base + 0) as *const i32),
                                                        (*((base + 4) as *const i32)) as usize,
                                                        1,
                                                    );
                                                    match i32::from(*((base + 8) as *const u8)) {
                                                        0 => {}
                                                        1 => {}
                                                        2 => {}
                                                        3 => {}
                                                        4 => {}
                                                        5 => {
                                                            wit_bindgen::rt::dealloc(
                                                                *((base + 16) as *const i32),
                                                                (*((base + 20) as *const i32)) as usize,
                                                                1,
                                                            );
                                                        }
                                                        6 => {
                                                            let base4 = *((base + 16) as *const i32);
                                                            let len4 = *((base + 20) as *const i32);
                                                            wit_bindgen::rt::dealloc(base4, (len4 as usize) * 1, 1);
                                                        }
                                                        7 => {}
                                                        _ => {}
                                                    }
                                                }
                                            }
                                            wit_bindgen::rt::dealloc(base5, (len5 as usize) * 24, 8);
                                        }
                                    }
                                    wit_bindgen::rt::dealloc(base6, (len6 as usize) * 8, 4);
                                }
                                1 => {}
                                2 => {}
                                3 => {}
                                4 => {}
                                5 => {}
                                6 => {}
                                _ => {}
                            }
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_observe<T: YDocMethods>(arg0: i32, arg1: i32) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_map_observe(YMap { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_map_observe_deep<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_map_observe_deep(YMap { ref_: arg0 as u32 }, arg1 as u32);
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_element_name<T: YDocMethods>(arg0: i32) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_xml_element_name(YXmlElement {
                        ref_: arg0 as u32,
                    });
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result0 {
                        Some(e) => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                            let vec2 = (e.into_bytes()).into_boxed_slice();
                            let ptr2 = vec2.as_ptr() as i32;
                            let len2 = vec2.len() as i32;
                            ::core::mem::forget(vec2);
                            *((ptr1 + 8) as *mut i32) = len2;
                            *((ptr1 + 4) as *mut i32) = ptr2;
                        }
                        None => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                        }
                    };
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_xml_element_name<T: YDocMethods>(arg0: i32) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_element_length<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_xml_element_length(
                        YXmlElement { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::as_i32(result0)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_element_insert_xml_element<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                    arg6: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let len0 = arg3 as usize;
                    let result1 = T::y_xml_element_insert_xml_element(
                        YXmlElement { ref_: arg0 as u32 },
                        arg1 as u32,
                        {
                            #[cfg(debug_assertions)]
                            {
                                String::from_utf8(
                                        Vec::from_raw_parts(arg2 as *mut _, len0, len0),
                                    )
                                    .unwrap()
                            }
                        },
                        match arg4 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg5 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg6 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg6 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let YXmlElement { ref_: ref_2 } = result1;
                    wit_bindgen::rt::as_i32(ref_2)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_element_insert_xml_text<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_xml_element_insert_xml_text(
                        YXmlElement { ref_: arg0 as u32 },
                        arg1 as u32,
                        match arg2 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg3 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg4 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg4 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    let YXmlText { ref_: ref_1 } = result0;
                    wit_bindgen::rt::as_i32(ref_1)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_element_delete<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                    arg4: i32,
                    arg5: i32,
                ) {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    T::y_xml_element_delete(
                        YXmlElement { ref_: arg0 as u32 },
                        arg1 as u32,
                        arg2 as u32,
                        match arg3 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg4 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg5 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_fragment_name<T: YDocMethods>(
                    arg0: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_xml_fragment_name(YXmlFragment {
                        ref_: arg0 as u32,
                    });
                    let ptr1 = _RET_AREA.0.as_mut_ptr() as i32;
                    match result0 {
                        Some(e) => {
                            *((ptr1 + 0) as *mut u8) = (1i32) as u8;
                            let vec2 = (e.into_bytes()).into_boxed_slice();
                            let ptr2 = vec2.as_ptr() as i32;
                            let len2 = vec2.len() as i32;
                            ::core::mem::forget(vec2);
                            *((ptr1 + 8) as *mut i32) = len2;
                            *((ptr1 + 4) as *mut i32) = ptr2;
                        }
                        None => {
                            *((ptr1 + 0) as *mut u8) = (0i32) as u8;
                        }
                    };
                    ptr1
                }
                #[doc(hidden)]
                pub unsafe fn post_return_y_xml_fragment_name<T: YDocMethods>(
                    arg0: i32,
                ) {
                    match i32::from(*((arg0 + 0) as *const u8)) {
                        0 => {}
                        _ => {
                            wit_bindgen::rt::dealloc(
                                *((arg0 + 4) as *const i32),
                                (*((arg0 + 8) as *const i32)) as usize,
                                1,
                            );
                        }
                    }
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_fragment_length<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_xml_fragment_length(
                        YXmlFragment { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::as_i32(result0)
                }
                #[doc(hidden)]
                pub unsafe fn call_y_xml_text_length<T: YDocMethods>(
                    arg0: i32,
                    arg1: i32,
                    arg2: i32,
                    arg3: i32,
                ) -> i32 {
                    #[allow(unused_imports)]
                    use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                    let result0 = T::y_xml_text_length(
                        YXmlText { ref_: arg0 as u32 },
                        match arg1 {
                            0 => None,
                            1 => {
                                Some(
                                    match arg2 {
                                        0 => {
                                            YTransaction::ReadTransaction(ReadTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        1 => {
                                            YTransaction::WriteTransaction(WriteTransaction {
                                                ref_: arg3 as u32,
                                            })
                                        }
                                        #[cfg(debug_assertions)]
                                        _ => {
                                            ::core::panicking::panic_fmt(
                                                format_args!("invalid union discriminant"),
                                            );
                                        }
                                    },
                                )
                            }
                            #[cfg(debug_assertions)]
                            _ => {
                                ::core::panicking::panic_fmt(
                                    format_args!("invalid enum discriminant"),
                                );
                            }
                        },
                    );
                    wit_bindgen::rt::as_i32(result0)
                }
                #[allow(unused_imports)]
                use wit_bindgen::rt::{alloc, vec::Vec, string::String};
                #[repr(align(8))]
                struct _RetArea([u8; 48]);
                static mut _RET_AREA: _RetArea = _RetArea([0; 48]);
            }
        }
    }
}
const _: &str = "package y-crdt-namespace:y-crdt\n\nworld y-crdt {\n    /// A record is a class with named fields\n    /// There are enum, list, variant, option, result, tuple and union types\n    record model {\n      /// Comment for a field\n      integer: s32,\n    }\n\n\n\n\n    /// An import is a function that is provided by the host environment (Dart)\n    import map-integer: func(value: s32) -> float64\n\n    /// export\n    export run: func(value: model) -> result<float64, string>\n\n    // TODO: should_load auto_load\n\n    export y-doc-methods\n}\n\ninterface y-doc-methods {\n\n    union y-value {\n      json-value-item,\n      y-text,\n      y-array,\n      y-map,\n      y-xml-fragment,\n      y-xml-element,\n      y-xml-text,\n      y-doc,\n    }\n\n    record y-doc {\n      ref: u32,\n    }\n    union y-transaction {\n      read-transaction,\n      write-transaction,\n    }\n    record read-transaction {\n      ref: u32,\n    }\n    record write-transaction {\n      ref: u32,\n    }\n\n    record y-text {\n      ref: u32,\n    }\n    record y-array {\n      ref: u32,\n    }\n    record y-map {\n      ref: u32,\n    }\n    record y-xml-fragment {\n      ref: u32,\n    }\n    record y-xml-element {\n      ref: u32,\n    }\n    record y-xml-text {\n      ref: u32,\n    }\n\n    enum offset-kind {\n        /// Compute editable strings length and offset using UTF-8 byte count.\n        bytes,\n        /// Compute editable strings length and offset using UTF-16 chars count.\n        utf16,\n        /// Compute editable strings length and offset using Unicode code points number.\n        utf32,\n    }\n\n    record y-doc-options {\n      /// Globally unique client identifier. This value must be unique across all active collaborating\n      /// peers, otherwise a update collisions will happen, causing document store state to be corrupted.\n      ///\n      /// Default value: randomly generated.\n      client-id: u64,\n      /// A globally unique identifier for this document.\n      ///\n      /// Default value: randomly generated UUID v4.\n      guid: string,\n      /// Associate this document with a collection. This only plays a role if your provider has\n      /// a concept of collection.\n      ///\n      /// Default value: `None`.\n      collection-id: option<string>,\n      /// How to we count offsets and lengths used in text operations.\n      ///\n      /// Default value: [OffsetKind::Bytes].\n      offset-kind: offset-kind,\n      /// Determines if transactions commits should try to perform GC-ing of deleted items.\n      ///\n      /// Default value: `false`.\n      skip-gc: bool,\n      /// If a subdocument, automatically load document. If this is a subdocument, remote peers will\n      /// load the document as well automatically.\n      ///\n      /// Default value: `false`.\n      auto-load: bool,\n      /// Whether the document should be synced by the provider now.\n      /// This is toggled to true when you call ydoc.load().\n      ///\n      /// Default value: `true`.\n      should-load: bool,\n  }\n\n    y-doc-new: func(options: option<y-doc-options>) -> y-doc\n    y-doc-parent-doc: func(ref: y-doc) -> option<y-doc>\n    y-doc-id: func(ref: y-doc) -> u64\n    y-doc-guid: func(ref: y-doc) -> string\n    y-doc-read-transaction: func(ref: y-doc) -> read-transaction\n    y-doc-write-transaction: func(ref: y-doc, origin: origin) -> write-transaction\n    y-doc-text: func(ref: y-doc, name: string) -> y-text\n    y-doc-array: func(ref: y-doc, name: string) -> y-array\n    y-doc-map: func(ref: y-doc, name: string) -> y-map\n    y-doc-xml-fragment: func(ref: y-doc, name: string) -> y-xml-fragment\n    y-doc-xml-element: func(ref: y-doc, name: string) -> y-xml-element\n    y-doc-xml-text: func(ref: y-doc, name: string) -> y-xml-text\n    y-doc-on-update-v1: func(ref: y-doc, function-id: u32)\n    // on_after_transaction\n    // on_subdocs\n    // on_destroy\n    // load\n    // destroy\n    subdocs: func(ref: y-doc, txn: y-transaction) -> list<string>\n    subdoc-guids: func(ref: y-doc, txn: y-transaction) -> list<string>\n\n    encode-state-vector: func(ref: y-doc) -> list<u8>\n    // debug_update_v1\n\n    type error = string\n    type origin = list<u8>\n\n    encode-state-as-update: func(ref: y-doc, vector: option<list<u8>>) -> result<list<u8>, error>\n    encode-state-as-update-v2: func(ref: y-doc, vector: option<list<u8>>) -> result<list<u8>, error>\n    apply-update: func(ref: y-doc, diff: list<u8>, origin: origin) -> result<_, error>\n    apply-update-v2: func(ref: y-doc, diff: list<u8>, origin: origin) -> result<_, error>\n\n    transaction-is-readonly: func(txn: y-transaction) -> bool\n    transaction-is-writeable: func(txn: y-transaction) -> bool\n    transaction-origin: func(txn: y-transaction) -> option<origin>\n    transaction-commit: func(txn: y-transaction)\n    transaction-state-vector-v1: func(txn: y-transaction) -> list<u8>\n    transaction-diff-v1: func(txn: y-transaction, vector: option<list<u8>>) -> result<list<u8>, error>\n    transaction-diff-v2: func(txn: y-transaction, vector: option<list<u8>>) -> result<list<u8>, error>\n    transaction-apply-v2: func(txn: y-transaction, diff: list<u8>) -> result<_, error>\n\n    transaction-encode-update: func(txn: y-transaction) -> list<u8>\n    transaction-encode-update-v2: func(txn: y-transaction) -> list<u8>\n\n\n    // record y-value {\n    //   ref: u32,\n    // }\n\n    record y-array-event {\n      // ref: u32,\n      // inner: *const ArrayEvent,\n      txn: write-transaction,\n      target: y-value,\n      delta: y-array-event-delta,\n      path: string,\n    }\n\n    union y-array-event-delta {\n      y-array-event-insert,\n      y-array-event-delete,\n      y-array-event-retain,\n    }\n\n    record y-array-event-insert {\n      insert: list<y-value>,\n    }\n    record y-array-event-delete {\n      delete: u32,\n    }\n    record y-array-event-retain {\n      retain: u32,\n    }\n\n    // YMapEvent\n    // YTextEvent\n    // YXmlEvent\n    // YXmlTextEvent\n    // YSubdocsEvent\n    // YSubdocsObserver(SubdocsSubscription)\n    // YDestroyObserver(DestroySubscription)\n    // YAfterTransactionEvent\n    // YAfterTransactionObserver(TransactionCleanupSubscription)\n    // YUpdateObserver(UpdateSubscription)\n\n    // YArrayObserver\n    // YTextObserver\n    // YMapObserver\n    // ... other observers\n    // YEventObserver\n\n\n    type text-attrs = json-object\n    type implicit-transaction = option<y-transaction>\n\n    y-text-new: func(init: option<string>) -> y-text\n    y-text-prelim: func(ref: y-text) -> bool\n    y-text-length: func(ref: y-text, txn: implicit-transaction) -> u32\n    y-text-to-string: func(ref: y-text, txn: implicit-transaction) -> string\n    y-text-to-json: func(ref: y-text, txn: implicit-transaction) -> string\n    y-text-insert: func(ref: y-text, index: u32, chunk: string, attributes: option<text-attrs>, txn: implicit-transaction)\n    y-text-insert-embed: func(ref: y-text, index: u32, embed: json-value-item, attributes: option<text-attrs>, txn: implicit-transaction)\n    y-text-format: func(ref: y-text, index: u32, length: u32, attributes: text-attrs, txn: implicit-transaction)\n    y-text-push: func(ref: y-text, chunk: string, attributes: option<text-attrs>, txn: implicit-transaction)\n    y-text-delete: func(ref: y-text, index: u32, length: u32, txn: implicit-transaction)\n    // TODO: y-text-to-delta: func(ref: y-text, index: u32, length: u32, txn: implicit-transaction)\n    y-text-observe: func(ref: y-text, function-id: u32)\n    y-text-observe-deep: func(ref: y-text, function-id: u32)\n\n    // YSnapshot(Snapshot)\n\n    // type json-value = list<tuple<string, string>>\n    // type json-object = list<tuple<string, json-value-item>>\n    // type json-array = list<json-value-item>\n\n    type json-object = json-value-item\n    type json-array = json-value-item\n\n    record json-value-item {\n      item: json-value,\n      array-references: list<list<json-value>>,\n      map-references: list<list<tuple<string, json-value>>>,\n    }\n\n    // record json-value-item {\n    //   item: json-value,\n    //   references: list<json-value>,\n    // }\n\n    record json-value-ref {\n      index: u32,\n    }\n\n    record json-array-ref {\n      index: u32,\n    }\n\n    record json-map-ref {\n      index: u32,\n    }\n\n    variant json-value {\n      null,\n      undefined,\n      boolean(bool),\n      number(float64),\n      big-int(s64),\n      str(string),\n      buffer(list<u8>),\n      /// TODO: use json-array-ref\n      array(json-array-ref),\n      map(json-map-ref),\n    }\n\n    y-array-new: func(init: option<json-array>) -> y-array\n    y-array-prelim: func(ref: y-array) -> bool\n    y-array-length: func(ref: y-array, txn: implicit-transaction) -> u32\n    y-array-to-json: func(ref: y-array, txn: implicit-transaction) -> json-value-item\n    y-array-insert: func(ref: y-array, index: u32, items: json-array, txn: implicit-transaction)\n    y-array-push: func(ref: y-array, items: json-array, txn: implicit-transaction)\n    y-array-delete: func(ref: y-array, index: u32, length: u32, txn: implicit-transaction)\n    y-array-move-content: func(ref: y-array, source: u32, target: u32, txn: implicit-transaction)\n    y-array-get: func(ref: y-array, index: u32, txn: implicit-transaction) -> result<y-value, error>\n    // TODO: iterable y-array-values: func(ref: y-array, txn: implicit-transaction) -> json-value-item\n    y-array-observe: func(ref: y-array, function-id: u32)\n    y-array-observe-deep: func(ref: y-array, function-id: u32)\n\n\n    y-map-new: func(init: option<json-object>) -> y-map\n    y-map-prelim: func(ref: y-map) -> bool\n    y-map-length: func(ref: y-map, txn: implicit-transaction) -> u32\n    y-map-to-json: func(ref: y-map, txn: implicit-transaction) -> json-value-item // TODO: json-object\n    y-map-set: func(ref: y-map, key: string, value: json-value-item, txn: implicit-transaction)\n    y-map-delete: func(ref: y-map, key: string, txn: implicit-transaction)\n    y-map-get: func(ref: y-map, key: string, txn: implicit-transaction) -> option<y-value>\n    // entries\n    y-map-observe: func(ref: y-map, function-id: u32)\n    y-map-observe-deep: func(ref: y-map, function-id: u32)\n\n\n    y-xml-element-name: func(ref: y-xml-element) -> option<string>\n    y-xml-element-length: func(ref: y-xml-element, txn: implicit-transaction) -> u32\n    y-xml-element-insert-xml-element: func(ref: y-xml-element, index: u32, name: string, txn: implicit-transaction) -> y-xml-element\n    y-xml-element-insert-xml-text: func(ref: y-xml-element, index: u32, txn: implicit-transaction) -> y-xml-text\n    y-xml-element-delete: func(ref: y-xml-element, index: u32, length: u32, txn: implicit-transaction)\n    // fn push_xml_element(&self, name: &str, txn: &ImplicitTransaction) -> YXmlElement\n    // fn push_xml_text(&self, txn: &ImplicitTransaction) -> YXmlText\n    // fn first_child(&self) -> JsValue\n    // fn next_sibling(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn prev_sibling(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn parent(&self) -> JsValue\n    // fn to_string(&self, txn: &ImplicitTransaction) -> String\n    // fn set_attribute(&self, name: &str, value: &str, txn: &ImplicitTransaction)\n    // fn get_attribute(&self, name: &str, txn: &ImplicitTransaction) -> Option<String>\n    // fn remove_attribute(&self, name: &str, txn: &ImplicitTransaction)\n    // fn attributes(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn tree_walker(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn observe(&mut self, f: js_sys::Function) -> YXmlObserver\n    // fn observe_deep(&mut self, f: js_sys::Function) -> YEventObserver\n\n\n    y-xml-fragment-name: func(ref: y-xml-fragment) -> option<string>\n    y-xml-fragment-length: func(ref: y-xml-fragment, txn: implicit-transaction) -> u32\n\n\n    y-xml-text-length: func(ref: y-xml-text, txn: implicit-transaction) -> u32\n    // fn insert(&self, index: i32, chunk: &str, attrs: JsValue, txn: &ImplicitTransaction)\n    // fn format(&self, index: i32, len: i32, attrs: JsValue, txn: &ImplicitTransaction)\n    // fn push(&self, chunk: &str, attrs: JsValue, txn: &ImplicitTransaction)\n    // fn delete(&self, index: u32, length: u32, txn: &ImplicitTransaction)\n    // fn next_sibling(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn prev_sibling(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn parent(&self) -> JsValue\n    // fn to_string(&self, txn: &ImplicitTransaction) -> String\n    // fn set_attribute(&self, name: &str, value: &str, txn: &ImplicitTransaction)\n    // fn get_attribute(&self, name: &str, txn: &ImplicitTransaction) -> Option<String>\n    // fn remove_attribute(&self, name: &str, txn: &ImplicitTransaction)\n    // fn attributes(&self, txn: &ImplicitTransaction) -> JsValue\n    // fn observe(&mut self, f: js_sys::Function) -> YXmlTextObserver\n    // fn observe_deep(&mut self, f: js_sys::Function) -> YEventObserver\n\n    // fn create_sticky_index_from_type(\n    //     ytype: &JsValue,\n    //     index: u32,\n    //     assoc: i32,\n    //     txn: &ImplicitTransaction,\n    // ) -> Result<JsValue, JsValue>\n    // \n    // fn create_offset_from_sticky_index(rpos: &JsValue, doc: &YDoc) -> Result<JsValue, JsValue>\n    // fn encode_sticky_index(rpos: &JsValue) -> Result<Uint8Array, JsValue>\n    // fn decode_sticky_index(bin: Uint8Array) -> Result<JsValue, JsValue>\n\n    record y-undo-event {\n      origin: json-value-item,\n      kind: json-value-item,\n      stack-item: json-value-item,\n    }\n}\n";
use exports::y_crdt_namespace::y_crdt::y_doc_methods::*;
use lib0::any::Any;
use std::cell::RefCell;
use std::collections::HashMap;
use std::convert::TryFrom;
use std::mem::ManuallyDrop;
use std::ops::Deref;
use std::rc::Rc;
use std::sync::Arc;
use yrs::block::{ClientID, ItemContent, Prelim, Unused};
use yrs::types::array::ArrayEvent;
use yrs::types::map::MapEvent;
use yrs::types::text::{ChangeKind, Diff, TextEvent, YChange};
use yrs::types::xml::{XmlEvent, XmlTextEvent};
use yrs::types::{
    Attrs, Branch, BranchPtr, Change, DeepEventsSubscription, DeepObservable, Delta,
    EntryChange, Event, Events, Path, PathSegment, ToJson, TypeRef, Value,
};
use yrs::undo::{EventKind, UndoEventSubscription};
use yrs::updates::decoder::{Decode, DecoderV1};
use yrs::updates::encoder::{Encode, Encoder, EncoderV1, EncoderV2};
use yrs::{
    Array, ArrayRef, Assoc, DeleteSet, DestroySubscription, Doc, GetString, IndexScope,
    Map, MapRef, Observable, Offset, Options, Origin, ReadTxn, Snapshot, StateVector,
    StickyIndex, Store, SubdocsEvent, SubdocsEventIter, SubdocsSubscription,
    Subscription, Text, TextRef, Transact, Transaction, TransactionCleanupEvent,
    TransactionCleanupSubscription, TransactionMut, UndoManager, Update,
    UpdateSubscription, Xml, XmlElementPrelim, XmlElementRef, XmlFragment,
    XmlFragmentRef, XmlNode, XmlTextPrelim, XmlTextRef, ID,
};
use once_cell::unsync::Lazy;
const IMAGES_MAP: ::std::thread::LocalKey<Lazy<RefCell<GlobalState>>> = {
    #[inline]
    fn __init() -> Lazy<RefCell<GlobalState>> {
        Lazy::new(|| Default::default())
    }
    #[inline]
    unsafe fn __getit(
        init: ::std::option::Option<
            &mut ::std::option::Option<Lazy<RefCell<GlobalState>>>,
        >,
    ) -> ::std::option::Option<&'static Lazy<RefCell<GlobalState>>> {
        #[thread_local]
        static __KEY: ::std::thread::local_impl::Key<Lazy<RefCell<GlobalState>>> = ::std::thread::local_impl::Key::<
            Lazy<RefCell<GlobalState>>,
        >::new();
        #[allow(unused_unsafe)]
        unsafe {
            __KEY
                .get(move || {
                    if let ::std::option::Option::Some(init) = init {
                        if let ::std::option::Option::Some(value) = init.take() {
                            return value;
                        } else if true {
                            {
                                ::core::panicking::panic_fmt(
                                    format_args!(
                                        "internal error: entered unreachable code: {0}",
                                        format_args!("missing default value")
                                    ),
                                );
                            };
                        }
                    }
                    __init()
                })
        }
    }
    unsafe { ::std::thread::LocalKey::new(__getit) }
};
const TXN_STATE: ::std::thread::LocalKey<Lazy<RefCell<TxnState>>> = {
    #[inline]
    fn __init() -> Lazy<RefCell<TxnState>> {
        Lazy::new(|| Default::default())
    }
    #[inline]
    unsafe fn __getit(
        init: ::std::option::Option<&mut ::std::option::Option<Lazy<RefCell<TxnState>>>>,
    ) -> ::std::option::Option<&'static Lazy<RefCell<TxnState>>> {
        #[thread_local]
        static __KEY: ::std::thread::local_impl::Key<Lazy<RefCell<TxnState>>> = ::std::thread::local_impl::Key::<
            Lazy<RefCell<TxnState>>,
        >::new();
        #[allow(unused_unsafe)]
        unsafe {
            __KEY
                .get(move || {
                    if let ::std::option::Option::Some(init) = init {
                        if let ::std::option::Option::Some(value) = init.take() {
                            return value;
                        } else if true {
                            {
                                ::core::panicking::panic_fmt(
                                    format_args!(
                                        "internal error: entered unreachable code: {0}",
                                        format_args!("missing default value")
                                    ),
                                );
                            };
                        }
                    }
                    __init()
                })
        }
    }
    unsafe { ::std::thread::LocalKey::new(__getit) }
};
pub struct GlobalState {
    pub last_id: u32,
    pub docs: HashMap<u32, Doc>,
    pub texts: HashMap<u32, TextRef>,
    pub arrays: HashMap<u32, ArrayRef>,
    pub maps: HashMap<u32, MapRef>,
    pub xml_elements: HashMap<u32, XmlElementRef>,
    pub xml_fragments: HashMap<u32, XmlFragmentRef>,
    pub xml_texts: HashMap<u32, XmlTextRef>,
}
#[automatically_derived]
impl ::core::default::Default for GlobalState {
    #[inline]
    fn default() -> GlobalState {
        GlobalState {
            last_id: ::core::default::Default::default(),
            docs: ::core::default::Default::default(),
            texts: ::core::default::Default::default(),
            arrays: ::core::default::Default::default(),
            maps: ::core::default::Default::default(),
            xml_elements: ::core::default::Default::default(),
            xml_fragments: ::core::default::Default::default(),
            xml_texts: ::core::default::Default::default(),
        }
    }
}
impl GlobalState {
    fn save_doc(&mut self, image: Doc) -> YDoc {
        let id = self.last_id;
        self.last_id += 1;
        let image_ref = YDoc { ref_: id };
        self.docs.insert(id, image);
        image_ref
    }
    fn save_text(&mut self, t: TextRef) -> YText {
        let id = self.last_id;
        self.last_id += 1;
        let v = YText { ref_: id };
        self.texts.insert(id, t);
        v
    }
    fn save_array(&mut self, t: ArrayRef) -> YArray {
        let id = self.last_id;
        self.last_id += 1;
        let v = YArray { ref_: id };
        self.arrays.insert(id, t);
        v
    }
    fn save_map(&mut self, t: MapRef) -> YMap {
        let id = self.last_id;
        self.last_id += 1;
        let v = YMap { ref_: id };
        self.maps.insert(id, t);
        v
    }
    fn save_xml_element(&mut self, t: XmlElementRef) -> YXmlElement {
        let id = self.last_id;
        self.last_id += 1;
        let v = YXmlElement { ref_: id };
        self.xml_elements.insert(id, t);
        v
    }
    fn save_xml_fragment(&mut self, t: XmlFragmentRef) -> YXmlFragment {
        let id = self.last_id;
        self.last_id += 1;
        let v = YXmlFragment { ref_: id };
        self.xml_fragments.insert(id, t);
        v
    }
    fn save_xml_text(&mut self, t: XmlTextRef) -> YXmlText {
        let id = self.last_id;
        self.last_id += 1;
        let v = YXmlText { ref_: id };
        self.xml_texts.insert(id, t);
        v
    }
}
pub struct TxnState {
    pub last_id: u32,
    pub transactions: HashMap<u32, Transaction<'static>>,
    pub transactions_mut: HashMap<u32, TransactionMut<'static>>,
}
#[automatically_derived]
impl ::core::default::Default for TxnState {
    #[inline]
    fn default() -> TxnState {
        TxnState {
            last_id: ::core::default::Default::default(),
            transactions: ::core::default::Default::default(),
            transactions_mut: ::core::default::Default::default(),
        }
    }
}
impl TxnState {
    fn save_transaction(&mut self, t: Transaction<'static>) -> ReadTransaction {
        let id = self.last_id;
        self.last_id += 1;
        let v = ReadTransaction { ref_: id };
        self.transactions.insert(id, t);
        v
    }
    fn save_transaction_mut(&mut self, t: TransactionMut<'static>) -> WriteTransaction {
        let id = self.last_id;
        self.last_id += 1;
        let v = WriteTransaction { ref_: id };
        self.transactions_mut.insert(id, t);
        v
    }
}
fn with_mut<T>(f: impl FnOnce(&mut GlobalState) -> T) -> T {
    IMAGES_MAP.with(|v| f(&mut v.borrow_mut()))
}
fn with<T>(f: impl FnOnce(&GlobalState) -> T) -> T {
    IMAGES_MAP.with(|v| f(&v.borrow()))
}
fn with_txn_state<T>(f: impl FnOnce(&mut TxnState) -> T) -> T {
    TXN_STATE.with(|v| f(&mut v.borrow_mut()))
}
fn operation<T>(image_ref: YDoc, f: impl FnOnce(&Doc) -> T) -> T {
    with(|state| {
        let img = &state.docs[&image_ref.ref_];
        f(img)
    })
}
fn with_mut_all<T>(f: impl FnOnce(&mut GlobalState, &mut TxnState) -> T) -> T {
    IMAGES_MAP
        .with(|v| {
            TXN_STATE.with(|state| f(&mut v.borrow_mut(), &mut state.borrow_mut()))
        })
}
fn with_txn<T>(t: YTransaction, f: impl FnOnce(&YTransactionInner) -> T) -> T {
    TXN_STATE
        .with(|state| {
            let mut m = state.borrow_mut();
            let t = YTransactionInner::from_ref(t, &mut m);
            f(&t)
        })
}
struct YTransactionInner<'a>(InnerTxn<'a>);
enum InnerTxn<'a> {
    ReadOnly(&'a Transaction<'static>),
    ReadWrite(&'a mut TransactionMut<'static>),
}
impl<'a> YTransactionInner<'a> {
    fn from_ref(txn: YTransaction, state: &'a mut TxnState) -> Self {
        match txn {
            YTransaction::ReadTransaction(t) => {
                let txn = &state.transactions[&t.ref_];
                YTransactionInner(InnerTxn::ReadOnly(txn))
            }
            YTransaction::WriteTransaction(t) => {
                let txn = state.transactions_mut.get_mut(&t.ref_).unwrap();
                YTransactionInner(InnerTxn::ReadWrite(txn))
            }
        }
    }
    fn from_transact<T: Transact>(
        txn: ImplicitTransaction,
        transact: &'a T,
        state: &'a mut TxnState,
    ) -> Self {
        txn.map(|t| YTransactionInner::from_ref(t, state))
            .unwrap_or_else(|| {
                YTransactionInner(
                    InnerTxn::ReadOnly(unsafe {
                        std::mem::transmute(&transact.transact())
                    }),
                )
            })
    }
    fn from_transact_mut<T: Transact>(
        txn: ImplicitTransaction,
        transact: T,
        state: &mut TxnState,
    ) -> &mut TransactionMut<'static> {
        match txn {
            Some(YTransaction::WriteTransaction(txn)) => {
                state.transactions_mut.get_mut(&txn.ref_).unwrap()
            }
            _ => unsafe { std::mem::transmute(&mut transact.transact_mut()) }
        }
    }
    fn try_mut(&mut self) -> Option<&mut TransactionMut<'static>> {
        match &mut self.0 {
            InnerTxn::ReadOnly(_) => None,
            InnerTxn::ReadWrite(txn) => Some(txn),
        }
    }
    fn try_apply(&mut self, update: Update) -> Result<(), String> {
        if let Some(txn) = self.try_mut() {
            txn.apply_update(update);
            Ok(())
        } else {
            Err("cannot apply an update using a read-only transaction".to_string())
        }
    }
}
impl<'a> ReadTxn for YTransactionInner<'a> {
    fn store(&self) -> &Store {
        match &self.0 {
            InnerTxn::ReadOnly(txn) => txn.store(),
            InnerTxn::ReadWrite(txn) => txn.store(),
        }
    }
}
enum SharedType<T, P> {
    Integrated(T),
    Prelim(P),
}
impl<T, P> SharedType<T, P> {
    #[inline(always)]
    fn new(value: T) -> RefCell<Self> {
        RefCell::new(SharedType::Integrated(value))
    }
    #[inline(always)]
    fn prelim(prelim: P) -> RefCell<Self> {
        RefCell::new(SharedType::Prelim(prelim))
    }
    fn as_integrated(&self) -> Option<&T> {
        if let SharedType::Integrated(value) = self { Some(value) } else { None }
    }
}
struct YTextInner(RefCell<SharedType<TextRef, String>>);
struct WitImplementation;
const _: () = {
    const _: () = {
        #[doc(hidden)]
        #[export_name = "run"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_run(arg0: i32) -> i32 {
            call_run::<WitImplementation>(arg0)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_run"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_run(arg0: i32) {
        post_return_run::<WitImplementation>(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-new"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_new(
            arg0: i32,
            arg1: i64,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
            arg6: i32,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_new::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-parent-doc"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_parent_doc(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_parent_doc::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-id"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_id(arg0: i32) -> i64 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_id::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-guid"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_guid(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_guid::<
                WitImplementation,
            >(arg0)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-doc-guid"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_doc_guid(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_doc_guid::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-read-transaction"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_read_transaction(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_read_transaction::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-write-transaction"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_write_transaction(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_write_transaction::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-text"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_text(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_text::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-array"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_array(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_array::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-map"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_map(arg0: i32, arg1: i32, arg2: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_map::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-xml-fragment"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_xml_fragment(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_xml_fragment::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-xml-element"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_xml_element(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_xml_element::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-xml-text"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_xml_text(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_xml_text::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-doc-on-update-v1"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_doc_on_update_v1(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_doc_on_update_v1::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#subdocs"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_subdocs(arg0: i32, arg1: i32, arg2: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_subdocs::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#subdocs"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_subdocs(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_subdocs::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#subdoc-guids"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_subdoc_guids(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_subdoc_guids::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#subdoc-guids"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_subdoc_guids(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_subdoc_guids::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#encode-state-vector"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_encode_state_vector(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_encode_state_vector::<
                WitImplementation,
            >(arg0)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#encode-state-vector"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_encode_state_vector(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_encode_state_vector::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#encode-state-as-update"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_encode_state_as_update(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_encode_state_as_update::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#encode-state-as-update"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_encode_state_as_update(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_encode_state_as_update::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#encode-state-as-update-v2"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_encode_state_as_update_v2(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_encode_state_as_update_v2::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#encode-state-as-update-v2"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_encode_state_as_update_v2(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_encode_state_as_update_v2::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#apply-update"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_apply_update(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_apply_update::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#apply-update"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_apply_update(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_apply_update::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#apply-update-v2"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_apply_update_v2(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_apply_update_v2::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#apply-update-v2"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_apply_update_v2(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_apply_update_v2::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-is-readonly"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_is_readonly(
            arg0: i32,
            arg1: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_is_readonly::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-is-writeable"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_is_writeable(
            arg0: i32,
            arg1: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_is_writeable::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-origin"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_origin(arg0: i32, arg1: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_origin::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-origin"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_origin(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_origin::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-commit"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_commit(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_commit::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-state-vector-v1"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_state_vector_v1(
            arg0: i32,
            arg1: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_state_vector_v1::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-state-vector-v1"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_state_vector_v1(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_state_vector_v1::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-diff-v1"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_diff_v1(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_diff_v1::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-diff-v1"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_diff_v1(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_diff_v1::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-diff-v2"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_diff_v2(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_diff_v2::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-diff-v2"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_diff_v2(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_diff_v2::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-apply-v2"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_apply_v2(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_apply_v2::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-apply-v2"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_apply_v2(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_apply_v2::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-encode-update"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_encode_update(
            arg0: i32,
            arg1: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_encode_update::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-encode-update"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_encode_update(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_encode_update::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#transaction-encode-update-v2"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_transaction_encode_update_v2(
            arg0: i32,
            arg1: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_transaction_encode_update_v2::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#transaction-encode-update-v2"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_transaction_encode_update_v2(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_transaction_encode_update_v2::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-new"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_new(
            arg0: i32,
            arg1: i32,
            arg2: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_new::<
                WitImplementation,
            >(arg0, arg1, arg2)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-prelim"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_prelim(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_prelim::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-length"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_length(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_length::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-string"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_to_string(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_to_string::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-string"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_text_to_string(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_text_to_string::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-json"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_to_json(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_to_json::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-json"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_text_to_json(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_text_to_json::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-insert"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_insert(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
            arg6: i64,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
            arg11: i32,
            arg12: i32,
            arg13: i32,
            arg14: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_insert::<
                WitImplementation,
            >(
                arg0,
                arg1,
                arg2,
                arg3,
                arg4,
                arg5,
                arg6,
                arg7,
                arg8,
                arg9,
                arg10,
                arg11,
                arg12,
                arg13,
                arg14,
            )
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-insert-embed"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_insert_embed(arg0: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_insert_embed::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-format"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_format(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i64,
            arg5: i32,
            arg6: i32,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
            arg11: i32,
            arg12: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_format::<
                WitImplementation,
            >(
                arg0,
                arg1,
                arg2,
                arg3,
                arg4,
                arg5,
                arg6,
                arg7,
                arg8,
                arg9,
                arg10,
                arg11,
                arg12,
            )
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-push"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_push(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i64,
            arg6: i32,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
            arg11: i32,
            arg12: i32,
            arg13: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_push::<
                WitImplementation,
            >(
                arg0,
                arg1,
                arg2,
                arg3,
                arg4,
                arg5,
                arg6,
                arg7,
                arg8,
                arg9,
                arg10,
                arg11,
                arg12,
                arg13,
            )
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-delete"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_delete(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_delete::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-observe"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_observe(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_observe::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-text-observe-deep"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_text_observe_deep(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_text_observe_deep::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-new"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_new(
            arg0: i32,
            arg1: i32,
            arg2: i64,
            arg3: i32,
            arg4: i32,
            arg5: i32,
            arg6: i32,
            arg7: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_new::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-prelim"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_prelim(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_prelim::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-length"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_length(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_length::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-to-json"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_to_json(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_to_json::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-array-to-json"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_array_to_json(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_array_to_json::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-insert"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_insert(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i64,
            arg4: i32,
            arg5: i32,
            arg6: i32,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
            arg11: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_insert::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-push"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_push(
            arg0: i32,
            arg1: i32,
            arg2: i64,
            arg3: i32,
            arg4: i32,
            arg5: i32,
            arg6: i32,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_push::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-delete"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_delete(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_delete::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-move-content"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_move_content(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_move_content::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-get"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_get(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_get::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-array-get"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_array_get(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_array_get::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-observe"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_observe(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_observe::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-array-observe-deep"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_array_observe_deep(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_array_observe_deep::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-new"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_new(
            arg0: i32,
            arg1: i32,
            arg2: i64,
            arg3: i32,
            arg4: i32,
            arg5: i32,
            arg6: i32,
            arg7: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_new::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-prelim"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_prelim(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_prelim::<
                WitImplementation,
            >(arg0)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-length"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_length(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_length::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-to-json"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_to_json(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_to_json::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-map-to-json"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_map_to_json(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_map_to_json::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-set"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_set(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i64,
            arg5: i32,
            arg6: i32,
            arg7: i32,
            arg8: i32,
            arg9: i32,
            arg10: i32,
            arg11: i32,
            arg12: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_set::<
                WitImplementation,
            >(
                arg0,
                arg1,
                arg2,
                arg3,
                arg4,
                arg5,
                arg6,
                arg7,
                arg8,
                arg9,
                arg10,
                arg11,
                arg12,
            )
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-delete"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_delete(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_delete::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-get"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_get(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_get::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-map-get"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_map_get(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_map_get::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-observe"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_observe(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_observe::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-map-observe-deep"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_map_observe_deep(arg0: i32, arg1: i32) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_map_observe_deep::<
                WitImplementation,
            >(arg0, arg1)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-name"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_element_name(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_element_name::<
                WitImplementation,
            >(arg0)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-name"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_xml_element_name(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_xml_element_name::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-length"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_element_length(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_element_length::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-insert-xml-element"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_element_insert_xml_element(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
            arg6: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_element_insert_xml_element::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-insert-xml-text"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_element_insert_xml_text(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_element_insert_xml_text::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-delete"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_element_delete(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
            arg4: i32,
            arg5: i32,
        ) {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_element_delete::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3, arg4, arg5)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-fragment-name"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_fragment_name(arg0: i32) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_fragment_name::<
                WitImplementation,
            >(arg0)
        }
    };
    #[doc(hidden)]
    #[export_name = "cabi_post_y-crdt-namespace:y-crdt/y-doc-methods#y-xml-fragment-name"]
    #[allow(non_snake_case)]
    unsafe extern "C" fn __post_return_y_xml_fragment_name(arg0: i32) {
        exports::y_crdt_namespace::y_crdt::y_doc_methods::post_return_y_xml_fragment_name::<
            WitImplementation,
        >(arg0)
    }
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-fragment-length"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_fragment_length(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_fragment_length::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
    const _: () = {
        #[doc(hidden)]
        #[export_name = "y-crdt-namespace:y-crdt/y-doc-methods#y-xml-text-length"]
        #[allow(non_snake_case)]
        unsafe extern "C" fn __export_y_xml_text_length(
            arg0: i32,
            arg1: i32,
            arg2: i32,
            arg3: i32,
        ) -> i32 {
            exports::y_crdt_namespace::y_crdt::y_doc_methods::call_y_xml_text_length::<
                WitImplementation,
            >(arg0, arg1, arg2, arg3)
        }
    };
};
impl YCrdt for WitImplementation {
    fn run(value: Model) -> Result<f64, String> {
        let mapped = map_integer(value.integer);
        if mapped.is_nan() {
            Err("NaN returned from map_integer".to_string())
        } else {
            Ok(mapped)
        }
    }
}
fn parse_options(options: YDocOptions) -> Options {
    let mut opts = Options::default();
    opts.client_id = options.client_id;
    opts.guid = options.guid.into();
    opts.collection_id = options.collection_id;
    opts
        .offset_kind = match options.offset_kind {
        OffsetKind::Utf16 => yrs::OffsetKind::Utf16,
        OffsetKind::Utf32 => yrs::OffsetKind::Utf32,
        OffsetKind::Bytes => yrs::OffsetKind::Bytes,
    };
    opts.skip_gc = options.skip_gc;
    opts.auto_load = options.auto_load;
    opts.should_load = options.should_load;
    opts
}
impl YDocMethods for WitImplementation {
    fn y_doc_new(options: Option<YDocOptions>) -> YDoc {
        let options = options.map(parse_options).unwrap_or_default();
        with_mut(|m| m.save_doc(Doc::with_options(options)))
    }
    fn y_doc_parent_doc(doc: YDoc) -> Option<YDoc> {
        with_mut(|state| {
            let img = &state.docs[&doc.ref_];
            img.parent_doc().map(|d| state.save_doc(d))
        })
    }
    fn y_doc_id(doc: YDoc) -> u64 {
        operation(doc, |doc| doc.client_id())
    }
    fn y_doc_guid(doc: YDoc) -> String {
        operation(doc, |doc| doc.guid().to_string())
    }
    fn y_doc_read_transaction(doc: YDoc) -> ReadTransaction {
        with_mut_all(|state, txs| {
            let d = unsafe { std::mem::transmute(state.docs[&doc.ref_].transact()) };
            txs.save_transaction(d)
        })
    }
    fn y_doc_write_transaction(doc: YDoc, origin: Vec<u8>) -> WriteTransaction {
        with_mut_all(|state, txs| {
            let d = unsafe { std::mem::transmute(state.docs[&doc.ref_].transact_mut()) };
            txs.save_transaction_mut(d)
        })
    }
    fn y_doc_text(doc: YDoc, name: String) -> YText {
        with_mut(|state| {
            let d = &state.docs[&doc.ref_];
            state.save_text(d.get_or_insert_text(&name))
        })
    }
    fn y_doc_array(doc: YDoc, name: String) -> YArray {
        with_mut(|state| {
            let d = &state.docs[&doc.ref_];
            state.save_array(d.get_or_insert_array(&name))
        })
    }
    fn y_doc_map(doc: YDoc, name: String) -> YMap {
        with_mut(|state| {
            let d = &state.docs[&doc.ref_];
            state.save_map(d.get_or_insert_map(&name))
        })
    }
    fn y_doc_xml_fragment(doc: YDoc, _: String) -> YXmlFragment {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_doc_xml_element(doc: YDoc, _: String) -> YXmlElement {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_doc_xml_text(doc: YDoc, _: String) -> YXmlText {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_doc_on_update_v1(doc: YDoc, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn subdocs(doc: YDoc, _: YTransaction) -> Vec<String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn subdoc_guids(doc: YDoc, _: YTransaction) -> Vec<String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn encode_state_vector(doc: YDoc) -> Vec<u8> {
        operation(doc, |doc| doc.transact().state_vector().encode_v1())
    }
    fn encode_state_as_update(
        doc: YDoc,
        vector: Option<Vec<u8>>,
    ) -> Result<Vec<u8>, String> {
        operation(
            doc,
            |doc| {
                let s = doc.transact();
                let mut encoder = EncoderV1::new();
                let sv = if let Some(vector) = vector {
                    match StateVector::decode_v1(vector.to_vec().as_slice()) {
                        Ok(sv) => sv,
                        Err(e) => {
                            return Err(e.to_string());
                        }
                    }
                } else {
                    StateVector::default()
                };
                s.encode_diff(&sv, &mut encoder);
                let payload = encoder.to_vec();
                Ok(payload)
            },
        )
    }
    fn encode_state_as_update_v2(
        doc: YDoc,
        _: Option<Vec<u8>>,
    ) -> Result<Vec<u8>, String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn apply_update(doc: YDoc, diff: Vec<u8>, origin: Vec<u8>) -> Result<(), String> {
        operation(
            doc,
            |doc| {
                let mut txn = doc.transact_mut();
                let diff: Vec<u8> = diff.to_vec();
                let mut decoder = DecoderV1::from(diff.as_slice());
                match Update::decode(&mut decoder) {
                    Ok(update) => Ok(txn.apply_update(update)),
                    Err(e) => Err(e.to_string()),
                }
            },
        )
    }
    fn apply_update_v2(doc: YDoc, _: Vec<u8>, _: Vec<u8>) -> Result<(), String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn transaction_is_readonly(_: YTransaction) -> bool {
        ::core::panicking::panic("not yet implemented")
    }
    fn transaction_is_writeable(_: YTransaction) -> bool {
        ::core::panicking::panic("not yet implemented")
    }
    fn transaction_origin(t: YTransaction) -> Option<Vec<u8>> {
        with_txn_state(|state| match t {
            YTransaction::ReadTransaction(t) => None,
            YTransaction::WriteTransaction(t) => {
                state.transactions_mut[&t.ref_].origin().map(|r| r.as_ref().to_vec())
            }
        })
    }
    fn transaction_commit(t: YTransaction) {
        with_txn_state(|state| match &t {
            YTransaction::ReadTransaction(t) => {}
            YTransaction::WriteTransaction(t) => {
                state.transactions_mut.get_mut(&t.ref_).unwrap().commit()
            }
        })
    }
    fn transaction_state_vector_v1(t: YTransaction) -> Vec<u8> {
        with_txn(t, |t| t.state_vector().encode_v1().to_vec())
    }
    fn transaction_diff_v1(
        t: YTransaction,
        vector: Option<Vec<u8>>,
    ) -> Result<Vec<u8>, String> {
        with_txn(
            t,
            |t| {
                let mut encoder = EncoderV1::new();
                let sv = if let Some(vector) = vector {
                    match StateVector::decode_v1(vector.to_vec().as_slice()) {
                        Ok(sv) => sv,
                        Err(e) => {
                            return Err(e.to_string());
                        }
                    }
                } else {
                    StateVector::default()
                };
                t.encode_diff(&sv, &mut encoder);
                Ok(encoder.to_vec())
            },
        )
    }
    fn transaction_diff_v2(
        _: YTransaction,
        _: Option<Vec<u8>>,
    ) -> Result<Vec<u8>, String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn transaction_apply_v2(_: YTransaction, _: Vec<u8>) -> Result<(), String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn transaction_encode_update(t: YTransaction) -> Vec<u8> {
        match t {
            YTransaction::ReadTransaction(_) => {
                <[_]>::into_vec(#[rustc_box] ::alloc::boxed::Box::new([0u8, 0u8]))
            }
            YTransaction::WriteTransaction(txn) => {
                with_txn_state(|state| {
                    state.transactions_mut[&txn.ref_].encode_update_v1()
                })
            }
        }
    }
    fn transaction_encode_update_v2(t: YTransaction) -> Vec<u8> {
        match t {
            YTransaction::ReadTransaction(_) => {
                <[_]>::into_vec(#[rustc_box] ::alloc::boxed::Box::new([0u8, 0u8]))
            }
            YTransaction::WriteTransaction(txn) => {
                with_txn_state(|state| {
                    state.transactions_mut[&txn.ref_].encode_update_v2()
                })
            }
        }
    }
    fn y_text_new(init: Option<String>) -> YText {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_text_prelim(text: YText) -> bool {
        false
    }
    fn y_text_length(text: YText, txn: ImplicitTransaction) -> u32 {
        with_mut_all(|state, txs| {
            let text = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact(txn, text, txs);
            text.len(&txn) as u32
        })
    }
    fn y_text_to_string(text: YText, txn: ImplicitTransaction) -> String {
        with_mut_all(|state, txs| {
            let text = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact(txn, text, txs);
            text.get_string(&txn)
        })
    }
    fn y_text_to_json(text: YText, txn: ImplicitTransaction) -> String {
        Self::y_text_to_string(text, txn)
    }
    fn y_text_insert(
        text: YText,
        index: u32,
        chunk: String,
        attributes: Option<JsonObject>,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let chunk = &chunk;
            let v = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            if let Some(attrs) = attributes.map(parse_attrs) {
                v.insert_with_attributes(txn, index, chunk, attrs)
            } else {
                v.insert(txn, index, chunk)
            }
        })
    }
    fn y_text_insert_embed(
        text: YText,
        index: u32,
        embed: JsonValueItem,
        attributes: Option<JsonObject>,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let embed = map_json_value_any(embed);
            let v = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            if let Some(attrs) = attributes.map(parse_attrs) {
                v.insert_embed_with_attributes(txn, index, embed, attrs);
            } else {
                v.insert_embed(txn, index, embed);
            }
        })
    }
    fn y_text_format(
        text: YText,
        index: u32,
        length: u32,
        attributes: JsonObject,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let v = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            let attrs = parse_attrs(attributes);
            v.format(txn, index, length, attrs);
        })
    }
    fn y_text_push(
        text: YText,
        chunk: String,
        attributes: Option<JsonObject>,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let chunk = &chunk;
            let v = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            if let Some(attrs) = attributes.map(parse_attrs) {
                let index = v.len(txn);
                v.insert_with_attributes(txn, index, chunk, attrs)
            } else {
                v.push(txn, chunk)
            }
        })
    }
    fn y_text_delete(text: YText, index: u32, length: u32, txn: ImplicitTransaction) {
        with_mut_all(|state, txs| {
            let v = &state.texts[&text.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            v.remove_range(txn, index, length);
        })
    }
    fn y_text_observe(text: YText, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_text_observe_deep(text: YText, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_array_new(_: Option<JsonArray>) -> YArray {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_array_prelim(array: YArray) -> bool {
        false
    }
    fn y_array_length(array: YArray, txn: ImplicitTransaction) -> u32 {
        with_mut_all(|state, txs| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact(txn, v, txs);
            v.len(&txn)
        })
    }
    fn y_array_to_json(array: YArray, txn: ImplicitTransaction) -> JsonValueItem {
        with_mut_all(|state, txs| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact(txn, v, txs);
            map_any_json_value(v.to_json(&txn))
        })
    }
    fn y_array_insert(
        array: YArray,
        index: u32,
        items: JsonArray,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            let items = match map_json_value_any(items) {
                Any::Array(items) => items,
                _ => {
                    ::core::panicking::panic_fmt(format_args!("expected array"));
                }
            };
            insert_at(v, txn, index, items);
        })
    }
    fn y_array_push(array: YArray, items: JsonArray, txn: ImplicitTransaction) {
        with_mut_all(|state, txs: &mut TxnState| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            let index = v.len(txn);
            let items = match map_json_value_any(items) {
                Any::Array(items) => items,
                _ => {
                    ::core::panicking::panic_fmt(format_args!("expected array"));
                }
            };
            insert_at(v, txn, index, items);
        })
    }
    fn y_array_delete(array: YArray, index: u32, length: u32, txn: ImplicitTransaction) {
        with_mut_all(|state, txs| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            v.remove_range(txn, index, length);
        })
    }
    fn y_array_move_content(
        array: YArray,
        source: u32,
        target: u32,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            v.move_to(txn, source, target)
        })
    }
    fn y_array_get(
        array: YArray,
        index: u32,
        txn: ImplicitTransaction,
    ) -> Result<YValue, String> {
        with_mut_all(|state, txs| {
            let v = &state.arrays[&array.ref_];
            let txn = YTransactionInner::from_transact(txn, v, txs);
            if let Some(value) = v.get(&txn, index) {
                Ok(map_y_value(value))
            } else {
                Err("Index outside the bounds of an YArray".to_string())
            }
        })
    }
    fn y_array_observe(array: YArray, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_array_observe_deep(array: YArray, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_map_new(_: Option<JsonObject>) -> YMap {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_map_prelim(map: YMap) -> bool {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_map_length(map: YMap, txn: ImplicitTransaction) -> u32 {
        with_mut_all(|state, txs| {
            let v = &state.maps[&map.ref_];
            let txn = YTransactionInner::from_transact(txn, v, txs);
            v.len(&txn)
        })
    }
    fn y_map_to_json(map: YMap, txn: ImplicitTransaction) -> JsonValueItem {
        with_mut_all(|state, txs| {
            let v = &state.maps[&map.ref_];
            let txn = YTransactionInner::from_transact(txn, v, txs);
            map_any_json_value(v.to_json(&txn))
        })
    }
    fn y_map_set(
        map: YMap,
        key: String,
        value: JsonValueItem,
        txn: ImplicitTransaction,
    ) {
        with_mut_all(|state, txs| {
            let v = &state.maps[&map.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            v.insert(txn, key, map_json_value_any(value));
        })
    }
    fn y_map_delete(map: YMap, key: String, txn: ImplicitTransaction) {
        with_mut_all(|state, txs| {
            let v = &state.maps[&map.ref_];
            let txn = YTransactionInner::from_transact_mut(txn, v, txs);
            v.remove(txn, &key);
        })
    }
    fn y_map_get(map: YMap, key: String, txn: ImplicitTransaction) -> Option<YValue> {
        with_mut_all(|state, txs| {
            let v = &state.maps[&map.ref_];
            let txn = YTransactionInner::from_transact(txn, v, txs);
            v.get(&txn, &key).map(map_y_value)
        })
    }
    fn y_map_observe(map: YMap, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_map_observe_deep(map: YMap, _: u32) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_element_name(_: YXmlElement) -> Option<String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_element_length(_: YXmlElement, txn: ImplicitTransaction) -> u32 {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_element_insert_xml_element(
        _: YXmlElement,
        _: u32,
        _: String,
        txn: ImplicitTransaction,
    ) -> YXmlElement {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_element_insert_xml_text(
        _: YXmlElement,
        _: u32,
        txn: ImplicitTransaction,
    ) -> YXmlText {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_element_delete(_: YXmlElement, _: u32, _: u32, txn: ImplicitTransaction) {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_fragment_name(_: YXmlFragment) -> Option<String> {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_fragment_length(_: YXmlFragment, txn: ImplicitTransaction) -> u32 {
        ::core::panicking::panic("not yet implemented")
    }
    fn y_xml_text_length(_: YXmlText, txn: ImplicitTransaction) -> u32 {
        ::core::panicking::panic("not yet implemented")
    }
}
fn parse_attrs(attributes: JsonObject) -> HashMap<Arc<str>, Any> {
    match map_json_value_any(attributes) {
        Any::Map(m) => m.into_iter().map(|(k, v)| (k.into(), v)).collect(),
        _ => {
            ::core::panicking::panic_fmt(format_args!("Expected a map"));
        }
    }
}
fn map_y_value(v: Value) -> YValue {
    match v {
        Value::Any(a) => YValue::JsonValueItem(map_any_json_value(a)),
        Value::YText(a) => YValue::YText(with_mut(|state| state.save_text(a))),
        Value::YArray(a) => YValue::YArray(with_mut(|state| state.save_array(a))),
        Value::YMap(a) => YValue::YMap(with_mut(|state| state.save_map(a))),
        Value::YXmlElement(a) => {
            YValue::YXmlElement(with_mut(|state| state.save_xml_element(a)))
        }
        Value::YXmlFragment(a) => {
            YValue::YXmlFragment(with_mut(|state| state.save_xml_fragment(a)))
        }
        Value::YXmlText(a) => YValue::YXmlText(with_mut(|state| state.save_xml_text(a))),
        Value::YDoc(a) => YValue::YDoc(with_mut(|state| state.save_doc(a))),
    }
}
fn map_value(v: YValue) -> Value {
    match v {
        YValue::JsonValueItem(a) => Value::Any(map_json_value_any(a)),
        YValue::YText(a) => Value::YText(with_mut(|state| state.texts[&a.ref_].clone())),
        YValue::YArray(a) => {
            Value::YArray(with_mut(|state| state.arrays[&a.ref_].clone()))
        }
        YValue::YMap(a) => Value::YMap(with_mut(|state| state.maps[&a.ref_].clone())),
        YValue::YXmlElement(a) => {
            Value::YXmlElement(with_mut(|state| state.xml_elements[&a.ref_].clone()))
        }
        YValue::YXmlFragment(a) => {
            Value::YXmlFragment(with_mut(|state| state.xml_fragments[&a.ref_].clone()))
        }
        YValue::YXmlText(a) => {
            Value::YXmlText(with_mut(|state| state.xml_texts[&a.ref_].clone()))
        }
        YValue::YDoc(a) => Value::YDoc(with_mut(|state| state.docs[&a.ref_].clone())),
    }
}
fn map_json_value_any(v: JsonValueItem) -> Any {
    map_json_value_any_v(&v.item, &v)
}
fn map_json_value_any_v(item: &JsonValue, references: &JsonValueItem) -> Any {
    let map_ref = |a: &JsonValue| -> Any { map_json_value_any_v(a, references) };
    match item {
        JsonValue::Str(s) => Any::String(s.clone().into()),
        JsonValue::Number(n) => Any::Number(*n),
        JsonValue::Undefined => Any::Undefined,
        JsonValue::BigInt(n) => Any::BigInt(*n),
        JsonValue::Boolean(b) => Any::Bool(*b),
        JsonValue::Null => Any::Null,
        JsonValue::Buffer(v) => Any::Buffer(v.clone().into()),
        JsonValue::Array(a) => {
            Any::Array(
                references
                    .array_references[a.index as usize]
                    .iter()
                    .map(map_ref)
                    .collect(),
            )
        }
        JsonValue::Map(o) => {
            Any::Map(
                Box::new(
                    HashMap::from_iter(
                        references
                            .map_references[o.index as usize]
                            .iter()
                            .map(|(k, v)| (k.clone(), map_ref(&v))),
                    ),
                ),
            )
        }
    }
}
fn map_any_json_value(v: Any) -> JsonValueItem {
    let mut references = JsonValueItem {
        item: JsonValue::Undefined,
        map_references: ::alloc::vec::Vec::new(),
        array_references: ::alloc::vec::Vec::new(),
    };
    let item = map_any_json_value_ref(v, &mut references);
    references.item = item;
    references
}
fn map_any_json_value_ref(v: Any, references: &mut JsonValueItem) -> JsonValue {
    match v {
        Any::String(s) => JsonValue::Str(s.to_string()),
        Any::Number(n) => JsonValue::Number(n),
        Any::Undefined => JsonValue::Undefined,
        Any::BigInt(n) => JsonValue::BigInt(n),
        Any::Bool(b) => JsonValue::Boolean(b),
        Any::Null => JsonValue::Null,
        Any::Buffer(v) => JsonValue::Buffer(v.to_vec()),
        Any::Array(a) => {
            let m = Vec::from(a)
                .into_iter()
                .map(|v| map_any_json_value_ref(v, references))
                .collect();
            let index = references.array_references.len() as u32;
            references.array_references.push(m);
            JsonValue::Array(JsonArrayRef { index })
        }
        Any::Map(o) => {
            let m = o
                .into_iter()
                .map(|(k, v)| (k, map_any_json_value_ref(v, references)))
                .collect();
            let index = references.map_references.len() as u32;
            references.map_references.push(m);
            JsonValue::Map(JsonMapRef { index })
        }
    }
}
fn insert_at(dst: &ArrayRef, txn: &mut TransactionMut, index: u32, src: Box<[Any]>) {
    dst.insert_range(txn, index, src.into_vec());
}
