// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'dart:convert' show Utf8Codec, latin1;
import 'dart:typed_data' show ByteData, Endian, Uint16List, Uint8List;

import 'package:wasm_wit_component/src/canonical_abi.dart';
import 'package:wasm_wit_component/src/canonical_abi_load_store.dart';
import 'package:wasm_wit_component/src/canonical_abi_utils.dart';

/// Storing strings is complicated by the goal of attempting to optimize the different transcoding cases.
/// In particular, one challenge is choosing the linear memory allocation size before examining
/// the contents of the string. The reason for this constraint is that, in some settings
/// where single-pass iterators are involved (host calls and post-MVP adapter functions),
/// examining the contents of a string more than once would require making an engine-internal
/// temporary copy of the whole string, which the component model specifically aims not to do.
/// To avoid multiple passes, the canonical ABI instead uses a realloc approach to update
/// the allocation size during the single copy. A blind realloc approach would normally
/// suffer from multiple reallocations per string (e.g., using the standard doubling-growth strategy).
/// However, as already shown in load_string above, string values come with two useful hints:
/// their original encoding and byte length. From this hint data, store_string can do a
/// much better job minimizing the number of reallocations.
void store_string(Context cx, ParsedString v, int ptr) {
  final (begin, tagged_code_units) = store_string_into_range(cx, v);
  store_int(cx, begin, ptr, 4);
  store_int(cx, tagged_code_units, ptr + 4, 4);
}

/// We start with a case analysis to enumerate all the meaningful
/// encoding combinations, subdividing the latin1+utf16 encoding into either
/// latin1 or utf16 based on the UTF16_BIT flag set by load_string
PointerAndSize store_string_into_range(Context cx, ParsedString v) {
  final src = v.value;
  final src_encoding = v.encoding;
  final src_tagged_code_units = v.tagged_code_units;

  final StringEncoding src_simple_encoding;
  final int src_code_units;
  if (src_encoding == StringEncoding.latin1utf16) {
    if ((src_tagged_code_units & UTF16_TAG) != 0) {
      src_simple_encoding = StringEncoding.utf16;
      src_code_units = src_tagged_code_units ^ UTF16_TAG;
    } else {
      src_simple_encoding = StringEncoding.latin1utf16;
      src_code_units = src_tagged_code_units;
    }
  } else {
    src_simple_encoding = src_encoding;
    src_code_units = src_tagged_code_units;
  }

  switch (cx.opts.string_encoding) {
    case StringEncoding.utf8:
      switch (src_simple_encoding) {
        case StringEncoding.utf8:
          return _store_string_copy(
              cx, src, src_code_units, 1, 1, StringEncoding.utf8);
        case StringEncoding.utf16:
          return _store_utf16_to_utf8(cx, src, src_code_units);
        case StringEncoding.latin1utf16:
          return _store_latin1_to_utf8(cx, src, src_code_units);
      }
    case StringEncoding.utf16:
      switch (src_simple_encoding) {
        case StringEncoding.utf8:
          return _store_utf8_to_utf16(cx, src, src_code_units);
        case StringEncoding.utf16:
          return _store_string_copy(
              cx, src, src_code_units, 2, 2, StringEncoding.utf16);
        case StringEncoding.latin1utf16:
          return _store_string_copy(
              cx, src, src_code_units, 2, 2, StringEncoding.utf16);
      }
    case StringEncoding.latin1utf16:
      switch (src_encoding) {
        case StringEncoding.utf8:
          return _store_string_to_latin1_or_utf16(cx, src, src_code_units);
        case StringEncoding.utf16:
          return _store_string_to_latin1_or_utf16(cx, src, src_code_units);
        case StringEncoding.latin1utf16:
          switch (src_simple_encoding) {
            case StringEncoding.latin1utf16:
              return _store_string_copy(
                  cx, src, src_code_units, 1, 2, StringEncoding.latin1utf16);
            case StringEncoding.utf16:
              return _store_probably_utf16_to_latin1_or_utf16(
                  cx, src, src_code_units);
            case _:
              throw unreachableException;
          }
      }
  }
}
// #

/// The choice of MAX_STRING_BYTE_LENGTH constant ensures that the
/// high bit of a string's byte length is never set, keeping it clear for [UTF16_TAG].
/// MAX_STRING_BYTE_LENGTH = (1 << 31) - 1
const int MAX_STRING_BYTE_LENGTH = UTF16_TAG - 1;

/// The simplest 4 cases above can compute the exact destination size and
/// then copy with a simply loop (that possibly inflates Latin-1 to UTF-16
/// by injecting a 0 byte after every Latin-1 byte).
PointerAndSize _store_string_copy(
  Context cx,
  String src,
  int src_code_units,
  int dst_code_unit_size,
  int dst_alignment,
  StringEncoding dst_encoding,
) {
  final dst_byte_length = dst_code_unit_size * src_code_units;
  trap_if(dst_byte_length > MAX_STRING_BYTE_LENGTH);
  final ptr = cx.opts.realloc(0, 0, dst_alignment, dst_byte_length);
  trap_if(ptr != align_to(ptr, dst_alignment));
  trap_if(ptr + dst_byte_length > cx.opts.memory.length);
  final encoded = dst_encoding.encode(src);
  assert(dst_byte_length == encoded.length);
  cx.opts.memory.setRange(ptr, ptr + dst_byte_length, encoded);
  return (ptr, src_code_units);
}
// #

PointerAndSize _store_utf16_to_utf8(
    Context cx, String src, int src_code_units) {
  final worst_case_size = src_code_units * 3;
  return _store_string_to_utf8(cx, src, src_code_units, worst_case_size);
}

PointerAndSize _store_latin1_to_utf8(
    Context cx, String src, int src_code_units) {
  final worst_case_size = src_code_units * 2;
  return _store_string_to_utf8(cx, src, src_code_units, worst_case_size);
}

/// The 2 cases of transcoding into UTF-8 share an algorithm that starts
/// by optimistically assuming that each code unit of the source string fits
/// in a single UTF-8 byte and then, failing that, reallocates to a worst-case size,
/// finishes the copy, and then finishes with a shrinking reallocation.
PointerAndSize _store_string_to_utf8(
    Context cx, String src, int src_code_units, int worst_case_size) {
  assert(src_code_units <= MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 1, src_code_units);
  trap_if(ptr + src_code_units > cx.opts.memory.length);
  final encoded = StringEncoding.utf8.encode(src);
  final lenEncoded = encoded.length;
  assert(src_code_units <= lenEncoded);
  cx.opts.memory.setRange(ptr, ptr + src_code_units, encoded);
  if (src_code_units < lenEncoded) {
    trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
    ptr = cx.opts.realloc(ptr, src_code_units, 1, worst_case_size);
    trap_if(ptr + worst_case_size > (cx.opts.memory.length));
    cx.opts.memory.setRange(
      ptr + src_code_units,
      ptr + lenEncoded,
      encoded,
      /* skipCount */ src_code_units,
    );
    if (worst_case_size > lenEncoded) {
      ptr = cx.opts.realloc(ptr, worst_case_size, 1, lenEncoded);
      trap_if(ptr + lenEncoded > cx.opts.memory.length);
    }
  }
  return (ptr, lenEncoded);
}

// #

/// Converting from UTF-8 to UTF-16 performs an initial worst-case size allocation
/// (assuming each UTF-8 byte encodes a whole code point that inflates into
/// a two-byte UTF-16 code unit) and then does a shrinking reallocation at the
/// end if multiple UTF-8 bytes were collapsed into a single 2-byte UTF-16 code unit
PointerAndSize _store_utf8_to_utf16(
    Context cx, String src, int src_code_units) {
  final worst_case_size = 2 * src_code_units;
  trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, worst_case_size);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + worst_case_size > cx.opts.memory.length);
  final encoded = StringEncoding.utf16.encode(src);
  final lenEncoded = encoded.length;
  cx.opts.memory.setAll(ptr, encoded);
  if (encoded.length < worst_case_size) {
    ptr = cx.opts.realloc(ptr, worst_case_size, 2, lenEncoded);
    trap_if(ptr != align_to(ptr, 2));
    trap_if(ptr + lenEncoded > cx.opts.memory.length);
  }
  final code_units = lenEncoded ~/ 2;
  return (ptr, code_units);
}
// #

/// The next transcoding case handles latin1+utf16 encoding,
/// where there general goal is to fit the incoming string into Latin-1
/// if possible based on the code points of the incoming string.
/// The algorithm speculates that all code points do fit into Latin-1
/// and then falls back to a worst-case allocation size when
/// a code point is found outside Latin-1. In this fallback case,
/// the previously-copied Latin-1 bytes are inflated in place,
/// inserting a 0 byte after every Latin-1 byte
/// (iterating in reverse to avoid clobbering later bytes)
PointerAndSize _store_string_to_latin1_or_utf16(
    Context cx, String src, int src_code_units) {
  assert(src_code_units <= MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, src_code_units);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + src_code_units > (cx.opts.memory.length));
  int dst_byte_length = 0;
  for (final usv in src.runes) {
    if (usv < (1 << 8)) {
      cx.opts.memory[ptr + dst_byte_length] = usv;
      dst_byte_length += 1;
    } else {
      final worst_case_size = 2 * src_code_units;
      trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
      ptr = cx.opts.realloc(ptr, src_code_units, 2, worst_case_size);
      trap_if(ptr != align_to(ptr, 2));
      trap_if(ptr + worst_case_size > (cx.opts.memory.length));
      for (int j = dst_byte_length - 1; j >= 0; j--) {
        cx.opts.memory[ptr + 2 * j] = cx.opts.memory[ptr + j];
        cx.opts.memory[ptr + 2 * j + 1] = 0;
      }
      final encoded = StringEncoding.utf16.encode(src);
      final lenEncoded = encoded.length;
      cx.opts.memory.setRange(ptr + 2 * dst_byte_length, ptr + lenEncoded,
          encoded, 2 * dst_byte_length);
      if (worst_case_size > lenEncoded) {
        ptr = cx.opts.realloc(ptr, worst_case_size, 2, lenEncoded);
        trap_if(ptr != align_to(ptr, 2));
        trap_if(ptr + lenEncoded > (cx.opts.memory.length));
      }
      final tagged_code_units = (lenEncoded ~/ 2) | UTF16_TAG;
      return (ptr, tagged_code_units);
    }
  }
  if (dst_byte_length < src_code_units) {
    ptr = cx.opts.realloc(ptr, src_code_units, 2, dst_byte_length);
    trap_if(ptr != align_to(ptr, 2));
    trap_if(ptr + dst_byte_length > (cx.opts.memory.length));
  }
  return (ptr, dst_byte_length);
}
// #

/// The final transcoding case takes advantage of the extra heuristic
/// information that the incoming UTF-16 bytes were intentionally chosen
/// over Latin-1 by the producer, indicating that they probably contain code
/// points outside Latin-1 and thus probably require inflation.
/// Based on this information, the transcoding algorithm pessimistically
/// allocates storage for UTF-16, deflating at the end if
/// indeed no non-Latin-1 code points were encountered.
/// This Latin-1 deflation ensures that if a group of components
/// are all using latin1+utf16 and one component over-uses UTF-16,
/// other components can recover the Latin-1 compression.
/// (The Latin-1 check can be inexpensively fused with the UTF-16 validate+copy loop.)
PointerAndSize _store_probably_utf16_to_latin1_or_utf16(
    Context cx, String src, int src_code_units) {
  final src_byte_length = 2 * src_code_units;
  trap_if(src_byte_length > MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, src_byte_length);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + src_byte_length > (cx.opts.memory.length));
  final encoded = StringEncoding.utf16.encode(src);
  final lenEncoded = encoded.length;
  cx.opts.memory.setAll(ptr, encoded);
  if (src.runes.any((c) => c >= (1 << 8))) {
    final tagged_code_units = (lenEncoded ~/ 2) | UTF16_TAG;
    return (ptr, tagged_code_units);
  }
  final latin1_size = lenEncoded ~/ 2;
  for (final i in Iterable<int>.generate(latin1_size)) {
    cx.opts.memory[ptr + i] = cx.opts.memory[ptr + 2 * i];
  }
  ptr = cx.opts.realloc(ptr, src_byte_length, 1, latin1_size);
  trap_if(ptr + latin1_size > (cx.opts.memory.length));
  return (ptr, latin1_size);
}
// #

/// The encoding used to [load_string] and [store_string] from wasm memory.
enum StringEncoding {
  /// [Utf8Codec]
  utf8,

  /// [String.fromCharCodes] little endian
  utf16,

  /// [latin1]
  latin1utf16;

  factory StringEncoding.fromJson(Object? json) {
    return switch (json) {
      'utf8' => utf8,
      'utf16' => utf16,
      'latin1+utf16' || 'latin1utf16' => latin1utf16,
      _ => throw Exception(
          'Invalid string encoding: $json.'
          ' Values: ${StringEncoding.values}',
        ),
    };
  }

  String toJson() {
    return switch (this) {
      utf8 => 'utf8',
      utf16 => 'utf16',
      latin1utf16 => 'latin1+utf16',
    };
  }

  /// Decodes the given little endian bytes into a Dart [String].
  String decode(Uint8List bytes) {
    switch (this) {
      case StringEncoding.utf8:
        return const Utf8Codec().decoder.convert(bytes);
      case StringEncoding.utf16:
        if (Endian.host != Endian.little) {
          final data = ByteData.sublistView(bytes);
          final list = Uint16List(bytes.lengthInBytes);
          for (var i = 0; i < list.length; i++) {
            list[i] = data.getInt16(i * 2, Endian.little);
          }
          return String.fromCharCodes(list);
        } else {
          return String.fromCharCodes(Uint16List.sublistView(bytes));
        }
      case StringEncoding.latin1utf16:
        return latin1.decode(bytes);
    }
  }

  /// Encodes the given Dart [String] into little endian bytes.
  Uint8List encode(String string) {
    switch (this) {
      case StringEncoding.utf8:
        return const Utf8Codec().encoder.convert(string);
      case StringEncoding.utf16:
        final codeUnits = string.codeUnits;
        if (Endian.host != Endian.little) {
          final data = ByteData(codeUnits.length * 2);
          for (int i = 0; i < codeUnits.length; i++) {
            data.setUint16(i * 2, codeUnits[i], Endian.little);
          }
          return data.buffer.asUint8List();
        } else {
          return Uint16List.fromList(codeUnits).buffer.asUint8List();
        }
      case StringEncoding.latin1utf16:
        return latin1.encode(string);
    }
  }
}

class ParsedString {
  /// The string value.
  final String value;

  /// The encoding of the string when it was parsed from wasm's memory.
  final StringEncoding encoding;

  /// The number of code units in the string.
  final int tagged_code_units;

  const ParsedString(this.value, this.encoding, this.tagged_code_units);

  /// Creates a [ParsedString] from a Dart [String] with [StringEncoding.utf16].
  factory ParsedString.fromString(String value) =>
      ParsedString(value, StringEncoding.utf16, value.length);

  factory ParsedString.fromJson(Object? json) {
    if (json is String) return ParsedString.fromString(json);
    final map = json! as Map<String, Object?>;
    return ParsedString(
      map['value']! as String,
      StringEncoding.fromJson(map['encoding']),
      map['tagged_code_units']! as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'value': value,
      'encoding': encoding.toJson(),
      'tagged_code_units': tagged_code_units,
    };
  }

  @override
  String toString() => value;
}

/// Strings are loaded from two i32 values: a pointer (offset in linear memory) and a number of bytes.
/// There are three supported string encodings ([StringEncoding]) in canonopt:
/// UTF-8, UTF-16 and latin1+utf16.
/// This last options allows a dynamic choice between Latin-1 and UTF-16, indicated
/// by the high bit of the second i32. String values include their original encoding
/// and byte length as a "hint" that enables store_string (defined below) to make better
/// up-front allocation size choices in many cases. Thus, the value produced by load_string
/// isn't simply a Dart String, but a [ParsedString] containing a String, the original encoding
/// and the original byte length.
ParsedString load_string(Context cx, int ptr) {
  final int begin = load_int(cx, ptr, 4);
  final int tagged_code_units = load_int(cx, ptr + 4, 4);
  return load_string_from_range(cx, begin, tagged_code_units);
}

/// Used to indicate that the string is UTF-16 encoded.
/// This is used to distinguish between Latin-1 and UTF-16
/// in [StringEncoding.latin1utf16]
///
/// See [store_string_into_range].
/// UTF16_TAG = 1 << 31
const int UTF16_TAG = 2147483648;

ParsedString load_string_from_range(
    Context cx, int ptr, int tagged_code_units) {
  final int alignment;
  final int byte_length;
  final StringEncoding encoding;
  switch (cx.opts.string_encoding) {
    case StringEncoding.utf8:
      alignment = 1;
      byte_length = tagged_code_units;
      encoding = StringEncoding.utf8;
    case StringEncoding.utf16:
      alignment = 2;
      byte_length = 2 * tagged_code_units;
      encoding = StringEncoding.utf16;
    case StringEncoding.latin1utf16:
      alignment = 2;
      if ((tagged_code_units & UTF16_TAG) != 0) {
        byte_length = 2 * (tagged_code_units ^ UTF16_TAG);
        encoding = StringEncoding.utf16;
      } else {
        byte_length = tagged_code_units;
        encoding = StringEncoding.latin1utf16;
      }
  }

  trap_if(ptr != align_to(ptr, alignment));
  trap_if(ptr + byte_length > cx.opts.memory.length);
  final String s;
  try {
    final codeUnits =
        Uint8List.sublistView(cx.opts.memory, ptr, ptr + byte_length);
    s = encoding.decode(codeUnits);
  }
  // TODO: on UnicodeError
  catch (e, s) {
    trap(e, s);
  }

  return ParsedString(s, cx.opts.string_encoding, tagged_code_units);
}
