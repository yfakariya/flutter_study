// This file is partial port of RxDart (https://github.com/ReactiveX/rxdart/blob/master/lib/src/transformers/backpressure/debounce.dart)
// which is licensed under Apache2 lisence.

part of 'debounce.dart';

class _BackpressureStreamSink<S, T> implements _ForwardingSink<S, T> {
  final Stream<dynamic> Function(S event)? _windowStreamFactory;
  final T Function(List<S> queue)? _onWindowEnd;
  final Queue<S> queue = DoubleLinkedQueue<S>();
  final int? maxLengthQueue;
  var skip = 0;
  var _hasData = false;
  var _mainClosed = false;
  StreamSubscription<dynamic>? _windowSubscription;

  _BackpressureStreamSink(
    this._windowStreamFactory,
    this._onWindowEnd,
    this.maxLengthQueue,
  );

  @override
  void add(EventSink<T> sink, S data) {
    _hasData = true;
    maybeCreateWindow(data, sink);

    if (skip == 0) {
      queue.add(data);

      if (maxLengthQueue != null && queue.length > maxLengthQueue!) {
        queue.removeFirstElements(queue.length - maxLengthQueue!);
      }
    }

    if (skip > 0) {
      skip--;
    }
  }

  @override
  void addError(EventSink<T> sink, Object e, StackTrace st) =>
      sink.addError(e, st);

  @override
  void close(EventSink<T> sink) {
    _mainClosed = true;

    resolveWindowEnd(sink, true);

    queue.clear();

    _windowSubscription?.cancel();
    sink.close();
  }

  @override
  FutureOr onCancel(EventSink<T> sink) => _windowSubscription?.cancel();

  @override
  void onListen(EventSink<T> sink) {}

  @override
  void onPause(EventSink<T> sink) => _windowSubscription?.pause();

  @override
  void onResume(EventSink<T> sink) => _windowSubscription?.resume();

  void maybeCreateWindow(S event, EventSink<T> sink) {
    _windowSubscription?.cancel();
    _windowSubscription = _singleWindow(event, sink);
  }

  StreamSubscription<dynamic> _singleWindow(S event, EventSink<T> sink) =>
      buildStream(event, sink).take(1).listen(
            null,
            onError: sink.addError,
            onDone: () => resolveWindowEnd(sink, _mainClosed),
          );

  Stream<dynamic> buildStream(S event, EventSink<T> sink) {
    Stream stream;

    _windowSubscription?.cancel();

    stream = _windowStreamFactory!(event);

    return stream;
  }

  void resolveWindowEnd(EventSink<T> sink, [bool isControllerClosing = false]) {
    _windowSubscription?.cancel();
    _windowSubscription = null;

    if (_hasData && (queue.isNotEmpty)) {
      if (_onWindowEnd != null) {
        sink.add(_onWindowEnd!(unmodifiableQueue));
      }

      queue.clear();
    }
  }

  List<S> get unmodifiableQueue => List<S>.unmodifiable(queue);
}

/// A highly customizable [StreamTransformer] which can be configured
/// to serve any of the common rx backpressure operators.
///
/// The [StreamTransformer] works by creating windows, during which it
/// buffers events to a [Queue].
///
/// The [StreamTransformer] works by creating windows, during which it
/// buffers events to a [Queue]. It uses a  [WindowStrategy] to determine
/// how and when a new window is created.
///
/// onWindowStart and onWindowEnd are handlers that fire when a window
/// opens and closes, right before emitting the transformed event.
///
/// startBufferEvery allows to skip events coming from the source [Stream].
///
/// ignoreEmptyWindows can be set to true, to allow events to be emitted
/// at the end of a window, even if the current buffer is empty.
/// If the buffer is empty, then an empty [List] will be emitted.
/// If false, then nothing is emitted on an empty buffer.
///
/// dispatchOnClose will cause the remaining values in the buffer to be
/// emitted when the source [Stream] closes.
/// When false, the remaining buffer is discarded on close.
class _BackpressureStreamTransformer<S, T> extends StreamTransformerBase<S, T> {
  /// Factory method used to create the [Stream] which will be buffered
  final Stream<dynamic> Function(S event)? windowStreamFactory;

  /// Handler which fires when the window closes
  final T Function(List<S> queue)? onWindowEnd;

  /// Maximum length of the buffer.
  /// Specify this value to avoid running out of memory when adding too many events to the buffer.
  /// If it's `null`, maximum length of the buffer is unlimited.
  final int? maxLengthQueue;

  /// Constructs a [StreamTransformer] which buffers events emitted by the
  /// [Stream] that is created by [windowStreamFactory].
  ///
  /// Use the various optional parameters to precisely determine how and when
  /// this buffer should be created.
  ///
  /// For more info on the parameters, see [BackpressureStreamTransformer],
  /// or see the various back pressure [StreamTransformer]s for examples.
  _BackpressureStreamTransformer(
    this.windowStreamFactory, {
    this.onWindowEnd,
    this.maxLengthQueue,
  });

  @override
  Stream<T> bind(Stream<S> stream) {
    final sink = _BackpressureStreamSink(
      windowStreamFactory,
      onWindowEnd,
      maxLengthQueue,
    );
    return _forwardStream(stream, sink);
  }
}

extension _RemoveFirstNQueueExtension<T> on Queue<T> {
  /// Removes the first [count] elements of this queue.
  void removeFirstElements(int count) {
    for (var i = 0; i < count; i++) {
      removeFirst();
    }
  }
}
