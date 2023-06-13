// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

/// A record is a class with named fields
/// There are enum, list, variant, option, result, tuple and union types
class Model {
  /// Comment for a field
  final int /*S32*/ integer;

  /// A record is a class with named fields
  /// There are enum, list, variant, option, result, tuple and union types
  const Model({
    required this.integer,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Model.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final integer] || (final integer,) => Model(
          integer: integer! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'integer': integer,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [integer];
  @override
  String toString() =>
      'Model${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Model copyWith({
    int /*S32*/ ? integer,
  }) =>
      Model(integer: integer ?? this.integer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [integer];
  static const _spec = RecordType([(label: 'integer', t: S32())]);
}

class CompressionRsWorldImports {
  /// An import is a function that is provided by the host environment (Dart)
  final double /*F64*/ Function({
    required int /*S32*/ value,
  }) mapInteger;
  const CompressionRsWorldImports({
    required this.mapInteger,
  });
}

class CompressionRsWorld {
  final CompressionRsWorldImports imports;
  final WasmLibrary library;

  CompressionRsWorld({
    required this.imports,
    required this.library,
  }) : _run = library.getComponentFunction(
          'run',
          const FuncType([('value', Model._spec)],
              [('', ResultType(Float64(), StringType()))]),
        )!;

  static Future<CompressionRsWorld> init(
    WasmInstanceBuilder builder, {
    required CompressionRsWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    {
      const ft = FuncType([('value', S32())], [('', Float64())]);

      (ListValue, void Function()) execImportsMapInteger(ListValue args) {
        final args0 = args[0];
        final results = imports.mapInteger(value: args0! as int);
        return ([results], () {});
      }

      final lowered = loweredImportFunction(
          r'$root#map-integer', ft, execImportsMapInteger, getLib);
      builder.addImport(r'$root', 'map-integer', lowered);
    }

    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return CompressionRsWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _run;

  /// export
  Result<double /*F64*/, String> run({
    required Model value,
  }) {
    final results = _run([value.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as double,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
