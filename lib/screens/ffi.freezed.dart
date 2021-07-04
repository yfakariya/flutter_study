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

  FfiStateDefault call({String? result, required bool isValid}) {
    return FfiStateDefault(
      result: result,
      isValid: isValid,
    );
  }
}

/// @nodoc
const $FfiState = _$FfiStateTearOff();

/// @nodoc
mixin _$FfiState {
  String? get result => throw _privateConstructorUsedError;
  bool get isValid => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FfiStateCopyWith<FfiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FfiStateCopyWith<$Res> {
  factory $FfiStateCopyWith(FfiState value, $Res Function(FfiState) then) =
      _$FfiStateCopyWithImpl<$Res>;
  $Res call({String? result, bool isValid});
}

/// @nodoc
class _$FfiStateCopyWithImpl<$Res> implements $FfiStateCopyWith<$Res> {
  _$FfiStateCopyWithImpl(this._value, this._then);

  final FfiState _value;
  // ignore: unused_field
  final $Res Function(FfiState) _then;

  @override
  $Res call({
    Object? result = freezed,
    Object? isValid = freezed,
  }) {
    return _then(_value.copyWith(
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: isValid == freezed
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class $FfiStateDefaultCopyWith<$Res>
    implements $FfiStateCopyWith<$Res> {
  factory $FfiStateDefaultCopyWith(
          FfiStateDefault value, $Res Function(FfiStateDefault) then) =
      _$FfiStateDefaultCopyWithImpl<$Res>;
  @override
  $Res call({String? result, bool isValid});
}

/// @nodoc
class _$FfiStateDefaultCopyWithImpl<$Res> extends _$FfiStateCopyWithImpl<$Res>
    implements $FfiStateDefaultCopyWith<$Res> {
  _$FfiStateDefaultCopyWithImpl(
      FfiStateDefault _value, $Res Function(FfiStateDefault) _then)
      : super(_value, (v) => _then(v as FfiStateDefault));

  @override
  FfiStateDefault get _value => super._value as FfiStateDefault;

  @override
  $Res call({
    Object? result = freezed,
    Object? isValid = freezed,
  }) {
    return _then(FfiStateDefault(
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: isValid == freezed
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FfiStateDefault implements FfiStateDefault {
  _$FfiStateDefault({this.result, required this.isValid});

  @override
  final String? result;
  @override
  final bool isValid;

  @override
  String toString() {
    return 'FfiState(result: $result, isValid: $isValid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FfiStateDefault &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)) &&
            (identical(other.isValid, isValid) ||
                const DeepCollectionEquality().equals(other.isValid, isValid)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(result) ^
      const DeepCollectionEquality().hash(isValid);

  @JsonKey(ignore: true)
  @override
  $FfiStateDefaultCopyWith<FfiStateDefault> get copyWith =>
      _$FfiStateDefaultCopyWithImpl<FfiStateDefault>(this, _$identity);
}

abstract class FfiStateDefault implements FfiState {
  factory FfiStateDefault({String? result, required bool isValid}) =
      _$FfiStateDefault;

  @override
  String? get result => throw _privateConstructorUsedError;
  @override
  bool get isValid => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $FfiStateDefaultCopyWith<FfiStateDefault> get copyWith =>
      throw _privateConstructorUsedError;
}
