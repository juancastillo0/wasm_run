// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$ExternalType_FuncImplCopyWith<$Res> {
  factory _$$ExternalType_FuncImplCopyWith(_$ExternalType_FuncImpl value,
          $Res Function(_$ExternalType_FuncImpl) then) =
      __$$ExternalType_FuncImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FuncTy field0});
}

/// @nodoc
class __$$ExternalType_FuncImplCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_FuncImpl>
    implements _$$ExternalType_FuncImplCopyWith<$Res> {
  __$$ExternalType_FuncImplCopyWithImpl(_$ExternalType_FuncImpl _value,
      $Res Function(_$ExternalType_FuncImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_FuncImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FuncTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_FuncImpl extends ExternalType_Func {
  const _$ExternalType_FuncImpl(this.field0) : super._();

  @override
  final FuncTy field0;

  @override
  String toString() {
    return 'ExternalType.func(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_FuncImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_FuncImplCopyWith<_$ExternalType_FuncImpl> get copyWith =>
      __$$ExternalType_FuncImplCopyWithImpl<_$ExternalType_FuncImpl>(
          this, _$identity);

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

abstract class ExternalType_Func extends ExternalType {
  const factory ExternalType_Func(final FuncTy field0) =
      _$ExternalType_FuncImpl;
  const ExternalType_Func._() : super._();

  @override
  FuncTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_FuncImplCopyWith<_$ExternalType_FuncImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalType_GlobalImplCopyWith<$Res> {
  factory _$$ExternalType_GlobalImplCopyWith(_$ExternalType_GlobalImpl value,
          $Res Function(_$ExternalType_GlobalImpl) then) =
      __$$ExternalType_GlobalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GlobalTy field0});
}

/// @nodoc
class __$$ExternalType_GlobalImplCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_GlobalImpl>
    implements _$$ExternalType_GlobalImplCopyWith<$Res> {
  __$$ExternalType_GlobalImplCopyWithImpl(_$ExternalType_GlobalImpl _value,
      $Res Function(_$ExternalType_GlobalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_GlobalImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as GlobalTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_GlobalImpl extends ExternalType_Global {
  const _$ExternalType_GlobalImpl(this.field0) : super._();

  @override
  final GlobalTy field0;

  @override
  String toString() {
    return 'ExternalType.global(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_GlobalImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_GlobalImplCopyWith<_$ExternalType_GlobalImpl> get copyWith =>
      __$$ExternalType_GlobalImplCopyWithImpl<_$ExternalType_GlobalImpl>(
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

abstract class ExternalType_Global extends ExternalType {
  const factory ExternalType_Global(final GlobalTy field0) =
      _$ExternalType_GlobalImpl;
  const ExternalType_Global._() : super._();

  @override
  GlobalTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_GlobalImplCopyWith<_$ExternalType_GlobalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalType_TableImplCopyWith<$Res> {
  factory _$$ExternalType_TableImplCopyWith(_$ExternalType_TableImpl value,
          $Res Function(_$ExternalType_TableImpl) then) =
      __$$ExternalType_TableImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TableTy field0});
}

/// @nodoc
class __$$ExternalType_TableImplCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_TableImpl>
    implements _$$ExternalType_TableImplCopyWith<$Res> {
  __$$ExternalType_TableImplCopyWithImpl(_$ExternalType_TableImpl _value,
      $Res Function(_$ExternalType_TableImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_TableImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as TableTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_TableImpl extends ExternalType_Table {
  const _$ExternalType_TableImpl(this.field0) : super._();

  @override
  final TableTy field0;

  @override
  String toString() {
    return 'ExternalType.table(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_TableImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_TableImplCopyWith<_$ExternalType_TableImpl> get copyWith =>
      __$$ExternalType_TableImplCopyWithImpl<_$ExternalType_TableImpl>(
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

abstract class ExternalType_Table extends ExternalType {
  const factory ExternalType_Table(final TableTy field0) =
      _$ExternalType_TableImpl;
  const ExternalType_Table._() : super._();

  @override
  TableTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_TableImplCopyWith<_$ExternalType_TableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalType_MemoryImplCopyWith<$Res> {
  factory _$$ExternalType_MemoryImplCopyWith(_$ExternalType_MemoryImpl value,
          $Res Function(_$ExternalType_MemoryImpl) then) =
      __$$ExternalType_MemoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MemoryTy field0});
}

/// @nodoc
class __$$ExternalType_MemoryImplCopyWithImpl<$Res>
    extends _$ExternalTypeCopyWithImpl<$Res, _$ExternalType_MemoryImpl>
    implements _$$ExternalType_MemoryImplCopyWith<$Res> {
  __$$ExternalType_MemoryImplCopyWithImpl(_$ExternalType_MemoryImpl _value,
      $Res Function(_$ExternalType_MemoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalType_MemoryImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as MemoryTy,
    ));
  }
}

/// @nodoc

class _$ExternalType_MemoryImpl extends ExternalType_Memory {
  const _$ExternalType_MemoryImpl(this.field0) : super._();

  @override
  final MemoryTy field0;

  @override
  String toString() {
    return 'ExternalType.memory(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalType_MemoryImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalType_MemoryImplCopyWith<_$ExternalType_MemoryImpl> get copyWith =>
      __$$ExternalType_MemoryImplCopyWithImpl<_$ExternalType_MemoryImpl>(
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

abstract class ExternalType_Memory extends ExternalType {
  const factory ExternalType_Memory(final MemoryTy field0) =
      _$ExternalType_MemoryImpl;
  const ExternalType_Memory._() : super._();

  @override
  MemoryTy get field0;
  @JsonKey(ignore: true)
  _$$ExternalType_MemoryImplCopyWith<_$ExternalType_MemoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ExternalValue {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WFunc field0) func,
    required TResult Function(WGlobal field0) global,
    required TResult Function(WTable field0) table,
    required TResult Function(WMemory field0) memory,
    required TResult Function(WasmRunSharedMemory field0) sharedMemory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WFunc field0)? func,
    TResult? Function(WGlobal field0)? global,
    TResult? Function(WTable field0)? table,
    TResult? Function(WMemory field0)? memory,
    TResult? Function(WasmRunSharedMemory field0)? sharedMemory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WFunc field0)? func,
    TResult Function(WGlobal field0)? global,
    TResult Function(WTable field0)? table,
    TResult Function(WMemory field0)? memory,
    TResult Function(WasmRunSharedMemory field0)? sharedMemory,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ExternalValue_Func value) func,
    required TResult Function(ExternalValue_Global value) global,
    required TResult Function(ExternalValue_Table value) table,
    required TResult Function(ExternalValue_Memory value) memory,
    required TResult Function(ExternalValue_SharedMemory value) sharedMemory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
    TResult? Function(ExternalValue_SharedMemory value)? sharedMemory,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    TResult Function(ExternalValue_SharedMemory value)? sharedMemory,
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
abstract class _$$ExternalValue_FuncImplCopyWith<$Res> {
  factory _$$ExternalValue_FuncImplCopyWith(_$ExternalValue_FuncImpl value,
          $Res Function(_$ExternalValue_FuncImpl) then) =
      __$$ExternalValue_FuncImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WFunc field0});
}

/// @nodoc
class __$$ExternalValue_FuncImplCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_FuncImpl>
    implements _$$ExternalValue_FuncImplCopyWith<$Res> {
  __$$ExternalValue_FuncImplCopyWithImpl(_$ExternalValue_FuncImpl _value,
      $Res Function(_$ExternalValue_FuncImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_FuncImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WFunc,
    ));
  }
}

/// @nodoc

class _$ExternalValue_FuncImpl extends ExternalValue_Func {
  const _$ExternalValue_FuncImpl(this.field0) : super._();

  @override
  final WFunc field0;

  @override
  String toString() {
    return 'ExternalValue.func(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_FuncImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_FuncImplCopyWith<_$ExternalValue_FuncImpl> get copyWith =>
      __$$ExternalValue_FuncImplCopyWithImpl<_$ExternalValue_FuncImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WFunc field0) func,
    required TResult Function(WGlobal field0) global,
    required TResult Function(WTable field0) table,
    required TResult Function(WMemory field0) memory,
    required TResult Function(WasmRunSharedMemory field0) sharedMemory,
  }) {
    return func(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WFunc field0)? func,
    TResult? Function(WGlobal field0)? global,
    TResult? Function(WTable field0)? table,
    TResult? Function(WMemory field0)? memory,
    TResult? Function(WasmRunSharedMemory field0)? sharedMemory,
  }) {
    return func?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WFunc field0)? func,
    TResult Function(WGlobal field0)? global,
    TResult Function(WTable field0)? table,
    TResult Function(WMemory field0)? memory,
    TResult Function(WasmRunSharedMemory field0)? sharedMemory,
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
    required TResult Function(ExternalValue_SharedMemory value) sharedMemory,
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
    TResult? Function(ExternalValue_SharedMemory value)? sharedMemory,
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
    TResult Function(ExternalValue_SharedMemory value)? sharedMemory,
    required TResult orElse(),
  }) {
    if (func != null) {
      return func(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Func extends ExternalValue {
  const factory ExternalValue_Func(final WFunc field0) =
      _$ExternalValue_FuncImpl;
  const ExternalValue_Func._() : super._();

  @override
  WFunc get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_FuncImplCopyWith<_$ExternalValue_FuncImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_GlobalImplCopyWith<$Res> {
  factory _$$ExternalValue_GlobalImplCopyWith(_$ExternalValue_GlobalImpl value,
          $Res Function(_$ExternalValue_GlobalImpl) then) =
      __$$ExternalValue_GlobalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WGlobal field0});
}

/// @nodoc
class __$$ExternalValue_GlobalImplCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_GlobalImpl>
    implements _$$ExternalValue_GlobalImplCopyWith<$Res> {
  __$$ExternalValue_GlobalImplCopyWithImpl(_$ExternalValue_GlobalImpl _value,
      $Res Function(_$ExternalValue_GlobalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_GlobalImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WGlobal,
    ));
  }
}

/// @nodoc

class _$ExternalValue_GlobalImpl extends ExternalValue_Global {
  const _$ExternalValue_GlobalImpl(this.field0) : super._();

  @override
  final WGlobal field0;

  @override
  String toString() {
    return 'ExternalValue.global(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_GlobalImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_GlobalImplCopyWith<_$ExternalValue_GlobalImpl>
      get copyWith =>
          __$$ExternalValue_GlobalImplCopyWithImpl<_$ExternalValue_GlobalImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WFunc field0) func,
    required TResult Function(WGlobal field0) global,
    required TResult Function(WTable field0) table,
    required TResult Function(WMemory field0) memory,
    required TResult Function(WasmRunSharedMemory field0) sharedMemory,
  }) {
    return global(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WFunc field0)? func,
    TResult? Function(WGlobal field0)? global,
    TResult? Function(WTable field0)? table,
    TResult? Function(WMemory field0)? memory,
    TResult? Function(WasmRunSharedMemory field0)? sharedMemory,
  }) {
    return global?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WFunc field0)? func,
    TResult Function(WGlobal field0)? global,
    TResult Function(WTable field0)? table,
    TResult Function(WMemory field0)? memory,
    TResult Function(WasmRunSharedMemory field0)? sharedMemory,
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
    required TResult Function(ExternalValue_SharedMemory value) sharedMemory,
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
    TResult? Function(ExternalValue_SharedMemory value)? sharedMemory,
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
    TResult Function(ExternalValue_SharedMemory value)? sharedMemory,
    required TResult orElse(),
  }) {
    if (global != null) {
      return global(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Global extends ExternalValue {
  const factory ExternalValue_Global(final WGlobal field0) =
      _$ExternalValue_GlobalImpl;
  const ExternalValue_Global._() : super._();

  @override
  WGlobal get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_GlobalImplCopyWith<_$ExternalValue_GlobalImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_TableImplCopyWith<$Res> {
  factory _$$ExternalValue_TableImplCopyWith(_$ExternalValue_TableImpl value,
          $Res Function(_$ExternalValue_TableImpl) then) =
      __$$ExternalValue_TableImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WTable field0});
}

/// @nodoc
class __$$ExternalValue_TableImplCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_TableImpl>
    implements _$$ExternalValue_TableImplCopyWith<$Res> {
  __$$ExternalValue_TableImplCopyWithImpl(_$ExternalValue_TableImpl _value,
      $Res Function(_$ExternalValue_TableImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_TableImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WTable,
    ));
  }
}

/// @nodoc

class _$ExternalValue_TableImpl extends ExternalValue_Table {
  const _$ExternalValue_TableImpl(this.field0) : super._();

  @override
  final WTable field0;

  @override
  String toString() {
    return 'ExternalValue.table(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_TableImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_TableImplCopyWith<_$ExternalValue_TableImpl> get copyWith =>
      __$$ExternalValue_TableImplCopyWithImpl<_$ExternalValue_TableImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WFunc field0) func,
    required TResult Function(WGlobal field0) global,
    required TResult Function(WTable field0) table,
    required TResult Function(WMemory field0) memory,
    required TResult Function(WasmRunSharedMemory field0) sharedMemory,
  }) {
    return table(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WFunc field0)? func,
    TResult? Function(WGlobal field0)? global,
    TResult? Function(WTable field0)? table,
    TResult? Function(WMemory field0)? memory,
    TResult? Function(WasmRunSharedMemory field0)? sharedMemory,
  }) {
    return table?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WFunc field0)? func,
    TResult Function(WGlobal field0)? global,
    TResult Function(WTable field0)? table,
    TResult Function(WMemory field0)? memory,
    TResult Function(WasmRunSharedMemory field0)? sharedMemory,
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
    required TResult Function(ExternalValue_SharedMemory value) sharedMemory,
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
    TResult? Function(ExternalValue_SharedMemory value)? sharedMemory,
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
    TResult Function(ExternalValue_SharedMemory value)? sharedMemory,
    required TResult orElse(),
  }) {
    if (table != null) {
      return table(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Table extends ExternalValue {
  const factory ExternalValue_Table(final WTable field0) =
      _$ExternalValue_TableImpl;
  const ExternalValue_Table._() : super._();

  @override
  WTable get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_TableImplCopyWith<_$ExternalValue_TableImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_MemoryImplCopyWith<$Res> {
  factory _$$ExternalValue_MemoryImplCopyWith(_$ExternalValue_MemoryImpl value,
          $Res Function(_$ExternalValue_MemoryImpl) then) =
      __$$ExternalValue_MemoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WMemory field0});
}

/// @nodoc
class __$$ExternalValue_MemoryImplCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_MemoryImpl>
    implements _$$ExternalValue_MemoryImplCopyWith<$Res> {
  __$$ExternalValue_MemoryImplCopyWithImpl(_$ExternalValue_MemoryImpl _value,
      $Res Function(_$ExternalValue_MemoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_MemoryImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WMemory,
    ));
  }
}

/// @nodoc

class _$ExternalValue_MemoryImpl extends ExternalValue_Memory {
  const _$ExternalValue_MemoryImpl(this.field0) : super._();

  @override
  final WMemory field0;

  @override
  String toString() {
    return 'ExternalValue.memory(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_MemoryImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_MemoryImplCopyWith<_$ExternalValue_MemoryImpl>
      get copyWith =>
          __$$ExternalValue_MemoryImplCopyWithImpl<_$ExternalValue_MemoryImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WFunc field0) func,
    required TResult Function(WGlobal field0) global,
    required TResult Function(WTable field0) table,
    required TResult Function(WMemory field0) memory,
    required TResult Function(WasmRunSharedMemory field0) sharedMemory,
  }) {
    return memory(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WFunc field0)? func,
    TResult? Function(WGlobal field0)? global,
    TResult? Function(WTable field0)? table,
    TResult? Function(WMemory field0)? memory,
    TResult? Function(WasmRunSharedMemory field0)? sharedMemory,
  }) {
    return memory?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WFunc field0)? func,
    TResult Function(WGlobal field0)? global,
    TResult Function(WTable field0)? table,
    TResult Function(WMemory field0)? memory,
    TResult Function(WasmRunSharedMemory field0)? sharedMemory,
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
    required TResult Function(ExternalValue_SharedMemory value) sharedMemory,
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
    TResult? Function(ExternalValue_SharedMemory value)? sharedMemory,
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
    TResult Function(ExternalValue_SharedMemory value)? sharedMemory,
    required TResult orElse(),
  }) {
    if (memory != null) {
      return memory(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_Memory extends ExternalValue {
  const factory ExternalValue_Memory(final WMemory field0) =
      _$ExternalValue_MemoryImpl;
  const ExternalValue_Memory._() : super._();

  @override
  WMemory get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_MemoryImplCopyWith<_$ExternalValue_MemoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ExternalValue_SharedMemoryImplCopyWith<$Res> {
  factory _$$ExternalValue_SharedMemoryImplCopyWith(
          _$ExternalValue_SharedMemoryImpl value,
          $Res Function(_$ExternalValue_SharedMemoryImpl) then) =
      __$$ExternalValue_SharedMemoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WasmRunSharedMemory field0});
}

/// @nodoc
class __$$ExternalValue_SharedMemoryImplCopyWithImpl<$Res>
    extends _$ExternalValueCopyWithImpl<$Res, _$ExternalValue_SharedMemoryImpl>
    implements _$$ExternalValue_SharedMemoryImplCopyWith<$Res> {
  __$$ExternalValue_SharedMemoryImplCopyWithImpl(
      _$ExternalValue_SharedMemoryImpl _value,
      $Res Function(_$ExternalValue_SharedMemoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ExternalValue_SharedMemoryImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WasmRunSharedMemory,
    ));
  }
}

/// @nodoc

class _$ExternalValue_SharedMemoryImpl extends ExternalValue_SharedMemory {
  const _$ExternalValue_SharedMemoryImpl(this.field0) : super._();

  @override
  final WasmRunSharedMemory field0;

  @override
  String toString() {
    return 'ExternalValue.sharedMemory(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExternalValue_SharedMemoryImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExternalValue_SharedMemoryImplCopyWith<_$ExternalValue_SharedMemoryImpl>
      get copyWith => __$$ExternalValue_SharedMemoryImplCopyWithImpl<
          _$ExternalValue_SharedMemoryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(WFunc field0) func,
    required TResult Function(WGlobal field0) global,
    required TResult Function(WTable field0) table,
    required TResult Function(WMemory field0) memory,
    required TResult Function(WasmRunSharedMemory field0) sharedMemory,
  }) {
    return sharedMemory(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(WFunc field0)? func,
    TResult? Function(WGlobal field0)? global,
    TResult? Function(WTable field0)? table,
    TResult? Function(WMemory field0)? memory,
    TResult? Function(WasmRunSharedMemory field0)? sharedMemory,
  }) {
    return sharedMemory?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(WFunc field0)? func,
    TResult Function(WGlobal field0)? global,
    TResult Function(WTable field0)? table,
    TResult Function(WMemory field0)? memory,
    TResult Function(WasmRunSharedMemory field0)? sharedMemory,
    required TResult orElse(),
  }) {
    if (sharedMemory != null) {
      return sharedMemory(field0);
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
    required TResult Function(ExternalValue_SharedMemory value) sharedMemory,
  }) {
    return sharedMemory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExternalValue_Func value)? func,
    TResult? Function(ExternalValue_Global value)? global,
    TResult? Function(ExternalValue_Table value)? table,
    TResult? Function(ExternalValue_Memory value)? memory,
    TResult? Function(ExternalValue_SharedMemory value)? sharedMemory,
  }) {
    return sharedMemory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExternalValue_Func value)? func,
    TResult Function(ExternalValue_Global value)? global,
    TResult Function(ExternalValue_Table value)? table,
    TResult Function(ExternalValue_Memory value)? memory,
    TResult Function(ExternalValue_SharedMemory value)? sharedMemory,
    required TResult orElse(),
  }) {
    if (sharedMemory != null) {
      return sharedMemory(this);
    }
    return orElse();
  }
}

abstract class ExternalValue_SharedMemory extends ExternalValue {
  const factory ExternalValue_SharedMemory(final WasmRunSharedMemory field0) =
      _$ExternalValue_SharedMemoryImpl;
  const ExternalValue_SharedMemory._() : super._();

  @override
  WasmRunSharedMemory get field0;
  @JsonKey(ignore: true)
  _$$ExternalValue_SharedMemoryImplCopyWith<_$ExternalValue_SharedMemoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ParallelExec {
  Object get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<WasmVal> field0) ok,
    required TResult Function(String field0) err,
    required TResult Function(FunctionCall field0) call,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<WasmVal> field0)? ok,
    TResult? Function(String field0)? err,
    TResult? Function(FunctionCall field0)? call,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<WasmVal> field0)? ok,
    TResult Function(String field0)? err,
    TResult Function(FunctionCall field0)? call,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParallelExec_Ok value) ok,
    required TResult Function(ParallelExec_Err value) err,
    required TResult Function(ParallelExec_Call value) call,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParallelExec_Ok value)? ok,
    TResult? Function(ParallelExec_Err value)? err,
    TResult? Function(ParallelExec_Call value)? call,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParallelExec_Ok value)? ok,
    TResult Function(ParallelExec_Err value)? err,
    TResult Function(ParallelExec_Call value)? call,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParallelExecCopyWith<$Res> {
  factory $ParallelExecCopyWith(
          ParallelExec value, $Res Function(ParallelExec) then) =
      _$ParallelExecCopyWithImpl<$Res, ParallelExec>;
}

/// @nodoc
class _$ParallelExecCopyWithImpl<$Res, $Val extends ParallelExec>
    implements $ParallelExecCopyWith<$Res> {
  _$ParallelExecCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ParallelExec_OkImplCopyWith<$Res> {
  factory _$$ParallelExec_OkImplCopyWith(_$ParallelExec_OkImpl value,
          $Res Function(_$ParallelExec_OkImpl) then) =
      __$$ParallelExec_OkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<WasmVal> field0});
}

/// @nodoc
class __$$ParallelExec_OkImplCopyWithImpl<$Res>
    extends _$ParallelExecCopyWithImpl<$Res, _$ParallelExec_OkImpl>
    implements _$$ParallelExec_OkImplCopyWith<$Res> {
  __$$ParallelExec_OkImplCopyWithImpl(
      _$ParallelExec_OkImpl _value, $Res Function(_$ParallelExec_OkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParallelExec_OkImpl(
      null == field0
          ? _value._field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as List<WasmVal>,
    ));
  }
}

/// @nodoc

class _$ParallelExec_OkImpl extends ParallelExec_Ok {
  const _$ParallelExec_OkImpl(final List<WasmVal> field0)
      : _field0 = field0,
        super._();

  final List<WasmVal> _field0;
  @override
  List<WasmVal> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  @override
  String toString() {
    return 'ParallelExec.ok(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParallelExec_OkImpl &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParallelExec_OkImplCopyWith<_$ParallelExec_OkImpl> get copyWith =>
      __$$ParallelExec_OkImplCopyWithImpl<_$ParallelExec_OkImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<WasmVal> field0) ok,
    required TResult Function(String field0) err,
    required TResult Function(FunctionCall field0) call,
  }) {
    return ok(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<WasmVal> field0)? ok,
    TResult? Function(String field0)? err,
    TResult? Function(FunctionCall field0)? call,
  }) {
    return ok?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<WasmVal> field0)? ok,
    TResult Function(String field0)? err,
    TResult Function(FunctionCall field0)? call,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParallelExec_Ok value) ok,
    required TResult Function(ParallelExec_Err value) err,
    required TResult Function(ParallelExec_Call value) call,
  }) {
    return ok(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParallelExec_Ok value)? ok,
    TResult? Function(ParallelExec_Err value)? err,
    TResult? Function(ParallelExec_Call value)? call,
  }) {
    return ok?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParallelExec_Ok value)? ok,
    TResult Function(ParallelExec_Err value)? err,
    TResult Function(ParallelExec_Call value)? call,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(this);
    }
    return orElse();
  }
}

abstract class ParallelExec_Ok extends ParallelExec {
  const factory ParallelExec_Ok(final List<WasmVal> field0) =
      _$ParallelExec_OkImpl;
  const ParallelExec_Ok._() : super._();

  @override
  List<WasmVal> get field0;
  @JsonKey(ignore: true)
  _$$ParallelExec_OkImplCopyWith<_$ParallelExec_OkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParallelExec_ErrImplCopyWith<$Res> {
  factory _$$ParallelExec_ErrImplCopyWith(_$ParallelExec_ErrImpl value,
          $Res Function(_$ParallelExec_ErrImpl) then) =
      __$$ParallelExec_ErrImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class __$$ParallelExec_ErrImplCopyWithImpl<$Res>
    extends _$ParallelExecCopyWithImpl<$Res, _$ParallelExec_ErrImpl>
    implements _$$ParallelExec_ErrImplCopyWith<$Res> {
  __$$ParallelExec_ErrImplCopyWithImpl(_$ParallelExec_ErrImpl _value,
      $Res Function(_$ParallelExec_ErrImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParallelExec_ErrImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ParallelExec_ErrImpl extends ParallelExec_Err {
  const _$ParallelExec_ErrImpl(this.field0) : super._();

  @override
  final String field0;

  @override
  String toString() {
    return 'ParallelExec.err(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParallelExec_ErrImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParallelExec_ErrImplCopyWith<_$ParallelExec_ErrImpl> get copyWith =>
      __$$ParallelExec_ErrImplCopyWithImpl<_$ParallelExec_ErrImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<WasmVal> field0) ok,
    required TResult Function(String field0) err,
    required TResult Function(FunctionCall field0) call,
  }) {
    return err(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<WasmVal> field0)? ok,
    TResult? Function(String field0)? err,
    TResult? Function(FunctionCall field0)? call,
  }) {
    return err?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<WasmVal> field0)? ok,
    TResult Function(String field0)? err,
    TResult Function(FunctionCall field0)? call,
    required TResult orElse(),
  }) {
    if (err != null) {
      return err(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParallelExec_Ok value) ok,
    required TResult Function(ParallelExec_Err value) err,
    required TResult Function(ParallelExec_Call value) call,
  }) {
    return err(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParallelExec_Ok value)? ok,
    TResult? Function(ParallelExec_Err value)? err,
    TResult? Function(ParallelExec_Call value)? call,
  }) {
    return err?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParallelExec_Ok value)? ok,
    TResult Function(ParallelExec_Err value)? err,
    TResult Function(ParallelExec_Call value)? call,
    required TResult orElse(),
  }) {
    if (err != null) {
      return err(this);
    }
    return orElse();
  }
}

abstract class ParallelExec_Err extends ParallelExec {
  const factory ParallelExec_Err(final String field0) = _$ParallelExec_ErrImpl;
  const ParallelExec_Err._() : super._();

  @override
  String get field0;
  @JsonKey(ignore: true)
  _$$ParallelExec_ErrImplCopyWith<_$ParallelExec_ErrImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParallelExec_CallImplCopyWith<$Res> {
  factory _$$ParallelExec_CallImplCopyWith(_$ParallelExec_CallImpl value,
          $Res Function(_$ParallelExec_CallImpl) then) =
      __$$ParallelExec_CallImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FunctionCall field0});
}

/// @nodoc
class __$$ParallelExec_CallImplCopyWithImpl<$Res>
    extends _$ParallelExecCopyWithImpl<$Res, _$ParallelExec_CallImpl>
    implements _$$ParallelExec_CallImplCopyWith<$Res> {
  __$$ParallelExec_CallImplCopyWithImpl(_$ParallelExec_CallImpl _value,
      $Res Function(_$ParallelExec_CallImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$ParallelExec_CallImpl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FunctionCall,
    ));
  }
}

/// @nodoc

class _$ParallelExec_CallImpl extends ParallelExec_Call {
  const _$ParallelExec_CallImpl(this.field0) : super._();

  @override
  final FunctionCall field0;

  @override
  String toString() {
    return 'ParallelExec.call(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParallelExec_CallImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParallelExec_CallImplCopyWith<_$ParallelExec_CallImpl> get copyWith =>
      __$$ParallelExec_CallImplCopyWithImpl<_$ParallelExec_CallImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<WasmVal> field0) ok,
    required TResult Function(String field0) err,
    required TResult Function(FunctionCall field0) call,
  }) {
    return call(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<WasmVal> field0)? ok,
    TResult? Function(String field0)? err,
    TResult? Function(FunctionCall field0)? call,
  }) {
    return call?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<WasmVal> field0)? ok,
    TResult Function(String field0)? err,
    TResult Function(FunctionCall field0)? call,
    required TResult orElse(),
  }) {
    if (call != null) {
      return call(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ParallelExec_Ok value) ok,
    required TResult Function(ParallelExec_Err value) err,
    required TResult Function(ParallelExec_Call value) call,
  }) {
    return call(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ParallelExec_Ok value)? ok,
    TResult? Function(ParallelExec_Err value)? err,
    TResult? Function(ParallelExec_Call value)? call,
  }) {
    return call?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ParallelExec_Ok value)? ok,
    TResult Function(ParallelExec_Err value)? err,
    TResult Function(ParallelExec_Call value)? call,
    required TResult orElse(),
  }) {
    if (call != null) {
      return call(this);
    }
    return orElse();
  }
}

abstract class ParallelExec_Call extends ParallelExec {
  const factory ParallelExec_Call(final FunctionCall field0) =
      _$ParallelExec_CallImpl;
  const ParallelExec_Call._() : super._();

  @override
  FunctionCall get field0;
  @JsonKey(ignore: true)
  _$$ParallelExec_CallImplCopyWith<_$ParallelExec_CallImpl> get copyWith =>
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
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WasmVal_i32 value) i32,
    required TResult Function(WasmVal_i64 value) i64,
    required TResult Function(WasmVal_f32 value) f32,
    required TResult Function(WasmVal_f64 value) f64,
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
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
abstract class _$$WasmVal_i32ImplCopyWith<$Res> {
  factory _$$WasmVal_i32ImplCopyWith(
          _$WasmVal_i32Impl value, $Res Function(_$WasmVal_i32Impl) then) =
      __$$WasmVal_i32ImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$WasmVal_i32ImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_i32Impl>
    implements _$$WasmVal_i32ImplCopyWith<$Res> {
  __$$WasmVal_i32ImplCopyWithImpl(
      _$WasmVal_i32Impl _value, $Res Function(_$WasmVal_i32Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_i32Impl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WasmVal_i32Impl extends WasmVal_i32 {
  const _$WasmVal_i32Impl(this.field0) : super._();

  @override
  final int field0;

  @override
  String toString() {
    return 'WasmVal.i32(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_i32Impl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_i32ImplCopyWith<_$WasmVal_i32Impl> get copyWith =>
      __$$WasmVal_i32ImplCopyWithImpl<_$WasmVal_i32Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
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
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
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
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
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
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
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
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (i32 != null) {
      return i32(this);
    }
    return orElse();
  }
}

abstract class WasmVal_i32 extends WasmVal {
  const factory WasmVal_i32(final int field0) = _$WasmVal_i32Impl;
  const WasmVal_i32._() : super._();

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_i32ImplCopyWith<_$WasmVal_i32Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_i64ImplCopyWith<$Res> {
  factory _$$WasmVal_i64ImplCopyWith(
          _$WasmVal_i64Impl value, $Res Function(_$WasmVal_i64Impl) then) =
      __$$WasmVal_i64ImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int field0});
}

/// @nodoc
class __$$WasmVal_i64ImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_i64Impl>
    implements _$$WasmVal_i64ImplCopyWith<$Res> {
  __$$WasmVal_i64ImplCopyWithImpl(
      _$WasmVal_i64Impl _value, $Res Function(_$WasmVal_i64Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_i64Impl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$WasmVal_i64Impl extends WasmVal_i64 {
  const _$WasmVal_i64Impl(this.field0) : super._();

  @override
  final int field0;

  @override
  String toString() {
    return 'WasmVal.i64(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_i64Impl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_i64ImplCopyWith<_$WasmVal_i64Impl> get copyWith =>
      __$$WasmVal_i64ImplCopyWithImpl<_$WasmVal_i64Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
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
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
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
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
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
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
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
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (i64 != null) {
      return i64(this);
    }
    return orElse();
  }
}

abstract class WasmVal_i64 extends WasmVal {
  const factory WasmVal_i64(final int field0) = _$WasmVal_i64Impl;
  const WasmVal_i64._() : super._();

  @override
  int get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_i64ImplCopyWith<_$WasmVal_i64Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_f32ImplCopyWith<$Res> {
  factory _$$WasmVal_f32ImplCopyWith(
          _$WasmVal_f32Impl value, $Res Function(_$WasmVal_f32Impl) then) =
      __$$WasmVal_f32ImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$WasmVal_f32ImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_f32Impl>
    implements _$$WasmVal_f32ImplCopyWith<$Res> {
  __$$WasmVal_f32ImplCopyWithImpl(
      _$WasmVal_f32Impl _value, $Res Function(_$WasmVal_f32Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_f32Impl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WasmVal_f32Impl extends WasmVal_f32 {
  const _$WasmVal_f32Impl(this.field0) : super._();

  @override
  final double field0;

  @override
  String toString() {
    return 'WasmVal.f32(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_f32Impl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_f32ImplCopyWith<_$WasmVal_f32Impl> get copyWith =>
      __$$WasmVal_f32ImplCopyWithImpl<_$WasmVal_f32Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
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
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
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
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
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
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
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
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (f32 != null) {
      return f32(this);
    }
    return orElse();
  }
}

abstract class WasmVal_f32 extends WasmVal {
  const factory WasmVal_f32(final double field0) = _$WasmVal_f32Impl;
  const WasmVal_f32._() : super._();

  @override
  double get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_f32ImplCopyWith<_$WasmVal_f32Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_f64ImplCopyWith<$Res> {
  factory _$$WasmVal_f64ImplCopyWith(
          _$WasmVal_f64Impl value, $Res Function(_$WasmVal_f64Impl) then) =
      __$$WasmVal_f64ImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class __$$WasmVal_f64ImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_f64Impl>
    implements _$$WasmVal_f64ImplCopyWith<$Res> {
  __$$WasmVal_f64ImplCopyWithImpl(
      _$WasmVal_f64Impl _value, $Res Function(_$WasmVal_f64Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_f64Impl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$WasmVal_f64Impl extends WasmVal_f64 {
  const _$WasmVal_f64Impl(this.field0) : super._();

  @override
  final double field0;

  @override
  String toString() {
    return 'WasmVal.f64(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_f64Impl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_f64ImplCopyWith<_$WasmVal_f64Impl> get copyWith =>
      __$$WasmVal_f64ImplCopyWithImpl<_$WasmVal_f64Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
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
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
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
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
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
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
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
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (f64 != null) {
      return f64(this);
    }
    return orElse();
  }
}

abstract class WasmVal_f64 extends WasmVal {
  const factory WasmVal_f64(final double field0) = _$WasmVal_f64Impl;
  const WasmVal_f64._() : super._();

  @override
  double get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_f64ImplCopyWith<_$WasmVal_f64Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_v128ImplCopyWith<$Res> {
  factory _$$WasmVal_v128ImplCopyWith(
          _$WasmVal_v128Impl value, $Res Function(_$WasmVal_v128Impl) then) =
      __$$WasmVal_v128ImplCopyWithImpl<$Res>;
  @useResult
  $Res call({U8Array16 field0});
}

/// @nodoc
class __$$WasmVal_v128ImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_v128Impl>
    implements _$$WasmVal_v128ImplCopyWith<$Res> {
  __$$WasmVal_v128ImplCopyWithImpl(
      _$WasmVal_v128Impl _value, $Res Function(_$WasmVal_v128Impl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$WasmVal_v128Impl(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as U8Array16,
    ));
  }
}

/// @nodoc

class _$WasmVal_v128Impl extends WasmVal_v128 {
  const _$WasmVal_v128Impl(this.field0) : super._();

  @override
  final U8Array16 field0;

  @override
  String toString() {
    return 'WasmVal.v128(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_v128Impl &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_v128ImplCopyWith<_$WasmVal_v128Impl> get copyWith =>
      __$$WasmVal_v128ImplCopyWithImpl<_$WasmVal_v128Impl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
  }) {
    return v128(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
  }) {
    return v128?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
    required TResult orElse(),
  }) {
    if (v128 != null) {
      return v128(field0);
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
  }) {
    return v128(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
  }) {
    return v128?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (v128 != null) {
      return v128(this);
    }
    return orElse();
  }
}

abstract class WasmVal_v128 extends WasmVal {
  const factory WasmVal_v128(final U8Array16 field0) = _$WasmVal_v128Impl;
  const WasmVal_v128._() : super._();

  @override
  U8Array16 get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_v128ImplCopyWith<_$WasmVal_v128Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_funcRefImplCopyWith<$Res> {
  factory _$$WasmVal_funcRefImplCopyWith(_$WasmVal_funcRefImpl value,
          $Res Function(_$WasmVal_funcRefImpl) then) =
      __$$WasmVal_funcRefImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WFunc? field0});
}

/// @nodoc
class __$$WasmVal_funcRefImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_funcRefImpl>
    implements _$$WasmVal_funcRefImplCopyWith<$Res> {
  __$$WasmVal_funcRefImplCopyWithImpl(
      _$WasmVal_funcRefImpl _value, $Res Function(_$WasmVal_funcRefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$WasmVal_funcRefImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WFunc?,
    ));
  }
}

/// @nodoc

class _$WasmVal_funcRefImpl extends WasmVal_funcRef {
  const _$WasmVal_funcRefImpl([this.field0]) : super._();

  @override
  final WFunc? field0;

  @override
  String toString() {
    return 'WasmVal.funcRef(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_funcRefImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_funcRefImplCopyWith<_$WasmVal_funcRefImpl> get copyWith =>
      __$$WasmVal_funcRefImplCopyWithImpl<_$WasmVal_funcRefImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
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
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
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
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
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
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
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
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (funcRef != null) {
      return funcRef(this);
    }
    return orElse();
  }
}

abstract class WasmVal_funcRef extends WasmVal {
  const factory WasmVal_funcRef([final WFunc? field0]) = _$WasmVal_funcRefImpl;
  const WasmVal_funcRef._() : super._();

  @override
  WFunc? get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_funcRefImplCopyWith<_$WasmVal_funcRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_externRefImplCopyWith<$Res> {
  factory _$$WasmVal_externRefImplCopyWith(_$WasmVal_externRefImpl value,
          $Res Function(_$WasmVal_externRefImpl) then) =
      __$$WasmVal_externRefImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? field0});
}

/// @nodoc
class __$$WasmVal_externRefImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_externRefImpl>
    implements _$$WasmVal_externRefImplCopyWith<$Res> {
  __$$WasmVal_externRefImplCopyWithImpl(_$WasmVal_externRefImpl _value,
      $Res Function(_$WasmVal_externRefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$WasmVal_externRefImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$WasmVal_externRefImpl extends WasmVal_externRef {
  const _$WasmVal_externRefImpl([this.field0]) : super._();

  @override
  final int? field0;

  @override
  String toString() {
    return 'WasmVal.externRef(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_externRefImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_externRefImplCopyWith<_$WasmVal_externRefImpl> get copyWith =>
      __$$WasmVal_externRefImplCopyWithImpl<_$WasmVal_externRefImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
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
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
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
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
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
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
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
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (externRef != null) {
      return externRef(this);
    }
    return orElse();
  }
}

abstract class WasmVal_externRef extends WasmVal {
  const factory WasmVal_externRef([final int? field0]) =
      _$WasmVal_externRefImpl;
  const WasmVal_externRef._() : super._();

  @override
  int? get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_externRefImplCopyWith<_$WasmVal_externRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_anyRefImplCopyWith<$Res> {
  factory _$$WasmVal_anyRefImplCopyWith(_$WasmVal_anyRefImpl value,
          $Res Function(_$WasmVal_anyRefImpl) then) =
      __$$WasmVal_anyRefImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WAnyRef? field0});
}

/// @nodoc
class __$$WasmVal_anyRefImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_anyRefImpl>
    implements _$$WasmVal_anyRefImplCopyWith<$Res> {
  __$$WasmVal_anyRefImplCopyWithImpl(
      _$WasmVal_anyRefImpl _value, $Res Function(_$WasmVal_anyRefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$WasmVal_anyRefImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WAnyRef?,
    ));
  }
}

/// @nodoc

class _$WasmVal_anyRefImpl extends WasmVal_anyRef {
  const _$WasmVal_anyRefImpl([this.field0]) : super._();

  @override
  final WAnyRef? field0;

  @override
  String toString() {
    return 'WasmVal.anyRef(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_anyRefImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_anyRefImplCopyWith<_$WasmVal_anyRefImpl> get copyWith =>
      __$$WasmVal_anyRefImplCopyWithImpl<_$WasmVal_anyRefImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
  }) {
    return anyRef(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
  }) {
    return anyRef?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
    required TResult orElse(),
  }) {
    if (anyRef != null) {
      return anyRef(field0);
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
  }) {
    return anyRef(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
  }) {
    return anyRef?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (anyRef != null) {
      return anyRef(this);
    }
    return orElse();
  }
}

abstract class WasmVal_anyRef extends WasmVal {
  const factory WasmVal_anyRef([final WAnyRef? field0]) = _$WasmVal_anyRefImpl;
  const WasmVal_anyRef._() : super._();

  @override
  WAnyRef? get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_anyRefImplCopyWith<_$WasmVal_anyRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WasmVal_exnRefImplCopyWith<$Res> {
  factory _$$WasmVal_exnRefImplCopyWith(_$WasmVal_exnRefImpl value,
          $Res Function(_$WasmVal_exnRefImpl) then) =
      __$$WasmVal_exnRefImplCopyWithImpl<$Res>;
  @useResult
  $Res call({WExnRef? field0});
}

/// @nodoc
class __$$WasmVal_exnRefImplCopyWithImpl<$Res>
    extends _$WasmValCopyWithImpl<$Res, _$WasmVal_exnRefImpl>
    implements _$$WasmVal_exnRefImplCopyWith<$Res> {
  __$$WasmVal_exnRefImplCopyWithImpl(
      _$WasmVal_exnRefImpl _value, $Res Function(_$WasmVal_exnRefImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$WasmVal_exnRefImpl(
      freezed == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as WExnRef?,
    ));
  }
}

/// @nodoc

class _$WasmVal_exnRefImpl extends WasmVal_exnRef {
  const _$WasmVal_exnRefImpl([this.field0]) : super._();

  @override
  final WExnRef? field0;

  @override
  String toString() {
    return 'WasmVal.exnRef(field0: $field0)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasmVal_exnRefImpl &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WasmVal_exnRefImplCopyWith<_$WasmVal_exnRefImpl> get copyWith =>
      __$$WasmVal_exnRefImplCopyWithImpl<_$WasmVal_exnRefImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int field0) i32,
    required TResult Function(int field0) i64,
    required TResult Function(double field0) f32,
    required TResult Function(double field0) f64,
    required TResult Function(U8Array16 field0) v128,
    required TResult Function(WFunc? field0) funcRef,
    required TResult Function(int? field0) externRef,
    required TResult Function(WAnyRef? field0) anyRef,
    required TResult Function(WExnRef? field0) exnRef,
  }) {
    return exnRef(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int field0)? i32,
    TResult? Function(int field0)? i64,
    TResult? Function(double field0)? f32,
    TResult? Function(double field0)? f64,
    TResult? Function(U8Array16 field0)? v128,
    TResult? Function(WFunc? field0)? funcRef,
    TResult? Function(int? field0)? externRef,
    TResult? Function(WAnyRef? field0)? anyRef,
    TResult? Function(WExnRef? field0)? exnRef,
  }) {
    return exnRef?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int field0)? i32,
    TResult Function(int field0)? i64,
    TResult Function(double field0)? f32,
    TResult Function(double field0)? f64,
    TResult Function(U8Array16 field0)? v128,
    TResult Function(WFunc? field0)? funcRef,
    TResult Function(int? field0)? externRef,
    TResult Function(WAnyRef? field0)? anyRef,
    TResult Function(WExnRef? field0)? exnRef,
    required TResult orElse(),
  }) {
    if (exnRef != null) {
      return exnRef(field0);
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
    required TResult Function(WasmVal_v128 value) v128,
    required TResult Function(WasmVal_funcRef value) funcRef,
    required TResult Function(WasmVal_externRef value) externRef,
    required TResult Function(WasmVal_anyRef value) anyRef,
    required TResult Function(WasmVal_exnRef value) exnRef,
  }) {
    return exnRef(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WasmVal_i32 value)? i32,
    TResult? Function(WasmVal_i64 value)? i64,
    TResult? Function(WasmVal_f32 value)? f32,
    TResult? Function(WasmVal_f64 value)? f64,
    TResult? Function(WasmVal_v128 value)? v128,
    TResult? Function(WasmVal_funcRef value)? funcRef,
    TResult? Function(WasmVal_externRef value)? externRef,
    TResult? Function(WasmVal_anyRef value)? anyRef,
    TResult? Function(WasmVal_exnRef value)? exnRef,
  }) {
    return exnRef?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WasmVal_i32 value)? i32,
    TResult Function(WasmVal_i64 value)? i64,
    TResult Function(WasmVal_f32 value)? f32,
    TResult Function(WasmVal_f64 value)? f64,
    TResult Function(WasmVal_v128 value)? v128,
    TResult Function(WasmVal_funcRef value)? funcRef,
    TResult Function(WasmVal_externRef value)? externRef,
    TResult Function(WasmVal_anyRef value)? anyRef,
    TResult Function(WasmVal_exnRef value)? exnRef,
    required TResult orElse(),
  }) {
    if (exnRef != null) {
      return exnRef(this);
    }
    return orElse();
  }
}

abstract class WasmVal_exnRef extends WasmVal {
  const factory WasmVal_exnRef([final WExnRef? field0]) = _$WasmVal_exnRefImpl;
  const WasmVal_exnRef._() : super._();

  @override
  WExnRef? get field0;
  @JsonKey(ignore: true)
  _$$WasmVal_exnRefImplCopyWith<_$WasmVal_exnRefImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
