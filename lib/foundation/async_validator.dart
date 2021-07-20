// See LICENCE file in the root.

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'async_operation_result_notifier.dart';

// TODO: test with samples.

/// A function represents async validation invocation.
///
/// It takes target value, which may be `null`,
/// and then returns validation error message if the value is not valid,
/// or returns `null` if the value is valid.
typedef AsyncValidator<T> = Future<String?> Function(T? value, Locale locale);

class ValidationTarget<T> {
  final T value;
  final Locale locale;
  final VoidCallback onCompleted;

  ValidationTarget({
    required this.value,
    required this.locale,
    required this.onCompleted,
  });
}

// TODO: この人が値を受け取ってバリデーションロジックをコンストラクターで受け取るから話がおかしくなる。
//       処理ごと受け取って、非同期処理をコールバックに直す & スロットリングにすればいい。
//       →本当に？
/// Implements async validation with caching.
class AsyncValidatorExecutor_<T>
    extends AsyncOperationResultNotifier<ValidationTarget<T?>, String?> {
  final AsyncValidator<T> _asyncValidator;

  bool get validating => this.hasPendingOperation;

  AsyncValidatorExecutor_({
    /// Async validation process invocation.
    required AsyncValidator<T> asyncValidator,

    /// [Equality] to be used cache resolution.
    ///
    /// If omitted, [EqualityBy] will be used.
    Equality<T?>? equality,
    AsyncErrorHandler? canceledValidationErrorHandler,
  })  : _asyncValidator = asyncValidator,
        super(
            parameterEquality: EqualityBy<ValidationTarget<T?>, T?>(
              (x) => x.value,
              equality ?? Equality(),
            ),
            canceledOperationErrorHandler: canceledValidationErrorHandler);

  @override
  Future<String?> executeAsync(ValidationTarget<T?> value) =>
      _asyncValidator(value.value, value.locale);
}

class ValidationInvocation<T> implements CompletionNotifier {
  final T value;
  final AsyncValidator<T> validator;
  final Locale locale;
  final VoidCallback onCompleted;

  ValidationInvocation({
    required this.validator,
    required this.value,
    required this.locale,
    required this.onCompleted,
  });
}

class AsyncValidatorExecutor<T>
    extends FutureInvoker<ValidationInvocation<T?>, String?> {
  /// Indicates that whether this executor validating asynchronously or not.
  bool get validating => this.hasPendingOperation;

  /// Creates a new [AsyncValidatorExecutor]
  AsyncValidatorExecutor({
    /// [Equality] to be used cache resolution.
    ///
    /// If omitted, [EqualityBy] will be used.
    Equality<T?>? equality,
    AsyncErrorHandler? canceledValidationErrorHandler,
  }) : super(
            parameterEquality: EqualityBy<ValidationInvocation<T?>, T?>(
              (x) => x.value,
              equality ?? Equality(),
            ),
            canceledOperationErrorHandler: canceledValidationErrorHandler);

  @override
  Future<String?> executeAsync(ValidationInvocation<T?> parameter) =>
      parameter.validator(parameter.value, parameter.locale);

  /// Validates specified value with specified [AsyncValidator] and [Locale].
  ///
  /// This method just calls [execute].
  String? validate(
    AsyncValidator<T> validator,
    T? value,
    Locale locale,
    VoidCallback onCompleted,
  ) =>
      execute(
        ValidationInvocation(
            validator: validator,
            value: value,
            locale: locale,
            onCompleted: onCompleted),
      );
}
