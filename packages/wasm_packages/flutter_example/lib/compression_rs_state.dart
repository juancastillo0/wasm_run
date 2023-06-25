import 'dart:typed_data';

import 'package:compression_rs/compression_rs.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/widgets.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

enum CompressorView {
  compress,
  zip,
  tar,
}

class CompressionRsState extends ChangeNotifier with ErrorNotifier {
  CompressionRsState(this.compressionRs);

  final CompressionRsWorld compressionRs;
  final List<InputFileState> files = [];
  CompressorView view = CompressorView.compress;

  void viewSet(CompressorView view) {
    this.view = view;
    notifyListeners();
  }

  void compress(InputFileState file, CompressorKind kind) {
    if (file.compressed[kind] != null) return;
    final result =
        kind.compressor(compressionRs).compress(input: Input.bytes(file.bytes));
    file.compressed[kind] = result.mapErr(setError).ok;
    notifyListeners();
  }

  void decompress(InputFileState file, CompressorKind kind) {
    if (file.decompressed[kind] != null) return;
    final result = kind
        .compressor(compressionRs)
        .decompress(input: Input.bytes(file.bytes));
    file.decompressed[kind] = result.mapErr(setError).ok;
    notifyListeners();
  }

  InputFileState loadFile(String name, Uint8List bytes) {
    final file = InputFileState(name, bytes);
    files.add(file);
    for (final kind in CompressorKind.values) {
      if (kind.extensions.any((ext) => file.name.endsWith('.$ext'))) {
        decompress(file, kind);
        break;
      }
    }
    notifyListeners();
    return file;
  }

  void removeFile(InputFileState file) {
    files.remove(file);
    notifyListeners();
  }

  void zipFiles({bool download = false}) {
    final zipList = files
        .map(
          (f) => ZipArchiveInput(
            item: FileBytes(bytes: f.bytes, path: f.name),
            options: f.zipOptions.value,
          ),
        )
        .toList();
    final result = compressionRs.archive.createArchive(
      input: ArchiveInput.zip(zipList),
    );
    final zipBytes = result.mapErr(setError).ok;
    if (zipBytes != null) {
      files.add(InputFileState('archive.zip', zipBytes));
      view = CompressorView.compress;
      if (download) {
        downloadFile('archive.zip', zipBytes);
      }
    }
    notifyListeners();
  }

  void tarFiles({bool download = false}) {
    final tarList = files
        .map(
          (f) => TarArchiveInput(
            item: FileBytes(bytes: f.bytes, path: f.name),
            header: TarHeaderInputModel(f.tarHeader.value),
          ),
        )
        .toList();
    final result = compressionRs.archive.createArchive(
      input: ArchiveInput.tar(tarList),
    );
    final tarBytes = result.mapErr(setError).ok;
    if (tarBytes != null) {
      final file = InputFileState('archive.tar', tarBytes);
      files.add(file);
      view = CompressorView.compress;
      if (download) {
        compress(file, CompressorKind.gzip);
        final compressed = file.compressed[CompressorKind.gzip];
        if (compressed != null) {
          downloadFile('archive.tar.gz', compressed);
        }
      }
    }
    notifyListeners();
  }

  void extractArchive(InputFileState file) {
    if (file.name.endsWith('.zip')) {
      final result = compressionRs.archive.viewZip(zipBytes: file.bytes);
      final files = result.mapErr(setError).ok;
      if (files != null) {
        for (final zipFile in files) {
          final file = loadFile(zipFile.file.path, zipFile.file.bytes);
          // TODO: zipFile.crc32 and others
          file.zipOptions.value = ZipOptions(
            compressionMethod: zipFile.compressionMethod,
            comment: BytesOrUnicode.string(zipFile.comment),
            lastModifiedTime: zipFile.lastModifiedTime,
            permissions: zipFile.permissions,
          );
        }
      }
    } else {
      final Result<List<TarFile>, String> result;
      final decompressed =
          file.decompressed.values.whereType<Uint8List>().firstOrNull;
      if (decompressed != null) {
        result = compressionRs.archive.viewTar(tarBytes: decompressed);
      } else if (file.name.endsWith('.tar')) {
        result = compressionRs.archive.viewTar(tarBytes: file.bytes);
      } else {
        return setError('Unknown archive type ${file.name}');
      }

      final files = result.mapErr(setError).ok;
      if (files != null) {
        for (final tarFile in files) {
          // TODO: symlink and directory tarFile.header.entryType;
          final file = loadFile(tarFile.file.path, tarFile.file.bytes);
          final header = tarFile.header;
          file.tarHeader.value = TarHeaderModel(
            deviceMajor: header.deviceMajor,
            deviceMinor: header.deviceMinor,
            gid: header.gid,
            groupname: header.groupname,
            uid: header.uid,
            username: header.username,
            mode: header.mode,
            mtime: header.mtime,
            // TODO: size: header.size,
            // TODO: type: header.type,
          );
        }
        final error = files.expand((f) => f.header.formatErrors).join('\n');
        if (error.isNotEmpty) setError(error);
      }
    }
    notifyListeners();
  }
}

extension CompressorKindExt on CompressorKind {
  List<String> get extensions => switch (this) {
        CompressorKind.gzip => const ['gz', 'tgz', 'gzip'],
        CompressorKind.brotli => const ['br'],
        CompressorKind.zstd => const ['zst'],
        CompressorKind.lz4 => const ['lz4'],
        CompressorKind.deflate => const ['deflate'],
        CompressorKind.zlib => const ['zlib'],
      };
}

String removeExtension(String e, List<String> extension) {
  final k = extension.firstWhere((k) => e.endsWith('.$k'), orElse: () => '');
  return k.isEmpty ? e : e.substring(0, e.length - k.length - 1);
}

class InputFileState {
  final String name;
  final Uint8List bytes;
  final Map<CompressorKind, Uint8List?> compressed = {};
  final Map<CompressorKind, Uint8List?> decompressed = {};

  final zipOptions = ValueNotifier(const ZipOptions(
    compressionMethod: ZipCompressionMethod.deflated,
  ));
  final tarHeader = ValueNotifier(const TarHeaderModel());

  InputFileState(this.name, this.bytes);
}
