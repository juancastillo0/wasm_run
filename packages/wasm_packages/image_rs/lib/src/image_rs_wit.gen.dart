// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

enum PixelType {
  /// RGB pixel
  rgb,

  /// RGB with alpha (RGBA pixel)
  rgba,

  /// Grayscale pixel
  luma,

  /// Grayscale with alpha
  lumaA;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory PixelType.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['rgb', 'rgba', 'luma', 'luma-a']);
}

class ImageSize {
  final int /*U32*/ width;
  final int /*U32*/ height;
  const ImageSize({
    required this.width,
    required this.height,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ImageSize.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final width, final height] || (final width, final height) => ImageSize(
          width: width! as int,
          height: height! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'width': width,
        'height': height,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [width, height];
  @override
  String toString() =>
      'ImageSize${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ImageSize copyWith({
    int /*U32*/ ? width,
    int /*U32*/ ? height,
  }) =>
      ImageSize(width: width ?? this.width, height: height ?? this.height);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageSize && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [width, height];
  static const _spec =
      RecordType([(label: 'width', t: U32()), (label: 'height', t: U32())]);
}

enum ImageFormat {
  /// All supported color types	Same as decoding
  png,

  /// Baseline and progressive	Baseline JPEG
  jpeg,

  /// Yes	Yes
  gif,

  /// Yes	Rgb8, Rgba8, Gray8, GrayA8
  bmp,

  /// Yes	Yes
  ico,

  /// Baseline(no fax support) + LZW + PackBits	Rgb8, Rgba8, Gray8
  tiff,

  /// Yes	Rgb8, Rgba8*
  webP,

  /// No**	Lossy
  avif,

  /// PBM, PGM, PPM, standard PAM	Yes
  pnm,

  /// DXT1, DXT3, DXT5	No
  dds,

  /// Yes	Rgb8, Rgba8, Bgr8, Bgra8, Gray8, GrayA8
  tga,

  /// Rgb32F, Rgba32F (no dwa compression)	Rgb32F, Rgba32F (no dwa compression)
  openExr,

  /// Yes	Yes
  farbfeld,
  hdr,
  qoi,
  unknown;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ImageFormat.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'png',
    'jpeg',
    'gif',
    'bmp',
    'ico',
    'tiff',
    'web-p',
    'avif',
    'pnm',
    'dds',
    'tga',
    'open-exr',
    'farbfeld',
    'hdr',
    'qoi',
    'unknown'
  ]);
}

class Image {
  final Uint8List bytes;
  const Image({
    required this.bytes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Image.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final bytes] || (final bytes,) => Image(
          bytes: (bytes is Uint8List
              ? bytes
              : Uint8List.fromList((bytes! as List).cast())),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'bytes': bytes.toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [bytes];
  @override
  String toString() =>
      'Image${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Image copyWith({
    Uint8List? bytes,
  }) =>
      Image(bytes: bytes ?? this.bytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Image && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [bytes];
  static const _spec = RecordType([(label: 'bytes', t: ListType(U8()))]);
}

enum ColorType {
  l8,
  la8,
  rgb8,
  rgba8,
  l16,
  la16,
  rgb16,
  rgba16,
  rgb32f,
  rgba32f,
  unknown;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ColorType.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'l8',
    'la8',
    'rgb8',
    'rgba8',
    'l16',
    'la16',
    'rgb16',
    'rgba16',
    'rgb32f',
    'rgba32f',
    'unknown'
  ]);
}

class ImageRef {
  final int /*U32*/ id;
  final ImageFormat format;
  final ColorType color;
  final int /*U32*/ width;
  final int /*U32*/ height;
  const ImageRef({
    required this.id,
    required this.format,
    required this.color,
    required this.width,
    required this.height,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ImageRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final id, final format, final color, final width, final height] ||
      (final id, final format, final color, final width, final height) =>
        ImageRef(
          id: id! as int,
          format: ImageFormat.fromJson(format),
          color: ColorType.fromJson(color),
          width: width! as int,
          height: height! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'id': id,
        'format': format.toJson(),
        'color': color.toJson(),
        'width': width,
        'height': height,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [id, format.toWasm(), color.toWasm(), width, height];
  @override
  String toString() =>
      'ImageRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ImageRef copyWith({
    int /*U32*/ ? id,
    ImageFormat? format,
    ColorType? color,
    int /*U32*/ ? width,
    int /*U32*/ ? height,
  }) =>
      ImageRef(
          id: id ?? this.id,
          format: format ?? this.format,
          color: color ?? this.color,
          width: width ?? this.width,
          height: height ?? this.height);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageRef && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [id, format, color, width, height];
  static const _spec = RecordType([
    (label: 'id', t: U32()),
    (label: 'format', t: ImageFormat._spec),
    (label: 'color', t: ColorType._spec),
    (label: 'width', t: U32()),
    (label: 'height', t: U32())
  ]);
}

class ImageCrop {
  final int /*U32*/ x;
  final int /*U32*/ y;
  final int /*U32*/ width;
  final int /*U32*/ height;
  const ImageCrop({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ImageCrop.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final x, final y, final width, final height] ||
      (final x, final y, final width, final height) =>
        ImageCrop(
          x: x! as int,
          y: y! as int,
          width: width! as int,
          height: height! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [x, y, width, height];
  @override
  String toString() =>
      'ImageCrop${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ImageCrop copyWith({
    int /*U32*/ ? x,
    int /*U32*/ ? y,
    int /*U32*/ ? width,
    int /*U32*/ ? height,
  }) =>
      ImageCrop(
          x: x ?? this.x,
          y: y ?? this.y,
          width: width ?? this.width,
          height: height ?? this.height);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageCrop && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [x, y, width, height];
  static const _spec = RecordType([
    (label: 'x', t: U32()),
    (label: 'y', t: U32()),
    (label: 'width', t: U32()),
    (label: 'height', t: U32())
  ]);
}

enum FilterType {
  /// Nearest Neighbor
  nearest,

  /// Linear Filter
  triangle,

  /// Cubic Filter
  catmullRom,

  /// Gaussian Filter
  gaussian,

  /// Lanczos with window 3
  lanczos3;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FilterType.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['nearest', 'triangle', 'catmull-rom', 'gaussian', 'lanczos3']);
}

sealed class ImageError {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ImageError.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (
        k is int ? k : _spec.cases.indexWhere((c) => c.label == k),
        json.values.first
      );
    }
    return switch (json) {
      (0, final value) || [0, final value] => ImageErrorDecoding(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => ImageErrorEncoding(
          value is String ? value : (value! as ParsedString).value),
      (2, final value) || [2, final value] => ImageErrorParameter(
          value is String ? value : (value! as ParsedString).value),
      (3, final value) || [3, final value] => ImageErrorLimits(
          value is String ? value : (value! as ParsedString).value),
      (4, final value) || [4, final value] => ImageErrorUnsupported(
          value is String ? value : (value! as ParsedString).value),
      (5, final value) || [5, final value] => ImageErrorIoError(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ImageError.decoding(String value) = ImageErrorDecoding;
  const factory ImageError.encoding(String value) = ImageErrorEncoding;
  const factory ImageError.parameter(String value) = ImageErrorParameter;
  const factory ImageError.limits(String value) = ImageErrorLimits;
  const factory ImageError.unsupported(String value) = ImageErrorUnsupported;
  const factory ImageError.ioError(String value) = ImageErrorIoError;

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('decoding', StringType()),
    Case('encoding', StringType()),
    Case('parameter', StringType()),
    Case('limits', StringType()),
    Case('unsupported', StringType()),
    Case('io-error', StringType())
  ]);
}

/// An error was encountered while decoding.
///
/// This means that the input data did not conform to the specification of some image format,
/// or that no format could be determined, or that it did not match format specific
/// requirements set by the caller.
class ImageErrorDecoding implements ImageError {
  final String value;

  /// An error was encountered while decoding.
  ///
  /// This means that the input data did not conform to the specification of some image format,
  /// or that no format could be determined, or that it did not match format specific
  /// requirements set by the caller.
  const ImageErrorDecoding(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'decoding': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'ImageErrorDecoding($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorDecoding && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// An error was encountered while encoding.
///
/// The input image can not be encoded with the chosen format, for example because the
/// specification has no representation for its color space or because a necessary conversion
/// is ambiguous. In some cases it might also happen that the dimensions can not be used with
/// the format.
class ImageErrorEncoding implements ImageError {
  final String value;

  /// An error was encountered while encoding.
  ///
  /// The input image can not be encoded with the chosen format, for example because the
  /// specification has no representation for its color space or because a necessary conversion
  /// is ambiguous. In some cases it might also happen that the dimensions can not be used with
  /// the format.
  const ImageErrorEncoding(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'encoding': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'ImageErrorEncoding($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorEncoding && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// An error was encountered in input arguments.
///
/// This is a catch-all case for strictly internal operations such as scaling, conversions,
/// etc. that involve no external format specifications.
class ImageErrorParameter implements ImageError {
  final String value;

  /// An error was encountered in input arguments.
  ///
  /// This is a catch-all case for strictly internal operations such as scaling, conversions,
  /// etc. that involve no external format specifications.
  const ImageErrorParameter(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'parameter': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value);
  @override
  String toString() => 'ImageErrorParameter($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorParameter && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// Completing the operation would have required more resources than allowed.
///
/// Errors of this type are limits set by the user or environment, *not* inherent in a specific
/// format or operation that was executed.
class ImageErrorLimits implements ImageError {
  final String value;

  /// Completing the operation would have required more resources than allowed.
  ///
  /// Errors of this type are limits set by the user or environment, *not* inherent in a specific
  /// format or operation that was executed.
  const ImageErrorLimits(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'limits': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value);
  @override
  String toString() => 'ImageErrorLimits($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorLimits && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// An operation can not be completed by the chosen abstraction.
///
/// This means that it might be possible for the operation to succeed in general but
/// * it requires a disabled feature,
/// * the implementation does not yet exist, or
/// * no abstraction for a lower level could be found.
class ImageErrorUnsupported implements ImageError {
  final String value;

  /// An operation can not be completed by the chosen abstraction.
  ///
  /// This means that it might be possible for the operation to succeed in general but
  /// * it requires a disabled feature,
  /// * the implementation does not yet exist, or
  /// * no abstraction for a lower level could be found.
  const ImageErrorUnsupported(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'unsupported': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, value);
  @override
  String toString() => 'ImageErrorUnsupported($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorUnsupported && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// An error occurred while interacting with the environment.
class ImageErrorIoError implements ImageError {
  final String value;

  /// An error occurred while interacting with the environment.
  const ImageErrorIoError(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'io-error': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value);
  @override
  String toString() => 'ImageErrorIoError($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorIoError && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class ImageRsWorldImports {
  const ImageRsWorldImports();
}

class Operations {
  Operations(WasmLibrary library)
      : _blur = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#blur',
          const FuncType([('image-ref', ImageRef._spec), ('value', Float32())],
              [('', ImageRef._spec)]),
        )!,
        _brighten = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#brighten',
          const FuncType([('image-ref', ImageRef._spec), ('value', S32())],
              [('', ImageRef._spec)]),
        )!,
        _huerotate = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#huerotate',
          const FuncType([('image-ref', ImageRef._spec), ('value', S32())],
              [('', ImageRef._spec)]),
        )!,
        _adjustContrast = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#adjust-contrast',
          const FuncType([('image-ref', ImageRef._spec), ('c', Float32())],
              [('', ImageRef._spec)]),
        )!,
        _crop = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#crop',
          const FuncType(
              [('image-ref', ImageRef._spec), ('image-crop', ImageCrop._spec)],
              [('', ImageRef._spec)]),
        )!,
        _filter3x3 = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#filter3x3',
          const FuncType(
              [('image-ref', ImageRef._spec), ('kernel', ListType(Float32()))],
              [('', ImageRef._spec)]),
        )!,
        _flipHorizontal = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#flip-horizontal',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _flipVertical = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#flip-vertical',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _grayscale = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#grayscale',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _invert = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#invert',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _resize = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#resize',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('size', ImageSize._spec),
            ('filter', FilterType._spec)
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _resizeExact = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#resize-exact',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('size', ImageSize._spec),
            ('filter', FilterType._spec)
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _resizeToFill = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#resize-to-fill',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('size', ImageSize._spec),
            ('filter', FilterType._spec)
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _rotate180 = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#rotate180',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _rotate270 = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#rotate270',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _rotate90 = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#rotate90',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _unsharpen = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#unsharpen',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('sigma', Float32()),
            ('threshold', S32())
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _thumbnail = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#thumbnail',
          const FuncType(
              [('image-ref', ImageRef._spec), ('size', ImageSize._spec)],
              [('', ImageRef._spec)]),
        )!,
        _thumbnailExact = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#thumbnail-exact',
          const FuncType(
              [('image-ref', ImageRef._spec), ('size', ImageSize._spec)],
              [('', ImageRef._spec)]),
        )!,
        _overlay = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#overlay',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('other', ImageRef._spec),
            ('x', U32()),
            ('y', U32())
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _replace = library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#replace',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('other', ImageRef._spec),
            ('x', U32()),
            ('y', U32())
          ], [
            ('', ImageRef._spec)
          ]),
        )!;
  final ListValue Function(ListValue) _blur;

  /// Performs a Gaussian blur on the supplied image.
  ImageRef blur({
    required ImageRef imageRef,
    required double /*F32*/ value,
  }) {
    final results = _blur([imageRef.toWasm(), value]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _brighten;

  /// Brighten the supplied image.
  ImageRef brighten({
    required ImageRef imageRef,
    required int /*S32*/ value,
  }) {
    final results = _brighten([imageRef.toWasm(), value]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _huerotate;

  /// Hue rotate the supplied image by degrees.
  ImageRef huerotate({
    required ImageRef imageRef,
    required int /*S32*/ value,
  }) {
    final results = _huerotate([imageRef.toWasm(), value]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _adjustContrast;

  /// Adjust the contrast of the supplied image.
  ImageRef adjustContrast({
    required ImageRef imageRef,
    required double /*F32*/ c,
  }) {
    final results = _adjustContrast([imageRef.toWasm(), c]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _crop;

  /// Return a mutable view into an image.
  ImageRef crop({
    required ImageRef imageRef,
    required ImageCrop imageCrop,
  }) {
    final results = _crop([imageRef.toWasm(), imageCrop.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _filter3x3;

  /// Perform a 3x3 box filter on the supplied image.
  ImageRef filter3x3({
    required ImageRef imageRef,
    required Float32List kernel,
  }) {
    final results = _filter3x3([imageRef.toWasm(), kernel]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _flipHorizontal;

  /// Flip an image horizontally.
  ImageRef flipHorizontal({
    required ImageRef imageRef,
  }) {
    final results = _flipHorizontal([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _flipVertical;

  /// Flip an image vertically.
  ImageRef flipVertical({
    required ImageRef imageRef,
  }) {
    final results = _flipVertical([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _grayscale;

  /// Convert the supplied image to grayscale.
  ImageRef grayscale({
    required ImageRef imageRef,
  }) {
    final results = _grayscale([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _invert;

  /// Invert each pixel within the supplied image This function operates in place.
  ImageRef invert({
    required ImageRef imageRef,
  }) {
    final results = _invert([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _resize;

  /// Resize the supplied image to the specified dimensions.
  /// The image's aspect ratio is preserved.
  ImageRef resize({
    required ImageRef imageRef,
    required ImageSize size,
    required FilterType filter,
  }) {
    final results =
        _resize([imageRef.toWasm(), size.toWasm(), filter.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _resizeExact;

  /// Resize the supplied image to the specified dimensions.
  /// Does not preserve aspect ratio.
  ImageRef resizeExact({
    required ImageRef imageRef,
    required ImageSize size,
    required FilterType filter,
  }) {
    final results =
        _resizeExact([imageRef.toWasm(), size.toWasm(), filter.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _resizeToFill;

  /// Resize the supplied image to the specified dimensions.
  /// The image's aspect ratio is preserved. The image is scaled to the
  /// maximum possible size that fits within the larger (relative to aspect ratio)
  /// of the bounds specified by nwidth and nheight, then cropped to fit within the other bound.
  ImageRef resizeToFill({
    required ImageRef imageRef,
    required ImageSize size,
    required FilterType filter,
  }) {
    final results =
        _resizeToFill([imageRef.toWasm(), size.toWasm(), filter.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _rotate180;

  /// Rotate an image 180 degrees clockwise.
  ImageRef rotate180({
    required ImageRef imageRef,
  }) {
    final results = _rotate180([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _rotate270;

  /// Rotate an image 270 degrees clockwise.
  ImageRef rotate270({
    required ImageRef imageRef,
  }) {
    final results = _rotate270([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _rotate90;

  /// Rotate an image 90 degrees clockwise.
  ImageRef rotate90({
    required ImageRef imageRef,
  }) {
    final results = _rotate90([imageRef.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _unsharpen;

  /// Performs an unsharpen mask on the supplied image.
  ImageRef unsharpen({
    required ImageRef imageRef,
    required double /*F32*/ sigma,
    required int /*S32*/ threshold,
  }) {
    final results = _unsharpen([imageRef.toWasm(), sigma, threshold]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _thumbnail;

  /// Scale this image down to fit within a specific size. Returns a new image.
  /// The image's aspect ratio is preserved.
  ImageRef thumbnail({
    required ImageRef imageRef,
    required ImageSize size,
  }) {
    final results = _thumbnail([imageRef.toWasm(), size.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _thumbnailExact;

  /// Scale this image down to a specific size. Returns a new image.
  /// Does not preserve aspect ratio.
  ImageRef thumbnailExact({
    required ImageRef imageRef,
    required ImageSize size,
  }) {
    final results = _thumbnailExact([imageRef.toWasm(), size.toWasm()]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _overlay;

  /// Overlay an image at a given coordinate (x, y)
  ImageRef overlay({
    required ImageRef imageRef,
    required ImageRef other,
    required int /*U32*/ x,
    required int /*U32*/ y,
  }) {
    final results = _overlay([imageRef.toWasm(), other.toWasm(), x, y]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }

  final ListValue Function(ListValue) _replace;

  /// Replace the contents of an image at a given coordinate (x, y)
  ImageRef replace({
    required ImageRef imageRef,
    required ImageRef other,
    required int /*U32*/ x,
    required int /*U32*/ y,
  }) {
    final results = _replace([imageRef.toWasm(), other.toWasm(), x, y]);
    final result = results[0];
    return ImageRef.fromJson(result);
  }
}

class ImageRsWorld {
  final ImageRsWorldImports imports;
  final WasmLibrary library;
  final Operations operations;

  ImageRsWorld({
    required this.imports,
    required this.library,
  })  : operations = Operations(library),
        _guessBufferFormat = library.getComponentFunction(
          'guess-buffer-format',
          const FuncType([('buffer', ListType(U8()))],
              [('', ResultType(ImageFormat._spec, StringType()))]),
        )!,
        _fileImageSize = library.getComponentFunction(
          'file-image-size',
          const FuncType([('path', StringType())],
              [('', ResultType(ImageSize._spec, StringType()))]),
        )!,
        _imageBufferPointerAndSize = library.getComponentFunction(
          'image-buffer-pointer-and-size',
          const FuncType([
            ('image-ref', ImageRef._spec)
          ], [
            ('', Tuple([U32(), U32()]))
          ]),
        )!,
        _copyImageBuffer = library.getComponentFunction(
          'copy-image-buffer',
          const FuncType([('image-ref', ImageRef._spec)], [('', Image._spec)]),
        )!,
        _disposeImage = library.getComponentFunction(
          'dispose-image',
          const FuncType([('image', ImageRef._spec)],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _readBuffer = library.getComponentFunction(
          'read-buffer',
          const FuncType([('buffer', ListType(U8()))],
              [('', ResultType(ImageRef._spec, StringType()))]),
        )!,
        _readFile = library.getComponentFunction(
          'read-file',
          const FuncType([('path', StringType())],
              [('', ResultType(ImageRef._spec, StringType()))]),
        )!,
        _saveFile = library.getComponentFunction(
          'save-file',
          const FuncType([('image', ImageRef._spec), ('path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;

  static Future<ImageRsWorld> init(
    WasmInstanceBuilder builder, {
    required ImageRsWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return ImageRsWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _guessBufferFormat;
  Result<ImageFormat, String> guessBufferFormat({
    required Uint8List buffer,
  }) {
    final results = _guessBufferFormat([buffer]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ImageFormat.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _fileImageSize;
  Result<ImageSize, String> fileImageSize({
    required String path,
  }) {
    final results = _fileImageSize([path]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ImageSize.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _imageBufferPointerAndSize;
  (
    int /*U32*/,
    int /*U32*/,
  ) imageBufferPointerAndSize({
    required ImageRef imageRef,
  }) {
    final results = _imageBufferPointerAndSize([imageRef.toWasm()]);
    final result = results[0];
    return (() {
      final l = result is Map
          ? List.generate(2, (i) => result[i.toString()], growable: false)
          : result;
      return switch (l) {
        [final v0, final v1] || (final v0, final v1) => (
            v0! as int,
            v1! as int,
          ),
        _ => throw Exception('Invalid JSON $result')
      };
    })();
  }

  final ListValue Function(ListValue) _copyImageBuffer;
  Image copyImageBuffer({
    required ImageRef imageRef,
  }) {
    final results = _copyImageBuffer([imageRef.toWasm()]);
    final result = results[0];
    return Image.fromJson(result);
  }

  final ListValue Function(ListValue) _disposeImage;
  Result<int /*U32*/, String> disposeImage({
    required ImageRef image,
  }) {
    final results = _disposeImage([image.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _readBuffer;

  /// Create a new image from a byte slice
  /// Makes an educated guess about the image format.
  Result<ImageRef, String> readBuffer({
    required Uint8List buffer,
  }) {
    final results = _readBuffer([buffer]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ImageRef.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _readFile;

  /// Open the image located at the path specified.
  /// The image's format is determined from the path's file extension.
  Result<ImageRef, String> readFile({
    required String path,
  }) {
    final results = _readFile([path]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ImageRef.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _saveFile;

  /// Saves the buffer to a file at the path specified.
  /// The image format is derived from the file extension.
  Result<int /*U32*/, String> saveFile({
    required ImageRef image,
    required String path,
  }) {
    final results = _saveFile([image.toWasm(), path]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
