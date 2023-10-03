const hostWitDartOutput = r'''
// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

class RecordTest implements ToJsonSerializable {
  final int /*U32*/ a;
  final String b;
  final double /*F64*/ c;
  const RecordTest({
    required this.a,
    required this.b,
    required this.c,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RecordTest.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final a, final b, final c] || (final a, final b, final c) => RecordTest(
          a: a! as int,
          b: b is String ? b : (b! as ParsedString).value,
          c: c! as double,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RecordTest',
        'a': a,
        'b': b,
        'c': c,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [a, b, c];
  @override
  String toString() =>
      'RecordTest${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RecordTest copyWith({
    int /*U32*/ ? a,
    String? b,
    double /*F64*/ ? c,
  }) =>
      RecordTest(a: a ?? this.a, b: b ?? this.b, c: c ?? this.c);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordTest &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [a, b, c];
  static const _spec = RecordType([
    (label: 'a', t: U32()),
    (label: 'b', t: StringType()),
    (label: 'c', t: Float64())
  ]);
}

class HostWorldImports {
  final void Function({
    required String msg,
  }) print;
  const HostWorldImports({
    required this.print,
  });
}

class HostWorld {
  final HostWorldImports imports;
  final WasmLibrary library;

  HostWorld({
    required this.imports,
    required this.library,
  })  : _run = library.getComponentFunction(
          'run',
          const FuncType([], []),
        )!,
        _get_ = library.getComponentFunction(
          'get',
          const FuncType([], [('', RecordTest._spec)]),
        )!,
        _map = library.getComponentFunction(
          'map',
          const FuncType([('rec', RecordTest._spec)], [('', RecordTest._spec)]),
        )!,
        _mapI = library.getComponentFunction(
          'map-i',
          const FuncType([('rec', RecordTest._spec), ('i', Float32())],
              [('', RecordTest._spec)]),
        )!,
        _receiveI = library.getComponentFunction(
          'receive-i',
          const FuncType([('rec', RecordTest._spec), ('i', Float32())], []),
        )!;

  static Future<HostWorld> init(
    WasmInstanceBuilder builder, {
    required HostWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    {
      const ft = FuncType([('msg', StringType())], []);

      (ListValue, void Function()) execImportsPrint(ListValue args) {
        final args0 = args[0];
        imports.print(
            msg: args0 is String ? args0 : (args0! as ParsedString).value);
        return (const [], () {});
      }

      final lowered =
          loweredImportFunction(r'$root#print', ft, execImportsPrint, getLib);
      builder.addImport(r'$root', 'print', lowered);
    }
    final instance = await builder.build();

    library = WasmLibrary(instance,
        componentId: 'host-namespace:host-pkg/host',
        int64Type: Int64TypeConfig.bigInt);
    return HostWorld(imports: imports, library: library);
  }

  static final _zoneKey = Object();
  late final _zoneValues = {_zoneKey: this};
  static HostWorld? currentZoneWorld() => Zone.current[_zoneKey] as HostWorld?;
  T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);

  final ListValue Function(ListValue) _run;
  void run() {
    _run([]);
  }

  final ListValue Function(ListValue) _get_;
  RecordTest get_() {
    final results = _get_([]);
    final result = results[0];
    return withContext(() => RecordTest.fromJson(result));
  }

  final ListValue Function(ListValue) _map;
  RecordTest map({
    required RecordTest rec,
  }) {
    final results = _map([rec.toWasm()]);
    final result = results[0];
    return withContext(() => RecordTest.fromJson(result));
  }

  final ListValue Function(ListValue) _mapI;
  RecordTest mapI({
    required RecordTest rec,
    required double /*F32*/ i,
  }) {
    final results = _mapI([rec.toWasm(), i]);
    final result = results[0];
    return withContext(() => RecordTest.fromJson(result));
  }

  final ListValue Function(ListValue) _receiveI;
  void receiveI({
    required RecordTest rec,
    required double /*F32*/ i,
  }) {
    _receiveI([rec.toWasm(), i]);
  }
}
''';
