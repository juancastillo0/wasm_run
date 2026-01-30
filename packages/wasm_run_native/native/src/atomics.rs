use std::{cell::UnsafeCell, sync::atomic};

pub enum AtomicKind {
    I8,
    I16,
    I32,
    I64,
    U8,
    U16,
    U32,
    U64,
}

pub enum AtomicOrdering {
    Relaxed,
    Release,
    Acquire,
    AcqRel,
    SeqCst,
}

impl From<AtomicOrdering> for atomic::Ordering {
    fn from(order: AtomicOrdering) -> Self {
        match order {
            AtomicOrdering::Relaxed => atomic::Ordering::Relaxed,
            AtomicOrdering::Release => atomic::Ordering::Release,
            AtomicOrdering::Acquire => atomic::Ordering::Acquire,
            AtomicOrdering::AcqRel => atomic::Ordering::AcqRel,
            AtomicOrdering::SeqCst => atomic::Ordering::SeqCst,
        }
    }
}

/// Result of [SharedMemory.atomicWait32] and [SharedMemory.atomicWait64]
#[derive(Copy, Clone, PartialEq, Eq, Debug)]
#[allow(non_camel_case_types)]
pub enum SharedMemoryWaitResult {
    /// Indicates that a `wait` completed by being awoken by a different thread.
    /// This means the thread went to sleep and didn't time out.
    ok = 0,
    /// Indicates that `wait` did not complete and instead returned due to the
    /// value in memory not matching the expected value.
    mismatch = 1,
    /// Indicates that `wait` completed with a timeout, meaning that the
    /// original value matched as expected but nothing ever called `notify`.
    timedOut = 2,
}

#[cfg(feature = "wasmtime")]
impl From<wasmtime::WaitResult> for SharedMemoryWaitResult {
    fn from(result: wasmtime::WaitResult) -> Self {
        match result {
            wasmtime::WaitResult::Ok => SharedMemoryWaitResult::ok,
            wasmtime::WaitResult::Mismatch => SharedMemoryWaitResult::mismatch,
            wasmtime::WaitResult::TimedOut => SharedMemoryWaitResult::timedOut,
        }
    }
}

pub struct CompareExchangeResult {
    pub success: bool,
    pub value: i64,
}

macro_rules! create_atomic {
    ($integer_struct:ty, $integer:ty, $integer_atomic:ty) => {
        impl $integer_struct {
            pub unsafe fn load(&self, offset: usize, order: AtomicOrdering) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.load(order.into())
            }

            pub unsafe fn store(&self, offset: usize, val: $integer, order: AtomicOrdering) {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.store(val, order.into())
            }

            pub unsafe fn swap(
                &self,
                offset: usize,
                val: $integer,
                order: AtomicOrdering,
            ) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.swap(val, order.into())
            }

            pub unsafe fn compare_exchange(
                &self,
                offset: usize,
                current: $integer,
                new: $integer,
                success: AtomicOrdering,
                failure: AtomicOrdering,
            ) -> Result<$integer, $integer> {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.compare_exchange(
                    current,
                    new,
                    success.into(),
                    failure.into(),
                )
            }

            pub unsafe fn add(
                &self,
                offset: usize,
                val: $integer,
                order: AtomicOrdering,
            ) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.fetch_add(val, order.into())
            }

            pub unsafe fn sub(
                &self,
                offset: usize,
                val: $integer,
                order: AtomicOrdering,
            ) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.fetch_sub(val, order.into())
            }

            pub unsafe fn and(
                &self,
                offset: usize,
                val: $integer,
                order: AtomicOrdering,
            ) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.fetch_and(val, order.into())
            }

            pub unsafe fn or(
                &self,
                offset: usize,
                val: $integer,
                order: AtomicOrdering,
            ) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.fetch_or(val, order.into())
            }

            pub unsafe fn xor(
                &self,
                offset: usize,
                val: $integer,
                order: AtomicOrdering,
            ) -> $integer {
                let r = &(self.0 as *const UnsafeCell<u8>).add(offset);
                { &*(r as *const _ as *const $integer_atomic) }.fetch_xor(val, order.into())
            }
        }
    };
}

pub struct Ati8(pub usize);
create_atomic!(Ati8, i8, atomic::AtomicI8);
pub struct Ati16(pub usize);
create_atomic!(Ati16, i16, atomic::AtomicI16);
pub struct Ati32(pub usize);
create_atomic!(Ati32, i32, atomic::AtomicI32);
pub struct Ati64(pub usize);
create_atomic!(Ati64, i64, atomic::AtomicI64);
pub struct Atu8(pub usize);
create_atomic!(Atu8, u8, atomic::AtomicU8);
pub struct Atu16(pub usize);
create_atomic!(Atu16, u16, atomic::AtomicU16);
pub struct Atu32(pub usize);
create_atomic!(Atu32, u32, atomic::AtomicU32);
pub struct Atu64(pub usize);
create_atomic!(Atu64, u64, atomic::AtomicU64);

pub struct Atomics(pub usize);
