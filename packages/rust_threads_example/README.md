We need cargo nightly for importing a WASM shared memory:

```
RUSTFLAGS='-C target-feature=+atomics,+bulk-memory,+mutable-globals' \
  cargo +nightly build --target wasm32-unknown-unknown --release -Z build-std=std,panic_abort
```