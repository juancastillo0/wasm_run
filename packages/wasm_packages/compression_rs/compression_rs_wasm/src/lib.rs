mod archive;

pub use crate::archive::*;
use std::fmt::Display;
use std::fs::File;
use std::io::prelude::*;

// Use a procedural macro to generate bindings for the world we specified in `compression-rs.wit`
wit_bindgen::generate!("compression-rs");

use compression_rs_namespace::compression_rs::flate::Input;
use exports::compression_rs_namespace::compression_rs;

// Define a custom type and implement the generated trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct WitImplementation;

export_compression_rs!(WitImplementation);

impl Input {
    fn with_read<T>(
        &mut self,
        f: impl FnOnce(&mut dyn Read) -> Result<T, String>,
    ) -> Result<T, String> {
        match self {
            Input::Bytes(bytes) => f(&mut bytes.as_slice()),
            #[cfg(feature = "wasi")]
            Input::File(file) => f(&mut File::open(file).map_err(map_err)?),
            #[cfg(not(feature = "wasi"))]
            Input::File(file) => {
                Err(format!("The wasm module should be compiled with the wasi feature. Tried to open file {file}."))
            }
        }
    }
}

pub fn map_err<E: Display>(e: E) -> String {
    e.to_string()
}

#[cfg(not(feature = "brotli"))]
#[allow(unused_variables, unused_mut)]
impl compression_rs::brotli::Brotli for WitImplementation {
    fn brotli_compress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the brotli feature".to_string());
    }
    fn brotli_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the brotli feature".to_string());
    }
    fn brotli_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the brotli feature".to_string());
    }
    fn brotli_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the brotli feature".to_string());
    }
}

#[cfg(feature = "brotli")]
impl compression_rs::brotli::Brotli for WitImplementation {
    fn brotli_compress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut w = brotli::CompressorWriter::with_params(
                Vec::new(),
                4096, /* buffer size */
                &brotli::enc::BrotliEncoderParams::default(),
            );
            std::io::copy(i, &mut w).map_err(map_err)?;
            Ok(w.into_inner())
        })
    }

    fn brotli_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut d = brotli::Decompressor::new(i, 4096 /* buffer size */);
            let mut output = Vec::new();
            d.read_to_end(&mut output).map_err(map_err)?;
            Ok(output)
        })
    }

    fn brotli_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let file = File::options().write(true).open(path).map_err(map_err)?;
            let mut w = brotli::CompressorWriter::with_params(
                file,
                4096, /* buffer size */
                &brotli::enc::BrotliEncoderParams::default(),
            );
            let size = std::io::copy(i, &mut w).map_err(map_err)?;
            Ok(size)
        })
    }

    fn brotli_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let mut d = brotli::Decompressor::new(i, 4096 /* buffer size */);
            let mut file = File::options().write(true).open(path).map_err(map_err)?;
            let size = std::io::copy(&mut d, &mut file).map_err(map_err)?;
            Ok(size)
        })
    }
}

#[cfg(not(feature = "zstd"))]
#[allow(unused_variables, unused_mut)]
impl compression_rs::zstd::Zstd for WitImplementation {
    fn zstd_compress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the zstd feature".to_string());
    }
    fn zstd_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the zstd feature".to_string());
    }
    fn zstd_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the zstd feature".to_string());
    }
    fn zstd_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the zstd feature".to_string());
    }
}

#[cfg(feature = "zstd")]
impl compression_rs::zstd::Zstd for WitImplementation {
    fn zstd_compress(mut _i: Input) -> Result<Vec<u8>, String> {
        Err("zstd compression is not implemented".to_string())
    }

    fn zstd_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut d = ruzstd::FrameDecoder::new();
            d.init(i).map_err(map_err)?;
            let mut output = Vec::new();
            d.read_to_end(&mut output).map_err(map_err)?;
            Ok(output)
        })
    }

    fn zstd_compress_file(mut _i: Input, _path: String) -> Result<u64, String> {
        Err("zstd compression is not implemented".to_string())
    }

    fn zstd_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let mut d = ruzstd::FrameDecoder::new();
            d.init(i).map_err(map_err)?;
            let mut file = File::options().write(true).open(path).map_err(map_err)?;
            let size = std::io::copy(&mut d, &mut file).map_err(map_err)?;
            Ok(size)
        })
    }
}

#[cfg(not(feature = "lz4"))]
#[allow(unused_variables, unused_mut)]
impl compression_rs::lz4::Lz4 for WitImplementation {
    fn lz4_compress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the lz4 feature".to_string());
    }
    fn lz4_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the lz4 feature".to_string());
    }
    fn lz4_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the lz4 feature".to_string());
    }
    fn lz4_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the lz4 feature".to_string());
    }
}

#[cfg(feature = "lz4")]
impl compression_rs::lz4::Lz4 for WitImplementation {
    fn lz4_compress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut w = lz4_flex::frame::FrameEncoder::new(Vec::new());
            std::io::copy(i, &mut w).map_err(map_err)?;
            Ok(w.finish().map_err(map_err)?)
        })
    }

    fn lz4_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut d = lz4_flex::frame::FrameDecoder::new(i);
            let mut output = Vec::new();
            d.read_to_end(&mut output).map_err(map_err)?;
            Ok(output)
        })
    }

    fn lz4_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let file = File::options().write(true).open(path).map_err(map_err)?;
            let mut w = lz4_flex::frame::FrameEncoder::new(file);
            let size = std::io::copy(i, &mut w).map_err(map_err)?;
            w.finish().map_err(map_err)?;
            Ok(size)
        })
    }

    fn lz4_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let mut d = lz4_flex::frame::FrameDecoder::new(i);
            let mut file = File::options().write(true).open(path).map_err(map_err)?;
            let size = std::io::copy(&mut d, &mut file).map_err(map_err)?;
            Ok(size)
        })
    }
}

#[cfg(not(feature = "gzip"))]
#[allow(unused_variables, unused_mut)]
impl compression_rs::gzip::Gzip for WitImplementation {
    fn gzip_compress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the gzip feature".to_string());
    }
    fn gzip_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the gzip feature".to_string());
    }
    fn gzip_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the gzip feature".to_string());
    }
    fn gzip_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the gzip feature".to_string());
    }
}

#[cfg(feature = "gzip")]
impl compression_rs::gzip::Gzip for WitImplementation {
    fn gzip_compress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut w = flate2::write::GzEncoder::new(Vec::new(), flate2::Compression::default());
            std::io::copy(i, &mut w).map_err(map_err)?;
            Ok(w.finish().map_err(map_err)?)
        })
    }

    fn gzip_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut d = flate2::read::GzDecoder::new(i);
            let mut output = Vec::new();
            d.read_to_end(&mut output).map_err(map_err)?;
            Ok(output)
        })
    }

    fn gzip_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let file = File::options().write(true).open(path).map_err(map_err)?;
            let mut w = flate2::write::GzEncoder::new(file, flate2::Compression::default());
            let size = std::io::copy(i, &mut w).map_err(map_err)?;
            w.finish().map_err(map_err)?;
            Ok(size)
        })
    }

    fn gzip_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let mut d = flate2::read::GzDecoder::new(i);
            let mut file = File::options().write(true).open(path).map_err(map_err)?;
            let size = std::io::copy(&mut d, &mut file).map_err(map_err)?;
            Ok(size)
        })
    }
}

#[cfg(not(feature = "zlib"))]
#[allow(unused_variables, unused_mut)]
impl compression_rs::zlib::Zlib for WitImplementation {
    fn zlib_compress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the zlib feature".to_string());
    }
    fn zlib_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the zlib feature".to_string());
    }
    fn zlib_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the zlib feature".to_string());
    }
    fn zlib_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the zlib feature".to_string());
    }
}

#[cfg(feature = "zlib")]
impl compression_rs::zlib::Zlib for WitImplementation {
    fn zlib_compress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut w = flate2::write::ZlibEncoder::new(Vec::new(), flate2::Compression::default());
            std::io::copy(i, &mut w).map_err(map_err)?;
            Ok(w.finish().map_err(map_err)?)
        })
    }

    fn zlib_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut d = flate2::read::ZlibDecoder::new(i);
            let mut output = Vec::new();
            d.read_to_end(&mut output).map_err(map_err)?;
            Ok(output)
        })
    }

    fn zlib_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let file = File::options().write(true).open(path).map_err(map_err)?;
            let mut w = flate2::write::ZlibEncoder::new(file, flate2::Compression::default());
            let size = std::io::copy(i, &mut w).map_err(map_err)?;
            w.finish().map_err(map_err)?;
            Ok(size)
        })
    }

    fn zlib_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let mut d = flate2::read::ZlibDecoder::new(i);
            let mut file = File::options().write(true).open(path).map_err(map_err)?;
            let size = std::io::copy(&mut d, &mut file).map_err(map_err)?;
            Ok(size)
        })
    }
}

#[cfg(not(feature = "deflate"))]
#[allow(unused_variables, unused_mut)]
impl compression_rs::deflate::Deflate for WitImplementation {
    fn deflate_compress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the deflate feature".to_string());
    }
    fn deflate_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        Err("The wasm module should be compiled with the deflate feature".to_string());
    }
    fn deflate_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the deflate feature".to_string());
    }
    fn deflate_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        Err("The wasm module should be compiled with the deflate feature".to_string());
    }
}

#[cfg(feature = "deflate")]
impl compression_rs::deflate::Deflate for WitImplementation {
    fn deflate_compress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut w =
                flate2::write::DeflateEncoder::new(Vec::new(), flate2::Compression::default());
            std::io::copy(i, &mut w).map_err(map_err)?;
            Ok(w.finish().map_err(map_err)?)
        })
    }

    fn deflate_decompress(mut i: Input) -> Result<Vec<u8>, String> {
        i.with_read(|i| {
            let mut d = flate2::read::DeflateDecoder::new(i);
            let mut output = Vec::new();
            d.read_to_end(&mut output).map_err(map_err)?;
            Ok(output)
        })
    }

    fn deflate_compress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let file = File::options().write(true).open(path).map_err(map_err)?;
            let mut w = flate2::write::DeflateEncoder::new(file, flate2::Compression::default());
            let size = std::io::copy(i, &mut w).map_err(map_err)?;
            w.finish().map_err(map_err)?;
            Ok(size)
        })
    }

    fn deflate_decompress_file(mut i: Input, path: String) -> Result<u64, String> {
        i.with_read(|i| {
            let mut d = flate2::read::DeflateDecoder::new(i);
            let mut file = File::options().write(true).open(path).map_err(map_err)?;
            let size = std::io::copy(&mut d, &mut file).map_err(map_err)?;
            Ok(size)
        })
    }
}
