import 'package:flutter/foundation.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:image_rs/image_rs.dart';

class ImageRsState extends ChangeNotifier with ErrorNotifier {
  ImageRsState(this.imageRs);

  final ImageRsWorld imageRs;
  bool showOperations = true;
  final values = ImageRsStateValues();
  ImageFormat format = ImageFormat.png;
  ColorType? get color => ref?.color;
  Uint8List? bytes;
  ImageRef? previousRef;
  ImageRef? ref;
  String? filename;

  void op(ImageRef Function(ImageRef ref) exec) {
    final prevRef = ref!;
    final newRef = exec(prevRef);
    if (previousRef != null) {
      imageRs.disposeImage(image: previousRef!).unwrap();
    }
    previousRef = prevRef;
    ref = newRef;
    // final newImage = imageRs.copyImageBuffer(imageRef: newRef);
    // bytes = newImage.bytes;
    _updateBytes(format);
  }

  bool _updateBytes(ImageFormat format) {
    if (ref == null) return false;
    final newImage =
        imageRs.convertFormat(image: ref!, format: format).mapErr(setError).ok;
    if (newImage != null) {
      this.format = format;
      bytes = newImage;
    }
    notifyListeners();
    return newImage != null;
  }

  void loadImage(String name, Uint8List bytes) {
    imageRs
        .guessBufferFormat(buffer: bytes)
        .map((ok) => format = ok)
        .mapErr(setError);
    final result = imageRs.readBuffer(buffer: bytes).mapErr(setError);
    if (result.isOk) {
      filename = name;
      if (previousRef != null) {
        imageRs.disposeImage(image: previousRef!).unwrap();
      }
      previousRef = ref;
      ref = result.ok;
      this.bytes = bytes;
      notifyListeners();
    }
  }

  void toggleShowOperations() {
    showOperations = !showOperations;
    notifyListeners();
  }

  void setFormat(ImageFormat format) {
    if (this.format == format) return;
    _updateBytes(format);
  }

  void setColor(ColorType color) {
    if (this.color == color || ref == null) return;
    op((ref) => imageRs.convertColor(color: color, image: ref));
  }

  void revert() {
    if (previousRef == null) return;
    final current = ref;
    ref = previousRef;
    previousRef = current;
    _updateBytes(format);
  }
}

class ImageRsStateValues extends ChangeNotifier {
  double blur = 0;
  void setBlur(double d) {
    blur = d;
    notifyListeners();
  }

  int brighten = 0;
  void setBrighten(int d) {
    brighten = d;
    notifyListeners();
  }

  int huerotate = 0;
  void setHuerotate(int d) {
    huerotate = d;
    notifyListeners();
  }

  double contrast = 0;
  void setContrast(double d) {
    contrast = d;
    notifyListeners();
  }

  FilterType filterType = FilterType.nearest;
  void setFilterType(FilterType d) {
    filterType = d;
    notifyListeners();
  }

  int x = 0;
  void setX(int d) {
    x = d;
    notifyListeners();
  }

  int y = 0;
  void setY(int d) {
    y = d;
    notifyListeners();
  }

  ImageSize get size => ImageSize(width: width, height: height);
  ImageCrop get crop => ImageCrop(width: width, height: height, x: x, y: y);

  int width = 0;
  void setWidth(int d) {
    width = d;
    notifyListeners();
  }

  int height = 0;
  void setHeight(int d) {
    height = d;
    notifyListeners();
  }

  bool keepAspectRatio = true;
  void setKeepAspectRatio(bool d) {
    keepAspectRatio = d;
    notifyListeners();
  }
}
