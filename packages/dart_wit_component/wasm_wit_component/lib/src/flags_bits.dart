import 'dart:typed_data' show ByteData, Endian, Uint32List;

import 'package:wasm_wit_component/src/component.dart' show comparator;

/// A class that stores a list of flags as a [ByteData] instance.
class FlagsBits {
  /// The [ByteData] instance that stores the flag bits.
  final ByteData data;

  /// The number of flags.
  final int numFlags;

  /// Creates a [FlagsBits] from a [ByteData] instance.
  FlagsBits(this.data, {required this.numFlags})
      : assert(
          data.lengthInBytes % 4 == 0,
          "ByteData's length should be a multiple of 4",
        ) {
    _zeroOutUnusedBits();
  }

  /// Creates a [FlagsBits] with all flags set to `false`.
  FlagsBits.none({required this.numFlags})
      : data = ByteData((numFlags / 32).ceil() * 4);

  /// Creates a [FlagsBits] with all flags set to `true`.
  factory FlagsBits.all({required int numFlags}) =>
      FlagsBits.fromBooleans(List.generate(numFlags, (_) => true));

  /// Creates a [FlagsBits] from a list of [bool]s.
  factory FlagsBits.fromBooleans(List<bool> flags) {
    final value = FlagsBits.none(numFlags: flags.length);
    for (var i = 0; i < flags.length; i++) {
      if (flags[i]) value.setFlag(i, true);
    }
    return value;
  }

  /// Creates a [FlagsBits] from a JSON representation.
  /// [json_] must be a [List] of [int]s or [bool]s.
  factory FlagsBits.fromJson(
    Object? json_, {
    required List<Object> flagsKeys,
  }) {
    if (json_ is Map) {
      return FlagsBits._fromMap(json_, flagsKeys);
    } else if (json_ is List && json_.first is bool) {
      return FlagsBits.fromBooleans(json_.cast<bool>());
    }
    final json = (json_! as List).cast<int>();
    final flagBits = ByteData(json.length * 4);
    for (var i = 0; i < json.length; i++) {
      flagBits.setUint32(i * 4, json[i], Endian.little);
    }
    return FlagsBits(flagBits, numFlags: flagsKeys.length);
  }

  factory FlagsBits._fromMap(
    Map<Object?, Object?> map,
    List<Object> flagsKeys,
  ) {
    final value = FlagsBits.none(numFlags: flagsKeys.length);
    for (var i = 0; i < flagsKeys.length; i++) {
      final fv = map[flagsKeys[i]];
      if (fv == true || fv is int && fv != 0) {
        value.setFlag(i, true);
      }
    }
    return value;
  }

  /// Gets the flag at [i]
  bool getFlag(int i) {
    final flagBit = 1 << (i % 32);
    return (_index(i ~/ 32) & flagBit) != 0;
  }

  /// Sets the flag at [i] to [enable].
  // ignore: avoid_positional_boolean_parameters
  void setFlag(int i, bool enable) => _setIndex(i ~/ 32, 1 << (i % 32), enable);

  /// Gets the flag at [i]
  bool operator [](int i) => getFlag(i);

  /// Sets the flag at [i] to [enable].
  void operator []=(int i, bool enable) => setFlag(i, enable);

  /// Bitwise and
  FlagsBits operator &(FlagsBits other) => _merge(other, (a, b) => a & b);

  /// Bitwise or
  FlagsBits operator |(FlagsBits other) => _merge(other, (a, b) => a | b);

  /// Bitwise exclusive-or
  FlagsBits operator ^(FlagsBits other) => _merge(other, (a, b) => a ^ b);

  /// Bitwise not
  FlagsBits operator ~() => _merge(this, (a, _) => ~a);

  FlagsBits _merge(FlagsBits other, int Function(int, int) merge) {
    if (data.lengthInBytes != other.data.lengthInBytes) {
      throw ArgumentError(
        'The two FlagsBits must have the same number of flags',
      );
    }
    final c = ByteData(data.lengthInBytes);
    for (var i = 0; i < data.lengthInBytes ~/ 4; i++) {
      c.setUint32(i * 4, merge(_index(i), other._index(i)), Endian.little);
    }
    return FlagsBits(c, numFlags: numFlags);
  }

  void _zeroOutUnusedBits() {
    final lastOffset = data.lengthInBytes - 4;
    // zero-out unused last 32 bits
    final mask = 0xFFFFFFFF >> (32 - numFlags % 32);
    data.setUint32(
      lastOffset,
      data.getUint32(lastOffset, Endian.little) & mask,
      Endian.little,
    );
  }

  int _index(int i) => data.getUint32(i * 4, Endian.little);
  void _setIndex(int i, int flag, bool enable) {
    final currentValue = _index(i);
    data.setUint32(
      i * 4,
      enable ? (flag | currentValue) : ((~flag) & currentValue),
      Endian.little,
    );
  }

  Uint32List get _bitsAsUint32List => Uint32List.sublistView(data);

  /// Returns a JSON representation of the flag bits.
  Object toJson() {
    return List.generate(_bitsAsUint32List.length, _index);
  }

  @override
  String toString() {
    final bits = Iterable.generate(
      _bitsAsUint32List.length,
      (i) => _index(i).toRadixString(2),
    ).join(',');
    return 'FlagsBits(numFlags: $numFlags, ${bits})';
  }

  @override
  bool operator ==(Object other) =>
      other is FlagsBits &&
      numFlags == other.numFlags &&
      comparator.areEqual(_bitsAsUint32List, other._bitsAsUint32List);

  @override
  int get hashCode =>
      numFlags.hashCode ^ comparator.hashValue(_bitsAsUint32List);
}
