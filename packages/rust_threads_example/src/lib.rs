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
