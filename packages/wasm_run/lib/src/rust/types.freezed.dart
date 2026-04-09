// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExternalType {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalType&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'ExternalType(field0: $field0)';
}


}

/// @nodoc
class $ExternalTypeCopyWith<$Res>  {
$ExternalTypeCopyWith(ExternalType _, $Res Function(ExternalType) __);
}


/// Adds pattern-matching-related methods to [ExternalType].
extension ExternalTypePatterns on ExternalType {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExternalType_Func value)?  func,TResult Function( ExternalType_Global value)?  global,TResult Function( ExternalType_Table value)?  table,TResult Function( ExternalType_Memory value)?  memory,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExternalType_Func() when func != null:
return func(_that);case ExternalType_Global() when global != null:
return global(_that);case ExternalType_Table() when table != null:
return table(_that);case ExternalType_Memory() when memory != null:
return memory(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExternalType_Func value)  func,required TResult Function( ExternalType_Global value)  global,required TResult Function( ExternalType_Table value)  table,required TResult Function( ExternalType_Memory value)  memory,}){
final _that = this;
switch (_that) {
case ExternalType_Func():
return func(_that);case ExternalType_Global():
return global(_that);case ExternalType_Table():
return table(_that);case ExternalType_Memory():
return memory(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExternalType_Func value)?  func,TResult? Function( ExternalType_Global value)?  global,TResult? Function( ExternalType_Table value)?  table,TResult? Function( ExternalType_Memory value)?  memory,}){
final _that = this;
switch (_that) {
case ExternalType_Func() when func != null:
return func(_that);case ExternalType_Global() when global != null:
return global(_that);case ExternalType_Table() when table != null:
return table(_that);case ExternalType_Memory() when memory != null:
return memory(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FuncTy field0)?  func,TResult Function( GlobalTy field0)?  global,TResult Function( TableTy field0)?  table,TResult Function( MemoryTy field0)?  memory,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExternalType_Func() when func != null:
return func(_that.field0);case ExternalType_Global() when global != null:
return global(_that.field0);case ExternalType_Table() when table != null:
return table(_that.field0);case ExternalType_Memory() when memory != null:
return memory(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FuncTy field0)  func,required TResult Function( GlobalTy field0)  global,required TResult Function( TableTy field0)  table,required TResult Function( MemoryTy field0)  memory,}) {final _that = this;
switch (_that) {
case ExternalType_Func():
return func(_that.field0);case ExternalType_Global():
return global(_that.field0);case ExternalType_Table():
return table(_that.field0);case ExternalType_Memory():
return memory(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FuncTy field0)?  func,TResult? Function( GlobalTy field0)?  global,TResult? Function( TableTy field0)?  table,TResult? Function( MemoryTy field0)?  memory,}) {final _that = this;
switch (_that) {
case ExternalType_Func() when func != null:
return func(_that.field0);case ExternalType_Global() when global != null:
return global(_that.field0);case ExternalType_Table() when table != null:
return table(_that.field0);case ExternalType_Memory() when memory != null:
return memory(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ExternalType_Func extends ExternalType {
  const ExternalType_Func(this.field0): super._();
  

@override final  FuncTy field0;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalType_FuncCopyWith<ExternalType_Func> get copyWith => _$ExternalType_FuncCopyWithImpl<ExternalType_Func>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalType_Func&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalType.func(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalType_FuncCopyWith<$Res> implements $ExternalTypeCopyWith<$Res> {
  factory $ExternalType_FuncCopyWith(ExternalType_Func value, $Res Function(ExternalType_Func) _then) = _$ExternalType_FuncCopyWithImpl;
@useResult
$Res call({
 FuncTy field0
});




}
/// @nodoc
class _$ExternalType_FuncCopyWithImpl<$Res>
    implements $ExternalType_FuncCopyWith<$Res> {
  _$ExternalType_FuncCopyWithImpl(this._self, this._then);

  final ExternalType_Func _self;
  final $Res Function(ExternalType_Func) _then;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalType_Func(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as FuncTy,
  ));
}


}

/// @nodoc


class ExternalType_Global extends ExternalType {
  const ExternalType_Global(this.field0): super._();
  

@override final  GlobalTy field0;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalType_GlobalCopyWith<ExternalType_Global> get copyWith => _$ExternalType_GlobalCopyWithImpl<ExternalType_Global>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalType_Global&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalType.global(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalType_GlobalCopyWith<$Res> implements $ExternalTypeCopyWith<$Res> {
  factory $ExternalType_GlobalCopyWith(ExternalType_Global value, $Res Function(ExternalType_Global) _then) = _$ExternalType_GlobalCopyWithImpl;
@useResult
$Res call({
 GlobalTy field0
});




}
/// @nodoc
class _$ExternalType_GlobalCopyWithImpl<$Res>
    implements $ExternalType_GlobalCopyWith<$Res> {
  _$ExternalType_GlobalCopyWithImpl(this._self, this._then);

  final ExternalType_Global _self;
  final $Res Function(ExternalType_Global) _then;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalType_Global(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as GlobalTy,
  ));
}


}

/// @nodoc


class ExternalType_Table extends ExternalType {
  const ExternalType_Table(this.field0): super._();
  

@override final  TableTy field0;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalType_TableCopyWith<ExternalType_Table> get copyWith => _$ExternalType_TableCopyWithImpl<ExternalType_Table>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalType_Table&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalType.table(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalType_TableCopyWith<$Res> implements $ExternalTypeCopyWith<$Res> {
  factory $ExternalType_TableCopyWith(ExternalType_Table value, $Res Function(ExternalType_Table) _then) = _$ExternalType_TableCopyWithImpl;
@useResult
$Res call({
 TableTy field0
});




}
/// @nodoc
class _$ExternalType_TableCopyWithImpl<$Res>
    implements $ExternalType_TableCopyWith<$Res> {
  _$ExternalType_TableCopyWithImpl(this._self, this._then);

  final ExternalType_Table _self;
  final $Res Function(ExternalType_Table) _then;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalType_Table(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as TableTy,
  ));
}


}

/// @nodoc


class ExternalType_Memory extends ExternalType {
  const ExternalType_Memory(this.field0): super._();
  

@override final  MemoryTy field0;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalType_MemoryCopyWith<ExternalType_Memory> get copyWith => _$ExternalType_MemoryCopyWithImpl<ExternalType_Memory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalType_Memory&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalType.memory(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalType_MemoryCopyWith<$Res> implements $ExternalTypeCopyWith<$Res> {
  factory $ExternalType_MemoryCopyWith(ExternalType_Memory value, $Res Function(ExternalType_Memory) _then) = _$ExternalType_MemoryCopyWithImpl;
@useResult
$Res call({
 MemoryTy field0
});




}
/// @nodoc
class _$ExternalType_MemoryCopyWithImpl<$Res>
    implements $ExternalType_MemoryCopyWith<$Res> {
  _$ExternalType_MemoryCopyWithImpl(this._self, this._then);

  final ExternalType_Memory _self;
  final $Res Function(ExternalType_Memory) _then;

/// Create a copy of ExternalType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalType_Memory(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as MemoryTy,
  ));
}


}

/// @nodoc
mixin _$ExternalValue {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalValue&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'ExternalValue(field0: $field0)';
}


}

/// @nodoc
class $ExternalValueCopyWith<$Res>  {
$ExternalValueCopyWith(ExternalValue _, $Res Function(ExternalValue) __);
}


/// Adds pattern-matching-related methods to [ExternalValue].
extension ExternalValuePatterns on ExternalValue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExternalValue_Func value)?  func,TResult Function( ExternalValue_Global value)?  global,TResult Function( ExternalValue_Table value)?  table,TResult Function( ExternalValue_Memory value)?  memory,TResult Function( ExternalValue_SharedMemory value)?  sharedMemory,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExternalValue_Func() when func != null:
return func(_that);case ExternalValue_Global() when global != null:
return global(_that);case ExternalValue_Table() when table != null:
return table(_that);case ExternalValue_Memory() when memory != null:
return memory(_that);case ExternalValue_SharedMemory() when sharedMemory != null:
return sharedMemory(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExternalValue_Func value)  func,required TResult Function( ExternalValue_Global value)  global,required TResult Function( ExternalValue_Table value)  table,required TResult Function( ExternalValue_Memory value)  memory,required TResult Function( ExternalValue_SharedMemory value)  sharedMemory,}){
final _that = this;
switch (_that) {
case ExternalValue_Func():
return func(_that);case ExternalValue_Global():
return global(_that);case ExternalValue_Table():
return table(_that);case ExternalValue_Memory():
return memory(_that);case ExternalValue_SharedMemory():
return sharedMemory(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExternalValue_Func value)?  func,TResult? Function( ExternalValue_Global value)?  global,TResult? Function( ExternalValue_Table value)?  table,TResult? Function( ExternalValue_Memory value)?  memory,TResult? Function( ExternalValue_SharedMemory value)?  sharedMemory,}){
final _that = this;
switch (_that) {
case ExternalValue_Func() when func != null:
return func(_that);case ExternalValue_Global() when global != null:
return global(_that);case ExternalValue_Table() when table != null:
return table(_that);case ExternalValue_Memory() when memory != null:
return memory(_that);case ExternalValue_SharedMemory() when sharedMemory != null:
return sharedMemory(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( WFunc field0)?  func,TResult Function( Global field0)?  global,TResult Function( Table field0)?  table,TResult Function( Memory field0)?  memory,TResult Function( WasmRunSharedMemory field0)?  sharedMemory,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExternalValue_Func() when func != null:
return func(_that.field0);case ExternalValue_Global() when global != null:
return global(_that.field0);case ExternalValue_Table() when table != null:
return table(_that.field0);case ExternalValue_Memory() when memory != null:
return memory(_that.field0);case ExternalValue_SharedMemory() when sharedMemory != null:
return sharedMemory(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( WFunc field0)  func,required TResult Function( Global field0)  global,required TResult Function( Table field0)  table,required TResult Function( Memory field0)  memory,required TResult Function( WasmRunSharedMemory field0)  sharedMemory,}) {final _that = this;
switch (_that) {
case ExternalValue_Func():
return func(_that.field0);case ExternalValue_Global():
return global(_that.field0);case ExternalValue_Table():
return table(_that.field0);case ExternalValue_Memory():
return memory(_that.field0);case ExternalValue_SharedMemory():
return sharedMemory(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( WFunc field0)?  func,TResult? Function( Global field0)?  global,TResult? Function( Table field0)?  table,TResult? Function( Memory field0)?  memory,TResult? Function( WasmRunSharedMemory field0)?  sharedMemory,}) {final _that = this;
switch (_that) {
case ExternalValue_Func() when func != null:
return func(_that.field0);case ExternalValue_Global() when global != null:
return global(_that.field0);case ExternalValue_Table() when table != null:
return table(_that.field0);case ExternalValue_Memory() when memory != null:
return memory(_that.field0);case ExternalValue_SharedMemory() when sharedMemory != null:
return sharedMemory(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ExternalValue_Func extends ExternalValue {
  const ExternalValue_Func(this.field0): super._();
  

@override final  WFunc field0;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalValue_FuncCopyWith<ExternalValue_Func> get copyWith => _$ExternalValue_FuncCopyWithImpl<ExternalValue_Func>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalValue_Func&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalValue.func(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalValue_FuncCopyWith<$Res> implements $ExternalValueCopyWith<$Res> {
  factory $ExternalValue_FuncCopyWith(ExternalValue_Func value, $Res Function(ExternalValue_Func) _then) = _$ExternalValue_FuncCopyWithImpl;
@useResult
$Res call({
 WFunc field0
});




}
/// @nodoc
class _$ExternalValue_FuncCopyWithImpl<$Res>
    implements $ExternalValue_FuncCopyWith<$Res> {
  _$ExternalValue_FuncCopyWithImpl(this._self, this._then);

  final ExternalValue_Func _self;
  final $Res Function(ExternalValue_Func) _then;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalValue_Func(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as WFunc,
  ));
}


}

/// @nodoc


class ExternalValue_Global extends ExternalValue {
  const ExternalValue_Global(this.field0): super._();
  

@override final  Global field0;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalValue_GlobalCopyWith<ExternalValue_Global> get copyWith => _$ExternalValue_GlobalCopyWithImpl<ExternalValue_Global>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalValue_Global&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalValue.global(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalValue_GlobalCopyWith<$Res> implements $ExternalValueCopyWith<$Res> {
  factory $ExternalValue_GlobalCopyWith(ExternalValue_Global value, $Res Function(ExternalValue_Global) _then) = _$ExternalValue_GlobalCopyWithImpl;
@useResult
$Res call({
 Global field0
});




}
/// @nodoc
class _$ExternalValue_GlobalCopyWithImpl<$Res>
    implements $ExternalValue_GlobalCopyWith<$Res> {
  _$ExternalValue_GlobalCopyWithImpl(this._self, this._then);

  final ExternalValue_Global _self;
  final $Res Function(ExternalValue_Global) _then;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalValue_Global(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Global,
  ));
}


}

/// @nodoc


class ExternalValue_Table extends ExternalValue {
  const ExternalValue_Table(this.field0): super._();
  

@override final  Table field0;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalValue_TableCopyWith<ExternalValue_Table> get copyWith => _$ExternalValue_TableCopyWithImpl<ExternalValue_Table>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalValue_Table&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalValue.table(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalValue_TableCopyWith<$Res> implements $ExternalValueCopyWith<$Res> {
  factory $ExternalValue_TableCopyWith(ExternalValue_Table value, $Res Function(ExternalValue_Table) _then) = _$ExternalValue_TableCopyWithImpl;
@useResult
$Res call({
 Table field0
});




}
/// @nodoc
class _$ExternalValue_TableCopyWithImpl<$Res>
    implements $ExternalValue_TableCopyWith<$Res> {
  _$ExternalValue_TableCopyWithImpl(this._self, this._then);

  final ExternalValue_Table _self;
  final $Res Function(ExternalValue_Table) _then;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalValue_Table(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Table,
  ));
}


}

/// @nodoc


class ExternalValue_Memory extends ExternalValue {
  const ExternalValue_Memory(this.field0): super._();
  

@override final  Memory field0;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalValue_MemoryCopyWith<ExternalValue_Memory> get copyWith => _$ExternalValue_MemoryCopyWithImpl<ExternalValue_Memory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalValue_Memory&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalValue.memory(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalValue_MemoryCopyWith<$Res> implements $ExternalValueCopyWith<$Res> {
  factory $ExternalValue_MemoryCopyWith(ExternalValue_Memory value, $Res Function(ExternalValue_Memory) _then) = _$ExternalValue_MemoryCopyWithImpl;
@useResult
$Res call({
 Memory field0
});




}
/// @nodoc
class _$ExternalValue_MemoryCopyWithImpl<$Res>
    implements $ExternalValue_MemoryCopyWith<$Res> {
  _$ExternalValue_MemoryCopyWithImpl(this._self, this._then);

  final ExternalValue_Memory _self;
  final $Res Function(ExternalValue_Memory) _then;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalValue_Memory(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Memory,
  ));
}


}

/// @nodoc


class ExternalValue_SharedMemory extends ExternalValue {
  const ExternalValue_SharedMemory(this.field0): super._();
  

@override final  WasmRunSharedMemory field0;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalValue_SharedMemoryCopyWith<ExternalValue_SharedMemory> get copyWith => _$ExternalValue_SharedMemoryCopyWithImpl<ExternalValue_SharedMemory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalValue_SharedMemory&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ExternalValue.sharedMemory(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ExternalValue_SharedMemoryCopyWith<$Res> implements $ExternalValueCopyWith<$Res> {
  factory $ExternalValue_SharedMemoryCopyWith(ExternalValue_SharedMemory value, $Res Function(ExternalValue_SharedMemory) _then) = _$ExternalValue_SharedMemoryCopyWithImpl;
@useResult
$Res call({
 WasmRunSharedMemory field0
});




}
/// @nodoc
class _$ExternalValue_SharedMemoryCopyWithImpl<$Res>
    implements $ExternalValue_SharedMemoryCopyWith<$Res> {
  _$ExternalValue_SharedMemoryCopyWithImpl(this._self, this._then);

  final ExternalValue_SharedMemory _self;
  final $Res Function(ExternalValue_SharedMemory) _then;

/// Create a copy of ExternalValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ExternalValue_SharedMemory(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as WasmRunSharedMemory,
  ));
}


}

/// @nodoc
mixin _$ParallelExec {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParallelExec&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'ParallelExec(field0: $field0)';
}


}

/// @nodoc
class $ParallelExecCopyWith<$Res>  {
$ParallelExecCopyWith(ParallelExec _, $Res Function(ParallelExec) __);
}


/// Adds pattern-matching-related methods to [ParallelExec].
extension ParallelExecPatterns on ParallelExec {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ParallelExec_Ok value)?  ok,TResult Function( ParallelExec_Err value)?  err,TResult Function( ParallelExec_Call value)?  call,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ParallelExec_Ok() when ok != null:
return ok(_that);case ParallelExec_Err() when err != null:
return err(_that);case ParallelExec_Call() when call != null:
return call(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ParallelExec_Ok value)  ok,required TResult Function( ParallelExec_Err value)  err,required TResult Function( ParallelExec_Call value)  call,}){
final _that = this;
switch (_that) {
case ParallelExec_Ok():
return ok(_that);case ParallelExec_Err():
return err(_that);case ParallelExec_Call():
return call(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ParallelExec_Ok value)?  ok,TResult? Function( ParallelExec_Err value)?  err,TResult? Function( ParallelExec_Call value)?  call,}){
final _that = this;
switch (_that) {
case ParallelExec_Ok() when ok != null:
return ok(_that);case ParallelExec_Err() when err != null:
return err(_that);case ParallelExec_Call() when call != null:
return call(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<WasmVal> field0)?  ok,TResult Function( String field0)?  err,TResult Function( FunctionCall field0)?  call,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ParallelExec_Ok() when ok != null:
return ok(_that.field0);case ParallelExec_Err() when err != null:
return err(_that.field0);case ParallelExec_Call() when call != null:
return call(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<WasmVal> field0)  ok,required TResult Function( String field0)  err,required TResult Function( FunctionCall field0)  call,}) {final _that = this;
switch (_that) {
case ParallelExec_Ok():
return ok(_that.field0);case ParallelExec_Err():
return err(_that.field0);case ParallelExec_Call():
return call(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<WasmVal> field0)?  ok,TResult? Function( String field0)?  err,TResult? Function( FunctionCall field0)?  call,}) {final _that = this;
switch (_that) {
case ParallelExec_Ok() when ok != null:
return ok(_that.field0);case ParallelExec_Err() when err != null:
return err(_that.field0);case ParallelExec_Call() when call != null:
return call(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class ParallelExec_Ok extends ParallelExec {
  const ParallelExec_Ok(final  List<WasmVal> field0): _field0 = field0,super._();
  

 final  List<WasmVal> _field0;
@override List<WasmVal> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of ParallelExec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParallelExec_OkCopyWith<ParallelExec_Ok> get copyWith => _$ParallelExec_OkCopyWithImpl<ParallelExec_Ok>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParallelExec_Ok&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'ParallelExec.ok(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ParallelExec_OkCopyWith<$Res> implements $ParallelExecCopyWith<$Res> {
  factory $ParallelExec_OkCopyWith(ParallelExec_Ok value, $Res Function(ParallelExec_Ok) _then) = _$ParallelExec_OkCopyWithImpl;
@useResult
$Res call({
 List<WasmVal> field0
});




}
/// @nodoc
class _$ParallelExec_OkCopyWithImpl<$Res>
    implements $ParallelExec_OkCopyWith<$Res> {
  _$ParallelExec_OkCopyWithImpl(this._self, this._then);

  final ParallelExec_Ok _self;
  final $Res Function(ParallelExec_Ok) _then;

/// Create a copy of ParallelExec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ParallelExec_Ok(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<WasmVal>,
  ));
}


}

/// @nodoc


class ParallelExec_Err extends ParallelExec {
  const ParallelExec_Err(this.field0): super._();
  

@override final  String field0;

/// Create a copy of ParallelExec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParallelExec_ErrCopyWith<ParallelExec_Err> get copyWith => _$ParallelExec_ErrCopyWithImpl<ParallelExec_Err>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParallelExec_Err&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ParallelExec.err(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ParallelExec_ErrCopyWith<$Res> implements $ParallelExecCopyWith<$Res> {
  factory $ParallelExec_ErrCopyWith(ParallelExec_Err value, $Res Function(ParallelExec_Err) _then) = _$ParallelExec_ErrCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$ParallelExec_ErrCopyWithImpl<$Res>
    implements $ParallelExec_ErrCopyWith<$Res> {
  _$ParallelExec_ErrCopyWithImpl(this._self, this._then);

  final ParallelExec_Err _self;
  final $Res Function(ParallelExec_Err) _then;

/// Create a copy of ParallelExec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ParallelExec_Err(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ParallelExec_Call extends ParallelExec {
  const ParallelExec_Call(this.field0): super._();
  

@override final  FunctionCall field0;

/// Create a copy of ParallelExec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParallelExec_CallCopyWith<ParallelExec_Call> get copyWith => _$ParallelExec_CallCopyWithImpl<ParallelExec_Call>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParallelExec_Call&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'ParallelExec.call(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $ParallelExec_CallCopyWith<$Res> implements $ParallelExecCopyWith<$Res> {
  factory $ParallelExec_CallCopyWith(ParallelExec_Call value, $Res Function(ParallelExec_Call) _then) = _$ParallelExec_CallCopyWithImpl;
@useResult
$Res call({
 FunctionCall field0
});




}
/// @nodoc
class _$ParallelExec_CallCopyWithImpl<$Res>
    implements $ParallelExec_CallCopyWith<$Res> {
  _$ParallelExec_CallCopyWithImpl(this._self, this._then);

  final ParallelExec_Call _self;
  final $Res Function(ParallelExec_Call) _then;

/// Create a copy of ParallelExec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(ParallelExec_Call(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as FunctionCall,
  ));
}


}

/// @nodoc
mixin _$WasmVal {

 Object? get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'WasmVal(field0: $field0)';
}


}

/// @nodoc
class $WasmValCopyWith<$Res>  {
$WasmValCopyWith(WasmVal _, $Res Function(WasmVal) __);
}


/// Adds pattern-matching-related methods to [WasmVal].
extension WasmValPatterns on WasmVal {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WasmVal_i32 value)?  i32,TResult Function( WasmVal_i64 value)?  i64,TResult Function( WasmVal_f32 value)?  f32,TResult Function( WasmVal_f64 value)?  f64,TResult Function( WasmVal_v128 value)?  v128,TResult Function( WasmVal_funcRef value)?  funcRef,TResult Function( WasmVal_externRef value)?  externRef,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WasmVal_i32() when i32 != null:
return i32(_that);case WasmVal_i64() when i64 != null:
return i64(_that);case WasmVal_f32() when f32 != null:
return f32(_that);case WasmVal_f64() when f64 != null:
return f64(_that);case WasmVal_v128() when v128 != null:
return v128(_that);case WasmVal_funcRef() when funcRef != null:
return funcRef(_that);case WasmVal_externRef() when externRef != null:
return externRef(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WasmVal_i32 value)  i32,required TResult Function( WasmVal_i64 value)  i64,required TResult Function( WasmVal_f32 value)  f32,required TResult Function( WasmVal_f64 value)  f64,required TResult Function( WasmVal_v128 value)  v128,required TResult Function( WasmVal_funcRef value)  funcRef,required TResult Function( WasmVal_externRef value)  externRef,}){
final _that = this;
switch (_that) {
case WasmVal_i32():
return i32(_that);case WasmVal_i64():
return i64(_that);case WasmVal_f32():
return f32(_that);case WasmVal_f64():
return f64(_that);case WasmVal_v128():
return v128(_that);case WasmVal_funcRef():
return funcRef(_that);case WasmVal_externRef():
return externRef(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WasmVal_i32 value)?  i32,TResult? Function( WasmVal_i64 value)?  i64,TResult? Function( WasmVal_f32 value)?  f32,TResult? Function( WasmVal_f64 value)?  f64,TResult? Function( WasmVal_v128 value)?  v128,TResult? Function( WasmVal_funcRef value)?  funcRef,TResult? Function( WasmVal_externRef value)?  externRef,}){
final _that = this;
switch (_that) {
case WasmVal_i32() when i32 != null:
return i32(_that);case WasmVal_i64() when i64 != null:
return i64(_that);case WasmVal_f32() when f32 != null:
return f32(_that);case WasmVal_f64() when f64 != null:
return f64(_that);case WasmVal_v128() when v128 != null:
return v128(_that);case WasmVal_funcRef() when funcRef != null:
return funcRef(_that);case WasmVal_externRef() when externRef != null:
return externRef(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int field0)?  i32,TResult Function( PlatformInt64 field0)?  i64,TResult Function( double field0)?  f32,TResult Function( double field0)?  f64,TResult Function( U8Array16 field0)?  v128,TResult Function( WFunc? field0)?  funcRef,TResult Function( int? field0)?  externRef,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WasmVal_i32() when i32 != null:
return i32(_that.field0);case WasmVal_i64() when i64 != null:
return i64(_that.field0);case WasmVal_f32() when f32 != null:
return f32(_that.field0);case WasmVal_f64() when f64 != null:
return f64(_that.field0);case WasmVal_v128() when v128 != null:
return v128(_that.field0);case WasmVal_funcRef() when funcRef != null:
return funcRef(_that.field0);case WasmVal_externRef() when externRef != null:
return externRef(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int field0)  i32,required TResult Function( PlatformInt64 field0)  i64,required TResult Function( double field0)  f32,required TResult Function( double field0)  f64,required TResult Function( U8Array16 field0)  v128,required TResult Function( WFunc? field0)  funcRef,required TResult Function( int? field0)  externRef,}) {final _that = this;
switch (_that) {
case WasmVal_i32():
return i32(_that.field0);case WasmVal_i64():
return i64(_that.field0);case WasmVal_f32():
return f32(_that.field0);case WasmVal_f64():
return f64(_that.field0);case WasmVal_v128():
return v128(_that.field0);case WasmVal_funcRef():
return funcRef(_that.field0);case WasmVal_externRef():
return externRef(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int field0)?  i32,TResult? Function( PlatformInt64 field0)?  i64,TResult? Function( double field0)?  f32,TResult? Function( double field0)?  f64,TResult? Function( U8Array16 field0)?  v128,TResult? Function( WFunc? field0)?  funcRef,TResult? Function( int? field0)?  externRef,}) {final _that = this;
switch (_that) {
case WasmVal_i32() when i32 != null:
return i32(_that.field0);case WasmVal_i64() when i64 != null:
return i64(_that.field0);case WasmVal_f32() when f32 != null:
return f32(_that.field0);case WasmVal_f64() when f64 != null:
return f64(_that.field0);case WasmVal_v128() when v128 != null:
return v128(_that.field0);case WasmVal_funcRef() when funcRef != null:
return funcRef(_that.field0);case WasmVal_externRef() when externRef != null:
return externRef(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class WasmVal_i32 extends WasmVal {
  const WasmVal_i32(this.field0): super._();
  

@override final  int field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_i32CopyWith<WasmVal_i32> get copyWith => _$WasmVal_i32CopyWithImpl<WasmVal_i32>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_i32&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WasmVal.i32(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_i32CopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_i32CopyWith(WasmVal_i32 value, $Res Function(WasmVal_i32) _then) = _$WasmVal_i32CopyWithImpl;
@useResult
$Res call({
 int field0
});




}
/// @nodoc
class _$WasmVal_i32CopyWithImpl<$Res>
    implements $WasmVal_i32CopyWith<$Res> {
  _$WasmVal_i32CopyWithImpl(this._self, this._then);

  final WasmVal_i32 _self;
  final $Res Function(WasmVal_i32) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WasmVal_i32(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class WasmVal_i64 extends WasmVal {
  const WasmVal_i64(this.field0): super._();
  

@override final  PlatformInt64 field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_i64CopyWith<WasmVal_i64> get copyWith => _$WasmVal_i64CopyWithImpl<WasmVal_i64>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_i64&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WasmVal.i64(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_i64CopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_i64CopyWith(WasmVal_i64 value, $Res Function(WasmVal_i64) _then) = _$WasmVal_i64CopyWithImpl;
@useResult
$Res call({
 PlatformInt64 field0
});




}
/// @nodoc
class _$WasmVal_i64CopyWithImpl<$Res>
    implements $WasmVal_i64CopyWith<$Res> {
  _$WasmVal_i64CopyWithImpl(this._self, this._then);

  final WasmVal_i64 _self;
  final $Res Function(WasmVal_i64) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WasmVal_i64(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as PlatformInt64,
  ));
}


}

/// @nodoc


class WasmVal_f32 extends WasmVal {
  const WasmVal_f32(this.field0): super._();
  

@override final  double field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_f32CopyWith<WasmVal_f32> get copyWith => _$WasmVal_f32CopyWithImpl<WasmVal_f32>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_f32&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WasmVal.f32(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_f32CopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_f32CopyWith(WasmVal_f32 value, $Res Function(WasmVal_f32) _then) = _$WasmVal_f32CopyWithImpl;
@useResult
$Res call({
 double field0
});




}
/// @nodoc
class _$WasmVal_f32CopyWithImpl<$Res>
    implements $WasmVal_f32CopyWith<$Res> {
  _$WasmVal_f32CopyWithImpl(this._self, this._then);

  final WasmVal_f32 _self;
  final $Res Function(WasmVal_f32) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WasmVal_f32(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class WasmVal_f64 extends WasmVal {
  const WasmVal_f64(this.field0): super._();
  

@override final  double field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_f64CopyWith<WasmVal_f64> get copyWith => _$WasmVal_f64CopyWithImpl<WasmVal_f64>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_f64&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WasmVal.f64(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_f64CopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_f64CopyWith(WasmVal_f64 value, $Res Function(WasmVal_f64) _then) = _$WasmVal_f64CopyWithImpl;
@useResult
$Res call({
 double field0
});




}
/// @nodoc
class _$WasmVal_f64CopyWithImpl<$Res>
    implements $WasmVal_f64CopyWith<$Res> {
  _$WasmVal_f64CopyWithImpl(this._self, this._then);

  final WasmVal_f64 _self;
  final $Res Function(WasmVal_f64) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WasmVal_f64(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class WasmVal_v128 extends WasmVal {
  const WasmVal_v128(this.field0): super._();
  

@override final  U8Array16 field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_v128CopyWith<WasmVal_v128> get copyWith => _$WasmVal_v128CopyWithImpl<WasmVal_v128>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_v128&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'WasmVal.v128(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_v128CopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_v128CopyWith(WasmVal_v128 value, $Res Function(WasmVal_v128) _then) = _$WasmVal_v128CopyWithImpl;
@useResult
$Res call({
 U8Array16 field0
});




}
/// @nodoc
class _$WasmVal_v128CopyWithImpl<$Res>
    implements $WasmVal_v128CopyWith<$Res> {
  _$WasmVal_v128CopyWithImpl(this._self, this._then);

  final WasmVal_v128 _self;
  final $Res Function(WasmVal_v128) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(WasmVal_v128(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as U8Array16,
  ));
}


}

/// @nodoc


class WasmVal_funcRef extends WasmVal {
  const WasmVal_funcRef([this.field0]): super._();
  

@override final  WFunc? field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_funcRefCopyWith<WasmVal_funcRef> get copyWith => _$WasmVal_funcRefCopyWithImpl<WasmVal_funcRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_funcRef&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WasmVal.funcRef(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_funcRefCopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_funcRefCopyWith(WasmVal_funcRef value, $Res Function(WasmVal_funcRef) _then) = _$WasmVal_funcRefCopyWithImpl;
@useResult
$Res call({
 WFunc? field0
});




}
/// @nodoc
class _$WasmVal_funcRefCopyWithImpl<$Res>
    implements $WasmVal_funcRefCopyWith<$Res> {
  _$WasmVal_funcRefCopyWithImpl(this._self, this._then);

  final WasmVal_funcRef _self;
  final $Res Function(WasmVal_funcRef) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = freezed,}) {
  return _then(WasmVal_funcRef(
freezed == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as WFunc?,
  ));
}


}

/// @nodoc


class WasmVal_externRef extends WasmVal {
  const WasmVal_externRef([this.field0]): super._();
  

@override final  int? field0;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WasmVal_externRefCopyWith<WasmVal_externRef> get copyWith => _$WasmVal_externRefCopyWithImpl<WasmVal_externRef>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WasmVal_externRef&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'WasmVal.externRef(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $WasmVal_externRefCopyWith<$Res> implements $WasmValCopyWith<$Res> {
  factory $WasmVal_externRefCopyWith(WasmVal_externRef value, $Res Function(WasmVal_externRef) _then) = _$WasmVal_externRefCopyWithImpl;
@useResult
$Res call({
 int? field0
});




}
/// @nodoc
class _$WasmVal_externRefCopyWithImpl<$Res>
    implements $WasmVal_externRefCopyWith<$Res> {
  _$WasmVal_externRefCopyWithImpl(this._self, this._then);

  final WasmVal_externRef _self;
  final $Res Function(WasmVal_externRef) _then;

/// Create a copy of WasmVal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = freezed,}) {
  return _then(WasmVal_externRef(
freezed == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
