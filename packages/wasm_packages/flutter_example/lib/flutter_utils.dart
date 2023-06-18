import 'package:flutter/material.dart';

class Inherited<T> extends InheritedWidget {
  const Inherited({
    super.key,
    required this.state,
    required Widget child,
  }) : super(child: child);

  final T state;

  static T get<T>(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<Inherited<T>>()!.widget
              as Inherited<T>)
          .state;

  @override
  bool updateShouldNotify(covariant Inherited oldWidget) {
    return false;
  }
}

extension TextExt on Text {
  Widget title() => Text(
        data!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).container(padding: const EdgeInsets.all(10));

  Widget subtitle() => Text(
        data!,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ).container(padding: const EdgeInsets.all(6));
}

const codeTextStyle = TextStyle(
  fontSize: 13,
  fontFamily: 'monospace',
);

extension ContainerExt on Widget {
  Widget container({
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
}

extension WatchListenable<T extends Listenable> on T {
  Widget select<O>(
    O Function(T state) selector,
    Widget Function(O value) builder,
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
  final Widget Function(O value) builder;

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
    return widget.builder(previousValue as O);
  }
}
