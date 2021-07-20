// This file is partial port of RxDart (https://github.com/ReactiveX/rxdart/blob/master/lib/src/transformers/backpressure/debounce.dart)
// which is licensed under Apache2 lisence.

part of 'debounce.dart';
// We would not use subject for debounce...
// import 'subjects.dart';

/// @private
/// Helper method which forwards the events from an incoming [Stream]
/// to a new [StreamController].
/// It captures events such as onListen, onPause, onResume and onCancel,
/// which can be used in pair with a [ForwardingSink]
Stream<R> _forwardStream<T, R>(
    Stream<T> stream, _ForwardingSink<T, R> connectedSink) {
  ArgumentError.checkNotNull(stream, 'stream');
  ArgumentError.checkNotNull(connectedSink, 'connectedSink');

  late StreamController<R> controller;
  late StreamSubscription<T> subscription;

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  void runCatching(void Function() block) {
    try {
      block();
    } catch (e, s) {
      connectedSink.addError(controller, e, s);
    }
  }

  final onListen = () {
    runCatching(() => connectedSink.onListen(controller));

    subscription = stream.listen(
      (data) => runCatching(() => connectedSink.add(controller, data)),
      onError: (Object e, StackTrace st) =>
          runCatching(() => connectedSink.addError(controller, e, st)),
      onDone: () => runCatching(() => connectedSink.close(controller)),
    );
  };

  final onCancel = () {
    final onCancelSelfFuture = subscription.cancel();
    final onCancelConnectedFuture = connectedSink.onCancel(controller);
    final futures = <Future>[
      if (onCancelSelfFuture is Future) onCancelSelfFuture,
      if (onCancelConnectedFuture is Future) onCancelConnectedFuture,
    ];
    return Future.wait<dynamic>(futures);
  };

  final onPause = () {
    subscription.pause();
    runCatching(() => connectedSink.onPause(controller));
  };

  final onResume = () {
    subscription.resume();
    runCatching(() => connectedSink.onResume(controller));
  };

  // We would not use subject for debounce...
  //
  // Create a new Controller, which will serve as a trampoline for
  // forwarded events.
  // if (stream is Subject<T>) {
  //   controller = stream.createForwardingSubject<R>(
  //     onListen: onListen,
  //     onCancel: onCancel,
  //     sync: true,
  //   );
  // } else
  if (stream.isBroadcast) {
    controller = StreamController<R>.broadcast(
      onListen: onListen,
      onCancel: onCancel,
      sync: true,
    );
  } else {
    controller = StreamController<R>(
      onListen: onListen,
      onPause: onPause,
      onResume: onResume,
      onCancel: onCancel,
      sync: true,
    );
  }

  return controller.stream;
}
