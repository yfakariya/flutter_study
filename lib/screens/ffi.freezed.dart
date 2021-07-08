// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'ffi.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$FfiStateTearOff {
  const _$FfiStateTearOff();

  FfiStateCompleted completed({String? result, required String filePath}) {
    return FfiStateCompleted(
      result: result,
      filePath: filePath,
    );
  }

  FfiStatePartial partial() {
    return FfiStatePartial();
  }
}

/// @nodoc
const $FfiState = _$FfiStateTearOff();

/// @nodoc
mixin _$FfiState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? result, String filePath) completed,
    required TResult Function() partial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? result, String filePath)? completed,
    TResult Function()? partial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FfiStateCompleted value) completed,
    required TResult Function(FfiStatePartial value) partial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FfiStateCompleted value)? completed,
    TResult Function(FfiStatePartial value)? partial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FfiStateCopyWith<$Res> {
  factory $FfiStateCopyWith(FfiState value, $Res Function(FfiState) then) =
      _$FfiStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$FfiStateCopyWithImpl<$Res> implements $FfiStateCopyWith<$Res> {
  _$FfiStateCopyWithImpl(this._value, this._then);

  final FfiState _value;
  // ignore: unused_field
  final $Res Function(FfiState) _then;
}

/// @nodoc
abstract class $FfiStateCompletedCopyWith<$Res> {
  factory $FfiStateCompletedCopyWith(
          FfiStateCompleted value, $Res Function(FfiStateCompleted) then) =
      _$FfiStateCompletedCopyWithImpl<$Res>;
  $Res call({String? result, String filePath});
}

/// @nodoc
class _$FfiStateCompletedCopyWithImpl<$Res> extends _$FfiStateCopyWithImpl<$Res>
    implements $FfiStateCompletedCopyWith<$Res> {
  _$FfiStateCompletedCopyWithImpl(
      FfiStateCompleted _value, $Res Function(FfiStateCompleted) _then)
      : super(_value, (v) => _then(v as FfiStateCompleted));

  @override
  FfiStateCompleted get _value => super._value as FfiStateCompleted;

  @override
  $Res call({
    Object? result = freezed,
    Object? filePath = freezed,
  }) {
    return _then(FfiStateCompleted(
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      filePath: filePath == freezed
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FfiStateCompleted implements FfiStateCompleted {
  _$FfiStateCompleted({this.result, required this.filePath});

  @override
  final String? result;
  @override
  final String filePath;

  @override
  String toString() {
    return 'FfiState.completed(result: $result, filePath: $filePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FfiStateCompleted &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)) &&
            (identical(other.filePath, filePath) ||
                const DeepCollectionEquality()
                    .equals(other.filePath, filePath)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(result) ^
      const DeepCollectionEquality().hash(filePath);

  @JsonKey(ignore: true)
  @override
  $FfiStateCompletedCopyWith<FfiStateCompleted> get copyWith =>
      _$FfiStateCompletedCopyWithImpl<FfiStateCompleted>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? result, String filePath) completed,
    required TResult Function() partial,
  }) {
    return completed(result, filePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? result, String filePath)? completed,
    TResult Function()? partial,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(result, filePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FfiStateCompleted value) completed,
    required TResult Function(FfiStatePartial value) partial,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FfiStateCompleted value)? completed,
    TResult Function(FfiStatePartial value)? partial,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class FfiStateCompleted implements FfiState {
  factory FfiStateCompleted({String? result, required String filePath}) =
      _$FfiStateCompleted;

  String? get result => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FfiStateCompletedCopyWith<FfiStateCompleted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FfiStatePartialCopyWith<$Res> {
  factory $FfiStatePartialCopyWith(
          FfiStatePartial value, $Res Function(FfiStatePartial) then) =
      _$FfiStatePartialCopyWithImpl<$Res>;
}

/// @nodoc
class _$FfiStatePartialCopyWithImpl<$Res> extends _$FfiStateCopyWithImpl<$Res>
    implements $FfiStatePartialCopyWith<$Res> {
  _$FfiStatePartialCopyWithImpl(
      FfiStatePartial _value, $Res Function(FfiStatePartial) _then)
      : super(_value, (v) => _then(v as FfiStatePartial));

  @override
  FfiStatePartial get _value => super._value as FfiStatePartial;
}

/// @nodoc

class _$FfiStatePartial implements FfiStatePartial {
  _$FfiStatePartial();

  @override
  String toString() {
    return 'FfiState.partial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is FfiStatePartial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? result, String filePath) completed,
    required TResult Function() partial,
  }) {
    return partial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? result, String filePath)? completed,
    TResult Function()? partial,
    required TResult orElse(),
  }) {
    if (partial != null) {
      return partial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FfiStateCompleted value) completed,
    required TResult Function(FfiStatePartial value) partial,
  }) {
    return partial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FfiStateCompleted value)? completed,
    TResult Function(FfiStatePartial value)? partial,
    required TResult orElse(),
  }) {
    if (partial != null) {
      return partial(this);
    }
    return orElse();
  }
}

abstract class FfiStatePartial implements FfiState {
  factory FfiStatePartial() = _$FfiStatePartial;
}
