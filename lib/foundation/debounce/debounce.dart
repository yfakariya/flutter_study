// This file is partial port of RxDart (https://github.com/ReactiveX/rxdart/blob/master/lib/src/transformers/backpressure/debounce.dart)
// which is licensed under Apache2 lisence.

import 'dart:async';
import 'dart:collection';

part 'backpressure.dart';
part 'forwarding_sink.dart';
part 'forwarding_stream.dart';
part 'timer.dart';

class _DebounceStreamTransformer<T>
    extends _BackpressureStreamTransformer<T, T> {
  /// Constructs a [StreamTransformer] which will only emit items from the source sequence
  /// if a window has completed, without the source sequence emitting.
  ///
  /// The [window] is reset whenever the [Stream] that is being transformed
  /// emits an event.
  _DebounceStreamTransformer(Stream Function(T event) window)
      : super(
          window,
          onWindowEnd: (Iterable<T> queue) => queue.last,
          maxLengthQueue: 1,
        );
}

extension DebounceExtensions<T> on Stream<T> {
  /// Transforms a [Stream] so that will only emit items from the source
  /// sequence whenever the time span defined by [duration] passes, without the
  /// source sequence emitting another item.
  ///
  /// This time span start after the last debounced event was emitted.
  ///
  /// debounceTime filters out items emitted by the source [Stream] that are
  /// rapidly followed by another emitted item.
  ///
  /// [Interactive marble diagram](http://rxmarbles.com/#debounceTime)
  ///
  /// ### Example
  ///
  ///     Stream.fromIterable([1, 2, 3, 4])
  ///       .debounceTime(Duration(seconds: 1))
  ///       .listen(print); // prints 4
  Stream<T> debounceTime(Duration duration) => transform(
      _DebounceStreamTransformer<T>((_) => _TimerStream<void>(null, duration)));
}
