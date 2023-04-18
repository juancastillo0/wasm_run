// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExternalType {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FuncTy field0) func,
    required TResult Function(GlobalTy field0) global,
    required TResult Function(TableTy field0) table,
    required TResult Function(MemoryTy field0) memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FuncTy field0)? func,
    TResult? Function(GlobalTy field0)? global,
    TResult? Function(TableTy field0)? table,
    TResult? Function(MemoryTy field0)? memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FuncTy field0)? func,
    TResult Function(GlobalTy field0)? global,
    TResult Function(TableTy field0)? table,
    TResult Function(MemoryTy field0)? memory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalType_Func value) func,
    required TResult Function(ExternalType_Global value) global,
    required TResult Function(ExternalType_Table value) table,
    required TResult Function(ExternalType_Memory value) memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalType_Func value)? func,
    TResult? Function(ExternalType_Global value)? global,
    TResult? Function(ExternalType_Table value)? table,
    TResult? Function(ExternalType_Memory value)? memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalType_Func value)? func,
    TResult Function(ExternalType_Global value)? global,
    TResult Function(ExternalType_Table value)? table,
    TResult Function(ExternalType_Memory value)? memory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalTypeCopyWith<$Res> {
  factory $ExternalTypeCopyWith(
          ExternalType value, $Res Function(ExternalType) then) =
      _$ExternalTypeCopyWithImpl<$Res, ExternalType>;
}

/// @nodoc
class _$ExternalTypeCopyWithImpl<$Res, $Val extends ExternalType>
    implements $ExternalTypeCopyWith<$Res> {
  _$ExternalTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExternalType_FuncCopyWith<$Res> {
  factory _$$ExternalType_FuncCopyWith(
          _$ExternalType_Func value, $Res Function(_$ExternalType_Func) then) =
      __$$ExternalType_FuncCopyWithImpl<$Res>;
  @useResult
  $Res call({FuncTy field0});
}

/// @nodoc
class __$$ExternalType_FuncCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_Func>
    implements _$$ExternalType_FuncCopyWith<$Res> {
  __$$ExternalType_FuncCopyWithImpl(
      _$ExternalType_Func _value, $Res Function(_$ExternalType_Func) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_Func(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FuncTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_Func implements ExternalType_Func {
  const _$ExternalType_Func(this.field0);

  @override
  final FuncTy field0;

  @override
  String toString() {
    return 'ExternalType.func(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_Func &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_FuncCopyWith<_$ExternalType_Func> get copyWith =>
      __$$ExternalType_FuncCopyWithImpl<_$ExternalType_Func>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FuncTy field0) func,
    required TResult Function(GlobalTy field0) global,
    required TResult Function(TableTy field0) table,
    required TResult Function(MemoryTy field0) memory,
  }) {
    return func(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FuncTy field0)? func,
    TResult? Function(GlobalTy field0)? global,
    TResult? Function(TableTy field0)? table,
    TResult? Function(MemoryTy field0)? memory,
  }) {
    return func?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FuncTy field0)? func,
    TResult Function(GlobalTy field0)? global,
    TResult Function(TableTy field0)? table,
    TResult Function(MemoryTy field0)? memory,
    required TResult orElse(),
  }) {
    if (func != null) {
      return func(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalType_Func value) func,
    required TResult Function(ExternalType_Global value) global,
    required TResult Function(ExternalType_Table value) table,
    required TResult Function(ExternalType_Memory value) memory,
  }) {
    return func(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalType_Func value)? func,
    TResult? Function(ExternalType_Global value)? global,
    TResult? Function(ExternalType_Table value)? table,
    TResult? Function(ExternalType_Memory value)? memory,
  }) {
    return func?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalType_Func value)? func,
    TResult Function(ExternalType_Global value)? global,
    TResult Function(ExternalType_Table value)? table,
    TResult Function(ExternalType_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (func != null) {
      return func(this);
    }
    return orElse();
  }
}

abstract class ExternalType_Func implements ExternalType {
  const factory ExternalType_Func(final FuncTy field0) = _$ExternalType_Func;

  @override
  FuncTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_FuncCopyWith<_$ExternalType_Func> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalType_GlobalCopyWith<$Res> {
  factory _$$ExternalType_GlobalCopyWith(_$ExternalType_Global value,
          $Res Function(_$ExternalType_Global) then) =
      __$$ExternalType_GlobalCopyWithImpl<$Res>;
  @useResult
  $Res call({GlobalTy field0});
}

/// @nodoc
class __$$ExternalType_GlobalCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_Global>
    implements _$$ExternalType_GlobalCopyWith<$Res> {
  __$$ExternalType_GlobalCopyWithImpl(
      _$ExternalType_Global _value, $Res Function(_$ExternalType_Global) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_Global(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as GlobalTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_Global implements ExternalType_Global {
  const _$ExternalType_Global(this.field0);

  @override
  final GlobalTy field0;

  @override
  String toString() {
    return 'ExternalType.global(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_Global &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_GlobalCopyWith<_$ExternalType_Global> get copyWith =>
      __$$ExternalType_GlobalCopyWithImpl<_$ExternalType_Global>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FuncTy field0) func,
    required TResult Function(GlobalTy field0) global,
    required TResult Function(TableTy field0) table,
    required TResult Function(MemoryTy field0) memory,
  }) {
    return global(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FuncTy field0)? func,
    TResult? Function(GlobalTy field0)? global,
    TResult? Function(TableTy field0)? table,
    TResult? Function(MemoryTy field0)? memory,
  }) {
    return global?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FuncTy field0)? func,
    TResult Function(GlobalTy field0)? global,
    TResult Function(TableTy field0)? table,
    TResult Function(MemoryTy field0)? memory,
    required TResult orElse(),
  }) {
    if (global != null) {
      return global(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalType_Func value) func,
    required TResult Function(ExternalType_Global value) global,
    required TResult Function(ExternalType_Table value) table,
    required TResult Function(ExternalType_Memory value) memory,
  }) {
    return global(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalType_Func value)? func,
    TResult? Function(ExternalType_Global value)? global,
    TResult? Function(ExternalType_Table value)? table,
    TResult? Function(ExternalType_Memory value)? memory,
  }) {
    return global?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalType_Func value)? func,
    TResult Function(ExternalType_Global value)? global,
    TResult Function(ExternalType_Table value)? table,
    TResult Function(ExternalType_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (global != null) {
      return global(this);
    }
    return orElse();
  }
}

abstract class ExternalType_Global implements ExternalType {
  const factory ExternalType_Global(final GlobalTy field0) =
      _$ExternalType_Global;

  @override
  GlobalTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_GlobalCopyWith<_$ExternalType_Global> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalType_TableCopyWith<$Res> {
  factory _$$ExternalType_TableCopyWith(_$ExternalType_Table value,
          $Res Function(_$ExternalType_Table) then) =
      __$$ExternalType_TableCopyWithImpl<$Res>;
  @useResult
  $Res call({TableTy field0});
}

/// @nodoc
class __$$ExternalType_TableCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_Table>
    implements _$$ExternalType_TableCopyWith<$Res> {
  __$$ExternalType_TableCopyWithImpl(
      _$ExternalType_Table _value, $Res Function(_$ExternalType_Table) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_Table(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as TableTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_Table implements ExternalType_Table {
  const _$ExternalType_Table(this.field0);

  @override
  final TableTy field0;

  @override
  String toString() {
    return 'ExternalType.table(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_Table &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_TableCopyWith<_$ExternalType_Table> get copyWith =>
      __$$ExternalType_TableCopyWithImpl<_$ExternalType_Table>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FuncTy field0) func,
    required TResult Function(GlobalTy field0) global,
    required TResult Function(TableTy field0) table,
    required TResult Function(MemoryTy field0) memory,
  }) {
    return table(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FuncTy field0)? func,
    TResult? Function(GlobalTy field0)? global,
    TResult? Function(TableTy field0)? table,
    TResult? Function(MemoryTy field0)? memory,
  }) {
    return table?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FuncTy field0)? func,
    TResult Function(GlobalTy field0)? global,
    TResult Function(TableTy field0)? table,
    TResult Function(MemoryTy field0)? memory,
    required TResult orElse(),
  }) {
    if (table != null) {
      return table(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalType_Func value) func,
    required TResult Function(ExternalType_Global value) global,
    required TResult Function(ExternalType_Table value) table,
    required TResult Function(ExternalType_Memory value) memory,
  }) {
    return table(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalType_Func value)? func,
    TResult? Function(ExternalType_Global value)? global,
    TResult? Function(ExternalType_Table value)? table,
    TResult? Function(ExternalType_Memory value)? memory,
  }) {
    return table?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalType_Func value)? func,
    TResult Function(ExternalType_Global value)? global,
    TResult Function(ExternalType_Table value)? table,
    TResult Function(ExternalType_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (table != null) {
      return table(this);
    }
    return orElse();
  }
}

abstract class ExternalType_Table implements ExternalType {
  const factory ExternalType_Table(final TableTy field0) = _$ExternalType_Table;

  @override
  TableTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_TableCopyWith<_$ExternalType_Table> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalType_MemoryCopyWith<$Res> {
  factory _$$ExternalType_MemoryCopyWith(_$ExternalType_Memory value,
          $Res Function(_$ExternalType_Memory) then) =
      __$$ExternalType_MemoryCopyWithImpl<$Res>;
  @useResult
  $Res call({MemoryTy field0});
}

/// @nodoc
class __$$ExternalType_MemoryCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_Memory>
    implements _$$ExternalType_MemoryCopyWith<$Res> {
  __$$ExternalType_MemoryCopyWithImpl(
      _$ExternalType_Memory _value, $Res Function(_$ExternalType_Memory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_Memory(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as MemoryTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_Memory implements ExternalType_Memory {
  const _$ExternalType_Memory(this.field0);

  @override
  final MemoryTy field0;

  @override
  String toString() {
    return 'ExternalType.memory(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_Memory &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_MemoryCopyWith<_$ExternalType_Memory> get copyWith =>
      __$$ExternalType_MemoryCopyWithImpl<_$ExternalType_Memory>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FuncTy field0) func,
    required TResult Function(GlobalTy field0) global,
    required TResult Function(TableTy field0) table,
    required TResult Function(MemoryTy field0) memory,
  }) {
    return memory(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FuncTy field0)? func,
    TResult? Function(GlobalTy field0)? global,
    TResult? Function(TableTy field0)? table,
    TResult? Function(MemoryTy field0)? memory,
  }) {
    return memory?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FuncTy field0)? func,
    TResult Function(GlobalTy field0)? global,
    TResult Function(TableTy field0)? table,
    TResult Function(MemoryTy field0)? memory,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalType_Func value) func,
    required TResult Function(ExternalType_Global value) global,
    required TResult Function(ExternalType_Table value) table,
    required TResult Function(ExternalType_Memory value) memory,
  }) {
    return memory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalType_Func value)? func,
    TResult? Function(ExternalType_Global value)? global,
    TResult? Function(ExternalType_Table value)? table,
    TResult? Function(ExternalType_Memory value)? memory,
  }) {
    return memory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalType_Func value)? func,
    TResult Function(ExternalType_Global value)? global,
    TResult Function(ExternalType_Table value)? table,
    TResult Function(ExternalType_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory(this);
    }
    return orElse();
  }
}

abstract class ExternalType_Memory implements ExternalType {
  const factory ExternalType_Memory(final MemoryTy field0) =
      _$ExternalType_Memory;

  @override
  MemoryTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_MemoryCopyWith<_$ExternalType_Memory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExternalValue {
  FrbOpaque get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Func field0) func,
    required TResult Function(Global field0) global,
    required TResult Function(Table field0) table,
    required TResult Function(Memory field0) memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Func field0)? func,
    TResult? Function(Global field0)? global,
    TResult? Function(Table field0)? table,
    TResult? Function(Memory field0)? memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Func field0)? func,
    TResult Function(Global field0)? global,
    TResult Function(Table field0)? table,
    TResult Function(Memory field0)? memory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalValue_Func value) func,
    required TResult Function(ExternalValue_Global value) global,
    required TResult Function(ExternalValue_Table value) table,
    required TResult Function(ExternalValue_Memory value) memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExternalValueCopyWith<$Res> {
  factory $ExternalValueCopyWith(
          ExternalValue value, $Res Function(ExternalValue) then) =
      _$ExternalValueCopyWithImpl<$Res, ExternalValue>;
}

/// @nodoc
class _$ExternalValueCopyWithImpl<$Res, $Val extends ExternalValue>
    implements $ExternalValueCopyWith<$Res> {
  _$ExternalValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExternalValue_FuncCopyWith<$Res> {
  factory _$$ExternalValue_FuncCopyWith(_$ExternalValue_Func value,
          $Res Function(_$ExternalValue_Func) then) =
      __$$ExternalValue_FuncCopyWithImpl<$Res>;
  @useResult
  $Res call({Func field0});
}

/// @nodoc
class __$$ExternalValue_FuncCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_Func>
    implements _$$ExternalValue_FuncCopyWith<$Res> {
  __$$ExternalValue_FuncCopyWithImpl(
      _$ExternalValue_Func _value, $Res Function(_$ExternalValue_Func) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_Func(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Func,
    ));
  }
}

/// @nodoc

class _$ExternalValue_Func implements ExternalValue_Func {
  const _$ExternalValue_Func(this.field0);

  @override
  final Func field0;

  @override
  String toString() {
    return 'ExternalValue.func(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_Func &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_FuncCopyWith<_$ExternalValue_Func> get copyWith =>
      __$$ExternalValue_FuncCopyWithImpl<_$ExternalValue_Func>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Func field0) func,
    required TResult Function(Global field0) global,
    required TResult Function(Table field0) table,
    required TResult Function(Memory field0) memory,
  }) {
    return func(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Func field0)? func,
    TResult? Function(Global field0)? global,
    TResult? Function(Table field0)? table,
    TResult? Function(Memory field0)? memory,
  }) {
    return func?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Func field0)? func,
    TResult Function(Global field0)? global,
    TResult Function(Table field0)? table,
    TResult Function(Memory field0)? memory,
    required TResult orElse(),
  }) {
    if (func != null) {
      return func(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalValue_Func value) func,
    required TResult Function(ExternalValue_Global value) global,
    required TResult Function(ExternalValue_Table value) table,
    required TResult Function(ExternalValue_Memory value) memory,
  }) {
    return func(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
  }) {
    return func?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (func != null) {
      return func(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Func implements ExternalValue {
  const factory ExternalValue_Func(final Func field0) = _$ExternalValue_Func;

  @override
  Func get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_FuncCopyWith<_$ExternalValue_Func> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_GlobalCopyWith<$Res> {
  factory _$$ExternalValue_GlobalCopyWith(_$ExternalValue_Global value,
          $Res Function(_$ExternalValue_Global) then) =
      __$$ExternalValue_GlobalCopyWithImpl<$Res>;
  @useResult
  $Res call({Global field0});
}

/// @nodoc
class __$$ExternalValue_GlobalCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_Global>
    implements _$$ExternalValue_GlobalCopyWith<$Res> {
  __$$ExternalValue_GlobalCopyWithImpl(_$ExternalValue_Global _value,
      $Res Function(_$ExternalValue_Global) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_Global(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Global,
    ));
  }
}

/// @nodoc

class _$ExternalValue_Global implements ExternalValue_Global {
  const _$ExternalValue_Global(this.field0);

  @override
  final Global field0;

  @override
  String toString() {
    return 'ExternalValue.global(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_Global &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_GlobalCopyWith<_$ExternalValue_Global> get copyWith =>
      __$$ExternalValue_GlobalCopyWithImpl<_$ExternalValue_Global>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Func field0) func,
    required TResult Function(Global field0) global,
    required TResult Function(Table field0) table,
    required TResult Function(Memory field0) memory,
  }) {
    return global(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Func field0)? func,
    TResult? Function(Global field0)? global,
    TResult? Function(Table field0)? table,
    TResult? Function(Memory field0)? memory,
  }) {
    return global?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Func field0)? func,
    TResult Function(Global field0)? global,
    TResult Function(Table field0)? table,
    TResult Function(Memory field0)? memory,
    required TResult orElse(),
  }) {
    if (global != null) {
      return global(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalValue_Func value) func,
    required TResult Function(ExternalValue_Global value) global,
    required TResult Function(ExternalValue_Table value) table,
    required TResult Function(ExternalValue_Memory value) memory,
  }) {
    return global(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
  }) {
    return global?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (global != null) {
      return global(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Global implements ExternalValue {
  const factory ExternalValue_Global(final Global field0) =
      _$ExternalValue_Global;

  @override
  Global get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_GlobalCopyWith<_$ExternalValue_Global> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_TableCopyWith<$Res> {
  factory _$$ExternalValue_TableCopyWith(_$ExternalValue_Table value,
          $Res Function(_$ExternalValue_Table) then) =
      __$$ExternalValue_TableCopyWithImpl<$Res>;
  @useResult
  $Res call({Table field0});
}

/// @nodoc
class __$$ExternalValue_TableCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_Table>
    implements _$$ExternalValue_TableCopyWith<$Res> {
  __$$ExternalValue_TableCopyWithImpl(
      _$ExternalValue_Table _value, $Res Function(_$ExternalValue_Table) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_Table(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Table,
    ));
  }
}

/// @nodoc

class _$ExternalValue_Table implements ExternalValue_Table {
  const _$ExternalValue_Table(this.field0);

  @override
  final Table field0;

  @override
  String toString() {
    return 'ExternalValue.table(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_Table &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_TableCopyWith<_$ExternalValue_Table> get copyWith =>
      __$$ExternalValue_TableCopyWithImpl<_$ExternalValue_Table>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Func field0) func,
    required TResult Function(Global field0) global,
    required TResult Function(Table field0) table,
    required TResult Function(Memory field0) memory,
  }) {
    return table(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Func field0)? func,
    TResult? Function(Global field0)? global,
    TResult? Function(Table field0)? table,
    TResult? Function(Memory field0)? memory,
  }) {
    return table?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Func field0)? func,
    TResult Function(Global field0)? global,
    TResult Function(Table field0)? table,
    TResult Function(Memory field0)? memory,
    required TResult orElse(),
  }) {
    if (table != null) {
      return table(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalValue_Func value) func,
    required TResult Function(ExternalValue_Global value) global,
    required TResult Function(ExternalValue_Table value) table,
    required TResult Function(ExternalValue_Memory value) memory,
  }) {
    return table(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
  }) {
    return table?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (table != null) {
      return table(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Table implements ExternalValue {
  const factory ExternalValue_Table(final Table field0) = _$ExternalValue_Table;

  @override
  Table get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_TableCopyWith<_$ExternalValue_Table> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_MemoryCopyWith<$Res> {
  factory _$$ExternalValue_MemoryCopyWith(_$ExternalValue_Memory value,
          $Res Function(_$ExternalValue_Memory) then) =
      __$$ExternalValue_MemoryCopyWithImpl<$Res>;
  @useResult
  $Res call({Memory field0});
}

/// @nodoc
class __$$ExternalValue_MemoryCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_Memory>
    implements _$$ExternalValue_MemoryCopyWith<$Res> {
  __$$ExternalValue_MemoryCopyWithImpl(_$ExternalValue_Memory _value,
      $Res Function(_$ExternalValue_Memory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_Memory(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Memory,
    ));
  }
}

/// @nodoc

class _$ExternalValue_Memory implements ExternalValue_Memory {
  const _$ExternalValue_Memory(this.field0);

  @override
  final Memory field0;

  @override
  String toString() {
    return 'ExternalValue.memory(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_Memory &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_MemoryCopyWith<_$ExternalValue_Memory> get copyWith =>
      __$$ExternalValue_MemoryCopyWithImpl<_$ExternalValue_Memory>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Func field0) func,
    required TResult Function(Global field0) global,
    required TResult Function(Table field0) table,
    required TResult Function(Memory field0) memory,
  }) {
    return memory(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Func field0)? func,
    TResult? Function(Global field0)? global,
    TResult? Function(Table field0)? table,
    TResult? Function(Memory field0)? memory,
  }) {
    return memory?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Func field0)? func,
    TResult Function(Global field0)? global,
    TResult Function(Table field0)? table,
    TResult Function(Memory field0)? memory,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalValue_Func value) func,
    required TResult Function(ExternalValue_Global value) global,
    required TResult Function(ExternalValue_Table value) table,
    required TResult Function(ExternalValue_Memory value) memory,
  }) {
    return memory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
  }) {
    return memory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Memory implements ExternalValue {
  const factory ExternalValue_Memory(final Memory field0) =
      _$ExternalValue_Memory;

  @override
  Memory get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_MemoryCopyWith<_$ExternalValue_Memory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WasmVal {
  Object? get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WasmValCopyWith<$Res> {
  factory $WasmValCopyWith(WasmVal value, $Res Function(WasmVal) then) =
      _$WasmValCopyWithImpl<$Res, WasmVal>;
}

/// @nodoc
class _$WasmValCopyWithImpl<$Res, $Val extends WasmVal>
    implements $WasmValCopyWith<$Res> {
  _$WasmValCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$WasmVal_i32CopyWith<$Res> {
  factory _$$WasmVal_i32CopyWith(
          _$WasmVal_i32 value, $Res Function(_$WasmVal_i32) then) =
      __$$WasmVal_i32CopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$WasmVal_i32CopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_i32>
    implements _$$WasmVal_i32CopyWith<$Res> {
  __$$WasmVal_i32CopyWithImpl(
      _$WasmVal_i32 _value, $Res Function(_$WasmVal_i32) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_i32(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WasmVal_i32 implements WasmVal_i32 {
  const _$WasmVal_i32(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'WasmVal.i32(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_i32 &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_i32CopyWith<_$WasmVal_i32> get copyWith =>
      __$$WasmVal_i32CopyWithImpl<_$WasmVal_i32>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) {
    return i32(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) {
    return i32?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) {
    if (i32 != null) {
      return i32(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) {
    return i32(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) {
    return i32?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) {
    if (i32 != null) {
      return i32(this);
    }
    return orElse();
  }
}

abstract class WasmVal_i32 implements WasmVal {
  const factory WasmVal_i32(final int field0) = _$WasmVal_i32;

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_i32CopyWith<_$WasmVal_i32> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_i64CopyWith<$Res> {
  factory _$$WasmVal_i64CopyWith(
          _$WasmVal_i64 value, $Res Function(_$WasmVal_i64) then) =
      __$$WasmVal_i64CopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$WasmVal_i64CopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_i64>
    implements _$$WasmVal_i64CopyWith<$Res> {
  __$$WasmVal_i64CopyWithImpl(
      _$WasmVal_i64 _value, $Res Function(_$WasmVal_i64) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_i64(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WasmVal_i64 implements WasmVal_i64 {
  const _$WasmVal_i64(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'WasmVal.i64(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_i64 &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_i64CopyWith<_$WasmVal_i64> get copyWith =>
      __$$WasmVal_i64CopyWithImpl<_$WasmVal_i64>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) {
    return i64(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) {
    return i64?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) {
    if (i64 != null) {
      return i64(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) {
    return i64(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) {
    return i64?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) {
    if (i64 != null) {
      return i64(this);
    }
    return orElse();
  }
}

abstract class WasmVal_i64 implements WasmVal {
  const factory WasmVal_i64(final int field0) = _$WasmVal_i64;

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_i64CopyWith<_$WasmVal_i64> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_f32CopyWith<$Res> {
  factory _$$WasmVal_f32CopyWith(
          _$WasmVal_f32 value, $Res Function(_$WasmVal_f32) then) =
      __$$WasmVal_f32CopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$WasmVal_f32CopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_f32>
    implements _$$WasmVal_f32CopyWith<$Res> {
  __$$WasmVal_f32CopyWithImpl(
      _$WasmVal_f32 _value, $Res Function(_$WasmVal_f32) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_f32(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WasmVal_f32 implements WasmVal_f32 {
  const _$WasmVal_f32(this.field0);

  @override
  final double field0;

  @override
  String toString() {
    return 'WasmVal.f32(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_f32 &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_f32CopyWith<_$WasmVal_f32> get copyWith =>
      __$$WasmVal_f32CopyWithImpl<_$WasmVal_f32>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) {
    return f32(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) {
    return f32?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) {
    if (f32 != null) {
      return f32(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) {
    return f32(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) {
    return f32?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) {
    if (f32 != null) {
      return f32(this);
    }
    return orElse();
  }
}

abstract class WasmVal_f32 implements WasmVal {
  const factory WasmVal_f32(final double field0) = _$WasmVal_f32;

  @override
  double get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_f32CopyWith<_$WasmVal_f32> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_f64CopyWith<$Res> {
  factory _$$WasmVal_f64CopyWith(
          _$WasmVal_f64 value, $Res Function(_$WasmVal_f64) then) =
      __$$WasmVal_f64CopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$WasmVal_f64CopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_f64>
    implements _$$WasmVal_f64CopyWith<$Res> {
  __$$WasmVal_f64CopyWithImpl(
      _$WasmVal_f64 _value, $Res Function(_$WasmVal_f64) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_f64(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WasmVal_f64 implements WasmVal_f64 {
  const _$WasmVal_f64(this.field0);

  @override
  final double field0;

  @override
  String toString() {
    return 'WasmVal.f64(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_f64 &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_f64CopyWith<_$WasmVal_f64> get copyWith =>
      __$$WasmVal_f64CopyWithImpl<_$WasmVal_f64>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) {
    return f64(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) {
    return f64?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) {
    if (f64 != null) {
      return f64(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) {
    return f64(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) {
    return f64?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) {
    if (f64 != null) {
      return f64(this);
    }
    return orElse();
  }
}

abstract class WasmVal_f64 implements WasmVal {
  const factory WasmVal_f64(final double field0) = _$WasmVal_f64;

  @override
  double get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_f64CopyWith<_$WasmVal_f64> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_funcRefCopyWith<$Res> {
  factory _$$WasmVal_funcRefCopyWith(
          _$WasmVal_funcRef value, $Res Function(_$WasmVal_funcRef) then) =
      __$$WasmVal_funcRefCopyWithImpl<$Res>;
  @useResult
  $Res call({Func? field0});
}

/// @nodoc
class __$$WasmVal_funcRefCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_funcRef>
    implements _$$WasmVal_funcRefCopyWith<$Res> {
  __$$WasmVal_funcRefCopyWithImpl(
      _$WasmVal_funcRef _value, $Res Function(_$WasmVal_funcRef) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$WasmVal_funcRef(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Func?,
    ));
  }
}

/// @nodoc

class _$WasmVal_funcRef implements WasmVal_funcRef {
  const _$WasmVal_funcRef([this.field0]);

  @override
  final Func? field0;

  @override
  String toString() {
    return 'WasmVal.funcRef(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_funcRef &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_funcRefCopyWith<_$WasmVal_funcRef> get copyWith =>
      __$$WasmVal_funcRefCopyWithImpl<_$WasmVal_funcRef>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) {
    return funcRef(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) {
    return funcRef?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) {
    if (funcRef != null) {
      return funcRef(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) {
    return funcRef(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) {
    return funcRef?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) {
    if (funcRef != null) {
      return funcRef(this);
    }
    return orElse();
  }
}

abstract class WasmVal_funcRef implements WasmVal {
  const factory WasmVal_funcRef([final Func? field0]) = _$WasmVal_funcRef;

  @override
  Func? get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_funcRefCopyWith<_$WasmVal_funcRef> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_externRefCopyWith<$Res> {
  factory _$$WasmVal_externRefCopyWith(
          _$WasmVal_externRef value, $Res Function(_$WasmVal_externRef) then) =
      __$$WasmVal_externRefCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$WasmVal_externRefCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_externRef>
    implements _$$WasmVal_externRefCopyWith<$Res> {
  __$$WasmVal_externRefCopyWithImpl(
      _$WasmVal_externRef _value, $Res Function(_$WasmVal_externRef) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_externRef(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WasmVal_externRef implements WasmVal_externRef {
  const _$WasmVal_externRef(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'WasmVal.externRef(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_externRef &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_externRefCopyWith<_$WasmVal_externRef> get copyWith =>
      __$$WasmVal_externRefCopyWithImpl<_$WasmVal_externRef>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(Func? field0) funcRef,
    required TResult Function(int field0) externRef,
  }) {
    return externRef(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(Func? field0)? funcRef,
    TResult? Function(int field0)? externRef,
  }) {
    return externRef?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(Func? field0)? funcRef,
    TResult Function(int field0)? externRef,
    required TResult orElse(),
  }) {
    if (externRef != null) {
      return externRef(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
  }) {
    return externRef(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
  }) {
    return externRef?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    required TResult orElse(),
  }) {
    if (externRef != null) {
      return externRef(this);
    }
    return orElse();
  }
}

abstract class WasmVal_externRef implements WasmVal {
  const factory WasmVal_externRef(final int field0) = _$WasmVal_externRef;

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_externRefCopyWith<_$WasmVal_externRef> get copyWith =>
      throw _privateConstructorUsedError;
}
