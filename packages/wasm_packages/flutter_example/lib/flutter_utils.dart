import 'dart:typed_data';

import 'package:file_system_access/file_system_access.dart' as fsa;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Inherited<T> extends InheritedWidget {
  const Inherited({
    super.key,
    required this.state,
    required super.child,
  });

  final T state;

  static T get<T>(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<Inherited<T>>()!.widget
              as Inherited<T>)
          .state;

  @override
  bool updateShouldNotify(covariant Inherited<T> oldWidget) {
    return false;
  }
}

extension TextExt on Text {
  Widget title() => SelectableText(
        data!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).container(padding: const EdgeInsets.all(10));

  Widget subtitle() => SelectableText(
        data!,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ).container(padding: const EdgeInsets.all(6));
}

Future<void> downloadFile(
  String name,
  Uint8List bytes, {
  List<fsa.FilePickerAcceptType> types = const [],
}) async {
  if (!fsa.FileSystem.instance.isSupported) {
    await fsa.XFile.fromData(bytes).saveTo(name);
  } else {
    final handle = await fsa.FileSystem.instance.showSaveFilePicker(
      fsa.FsSaveOptions(types: types, suggestedName: name),
    );
    if (handle == null) return;
    final writable = await handle.createWritable(keepExistingData: false);
    await writable.write(
      fsa.FileSystemWriteChunkType.bufferSource(
        bytes.buffer,
      ),
    );
    await writable.close();
  }
}

final codeTextStyle = GoogleFonts.cousine(fontSize: 13);

extension ContainerExt on Widget {
  Widget container({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  Widget containerObject(Container container) {
    return Container(
      key: key,
      alignment: container.alignment,
      padding: container.padding,
      color: container.color,
      decoration: container.decoration,
      foregroundDecoration: container.foregroundDecoration,
      constraints: container.constraints,
      margin: container.margin,
      transform: container.transform,
      transformAlignment: container.transformAlignment,
      clipBehavior: container.clipBehavior,
      child: this,
    );
  }
}

extension Uint8ListExt on Uint8List {
  String get sizeHuman => '${length ~/ 1024} KB';
}

class IntInput extends StatelessWidget {
  const IntInput({
    super.key,
    required this.onChanged,
    this.label,
    this.initialValue,
  });
  final int? initialValue;
  final void Function(int value) onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      initialValue: initialValue?.toString(),
      decoration: InputDecoration(
        labelText: label,
      ),
      onChanged: (v) {
        final d = int.tryParse(v);
        if (d != null) onChanged(d);
      },
    );
  }
}

mixin ErrorNotifier on ChangeNotifier {
  String _error = '';

  String get error => _error;

  void setError(String error) {
    _error = error;
    notifyListeners();
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.state});

  final ErrorNotifier state;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        if (state.error.isEmpty) return const SizedBox();
        return Row(
          children: [
            Expanded(child: Text(state.error)),
            ElevatedButton(
              onPressed: () => state.setError(''),
              child: const Text('Close'),
            )
          ],
        ).container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(12),
          color: Colors.red.shade100,
        );
      },
    );
  }
}

extension WatchListenable<T extends Listenable> on T {
  Widget select<O>(
    O Function(T state) selector,
    Widget Function(BuildContext context, O value) builder,
  ) {
    return ListenableSelector(
      listenable: this,
      selector: selector,
      builder: builder,
    );
  }
}

class ListenableSelector<T extends Listenable, O> extends StatefulWidget {
  const ListenableSelector({
    super.key,
    required this.listenable,
    required this.selector,
    required this.builder,
  });
  final T listenable;
  final O Function(T state) selector;
  final Widget Function(BuildContext context, O value) builder;

  @override
  State<ListenableSelector<T, O>> createState() => _ListenableSelectorState();
}

class _ListenableSelectorState<T extends Listenable, O>
    extends State<ListenableSelector<T, O>> {
  O? previousValue;

  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_rebuild);
  }

  void _rebuild() {
    final newValue = widget.selector(widget.listenable);
    if (newValue != previousValue) {
      previousValue = newValue;
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant ListenableSelector<T, O> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable.removeListener(_rebuild);
      widget.listenable.addListener(_rebuild);
    }
    if (oldWidget.selector != widget.selector) {
      previousValue = widget.selector(widget.listenable);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    previousValue ??= widget.selector(widget.listenable);
    return widget.builder(context, previousValue as O);
  }
}
