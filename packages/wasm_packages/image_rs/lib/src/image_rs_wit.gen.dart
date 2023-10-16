// FILE GENERATED FROM WIT

// ignore: lines_longer_than_80_chars
// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion, unused_element, avoid_returning_null_for_void

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

class Image implements ToJsonSerializable {
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
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Image',
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
      other is Image &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [bytes];
  static const _spec = RecordType([(label: 'bytes', t: ListType(U8()))]);
}

class ImageSize implements ToJsonSerializable {
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
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ImageSize',
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
      other is ImageSize &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [width, height];
  static const _spec =
      RecordType([(label: 'width', t: U32()), (label: 'height', t: U32())]);
}

enum ColorType implements ToJsonSerializable {
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
  factory ColorType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColorType', _spec.labels[index]: null};

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

class ImageRef implements ToJsonSerializable {
  final int /*U32*/ id;
  final ColorType color;
  final int /*U32*/ width;
  final int /*U32*/ height;
  const ImageRef({
    required this.id,
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
      [final id, final color, final width, final height] ||
      (final id, final color, final width, final height) =>
        ImageRef(
          id: id! as int,
          color: ColorType.fromJson(color),
          width: width! as int,
          height: height! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ImageRef',
        'id': id,
        'color': color.toJson(),
        'width': width,
        'height': height,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [id, color.toWasm(), width, height];
  @override
  String toString() =>
      'ImageRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ImageRef copyWith({
    int /*U32*/ ? id,
    ColorType? color,
    int /*U32*/ ? width,
    int /*U32*/ ? height,
  }) =>
      ImageRef(
          id: id ?? this.id,
          color: color ?? this.color,
          width: width ?? this.width,
          height: height ?? this.height);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [id, color, width, height];
  static const _spec = RecordType([
    (label: 'id', t: U32()),
    (label: 'color', t: ColorType._spec),
    (label: 'width', t: U32()),
    (label: 'height', t: U32())
  ]);
}

enum ImageFormat implements ToJsonSerializable {
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
  factory ImageFormat.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageFormat', _spec.labels[index]: null};

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

enum PixelType implements ToJsonSerializable {
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
  factory PixelType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'PixelType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['rgb', 'rgba', 'luma', 'luma-a']);
}

enum FilterType implements ToJsonSerializable {
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
  factory FilterType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FilterType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['nearest', 'triangle', 'catmull-rom', 'gaussian', 'lanczos3']);
}

class ImageCrop implements ToJsonSerializable {
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
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ImageCrop',
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
      other is ImageCrop &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [x, y, width, height];
  static const _spec = RecordType([
    (label: 'x', t: U32()),
    (label: 'y', t: U32()),
    (label: 'width', t: U32()),
    (label: 'height', t: U32())
  ]);
}

typedef ImageError = String;

sealed class ImageErrorV implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ImageErrorV.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int ? key : _spec.cases.indexWhere((c) => c.label == key),
        value,
      );
    }
    return switch (json) {
      (0, final value) || [0, final value] => ImageErrorVDecoding(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => ImageErrorVEncoding(
          value is String ? value : (value! as ParsedString).value),
      (2, final value) || [2, final value] => ImageErrorVParameter(
          value is String ? value : (value! as ParsedString).value),
      (3, final value) || [3, final value] => ImageErrorVLimits(
          value is String ? value : (value! as ParsedString).value),
      (4, final value) || [4, final value] => ImageErrorVUnsupported(
          value is String ? value : (value! as ParsedString).value),
      (5, final value) || [5, final value] => ImageErrorVIoError(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ImageErrorV.decoding(String value) = ImageErrorVDecoding;
  const factory ImageErrorV.encoding(String value) = ImageErrorVEncoding;
  const factory ImageErrorV.parameter(String value) = ImageErrorVParameter;
  const factory ImageErrorV.limits(String value) = ImageErrorVLimits;
  const factory ImageErrorV.unsupported(String value) = ImageErrorVUnsupported;
  const factory ImageErrorV.ioError(String value) = ImageErrorVIoError;
  @override
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
class ImageErrorVDecoding implements ImageErrorV {
  final String value;

  /// An error was encountered while decoding.
  ///
  /// This means that the input data did not conform to the specification of some image format,
  /// or that no format could be determined, or that it did not match format specific
  /// requirements set by the caller.
  const ImageErrorVDecoding(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageErrorVDecoding', 'decoding': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'ImageErrorVDecoding($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorVDecoding &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// An error was encountered while encoding.
///
/// The input image can not be encoded with the chosen format, for example because the
/// specification has no representation for its color space or because a necessary conversion
/// is ambiguous. In some cases it might also happen that the dimensions can not be used with
/// the format.
class ImageErrorVEncoding implements ImageErrorV {
  final String value;

  /// An error was encountered while encoding.
  ///
  /// The input image can not be encoded with the chosen format, for example because the
  /// specification has no representation for its color space or because a necessary conversion
  /// is ambiguous. In some cases it might also happen that the dimensions can not be used with
  /// the format.
  const ImageErrorVEncoding(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageErrorVEncoding', 'encoding': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'ImageErrorVEncoding($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorVEncoding &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// An error was encountered in input arguments.
///
/// This is a catch-all case for strictly internal operations such as scaling, conversions,
/// etc. that involve no external format specifications.
class ImageErrorVParameter implements ImageErrorV {
  final String value;

  /// An error was encountered in input arguments.
  ///
  /// This is a catch-all case for strictly internal operations such as scaling, conversions,
  /// etc. that involve no external format specifications.
  const ImageErrorVParameter(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageErrorVParameter', 'parameter': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value);
  @override
  String toString() => 'ImageErrorVParameter($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorVParameter &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// Completing the operation would have required more resources than allowed.
///
/// Errors of this type are limits set by the user or environment, *not* inherent in a specific
/// format or operation that was executed.
class ImageErrorVLimits implements ImageErrorV {
  final String value;

  /// Completing the operation would have required more resources than allowed.
  ///
  /// Errors of this type are limits set by the user or environment, *not* inherent in a specific
  /// format or operation that was executed.
  const ImageErrorVLimits(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageErrorVLimits', 'limits': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value);
  @override
  String toString() => 'ImageErrorVLimits($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorVLimits &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// An operation can not be completed by the chosen abstraction.
///
/// This means that it might be possible for the operation to succeed in general but
/// * it requires a disabled feature,
/// * the implementation does not yet exist, or
/// * no abstraction for a lower level could be found.
class ImageErrorVUnsupported implements ImageErrorV {
  final String value;

  /// An operation can not be completed by the chosen abstraction.
  ///
  /// This means that it might be possible for the operation to succeed in general but
  /// * it requires a disabled feature,
  /// * the implementation does not yet exist, or
  /// * no abstraction for a lower level could be found.
  const ImageErrorVUnsupported(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageErrorVUnsupported', 'unsupported': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, value);
  @override
  String toString() => 'ImageErrorVUnsupported($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorVUnsupported &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// An error occurred while interacting with the environment.
class ImageErrorVIoError implements ImageErrorV {
  final String value;

  /// An error occurred while interacting with the environment.
  const ImageErrorVIoError(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ImageErrorVIoError', 'io-error': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value);
  @override
  String toString() => 'ImageErrorVIoError($value)';
  @override
  bool operator ==(Object other) =>
      other is ImageErrorVIoError &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ImageRsWorldImports {
  const ImageRsWorldImports();
}

class Operations {
  final ImageRsWorld _world;
  Operations(this._world)
      : _blur = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#blur',
          const FuncType([('image-ref', ImageRef._spec), ('value', Float32())],
              [('', ImageRef._spec)]),
        )!,
        _brighten = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#brighten',
          const FuncType([('image-ref', ImageRef._spec), ('value', S32())],
              [('', ImageRef._spec)]),
        )!,
        _huerotate = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#huerotate',
          const FuncType([('image-ref', ImageRef._spec), ('value', S32())],
              [('', ImageRef._spec)]),
        )!,
        _adjustContrast = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#adjust-contrast',
          const FuncType([('image-ref', ImageRef._spec), ('c', Float32())],
              [('', ImageRef._spec)]),
        )!,
        _crop = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#crop',
          const FuncType(
              [('image-ref', ImageRef._spec), ('image-crop', ImageCrop._spec)],
              [('', ImageRef._spec)]),
        )!,
        _filter3x3 = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#filter3x3',
          const FuncType(
              [('image-ref', ImageRef._spec), ('kernel', ListType(Float32()))],
              [('', ImageRef._spec)]),
        )!,
        _flipHorizontal = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#flip-horizontal',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _flipVertical = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#flip-vertical',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _grayscale = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#grayscale',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _invert = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#invert',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _resize = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#resize',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('size', ImageSize._spec),
            ('filter', FilterType._spec)
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _resizeExact = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#resize-exact',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('size', ImageSize._spec),
            ('filter', FilterType._spec)
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _resizeToFill = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#resize-to-fill',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('size', ImageSize._spec),
            ('filter', FilterType._spec)
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _rotate180 = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#rotate180',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _rotate270 = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#rotate270',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _rotate90 = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#rotate90',
          const FuncType(
              [('image-ref', ImageRef._spec)], [('', ImageRef._spec)]),
        )!,
        _unsharpen = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#unsharpen',
          const FuncType([
            ('image-ref', ImageRef._spec),
            ('sigma', Float32()),
            ('threshold', S32())
          ], [
            ('', ImageRef._spec)
          ]),
        )!,
        _thumbnail = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#thumbnail',
          const FuncType(
              [('image-ref', ImageRef._spec), ('size', ImageSize._spec)],
              [('', ImageRef._spec)]),
        )!,
        _thumbnailExact = _world.library.getComponentFunction(
          'wasm-run-dart:image-rs/operations#thumbnail-exact',
          const FuncType(
              [('image-ref', ImageRef._spec), ('size', ImageSize._spec)],
              [('', ImageRef._spec)]),
        )!,
        _overlay = _world.library.getComponentFunction(
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
        _replace = _world.library.getComponentFunction(
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
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _brighten;

  /// Brighten the supplied image.
  ImageRef brighten({
    required ImageRef imageRef,
    required int /*S32*/ value,
  }) {
    final results = _brighten([imageRef.toWasm(), value]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _huerotate;

  /// Hue rotate the supplied image by degrees.
  ImageRef huerotate({
    required ImageRef imageRef,
    required int /*S32*/ value,
  }) {
    final results = _huerotate([imageRef.toWasm(), value]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _adjustContrast;

  /// Adjust the contrast of the supplied image.
  ImageRef adjustContrast({
    required ImageRef imageRef,
    required double /*F32*/ c,
  }) {
    final results = _adjustContrast([imageRef.toWasm(), c]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _crop;

  /// Return a mutable view into an image.
  ImageRef crop({
    required ImageRef imageRef,
    required ImageCrop imageCrop,
  }) {
    final results = _crop([imageRef.toWasm(), imageCrop.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _filter3x3;

  /// Perform a 3x3 box filter on the supplied image.
  ImageRef filter3x3({
    required ImageRef imageRef,
    required Float32List kernel,
  }) {
    final results = _filter3x3([imageRef.toWasm(), kernel]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _flipHorizontal;

  /// Flip an image horizontally.
  ImageRef flipHorizontal({
    required ImageRef imageRef,
  }) {
    final results = _flipHorizontal([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _flipVertical;

  /// Flip an image vertically.
  ImageRef flipVertical({
    required ImageRef imageRef,
  }) {
    final results = _flipVertical([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _grayscale;

  /// Convert the supplied image to grayscale.
  ImageRef grayscale({
    required ImageRef imageRef,
  }) {
    final results = _grayscale([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _invert;

  /// Invert each pixel within the supplied image This function operates in place.
  ImageRef invert({
    required ImageRef imageRef,
  }) {
    final results = _invert([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _rotate180;

  /// Rotate an image 180 degrees clockwise.
  ImageRef rotate180({
    required ImageRef imageRef,
  }) {
    final results = _rotate180([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _rotate270;

  /// Rotate an image 270 degrees clockwise.
  ImageRef rotate270({
    required ImageRef imageRef,
  }) {
    final results = _rotate270([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _rotate90;

  /// Rotate an image 90 degrees clockwise.
  ImageRef rotate90({
    required ImageRef imageRef,
  }) {
    final results = _rotate90([imageRef.toWasm()]);
    final result = results[0];
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
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
    return _world.withContext(() => ImageRef.fromJson(result));
  }
}

class ImageRsWorld {
  final ImageRsWorldImports imports;
  final WasmLibrary library;
  late final Operations operations;

  ImageRsWorld({
    required this.imports,
    required this.library,
  })  : _guessBufferFormat = library.getComponentFunction(
          'guess-buffer-format',
          const FuncType([('buffer', ListType(U8()))],
              [('', ResultType(ImageFormat._spec, StringType()))]),
        )!,
        _fileImageSize = library.getComponentFunction(
          'file-image-size',
          const FuncType([('path', StringType())],
              [('', ResultType(ImageSize._spec, StringType()))]),
        )!,
        _formatExtensions = library.getComponentFunction(
          'format-extensions',
          const FuncType(
              [('format', ImageFormat._spec)], [('', ListType(StringType()))]),
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
        )!,
        _convertColor = library.getComponentFunction(
          'convert-color',
          const FuncType(
              [('image', ImageRef._spec), ('color', ColorType._spec)],
              [('', ImageRef._spec)]),
        )!,
        _convertFormat = library.getComponentFunction(
          'convert-format',
          const FuncType(
              [('image', ImageRef._spec), ('format', ImageFormat._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )! {
    operations = Operations(this);
  }

  static Future<ImageRsWorld> init(
    WasmInstanceBuilder builder, {
    required ImageRsWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance,
        componentId: 'wasm-run-dart:image-rs/image-rs',
        int64Type: Int64TypeConfig.bigInt);
    return ImageRsWorld(imports: imports, library: library);
  }

  static final _zoneKey = Object();
  late final _zoneValues = {_zoneKey: this};
  static ImageRsWorld? currentZoneWorld() =>
      Zone.current[_zoneKey] as ImageRsWorld?;
  T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);

  final ListValue Function(ListValue) _guessBufferFormat;
  Result<ImageFormat, ImageError> guessBufferFormat({
    required Uint8List buffer,
  }) {
    final results = _guessBufferFormat([buffer]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => ImageFormat.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _fileImageSize;
  Result<ImageSize, ImageError> fileImageSize({
    required String path,
  }) {
    final results = _fileImageSize([path]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => ImageSize.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _formatExtensions;
  List<String> formatExtensions({
    required ImageFormat format,
  }) {
    final results = _formatExtensions([format.toWasm()]);
    final result = results[0];
    return withContext(() => (result! as Iterable)
        .map((e) => e is String ? e : (e! as ParsedString).value)
        .toList());
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
    return withContext(() => (() {
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
        })());
  }

  final ListValue Function(ListValue) _copyImageBuffer;
  Image copyImageBuffer({
    required ImageRef imageRef,
  }) {
    final results = _copyImageBuffer([imageRef.toWasm()]);
    final result = results[0];
    return withContext(() => Image.fromJson(result));
  }

  final ListValue Function(ListValue) _disposeImage;
  Result<int /*U32*/, ImageError> disposeImage({
    required ImageRef image,
  }) {
    final results = _disposeImage([image.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _readBuffer;

  /// Create a new image from a byte slice
  /// Makes an educated guess about the image format.
  Result<ImageRef, ImageError> readBuffer({
    required Uint8List buffer,
  }) {
    final results = _readBuffer([buffer]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => ImageRef.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _readFile;

  /// Open the image located at the path specified.
  /// The image's format is determined from the path's file extension.
  Result<ImageRef, ImageError> readFile({
    required String path,
  }) {
    final results = _readFile([path]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => ImageRef.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _saveFile;

  /// Saves the buffer to a file at the path specified.
  /// The image format is derived from the file extension.
  Result<int /*U32*/, ImageError> saveFile({
    required ImageRef image,
    required String path,
  }) {
    final results = _saveFile([image.toWasm(), path]);
    final result = results[0];
    return withContext(() => Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _convertColor;

  /// Copy the image to a new color representation.
  ImageRef convertColor({
    required ImageRef image,
    required ColorType color,
  }) {
    final results = _convertColor([image.toWasm(), color.toWasm()]);
    final result = results[0];
    return withContext(() => ImageRef.fromJson(result));
  }

  final ListValue Function(ListValue) _convertFormat;

  /// Converts the image into a different [format].
  Result<Uint8List, ImageError> convertFormat({
    required ImageRef image,
    required ImageFormat format,
  }) {
    final results = _convertFormat([image.toWasm(), format.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}
