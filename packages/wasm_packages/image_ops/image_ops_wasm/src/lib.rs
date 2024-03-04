use std::io::Cursor;
use std::{collections::HashMap, sync::RwLock};

use once_cell::sync::Lazy;

static IMAGES_MAP: Lazy<RwLock<GlobalState>> = Lazy::new(|| RwLock::new(Default::default()));

#[derive(Debug, Default)]
pub struct GlobalState {
    pub last_id: u32,
    pub images: HashMap<u32, image::DynamicImage>,
}

impl GlobalState {
    fn save_image(&mut self, image: image::DynamicImage) -> ImageRef {
        let id = self.last_id;
        self.last_id += 1;
        let image_ref = ImageRef {
            id,
            // TODO: pointer?
            // format: image::guess_format(&image.as_bytes())
            //     .map(map_image_format)
            //     .unwrap_or(ImageFormat::Unknown),
            // pixel: None,
            width: image.width(),
            height: image.height(),
            color: map_color_type(image.color()),
        };
        self.images.insert(id, image);
        image_ref
    }
}

fn with_mut<T>(f: impl FnOnce(&mut GlobalState) -> T) -> T {
    let mut state = IMAGES_MAP.write().unwrap();
    f(&mut state)
}

fn with<T>(f: impl FnOnce(&GlobalState) -> T) -> T {
    let state = IMAGES_MAP.read().unwrap();
    f(&state)
}

fn operation(
    image_ref: ImageRef,
    f: impl FnOnce(&image::DynamicImage) -> image::DynamicImage,
) -> ImageRef {
    with_mut(|state| {
        let img = &state.images[&image_ref.id];
        let mapped = f(img);
        state.save_image(mapped)
    })
}

// Use a procedural macro to generate bindings for the world we specified in
// `with/dart-wit-generator.wit`
wit_bindgen::generate!("image-ops");

use exports::wasm_run_dart::image_ops;
use exports::wasm_run_dart::image_ops::operations::{FilterType, ImageCrop};

// Define a custom type and implement the generated `Host` trait for it which
// represents implementing all the necessary exported interfaces for this
// component.
struct ImageOpsImpl;

export_image_ops!(ImageOpsImpl);

impl ImageOps for ImageOpsImpl {
    fn guess_buffer_format(buffer: Vec<u8>) -> Result<ImageFormat, String> {
        image::guess_format(&buffer)
            .map(map_image_format)
            .map_err(map_err)
    }

    fn format_extensions(f: ImageFormat) -> Vec<String> {
        map_image_format_to(f)
            .extensions_str()
            .iter()
            .map(|e| e.to_string())
            .collect()
    }

    fn file_image_size(path: String) -> Result<ImageSize, String> {
        image::image_dimensions(&path)
            .map(|(width, height)| ImageSize { width, height })
            .map_err(map_err)
    }

    fn image_buffer_pointer_and_size(image_ref: ImageRef) -> (u32, u32) {
        with(|state| {
            let buffer = state.images[&image_ref.id].as_bytes();
            (buffer.as_ptr() as u32, buffer.len() as u32)
        })
    }

    fn copy_image_buffer(image_ref: ImageRef) -> Image {
        with(|state| {
            let img = &state.images[&image_ref.id];
            let len = Some(img.color().channel_count() as usize)
                .and_then(|size| size.checked_mul(img.width() as usize))
                .and_then(|size| size.checked_mul(img.height() as usize));
            let bytes = img.as_bytes()[..len.unwrap()].to_vec();
            Image { bytes }
        })
    }

    fn convert_color(image_ref: ImageRef, color: ColorType) -> ImageRef {
        operation(image_ref, |img| {
            let mapped = match color {
                ColorType::L8 => image::DynamicImage::ImageLuma8(img.to_luma8()),
                ColorType::La8 => image::DynamicImage::ImageLumaA8(img.to_luma_alpha8()),
                ColorType::Rgb8 => image::DynamicImage::ImageRgb8(img.to_rgb8()),
                ColorType::Rgba8 => image::DynamicImage::ImageRgba8(img.to_rgba8()),
                ColorType::L16 => image::DynamicImage::ImageLuma16(img.to_luma16()),
                ColorType::La16 => image::DynamicImage::ImageLumaA16(img.to_luma_alpha16()),
                ColorType::Rgb16 => image::DynamicImage::ImageRgb16(img.to_rgb16()),
                ColorType::Rgba16 => image::DynamicImage::ImageRgba16(img.to_rgba16()),
                ColorType::Rgb32f => image::DynamicImage::ImageRgb32F(img.to_rgb32f()),
                ColorType::Rgba32f => image::DynamicImage::ImageRgba32F(img.to_rgba32f()),
                ColorType::Unknown => img.clone(),
            };
            mapped
        })
    }

    fn convert_format(image_ref: ImageRef, image_format: ImageFormat) -> Result<Vec<u8>, String> {
        with(|state| {
            use image::error::*;
            use image::DynamicImage;
            let mut output = Cursor::new(Vec::new());
            let image_format = map_image_format_to(image_format);
            let img = &state.images[&image_ref.id];
            match img {
                DynamicImage::ImageLuma8(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageLumaA8(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageRgb8(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageRgba8(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageLuma16(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageLumaA16(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageRgb16(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageRgba16(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageRgb32F(p) => p.write_to(&mut output, image_format),
                DynamicImage::ImageRgba32F(p) => p.write_to(&mut output, image_format),
                _ => Err(image::ImageError::Unsupported(
                    UnsupportedError::from_format_and_kind(
                        ImageFormatHint::Unknown,
                        UnsupportedErrorKind::GenericFeature(
                            "Unsupported input format".to_string(),
                        ),
                    ),
                )),
            }
            .map_err(map_err)?;
            Ok(output.into_inner())
        })
    }

    fn dispose_image(image_ref: ImageRef) -> Result<u32, String> {
        with_mut(|state| {
            state
                .images
                .remove(&image_ref.id)
                .map(|_| image_ref.id)
                .ok_or_else(|| "Image not found".to_string())
        })
    }

    fn read_buffer(buffer: Vec<u8>) -> Result<ImageRef, String> {
        image::load_from_memory(&buffer)
            .map(|image| with_mut(|state| state.save_image(image)))
            .map_err(map_err)
    }

    fn read_file(path: String) -> Result<ImageRef, String> {
        image::open(path)
            .map(|image| with_mut(|state| state.save_image(image)))
            .map_err(map_err)
    }

    fn save_file(image_ref: ImageRef, path: String) -> Result<u32, String> {
        with(|state| {
            let img = &state.images[&image_ref.id];
            let len = img.as_bytes().len() as u32;
            // TODO: save with format
            img.save(path).map(|_| len).map_err(map_err)
        })
    }
}

impl image_ops::operations::Operations for ImageOpsImpl {
    fn blur(image_ref: ImageRef, sigma: f32) -> ImageRef {
        operation(image_ref, |img| img.blur(sigma))
    }

    fn brighten(image_ref: ImageRef, value: i32) -> ImageRef {
        operation(image_ref, |img| img.brighten(value))
    }

    fn huerotate(image_ref: ImageRef, value: i32) -> ImageRef {
        operation(image_ref, |img| img.huerotate(value))
    }
    fn adjust_contrast(image_ref: ImageRef, c: f32) -> ImageRef {
        operation(image_ref, |img| img.adjust_contrast(c))
    }

    fn flip_horizontal(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| img.fliph())
    }
    fn flip_vertical(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| img.flipv())
    }
    fn grayscale(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| img.grayscale())
    }
    fn invert(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| {
            let mut nimg = img.clone();
            nimg.invert();
            nimg
        })
    }
    fn rotate180(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| img.rotate180())
    }
    fn rotate270(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| img.rotate270())
    }
    fn rotate90(image_ref: ImageRef) -> ImageRef {
        operation(image_ref, |img| img.rotate90())
    }

    fn unsharpen(image_ref: ImageRef, sigma: f32, threshold: i32) -> ImageRef {
        operation(image_ref, |img| img.unsharpen(sigma, threshold))
    }

    fn resize(image_ref: ImageRef, size: ImageSize, filter: FilterType) -> ImageRef {
        operation(image_ref, |img| {
            img.resize(size.width, size.height, map_filter_type(filter))
        })
    }

    fn resize_exact(image_ref: ImageRef, size: ImageSize, filter: FilterType) -> ImageRef {
        operation(image_ref, |img| {
            img.resize_exact(size.width, size.height, map_filter_type(filter))
        })
    }

    fn resize_to_fill(image_ref: ImageRef, size: ImageSize, filter: FilterType) -> ImageRef {
        operation(image_ref, |img| {
            img.resize_to_fill(size.width, size.height, map_filter_type(filter))
        })
    }

    fn crop(image_ref: ImageRef, image_crop: ImageCrop) -> ImageRef {
        operation(image_ref, |img| {
            img.crop_imm(
                image_crop.x,
                image_crop.y,
                image_crop.width,
                image_crop.height,
            )
        })
    }

    fn filter3x3(image_ref: ImageRef, kernel: Vec<f32>) -> ImageRef {
        operation(image_ref, |img| img.filter3x3(&kernel))
    }

    fn thumbnail(image_ref: ImageRef, size: ImageSize) -> ImageRef {
        operation(image_ref, |img| img.thumbnail(size.width, size.height))
    }
    fn thumbnail_exact(image_ref: ImageRef, size: ImageSize) -> ImageRef {
        operation(image_ref, |img| {
            img.thumbnail_exact(size.width, size.height)
        })
    }

    fn overlay(image_ref: ImageRef, other: ImageRef, x: u32, y: u32) -> ImageRef {
        with_mut(|state| {
            // image::imageops::dither(image, color_map)
            // image::imageops::tile(bottom, top)
            // image::imageops::vertical_gradient(img, start, stop)
            // image::imageops::horizontal_gradient(img, start, stop)
            let mut new_img = state.images[&image_ref.id].clone();
            let other_img = &state.images[&other.id];

            image::imageops::overlay(&mut new_img, other_img, x.into(), y.into());
            state.save_image(new_img)
        })
    }
    fn replace(image_ref: ImageRef, other: ImageRef, x: u32, y: u32) -> ImageRef {
        with_mut(|state| {
            let mut new_img = state.images[&image_ref.id].clone();
            let other_img = &state.images[&other.id];

            image::imageops::replace(&mut new_img, other_img, x.into(), y.into());
            state.save_image(new_img)
        })
    }
}

fn map_err(e: image::ImageError) -> String {
    e.to_string()
}

fn map_image_format(f: image::ImageFormat) -> ImageFormat {
    match f {
        image::ImageFormat::Png => ImageFormat::Png,
        image::ImageFormat::Jpeg => ImageFormat::Jpeg,
        image::ImageFormat::Gif => ImageFormat::Gif,
        image::ImageFormat::WebP => ImageFormat::WebP,
        image::ImageFormat::Pnm => ImageFormat::Pnm,
        image::ImageFormat::Tiff => ImageFormat::Tiff,
        image::ImageFormat::Tga => ImageFormat::Tga,
        image::ImageFormat::Dds => ImageFormat::Dds,
        image::ImageFormat::Bmp => ImageFormat::Bmp,
        image::ImageFormat::Ico => ImageFormat::Ico,
        image::ImageFormat::Hdr => ImageFormat::Hdr,
        image::ImageFormat::Farbfeld => ImageFormat::Farbfeld,
        _ => ImageFormat::Unknown,
    }
}

fn map_image_format_to(f: ImageFormat) -> image::ImageFormat {
    match f {
        ImageFormat::Png => image::ImageFormat::Png,
        ImageFormat::Jpeg => image::ImageFormat::Jpeg,
        ImageFormat::Gif => image::ImageFormat::Gif,
        ImageFormat::WebP => image::ImageFormat::WebP,
        ImageFormat::Pnm => image::ImageFormat::Pnm,
        ImageFormat::Tiff => image::ImageFormat::Tiff,
        ImageFormat::Tga => image::ImageFormat::Tga,
        ImageFormat::Dds => image::ImageFormat::Dds,
        ImageFormat::Bmp => image::ImageFormat::Bmp,
        ImageFormat::Ico => image::ImageFormat::Ico,
        ImageFormat::Hdr => image::ImageFormat::Hdr,
        ImageFormat::Farbfeld => image::ImageFormat::Farbfeld,
        ImageFormat::OpenExr => image::ImageFormat::OpenExr,
        ImageFormat::Qoi => image::ImageFormat::Qoi,
        ImageFormat::Avif => image::ImageFormat::Avif,
        ImageFormat::Unknown => image::ImageFormat::Png,
    }
}

fn map_color_type(f: image::ColorType) -> ColorType {
    match f {
        image::ColorType::L8 => ColorType::L8,
        image::ColorType::La8 => ColorType::La8,
        image::ColorType::Rgb8 => ColorType::Rgb8,
        image::ColorType::Rgba8 => ColorType::Rgba8,
        image::ColorType::L16 => ColorType::L16,
        image::ColorType::La16 => ColorType::La16,
        image::ColorType::Rgb16 => ColorType::Rgb16,
        image::ColorType::Rgba16 => ColorType::Rgba16,
        _ => ColorType::Unknown,
    }
}

fn map_filter_type(f: FilterType) -> image::imageops::FilterType {
    match f {
        FilterType::Nearest => image::imageops::FilterType::Nearest,
        FilterType::CatmullRom => image::imageops::FilterType::CatmullRom,
        FilterType::Gaussian => image::imageops::FilterType::Gaussian,
        FilterType::Lanczos3 => image::imageops::FilterType::Lanczos3,
        FilterType::Triangle => image::imageops::FilterType::Triangle,
    }
}
