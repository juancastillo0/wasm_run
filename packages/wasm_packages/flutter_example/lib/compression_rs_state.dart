import 'dart:typed_data';

import 'package:compression_rs/compression_rs.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter_example/flutter_utils.dart';

class CompressionRsState extends ChangeNotifier with ErrorNotifier {
  CompressionRsState(this.compressionRs);

  final CompressionRsWorld compressionRs;
  final List<InputFile> files = [];

  void compress(InputFile file, CompressorKind kind) {
    if (file.compressed[kind] != null) return;
    final result =
        kind.compressor(compressionRs).compress(input: Input.bytes(file.bytes));
    file.compressed[kind] = result.mapErr(setError).ok;
    notifyListeners();
  }

  void decompress(InputFile file, CompressorKind kind) {
    if (file.decompressed[kind] != null) return;
    final result = kind
        .compressor(compressionRs)
        .decompress(input: Input.bytes(file.bytes));
    file.decompressed[kind] = result.mapErr(setError).ok;
    notifyListeners();
  }

  void loadFile(String name, Uint8List bytes) {
    final file = InputFile(name, bytes);
    files.add(file);
    for (final kind in CompressorKind.values) {
      if (name.endsWith('.${kind.name}')) {
        decompress(file, kind);
        break;
      }
    }
    notifyListeners();
  }

  void removeFile(InputFile file) {
    files.remove(file);
    notifyListeners();
  }
}

class InputFile {
  final String name;
  final Uint8List bytes;
  final Map<CompressorKind, Uint8List?> compressed = {};
  final Map<CompressorKind, Uint8List?> decompressed = {};

  InputFile(this.name, this.bytes);
}
