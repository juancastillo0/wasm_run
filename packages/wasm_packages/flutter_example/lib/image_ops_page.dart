import 'package:file_system_access/file_system_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/image_ops_state.dart';
import 'package:flutter_example/state.dart';
import 'package:image_ops/image_ops.dart' as image_ops;

class ImageOpsPage extends StatelessWidget {
  const ImageOpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final imageOpsLoader = Inherited.get<GlobalState>(context).imageOps;
    final state = imageOpsLoader.value;
    if (state == null) {
      return const CircularProgressIndicator();
    }

    void Function() op(image_ops.ImageRef Function(image_ops.ImageRef) exec) =>
        () => state.op(exec);

    const imageFileType = FilePickerAcceptType(
      description: 'Image',
      accept: {},
    );

    void loadImage(void Function(String name, Uint8List bytes) onLoad) async {
      final files = await FileSystem.instance.showOpenFilePickerWebSafe(
        const FsOpenOptions(
          multiple: false,
          types: [imageFileType],
        ),
      );
      if (files.isNotEmpty) {
        final file = files.first;
        final bytes = await file.file.readAsBytes();
        onLoad(file.file.name, bytes);
      }
    }

    Widget imageOpToWidget(ImgOp e) {
      final button = TextButton(
        onPressed: op(e.exec),
        child: Text(e.name),
      );
      if (e.fields != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button,
            e.fields!.container(width: 80),
          ],
        );
      }
      return button;
    }

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final values = state.values;
        return Row(
          children: [
            Visibility(
              visible: state.showOperations,
              child: FocusTraversalGroup(
                child: AnimatedBuilder(
                  animation: values,
                  builder: (context, _) {
                    return ListView(
                      children: [
                        Row(
                          children: [
                            const Text('Rotate'),
                            const SizedBox(width: 4),
                            ...([
                              (
                                90,
                                state.imageOps.operations.rotate90,
                              ),
                              (
                                180,
                                state.imageOps.operations.rotate180,
                              ),
                              (
                                270,
                                state.imageOps.operations.rotate270,
                              )
                            ]).map(
                              (e) => TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 0,
                                  ),
                                  minimumSize: const Size(45, 40),
                                ),
                                onPressed: op((ref) => e.$2(imageRef: ref)),
                                child: Text('${e.$1}'),
                              ),
                            )
                          ],
                        ),
                        ...imageOps(state).map(imageOpToWidget),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 6),
                            const Text('keepAspectRatio'),
                            Checkbox(
                              value: values.keepAspectRatio,
                              onChanged: (v) => values.setKeepAspectRatio(v!),
                            ),
                          ],
                        ),
                        DropdownButtonFormField(
                          value: values.filterType,
                          onChanged: (f) => values.setFilterType(f!),
                          items: image_ops.FilterType.values
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(growable: false),
                        ).container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(horizontal: 6)),
                        // TODO: /// Resize the supplied image to the specified dimensions.
                        // /// The image's aspect ratio is preserved. The image is scaled to the
                        // /// maximum possible size that fits within the larger (relative to aspect ratio)
                        // /// of the bounds specified by nwidth and nheight, then cropped to fit within the other bound.
                        // resize-to-fill: func(image-ref: image-ref, size: image-size, filter: filter-type) -> image-ref
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IntInput(label: 'Width', onChanged: values.setWidth)
                                .container(width: 80),
                            IntInput(
                                    label: 'Height',
                                    onChanged: values.setHeight)
                                .container(width: 80),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IntInput(label: 'X', onChanged: values.setX)
                                .container(width: 80),
                            IntInput(label: 'Y', onChanged: values.setY)
                                .container(width: 80),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ]
                          .expand((e) => [const SizedBox(height: 5), e])
                          .toList(growable: false),
                    ).container(
                      width: 180,
                      padding: const EdgeInsets.only(left: 6),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  FocusTraversalGroup(
                    child: AnimatedBuilder(
                      animation: values,
                      builder: (context, _) => Wrap(
                        runSpacing: 4,
                        spacing: 4,
                        children: [
                          TextButton.icon(
                            onPressed: state.toggleShowOperations,
                            icon: state.showOperations
                                ? const Icon(Icons.arrow_back_ios, size: 14)
                                : const Icon(Icons.arrow_forward_ios, size: 14),
                            label: state.showOperations
                                ? const Text('Hide')
                                : const Text('Show'),
                          ),
                          TextButton(
                            onPressed: () => loadImage(state.loadImage),
                            child: const Text('Load Image'),
                          ),
                          TextButton(
                            onPressed: () {
                              final extensions = state.imageOps
                                  .formatExtensions(format: state.format);
                              downloadFile(
                                'image.${extensions.firstOrNull ?? ''}',
                                state.bytes!,
                              );
                            },
                            child: const Text('Download'),
                          ),
                          DropdownButtonFormField(
                            value: state.format,
                            onChanged: (f) => state.setFormat(f!),
                            items: image_ops.ImageFormat.values
                                .where((e) => e != image_ops.ImageFormat.unknown)
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(growable: false),
                          ).container(width: 110),
                          DropdownButtonFormField(
                            value: state.color,
                            onChanged: (f) => state.setColor(f!),
                            items: image_ops.ColorType.values
                                .where((e) => e != image_ops.ColorType.unknown)
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(growable: false),
                          ).container(width: 110),
                          TextButton.icon(
                            onPressed: state.revert,
                            icon: const Icon(Icons.restore),
                            label: const Text('Revert Changes'),
                          ),
                        ],
                      ),
                    ).container(
                        padding: const EdgeInsets.symmetric(vertical: 5)),
                  ),
                  if (state.bytes != null)
                    Expanded(
                      child: Column(
                        children: [
                          ImageInfo(
                            ref: state.ref!,
                            format: state.format,
                            length: state.bytes!.length,
                          ),
                          Expanded(
                            child: Image.memory(
                              state.bytes!,
                              // TODO: handle unsuported format by flutter
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => loadImage(state.loadImage),
                        child: const Text('Load Image'),
                      ).container(alignment: Alignment.center),
                    ),
                  ErrorMessage(state: state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class DoubleInput extends StatelessWidget {
  const DoubleInput({super.key, required this.onChanged});

  final void Function(double value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) {
        final d = double.tryParse(v);
        if (d != null) onChanged(d);
      },
    );
  }
}

class ImgOp {
  final String name;
  final image_ops.ImageRef Function(image_ops.ImageRef) exec;
  final Widget? fields;

  ImgOp(this.name, this.exec, {this.fields});
}

class ImageInfo extends StatelessWidget {
  const ImageInfo({
    super.key,
    required this.ref,
    required this.format,
    required this.length,
  });

  final image_ops.ImageRef ref;
  final image_ops.ImageFormat format;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('width: ${ref.width}'),
        Text('height: ${ref.height}'),
        Text('color: ${ref.color.name}'),
        Text('format: ${format.name}'),
        Text('size: ${(length / 1024).toStringAsFixed(1)}kb'),
        // TODO: Text('channels: ${ref.channels}'),
        // Text('bytesPerRow: ${ref.bytesPerRow}'),
        // Text('bytesPerPixel: ${ref.bytesPerPixel}'),
        // Text('bytesPerImage: ${ref.bytesPerImage}'),
        // Text('bytes: ${ref.bytes}'),
      ]
          .map((e) => e.container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ))
          .toList(),
    );
  }
}

// TODO:
// /// Perform a 3x3 box filter on the supplied image.
// filter3x3: func(image-ref: image-ref, kernel: list<float32>) -> image-ref
// /// Performs an unsharpen mask on the supplied image.
// unsharpen: func(image-ref: image-ref, sigma: float32, threshold: s32) -> image-ref
// /// Overlay an image at a given coordinate (x, y)
// overlay: func(image-ref: image-ref, other: image-ref, x: u32, y: u32) -> image-ref
// /// Replace the contents of an image at a given coordinate (x, y)
// replace: func(image-ref: image-ref, other: image-ref, x: u32, y: u32) -> image-ref

List<ImgOp> imageOps(ImageOpsState state) {
  final values = state.values;
  return [
    ImgOp(
      'flipVertical',
      (ref) => state.imageOps.operations.flipVertical(imageRef: ref),
    ),
    ImgOp(
      'flipHorizontal',
      (ref) => state.imageOps.operations.flipHorizontal(imageRef: ref),
    ),
    ImgOp(
      'grayscale',
      (ref) => state.imageOps.operations.grayscale(imageRef: ref),
    ),
    ImgOp(
      'invert',
      (ref) => state.imageOps.operations.invert(imageRef: ref),
    ),
    // ImgOp(
    //   'rotate90',
    //   (ref) => state.imageOps.operations.rotate90(imageRef: ref),
    // ),
    // ImgOp(
    //   'rotate180',
    //   (ref) => state.imageOps.operations.rotate180(imageRef: ref),
    // ),
    // ImgOp(
    //   'rotate270',
    //   (ref) => state.imageOps.operations.rotate270(imageRef: ref),
    // ),
    ImgOp(
      'blur',
      (ref) => state.imageOps.operations.blur(imageRef: ref, value: values.blur),
      fields: DoubleInput(onChanged: values.setBlur),
    ),
    ImgOp(
      'brighten',
      (ref) => state.imageOps.operations
          .brighten(imageRef: ref, value: values.brighten),
      fields: IntInput(onChanged: values.setBrighten),
    ),
    ImgOp(
      'huerotate',
      (ref) => state.imageOps.operations
          .huerotate(imageRef: ref, value: values.huerotate),
      fields: IntInput(onChanged: values.setHuerotate),
    ),
    ImgOp(
      'contrast',
      (ref) => state.imageOps.operations
          .adjustContrast(imageRef: ref, c: values.contrast),
      fields: DoubleInput(onChanged: values.setContrast),
    ),
    ImgOp(
      'crop',
      (ref) =>
          state.imageOps.operations.crop(imageRef: ref, imageCrop: values.crop),
    ),
    ImgOp(
      'resize',
      (ref) => values.keepAspectRatio
          ? state.imageOps.operations.resize(
              imageRef: ref,
              size: values.size,
              filter: values.filterType,
            )
          : state.imageOps.operations.resizeExact(
              imageRef: ref,
              size: values.size,
              filter: values.filterType,
            ),
    ),
    ImgOp(
      'thumbnail',
      (ref) => values.keepAspectRatio
          ? state.imageOps.operations.thumbnail(imageRef: ref, size: values.size)
          : state.imageOps.operations
              .thumbnailExact(imageRef: ref, size: values.size),
    ),
  ];
}
