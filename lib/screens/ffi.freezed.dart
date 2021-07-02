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

  FfiStateDefault call({String? filePath, String? result}) {
    return FfiStateDefault(
      filePath: filePath,
      result: result,
    );
  }
}

/// @nodoc
const $FfiState = _$FfiStateTearOff();

/// @nodoc
mixin _$FfiState {
  String? get filePath => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FfiStateCopyWith<FfiState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FfiStateCopyWith<$Res> {
  factory $FfiStateCopyWith(FfiState value, $Res Function(FfiState) then) =
      _$FfiStateCopyWithImpl<$Res>;
  $Res call({String? filePath, String? result});
}

/// @nodoc
class _$FfiStateCopyWithImpl<$Res> implements $FfiStateCopyWith<$Res> {
  _$FfiStateCopyWithImpl(this._value, this._then);

  final FfiState _value;
  // ignore: unused_field
  final $Res Function(FfiState) _then;

  @override
  $Res call({
    Object? filePath = freezed,
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      filePath: filePath == freezed
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $Res call({String? filePath, String? result});
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
    Object? filePath = freezed,
    Object? result = freezed,
  }) {
    return _then(FfiStateDefault(
      filePath: filePath == freezed
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
      result: result == freezed
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FfiStateDefault implements FfiStateDefault {
  _$FfiStateDefault({this.filePath, this.result});

  @override
  final String? filePath;
  @override
  final String? result;

  @override
  String toString() {
    return 'FfiState(filePath: $filePath, result: $result)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FfiStateDefault &&
            (identical(other.filePath, filePath) ||
                const DeepCollectionEquality()
                    .equals(other.filePath, filePath)) &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(filePath) ^
      const DeepCollectionEquality().hash(result);

  @JsonKey(ignore: true)
  @override
  $FfiStateDefaultCopyWith<FfiStateDefault> get copyWith =>
      _$FfiStateDefaultCopyWithImpl<FfiStateDefault>(this, _$identity);
}

abstract class FfiStateDefault implements FfiState {
  factory FfiStateDefault({String? filePath, String? result}) =
      _$FfiStateDefault;

  @override
  String? get filePath => throw _privateConstructorUsedError;
  @override
  String? get result => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $FfiStateDefaultCopyWith<FfiStateDefault> get copyWith =>
      throw _privateConstructorUsedError;
}
