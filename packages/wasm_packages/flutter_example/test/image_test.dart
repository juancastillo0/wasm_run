import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_example/image_rs_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_rs/image_rs.dart';
// ignore: depend_on_referenced_packages
import 'package:wasm_run/wasm_run.dart';

Future<ImageRsState> imageState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WasmRunLibrary.setUp(
    override: false,
    isFlutter: true,
    loadAsset: rootBundle.load,
  );
  final parser = await createImageRs(
    wasiConfig: const WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
  );
  return ImageRsState(parser);
}

void main() {
  group('image rs', () {
    test('front multiple ops', () async {
      final state = await imageState();
      final codeImage = await rootBundle.load('assets/images/code.png');
      final flipH = await rootBundle.load('assets/images/flip-h.png');
      final contrast20 = await rootBundle.load('assets/images/contrast20.png');
      final convertGif = await rootBundle.load('assets/images/convert.gif');
      final crop100x52 = await rootBundle.load('assets/images/crop-100x52.png');
      final grayscale = await rootBundle.load('assets/images/grayscale.png');
      final grayrot90 = await rootBundle.load('assets/images/gray-rot90.png');
      final resize102x50Jpg =
          await rootBundle.load('assets/images/resize-102x50.jpg');
      final resize102x50 =
          await rootBundle.load('assets/images/resize-102x50.png');
      final resize102x50Exact =
          await rootBundle.load('assets/images/resize-102x50-exact.png');
      final webpconvertblur2 =
          await rootBundle.load('assets/images/webp-convert-blur2.bmp');
      final webpconvertBmp =
          await rootBundle.load('assets/images/webp-convert.bmp');
      final webpexample =
          await rootBundle.load('assets/images/webp-example.webp');

      ImageRef? initialRef;

      void validateState({
        ImageRef? previousRef,
        String filename = 'code.png',
        ImageFormat format = ImageFormat.png,
        ColorType color = ColorType.rgba8,
        Matcher error = isEmpty,
        int height = 223,
        int width = 581,
        required Uint8List buffer,
      }) {
        expect(state.filename, filename);
        expect(state.format, format);
        expect(state.color, color);
        expect(state.previousRef, previousRef ?? initialRef);
        final ref = state.ref!;
        expect(state.error, error);
        expect(ref.color, color);
        expect(ref.height, height);
        expect(ref.width, width);
        expect(state.bytes, buffer);
      }

      state.loadImage('code.png', codeImage.buffer.asUint8List());
      validateState(buffer: codeImage.buffer.asUint8List());
      initialRef = state.ref;

      ///
      state.op(
        (ref) => state.imageRs.operations.flipHorizontal(imageRef: ref),
      );
      final flipHRef = state.ref!;
      validateState(buffer: flipH.buffer.asUint8List());
      state.revert();

      ///
      expect(state.ref, initialRef);
      expect(state.previousRef, flipHRef);

      ///
      state.op(
        (ref) => state.imageRs.operations.grayscale(imageRef: ref),
      );
      validateState(
        buffer: grayscale.buffer.asUint8List(),
        color: ColorType.la8,
      );
      final grayscaleRef = state.ref;

      /// grayrot90
      state.op(
        (ref) => state.imageRs.operations.rotate90(imageRef: ref),
      );
      validateState(
        previousRef: grayscaleRef,
        color: ColorType.la8,
        buffer: grayrot90.buffer.asUint8List(),
        height: 581,
        width: 223,
      );
      final grayscaleRotRef = state.ref;
      state.revert();
      validateState(
        previousRef: grayscaleRotRef,
        color: ColorType.la8,
        buffer: grayscale.buffer.asUint8List(),
      );

      state.loadImage('code.png', codeImage.buffer.asUint8List());
      initialRef = state.ref;

      ///
      state.op(
        (ref) => state.imageRs.operations.adjustContrast(c: 20, imageRef: ref),
      );
      validateState(buffer: contrast20.buffer.asUint8List());
      final contrastRef = state.ref;
      state.revert();

      ///
      state.setFormat(ImageFormat.gif);
      validateState(
        buffer: convertGif.buffer.asUint8List(),
        format: ImageFormat.gif,
        previousRef: contrastRef,
      );
      state.setFormat(ImageFormat.png);

      ///
      state.op(
        (ref) => state.imageRs.operations.crop(
          imageCrop: const ImageCrop(x: 0, y: 0, width: 100, height: 52),
          imageRef: ref,
        ),
      );
      validateState(
        buffer: crop100x52.buffer.asUint8List(),
        width: 100,
        height: 52,
      );
      state.revert();

      ///
      state.op(
        (ref) => state.imageRs.operations.resizeExact(
          size: const ImageSize(width: 102, height: 50),
          filter: FilterType.nearest,
          imageRef: ref,
        ),
      );
      validateState(
        buffer: resize102x50Exact.buffer.asUint8List(),
        width: 102,
        height: 50,
      );
      state.revert();
      final resizedRef = state.ref;

      ///
      state.op(
        (ref) => state.imageRs.operations.resize(
          size: const ImageSize(width: 102, height: 50),
          filter: FilterType.nearest,
          imageRef: ref,
        ),
      );
      validateState(
        buffer: resize102x50.buffer.asUint8List(),
        width: 102,
        height: 39,
      );

      ///
      state.setFormat(ImageFormat.jpeg);
      validateState(
        previousRef: resizedRef,
        buffer: resize102x50Jpg.buffer.asUint8List(),
        format: ImageFormat.jpeg,
        width: 102,
        height: 39,
      );
      state.revert();

      ///
      initialRef = state.ref;
      state.loadImage('webp-example.webp', webpexample.buffer.asUint8List());

      validateState(
        filename: 'webp-example.webp',
        buffer: webpexample.buffer.asUint8List(),
        format: ImageFormat.webP,
        color: ColorType.rgb8,
        width: 320,
        height: 241,
      );
      final webpRef = state.ref;

      ///
      state.setFormat(ImageFormat.bmp);
      validateState(
        filename: 'webp-example.webp',
        buffer: webpconvertBmp.buffer.asUint8List(),
        format: ImageFormat.bmp,
        color: ColorType.rgb8,
        width: 320,
        height: 241,
      );

      ///
      state.op(
        (ref) => state.imageRs.operations.blur(value: 2, imageRef: ref),
      );
      validateState(
        filename: 'webp-example.webp',
        buffer: webpconvertblur2.buffer.asUint8List(),
        format: ImageFormat.bmp,
        color: ColorType.rgb8,
        width: 320,
        height: 241,
        previousRef: webpRef,
      );
    });
  });
}
