# flutter_exp

This is personal experiments of Flutter.

This repository is published under MIT license just to keep copyrights.

## Experiments

* Dependency management with [Riverpod](https://pub.dev/packages/riverpod)
* "MVVM" architecture with [State Notifier](https://pub.dev/packages/state_notifier)
* [UI stack](https://www.scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack/) based presenter/view state transition with [freezed](https://pub.dev/packages/freezed)
* FFI (Windows) with [win32](https://pub.dev/packages/win32)
  * It looks easier than channel for Win32. But it might be deprecated with UWP which supports modern features like OAuth2 client support etc.
* Validation with [Form Validator](https://pub.dev/packages/form_validator)
* L10N with [EasyLocalization](https://pub.dev/packages/easy_localization)
  * I choose this because it supports null-safety.
* Menu - route synchronization.
