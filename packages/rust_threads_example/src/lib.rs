// This requires nightly rust and wasm32-unknown-unknown target,
// you may comment out simd code and compile it in stable rust
#![feature(portable_simd)]

use std::cell::RefCell;
use std::simd::{i64x2, u32x4, SimdInt, SimdUint};
use std::sync::atomic::{AtomicI64, Ordering};

static STATE: AtomicI64 = AtomicI64::new(0);
thread_local!(static STATE_LOCAL: RefCell<u32> = RefCell::new(0));

#[no_mangle]
pub extern "C" fn sum_u32(pointer: *mut u32, length: usize) -> u32 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    slice.iter().sum()
}

#[no_mangle]
pub extern "C" fn max_u32(pointer: *mut u32, length: usize) -> u32 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    *slice.iter().max().unwrap()
}

#[no_mangle]
pub extern "C" fn simd_sum_u32(pointer: *mut u32, length: usize) -> u32 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    let mut sum = u32x4::splat(0); // [0, 0, 0, 0]
    for i in (0..slice.len()).step_by(4) {
        sum += u32x4::from_slice(&slice[i..]);
    }
    sum.reduce_sum()
}

#[no_mangle]
pub extern "C" fn simd_max_u32(pointer: *mut u32, length: usize) -> u32 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    let mut sum = u32x4::splat(0); // [0, 0, 0, 0]
    for i in (0..slice.len()).step_by(4) {
        sum = sum.max(u32x4::from_slice(&slice[i..]));
    }
    sum.reduce_max()
}

#[no_mangle]
pub extern "C" fn sum_i64(pointer: *mut i64, length: usize) -> i64 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    slice.iter().sum()
}

#[no_mangle]
pub extern "C" fn max_i64(pointer: *mut i64, length: usize) -> i64 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    *slice.iter().max().unwrap()
}

#[no_mangle]
pub extern "C" fn simd_sum_i64(pointer: *mut i64, length: usize) -> i64 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    let mut sum = i64x2::splat(0); // [0, 0, 0, 0]
    for i in (0..slice.len()).step_by(4) {
        sum += i64x2::from_slice(&slice[i..]);
    }
    sum.reduce_sum()
}

#[no_mangle]
pub extern "C" fn simd_max_i64(pointer: *mut i64, length: usize) -> i64 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    let mut sum = i64x2::splat(0); // [0, 0, 0, 0]
    for i in (0..slice.len()).step_by(4) {
        sum = sum.max(i64x2::from_slice(&slice[i..]));
    }
    sum.reduce_max()
}

#[no_mangle]
pub extern "C" fn sum_f32(pointer: *mut f32, length: usize) -> f32 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    slice.iter().sum()
}

#[no_mangle]
pub extern "C" fn max_f32(pointer: *mut f32, length: usize) -> f32 {
    let slice = unsafe { std::slice::from_raw_parts(pointer, length) };
    slice.iter().cloned().reduce(f32::max).unwrap()
}

#[no_mangle]
pub extern "C" fn get_state_local() -> u32 {
    STATE_LOCAL.with(|cell| *cell.borrow())
}

#[no_mangle]
pub extern "C" fn set_state_local(value: u32) -> u32 {
    STATE_LOCAL.with(|cell| {
        let mut m = cell.borrow_mut();
        let previous = *m;
        *m = value;
        previous
    })
}

#[no_mangle]
pub extern "C" fn get_state() -> i64 {
    STATE.load(Ordering::SeqCst)
}

#[no_mangle]
pub extern "C" fn increase_state(value: i64) -> i64 {
    STATE.fetch_add(value, Ordering::SeqCst)
}

#[no_mangle]
pub extern "C" fn map_state() {
    let mut result = Err(STATE.load(Ordering::SeqCst));
    while let Err(value) = result {
        let mapped = unsafe { host_map_state(value) };
        result = STATE.compare_exchange(value, mapped, Ordering::SeqCst, Ordering::SeqCst);
    }
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

#[link(wasm_import_module = "threaded_imports")]
extern "C" {
    fn host_map_state(state: i64) -> i64;
}
