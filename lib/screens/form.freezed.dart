// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AFormStateTearOff {
  const _$AFormStateTearOff();

  AFormStatePartial partial({String? stringValue}) {
    return AFormStatePartial(
      stringValue: stringValue,
    );
  }

  AFormStateCompleted completed({required String stringValue}) {
    return AFormStateCompleted(
      stringValue: stringValue,
    );
  }
}

/// @nodoc
const $AFormState = _$AFormStateTearOff();

/// @nodoc
mixin _$AFormState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? stringValue) partial,
    required TResult Function(String stringValue) completed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? stringValue)? partial,
    TResult Function(String stringValue)? completed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AFormStatePartial value) partial,
    required TResult Function(AFormStateCompleted value) completed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AFormStatePartial value)? partial,
    TResult Function(AFormStateCompleted value)? completed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AFormStateCopyWith<$Res> {
  factory $AFormStateCopyWith(
          AFormState value, $Res Function(AFormState) then) =
      _$AFormStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AFormStateCopyWithImpl<$Res> implements $AFormStateCopyWith<$Res> {
  _$AFormStateCopyWithImpl(this._value, this._then);

  final AFormState _value;
  // ignore: unused_field
  final $Res Function(AFormState) _then;
}

/// @nodoc
abstract class $AFormStatePartialCopyWith<$Res> {
  factory $AFormStatePartialCopyWith(
          AFormStatePartial value, $Res Function(AFormStatePartial) then) =
      _$AFormStatePartialCopyWithImpl<$Res>;
  $Res call({String? stringValue});
}

/// @nodoc
class _$AFormStatePartialCopyWithImpl<$Res>
    extends _$AFormStateCopyWithImpl<$Res>
    implements $AFormStatePartialCopyWith<$Res> {
  _$AFormStatePartialCopyWithImpl(
      AFormStatePartial _value, $Res Function(AFormStatePartial) _then)
      : super(_value, (v) => _then(v as AFormStatePartial));

  @override
  AFormStatePartial get _value => super._value as AFormStatePartial;

  @override
  $Res call({
    Object? stringValue = freezed,
  }) {
    return _then(AFormStatePartial(
      stringValue: stringValue == freezed
          ? _value.stringValue
          : stringValue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AFormStatePartial implements AFormStatePartial {
  _$AFormStatePartial({this.stringValue});

  @override
  final String? stringValue;

  @override
  String toString() {
    return 'AFormState.partial(stringValue: $stringValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AFormStatePartial &&
            (identical(other.stringValue, stringValue) ||
                const DeepCollectionEquality()
                    .equals(other.stringValue, stringValue)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(stringValue);

  @JsonKey(ignore: true)
  @override
  $AFormStatePartialCopyWith<AFormStatePartial> get copyWith =>
      _$AFormStatePartialCopyWithImpl<AFormStatePartial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? stringValue) partial,
    required TResult Function(String stringValue) completed,
  }) {
    return partial(stringValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? stringValue)? partial,
    TResult Function(String stringValue)? completed,
    required TResult orElse(),
  }) {
    if (partial != null) {
      return partial(stringValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AFormStatePartial value) partial,
    required TResult Function(AFormStateCompleted value) completed,
  }) {
    return partial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AFormStatePartial value)? partial,
    TResult Function(AFormStateCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (partial != null) {
      return partial(this);
    }
    return orElse();
  }
}

abstract class AFormStatePartial implements AFormState {
  factory AFormStatePartial({String? stringValue}) = _$AFormStatePartial;

  String? get stringValue => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AFormStatePartialCopyWith<AFormStatePartial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AFormStateCompletedCopyWith<$Res> {
  factory $AFormStateCompletedCopyWith(
          AFormStateCompleted value, $Res Function(AFormStateCompleted) then) =
      _$AFormStateCompletedCopyWithImpl<$Res>;
  $Res call({String stringValue});
}

/// @nodoc
class _$AFormStateCompletedCopyWithImpl<$Res>
    extends _$AFormStateCopyWithImpl<$Res>
    implements $AFormStateCompletedCopyWith<$Res> {
  _$AFormStateCompletedCopyWithImpl(
      AFormStateCompleted _value, $Res Function(AFormStateCompleted) _then)
      : super(_value, (v) => _then(v as AFormStateCompleted));

  @override
  AFormStateCompleted get _value => super._value as AFormStateCompleted;

  @override
  $Res call({
    Object? stringValue = freezed,
  }) {
    return _then(AFormStateCompleted(
      stringValue: stringValue == freezed
          ? _value.stringValue
          : stringValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AFormStateCompleted implements AFormStateCompleted {
  _$AFormStateCompleted({required this.stringValue});

  @override
  final String stringValue;

  @override
  String toString() {
    return 'AFormState.completed(stringValue: $stringValue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AFormStateCompleted &&
            (identical(other.stringValue, stringValue) ||
                const DeepCollectionEquality()
                    .equals(other.stringValue, stringValue)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(stringValue);

  @JsonKey(ignore: true)
  @override
  $AFormStateCompletedCopyWith<AFormStateCompleted> get copyWith =>
      _$AFormStateCompletedCopyWithImpl<AFormStateCompleted>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? stringValue) partial,
    required TResult Function(String stringValue) completed,
  }) {
    return completed(stringValue);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? stringValue)? partial,
    TResult Function(String stringValue)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(stringValue);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AFormStatePartial value) partial,
    required TResult Function(AFormStateCompleted value) completed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AFormStatePartial value)? partial,
    TResult Function(AFormStateCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class AFormStateCompleted implements AFormState {
  factory AFormStateCompleted({required String stringValue}) =
      _$AFormStateCompleted;

  String get stringValue => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AFormStateCompletedCopyWith<AFormStateCompleted> get copyWith =>
      throw _privateConstructorUsedError;
}
