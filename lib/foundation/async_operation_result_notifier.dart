// See LICENCE file in the root.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'debounce/debounce.dart';

enum AsyncOperationStatus { initial, inProgress, completed, failed }

@sealed
class AsyncOperationState<P, R> {
  final _ValueHolder<P>? _parameter;
  P? get parameter => _parameter?.value;
  bool get hasParameter => _parameter != null;
  final R? result;
  bool get hasResult => status == AsyncOperationStatus.completed;
  final AsyncError? error;
  bool get hasError => status == AsyncOperationStatus.failed;
  final AsyncOperationStatus status;

  AsyncOperationState._(this.result, this.error, this._parameter, this.status);

  factory AsyncOperationState.completed(
    P parameter,
    R? result,
  ) =>
      AsyncOperationState._(
        result,
        null,
        _ValueHolder(parameter),
        AsyncOperationStatus.completed,
      );

  factory AsyncOperationState.failed(
    P parameter,
    Object error,
    StackTrace stackTrace,
  ) =>
      AsyncOperationState._(
        null,
        AsyncError(error, stackTrace),
        _ValueHolder(parameter),
        AsyncOperationStatus.failed,
      );

  factory AsyncOperationState.initial(
    R? initialValue,
  ) =>
      AsyncOperationState._(
        initialValue,
        null,
        null,
        AsyncOperationStatus.initial,
      );

  factory AsyncOperationState.inProgress(
    P parameter,
    R? lastValue,
  ) =>
      AsyncOperationState._(
        lastValue,
        null,
        _ValueHolder(parameter),
        AsyncOperationStatus.inProgress,
      );
}

@sealed
class _ValueHolder<T> {
  T value;

  _ValueHolder(this.value);
}

typedef AsyncErrorHandler = void Function(AsyncError error);

/// Turns [Future] based async operation to [ValueNotifier] based state machine.
///
/// Most of [Widget] does not handle [Future] gracefully, but they can handle
/// [ChangeNotifier] (and [ValueNotifier]).
/// So, this class helps translated [Future] based asynchronous operation
/// to [ValueNotifier] based notification.
abstract class AsyncOperationResultNotifier<P, R>
    extends ValueNotifier<AsyncOperationState<P, R>> {
  final AsyncErrorHandler? _canceledOperationErrorHandler;
  // final StreamController<P> _invocationController;
  final Equality<P?> _parameterEquality;
  //
  // _ValueHolder<P>? _lastInvocationParameter;

  _ValueHolder<P>? _nextValue;
  _ValueHolder<P>? _processingValue;

  Object? _runningOperationCookie;
  bool get hasPendingOperation => this._runningOperationCookie != null;

  /// Creates new [AsyncOperationResultNotifier].
  ///
  /// The [initialValue] is logical initial value of this operation.
  /// This value will be returned from [execute]
  /// until the async operation completion.
  /// If you do not specify this "initial value", `null` will be used.
  /// This is reasonble default for many cases including form field validation.
  ///
  /// The [canceledOperationErrorHandler] is a callback which is called
  /// when the pending operation is canceled via [cancel] or [reset] and
  /// the operation failed with error.
  /// You can use the handler to handle error such as error logging to improve
  /// product quality.
  AsyncOperationResultNotifier({
    R? initialValue,
    AsyncErrorHandler? canceledOperationErrorHandler,
    // Duration debounceDuration = const Duration(milliseconds: 1000),
    Equality<P> parameterEquality = const Equality(),
  })  : _canceledOperationErrorHandler = canceledOperationErrorHandler,
        // this._invocationController = StreamController(),
        _parameterEquality = parameterEquality,
        super(AsyncOperationState.initial(initialValue)) {
    // this
    //     ._invocationController
    //     .stream
    //     .debounceTime(debounceDuration)
    //     .forEach((p) => this._executeAsync(/*p, Object()*/));
  }

  // @override
  // void dispose() {
  //   print('dispose AORN');
  //   _invocationController.close();
  //   super.dispose();
  // }

  bool _isAlreadyHandled(P? parameter) {
    // final holder = this._lastInvocationParameter;
    // if (holder == null) {
    //   // first
    //   print('first call');
    //   return false;
    // }

    // print(
    //     'non-first call (equals: (${_parameterEquality.equals(holder.value, parameter)}))');
    // return this._parameterEquality.equals(holder.value, parameter);
    final last = value;
    if (!last.hasParameter) {
      // first
      print('first call');
      return false;
    }

    print(
      'non-first call (equals: (${_parameterEquality.equals(last.parameter, parameter)}))',
    );
    return _parameterEquality.equals(last.parameter, parameter);
  }

  /// Execute the asynchronous operation.
  ///
  /// This method behaves differently for past [execute] call and its result.
  /// If the past operation with same [parameter] was completed successfully,
  /// this method returns its result.
  /// If the past operation with same [parameter] was failed with error,
  /// this method throws it as [AsyncError].
  /// If the past operation with same [parameter] is still in-progress,
  /// this method do nothing and returns "initial value".
  /// Else, this method initiate async operation (call [executeAsync]),
  /// and returns "initial value".
  ///
  /// Note that you can change the state with [reset] or [cancel] method.
  /// In addition, this method debounces continous execution.
  R? execute(P parameter) {
    print('execute($parameter)');
    switch (value.status) {
      case AsyncOperationStatus.completed:
        if (_isAlreadyHandled(parameter)) {
          return value.result;
        }
        break;
      case AsyncOperationStatus.failed:
        if (_isAlreadyHandled(parameter)) {
          throw value.error!;
        }
        break;
      case AsyncOperationStatus.initial:
        break;
      case AsyncOperationStatus.inProgress:
        // TODO: ここは現在アクティブなものと同じかどうかを判定する必要がある。
        if (_isAlreadyHandled(parameter)) {
          // Do nothing
          return value.result;
        }

        final processingValue = _processingValue;
        if (processingValue != null &&
            _parameterEquality.equals(processingValue.value, parameter)) {
          // Do nothing
          return value.result;
        }

        break;
    }

    // TODO: RXにせずに、単純に単一バッファに上書き配置でよさそう。。。シングルスレッドモデル難しくない？
    // _invocationController.add(parameter);
    final shouldInvoke = _nextValue == null;
    _nextValue = _ValueHolder(parameter);
    if (shouldInvoke) {
      _executeAsync();
    }

    // Returns "initial value".
    return value.result;
  }

  /// Resets this operation state to initial state
  /// with specified new initial value.
  ///
  /// Note that this method cancels pending operation.
  /// If the pending operation fails in the future,
  /// `canceledOperationErrorHandler`, which was passed in constructor,
  /// will be called.
  ///
  /// This method causes value change notification.
  void reset(R? newInitialValue) {
    value = AsyncOperationState.initial(newInitialValue);
    _runningOperationCookie = null;
    _nextValue = null;
  }

  /// Cancels pending operation.
  ///
  /// If the pending operation fails in the future,
  /// `canceledOperationErrorHandler`, which was passed in constructor,
  /// will be called.
  /// This method do nothing when the pending operation does not exist.
  ///
  /// This method causes value change notification.
  void cancel() {
    if (this._runningOperationCookie != null) {
      value = AsyncOperationState.initial(value.result);
      _runningOperationCookie = null;
      _nextValue = null;
    }
  }

  void _executeAsync(/*P parameter, Object cookie*/) async {
    // this._runningOperationCookie = cookie;

    for (var parameter = _processingValue = _nextValue;
        parameter != null;
        parameter = _processingValue = _nextValue) {
      try {
        value = AsyncOperationState.inProgress(
          parameter.value,
          value.result,
        );
        _nextValue = null;
        final result = await executeAsync(parameter.value);
        // final currentCookie = this._runningOperationCookie;

        // print('${cookie.hashCode} - ${currentCookie.hashCode}');
        // TODO(yfakariya): このロジックだと無限ループするのでCookieをいったん無効化。永遠に値を設定できない。
        //                  たぶん単純に後勝ちにすればいい、はず。→NW超えたとたん追い越しがあるよね
        // if (cookie == currentCookie) {
        value = AsyncOperationState.completed(parameter.value, result);
        // _lastInvocationParameter = _ValueHolder(parameter.value);
        // this._runningOperationCookie = null;
        // }
      }
      // ignore: avoid_catches_without_on_clauses
      catch (error, stackTrace) {
        // final currentCookie = this._runningOperationCookie;

        // if (cookie == currentCookie) {
        // _lastInvocationParameter = _ValueHolder(_processingValue.value);
        value = AsyncOperationState.failed(
          parameter.value,
          error,
          stackTrace,
        );
        // this._runningOperationCookie = null;
        // } else {
        //   final canceledOperationErrorHandler =
        //       this._canceledOperationErrorHandler;
        //   if (canceledOperationErrorHandler != null) {
        //     canceledOperationErrorHandler(AsyncError(error, stackTrace));
        //   } else {
        //     // Zone will be handled.
        //     throw AsyncError(error, stackTrace);
        //   }
        // }
      }
    }
  }

  @visibleForOverriding
  Future<R> executeAsync(P parameter);
}

abstract class CompletionNotifier {
  VoidCallback get onCompleted;
}

/// Turns [Future] based async operation to callback based state machine.
///
/// Most of [Widget] does not handle [Future] gracefully, but they can handle
/// [ChangeNotifier] (and [ValueNotifier]).
/// So, this class helps translated [Future] based asynchronous operation
/// to [ValueNotifier] based notification.
abstract class FutureInvoker<P extends CompletionNotifier, R> {
  final AsyncErrorHandler? _canceledOperationErrorHandler;
  final Equality<P?> _parameterEquality;
  _ValueHolder<P>? _nextValue;
  _ValueHolder<P>? _processingValue;
  AsyncOperationState<P, R> _state;
  bool _cancellationRequested = false;

  bool get hasPendingOperation =>
      _state.status == AsyncOperationStatus.inProgress;

  // TODO: remove
  AsyncOperationStatus get status => _state.status;

  /// Creates new [AsyncOperationResultNotifier].
  ///
  /// The [initialValue] is logical initial value of this operation.
  /// This value will be returned from [execute]
  /// until the async operation completion.
  /// If you do not specify this "initial value", `null` will be used.
  /// This is reasonble default for many cases including form field validation.
  ///
  /// The [canceledOperationErrorHandler] is a callback which is called
  /// when the pending operation is canceled via [cancel] or [reset] and
  /// the operation failed with error.
  /// You can use the handler to handle error such as error logging to improve
  /// product quality.
  FutureInvoker({
    R? initialValue,
    AsyncErrorHandler? canceledOperationErrorHandler,
    Equality<P> parameterEquality = const Equality(),
  })  : _canceledOperationErrorHandler = canceledOperationErrorHandler,
        _parameterEquality = parameterEquality,
        _state = AsyncOperationState.initial(initialValue);

  bool _isAlreadyHandled(P? parameter) {
    final last = _state;
    if (!last.hasParameter) {
      // first
      print('first call');
      return false;
    }

    print(
      'non-first call (equals: (${_parameterEquality.equals(last.parameter, parameter)}))',
    );
    return _parameterEquality.equals(last.parameter, parameter);
  }

  /// Execute the asynchronous operation.
  ///
  /// This method behaves differently for past [execute] call and its result.
  /// If the past operation with same [parameter] was completed successfully,
  /// this method returns its result.
  /// If the past operation with same [parameter] was failed with error,
  /// this method throws it as [AsyncError].
  /// If the past operation with same [parameter] is still in-progress,
  /// this method do nothing and returns "initial value".
  /// Else, this method initiate async operation (call [executeAsync]),
  /// and returns "initial value".
  ///
  /// Note that you can change the state with [reset] or [cancel] method.
  /// In addition, this method debounces continous execution.
  R? execute(P parameter) {
    print('execute($parameter)');
    switch (_state.status) {
      case AsyncOperationStatus.completed:
        if (_isAlreadyHandled(parameter)) {
          return _state.result;
        }
        break;
      case AsyncOperationStatus.failed:
        if (_isAlreadyHandled(parameter)) {
          throw _state.error!;
        }
        break;
      case AsyncOperationStatus.initial:
        break;
      case AsyncOperationStatus.inProgress:
        if (_isAlreadyHandled(parameter)) {
          // Do nothing
          return _state.result;
        }

        final processingValue = _processingValue;
        if (processingValue != null &&
            _parameterEquality.equals(processingValue.value, parameter)) {
          // Do nothing
          return _state.result;
        }

        break;
    }

    final shouldInvoke = _nextValue == null;
    _nextValue = _ValueHolder(parameter);
    if (shouldInvoke) {
      _executeAsync();
    }

    // Returns "initial value".
    return _state.result;
  }

  /// Resets this operation state to initial state
  /// with specified new initial value.
  ///
  /// Note that this method cancels pending operation.
  /// If the pending operation fails in the future,
  /// `canceledOperationErrorHandler`, which was passed in constructor,
  /// will be called.
  ///
  /// This method causes value change notification.
  void reset(R? newInitialValue) {
    _state = AsyncOperationState.initial(newInitialValue);
    _nextValue = null;
    _cancellationRequested = true;
  }

  /// Cancels pending operation.
  ///
  /// If the pending operation fails in the future,
  /// `canceledOperationErrorHandler`, which was passed in constructor,
  /// will be called.
  /// This method do nothing when the pending operation does not exist.
  ///
  /// This method causes value change notification.
  void cancel() {
    _state = AsyncOperationState.initial(_state.result);
    _cancellationRequested = true;
  }

  void _executeAsync() async {
    AsyncOperationState<P, R>? lastState = null;
    for (var parameter = _processingValue = _nextValue;
        parameter != null;
        parameter = _processingValue = _nextValue) {
      try {
        lastState = null;
        _state = AsyncOperationState.inProgress(
          parameter.value,
          _state.result,
        );
        _nextValue = null;
        if (_cancellationRequested) {
          _cancellationRequested = false;
          return;
        }

        final result = await executeAsync(parameter.value);

        if (_cancellationRequested) {
          _cancellationRequested = false;
          return;
        }

        lastState = AsyncOperationState.completed(parameter.value, result);
      }
      // ignore: avoid_catches_without_on_clauses
      catch (error, stackTrace) {
        _state = AsyncOperationState.failed(
          parameter.value,
          error,
          stackTrace,
        );

        if (_cancellationRequested) {
          _cancellationRequested = false;
          return;
        }
      }
    }

    if (lastState != null) {
      _state = lastState;
      lastState.parameter!.onCompleted();
    }
  }

  @visibleForOverriding
  Future<R> executeAsync(P parameter);
}
