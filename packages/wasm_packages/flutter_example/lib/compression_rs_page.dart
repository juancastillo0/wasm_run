import 'dart:typed_data';

import 'package:compression_rs/compression_rs.dart';
import 'package:file_system_access/file_system_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/state.dart';

class CompressionRsPage extends StatelessWidget {
  const CompressionRsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final compressionRsLoader =
        Inherited.get<GlobalState>(context).compressionRs;
    final state = compressionRsLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }

    void loadFiles() async {
      final files = await FileSystem.instance.showOpenFilePickerWebSafe(
        const FsOpenOptions(
          multiple: true,
          startIn: FsStartsInOptions.path(WellKnownDirectory.downloads),
        ),
      );
      for (final file in files) {
        final bytes = await file.file.readAsBytes();
        state.loadFile(file.file.name, bytes);
      }
    }

    // TODO: zip and tar

    const colWidth = 150.0;
    return AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: loadFiles,
                  child: const Text('Load Files'),
                ).container(
                  alignment: Alignment.bottomLeft,
                  width: CompressorKind.values.length * 150 + 150,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('File \\ Compressor')
                        .title()
                        .container(alignment: Alignment.center, width: 250),
                    ...CompressorKind.values.map(
                      (k) => Text(k.name).subtitle().container(
                          alignment: Alignment.center, width: colWidth),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...state.files.map(
                          (e) => Row(
                            children: [
                              Column(
                                children: [
                                  Text(e.name).subtitle(),
                                  Text(e.bytes.sizeHuman),
                                  TextButton(
                                    onPressed: () => CompressorKind.values
                                        .where((kind) =>
                                            kind != CompressorKind.zstd)
                                        .forEach(
                                            (kind) => state.compress(e, kind)),
                                    child: const Text('Compress All'),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ).container(width: 250),
                              ...CompressorKind.values.map(
                                (k) {
                                  final compressed = e.compressed[k];
                                  final decompressed = e.decompressed[k];

                                  return Column(
                                    children: [
                                      if (compressed != null)
                                        TextButton.icon(
                                          onPressed: () => downloadFile(
                                            '${e.name}.${k.name}',
                                            compressed,
                                          ),
                                          icon: const Icon(Icons.download),
                                          label: Text(compressed.sizeHuman),
                                        )
                                      else
                                        TextButton(
                                          onPressed: () => state.compress(e, k),
                                          child: const Text('Compress'),
                                        ),
                                      if (decompressed != null)
                                        TextButton.icon(
                                          onPressed: () {
                                            final name =
                                                e.name.endsWith('.${k.name}')
                                                    ? e.name.substring(
                                                        0,
                                                        e.name.length -
                                                            k.name.length -
                                                            1,
                                                      )
                                                    : e.name;
                                            downloadFile(name, decompressed);
                                          },
                                          icon: const Icon(Icons.download),
                                          label: Text(decompressed.sizeHuman),
                                        )
                                      else
                                        TextButton(
                                          onPressed: () =>
                                              state.decompress(e, k),
                                          child: const Text('Decompress'),
                                        ),
                                    ],
                                  ).container(width: colWidth);
                                },
                              ),
                              IconButton(
                                onPressed: () => state.removeFile(e),
                                icon: const Icon(Icons.delete),
                              ).container(width: 50),
                            ],
                          ),
                        ),
                        ErrorMessage(state: state),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
