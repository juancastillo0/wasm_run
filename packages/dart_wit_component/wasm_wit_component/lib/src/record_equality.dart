// coverage:ignore-file
// ignore_for_file: require_trailing_commas

/// Converts a record to a list.
/// May throw [InvalidRecordListException] if the record is
/// not completely positional or the size is greater than the supported size.
List<Object?> recordToList(Record a) {
  // TODO: check they are all positional
  return switch (a) {
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12,
      final $13,
      final $14,
      final $15,
      final $16,
      final $17,
      final $18
    ) =>
      [
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17,
        $18
      ],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12,
      final $13,
      final $14,
      final $15,
      final $16,
      final $17
    ) =>
      [
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        $9,
        $10,
        $11,
        $12,
        $13,
        $14,
        $15,
        $16,
        $17
      ],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12,
      final $13,
      final $14,
      final $15,
      final $16
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12,
      final $13,
      final $14,
      final $15
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12,
      final $13,
      final $14
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12,
      final $13
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11,
      final $12
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10,
      final $11
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9,
      final $10
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9, $10],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8,
      final $9
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8, $9],
    (
      final $1,
      final $2,
      final $3,
      final $4,
      final $5,
      final $6,
      final $7,
      final $8
    ) =>
      [$1, $2, $3, $4, $5, $6, $7, $8],
    (final $1, final $2, final $3, final $4, final $5, final $6, final $7) => [
        $1,
        $2,
        $3,
        $4,
        $5,
        $6,
        $7
      ],
    (final $1, final $2, final $3, final $4, final $5, final $6) => [
        $1,
        $2,
        $3,
        $4,
        $5,
        $6
      ],
    (final $1, final $2, final $3, final $4, final $5) => [$1, $2, $3, $4, $5],
    (final $1, final $2, final $3, final $4) => [$1, $2, $3, $4],
    (final $1, final $2, final $3) => [$1, $2, $3],
    (final $1, final $2) => [$1, $2],
    (final $1,) => [$1],
    () => [],
    _ => throw InvalidRecordListException(a),
  };
}

class InvalidRecordListException implements Exception {
  /// The record that was attempted to be converted to a list.
  final Record record;

  InvalidRecordListException(this.record);

  @override
  String toString() => 'InvalidRecordListException(Attempted to convert $record'
      ' to a list, but could not find a matching converter)';
}
