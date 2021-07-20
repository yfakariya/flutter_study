// See LICENCE file in the root.

import 'dart:async' as dart_async;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../../foundation/async_operation_result_notifier.dart';
import '../../foundation/async_validator.dart';

/// Base class for presenters which binds to a form using [FormBuilder].
abstract class FormBuilderPresenter<T> extends StateNotifier<T> {
  // late GlobalKey<FormBuilderState> _formBuilderKey;
  late Map<String, PropertyDescriptor> _properties;

  /// Returns submit callback suitable for `onClick` callback of button
  /// which represents `submit` of form.
  ///
  /// This proeprty returns `null` when [canSubmit] is `false`;
  /// otherwise, this returns [doSubmit] as function type result.
  /// So, the button will be disabled when [canSubmit] is `false`,
  /// and will be enabled otherwise.
  VoidCallback? get submit => canSubmit ? doSubmit : null;

  /// Returns whether the state of this presenter is "completed" or not.
  ///
  /// "Completed" means that:
  /// * All fields for the bound form are set.
  /// * There are no validation errors in the fields of the bound form.
  /// * There are no pending async validations in the fields of the bound form.
  /// * Previous async submit logic is not pending.
  bool get canSubmit;

  /// Creates [FormBuilderPresenter] with its initial state.
  FormBuilderPresenter({
    required T initialState,
    required PropertyDescriptorsBuilder propertiesBuilder,
  }) : super(initialState) {
    // _formBuilderKey = GlobalKey<FormBuilderState>(
    //   debugLabel: runtimeType.toString(),
    // );
    _properties = propertiesBuilder._build(
      handleCanceledAsyncValidationError,
    );
  }

  @visibleForOverriding
  void handleCanceledAsyncValidationError(dart_async.AsyncError error) {
    // nop
  }

  // TODO: onSubmit which will be used from View to complection logic like Navigator
  // TODO: separates FormBuilder dependency to child class
  /// Creates a new [FormBuilder] which is bound to this presenter.
  Widget createForm({
    AutovalidateMode? autovalidateMode,
    required Widget child,
  }) {
    // TODO: なんかリークしない？
    final key = GlobalObjectKey<FormBuilderState>(Object());
    // TODO: ここで、Provider的なものを作りたい……AsyncValidationStateをラップするようなもの。
    return FormBuilder(
      key: key,
      autovalidateMode: autovalidateMode,
      onChanged: (autovalidateMode ?? AutovalidateMode.disabled) ==
              AutovalidateMode.disabled
          ? null
          : () => this._setIsValid(key.currentState!),
      // TODO: wrap with AsyncValidationManager （仮）
      child: child,
    );
  }

  PropertyDescriptor property(String property) {
    final result = _properties[property];
    if (result == null) {
      throw StateError('Property $property is not registered.');
    }

    return result;
  }
  /*

      vm.properties.prop.form((p) => FormBuilderTextField(
        p.name,
        validator: FormBuilderValidators.composite([
          ...p.validators
        ]),

      ));
      */

  void _setIsValid(FormBuilderState state) {
    print('_setIsValid()');
    if (!_properties.values.every(
      (p) => p._asyncValidationExecutionInvokers.every(
        (a) => !a.executor.validating,
      ),
    )) {
      print('  pending async exists.');
      return;
    }

    if (state.fields.values.any((f) => !f.isValid)) {
      print('  any invalid fields.');
      return;
    }

    print('  commit values.');
    commitValues(state.fields.map((k, v) => MapEntry(k, v.value as Object?)));
  }

  /// Implements derived class specific value commit logic.
  ///
  /// This method should store field values to presenters internal state.
  ///
  /// This method will be called iff all fields are valid and
  /// there are no pending async validations.
  ///
  /// After this method is completed, [canSubmit] should return `true`.
  @visibleForOverriding
  void commitValues(
    Map<String, Object?> propertyValues,
  );

  /// A callback will be returned from [submit] when [canSubmit] is `true`.
  @visibleForOverriding
  void doSubmit();
}

typedef FormFieldFactory<F extends FormField<V>, V> = F Function(
  BuildContext context,
  PropertyDescriptor property,
);

// TODO(yfakariya): ここ、ステートフルにしても結局駄目なんじゃ。やりたいのは再バリデーションだよね。
// そうすると、コールバックを都度登録するのが正しい。
//

typedef Validator = String? Function(String? input);
typedef ValidatorFactory = Validator Function(BuildContext context);
// typedef AsyncValidationFactory = AsyncValidation Function(BuildContext context);

@sealed
class PropertyDescriptorsBuilder {
  final Map<String, _PropertyDescriptorSource> _properties = {};

  void add({
    required String name,
    List<ValidatorFactory> validatorFactories = const [],
    List<AsyncValidator> asyncValidators = const [],
  }) {
    final descriptor = _PropertyDescriptorSource(
      name: name,
      validatorFactories: validatorFactories,
      asyncValidators: asyncValidators,
    );
    final oldOrNew = _properties.putIfAbsent(name, () => descriptor);
    assert(oldOrNew == descriptor, '$name is already registered.');
  }

  Map<String, PropertyDescriptor> _build(
    AsyncErrorHandler canceledValidationErrorHandler,
  ) =>
      _properties.map(
        (key, value) => MapEntry(
          key,
          PropertyDescriptor._(
              name: value.name,
              validators: value.validatorFactories,
              asyncValidators: value.asyncValidators,
              canceledValidationErrorHandler: canceledValidationErrorHandler),
        ),
      );
}

class _PropertyDescriptorSource {
  final String name;
  final List<ValidatorFactory> validatorFactories;
  final List<AsyncValidator> asyncValidators;

  _PropertyDescriptorSource({
    required this.name,
    required this.validatorFactories,
    required this.asyncValidators,
  });
}

@sealed
class PropertyDescriptor {
  // ignore: prefer_const_constructors
  final String name;
  late List<_AsyncValidationExecutorInvoker> _asyncValidationExecutionInvokers;
  late List<ValidatorFactory> _validationFactories;

  PropertyDescriptor._({
    required this.name,
    required List<ValidatorFactory> validators,
    required List<AsyncValidator> asyncValidators,
    AsyncErrorHandler? canceledValidationErrorHandler,
  }) {
    _asyncValidationExecutionInvokers = asyncValidators
        .map(
          (v) =>
              _AsyncValidationExecutorInvoker(AsyncValidatorExecutor_<String>(
            asyncValidator: v,
            canceledValidationErrorHandler: canceledValidationErrorHandler,
          )..addListener(_onAsyncValidationCompleted)),
        )
        .toList();
    _validationFactories = [
      ...validators,
      ..._asyncValidationExecutionInvokers.map((e) => e.getValidator),
    ];
  }

  List<Validator> getValidators(BuildContext context) =>
      [..._validationFactories.map((e) => e(context))];

  void _onAsyncValidationCompleted() {
    // key.currentState?.validate();
  }

  // キーをキャッシュすると、VMを異なるビルドツリーで再利用できない。
  // 一方、ビルドツリーが単にリビルドされる場合はキーを破棄したくない。
  // キーは外から与えるべき。
  // 非同期バリデーション終了時にvalidate()を呼ぶにはどうすればいい？
  // 正確には、notifierに通知すればいいはず！
  // 通知できないなぁ。FormのVMを作って全部watchするのがいいかな。めんどい！
  // もしくは save の時に頑張る？

  // 立ち返ると、
  // * バリデーションはVM以下、できればモデルに実装したい
  // * 非同期バリデーションもあり得る
  // * 非同期バリデーションが完了したら、その結果を反映させるためにフォームフィールドをリビルドしたい（validate()するとか）
  // * 非同期バリデーションが終わっていない状態では「submit」を許可したくない
  //    つまり、非同期バリデーションが終わった段階でsubmitを実装するボタンのリビルドが必要
  // * ビルダーを作るのは難しすぎるので、Invokerを使用したStateを作ってみてから汎用化

  F textForm<F extends FormField<String?>>(
    BuildContext context,
    FormFieldFactory<F, String?> fieldFactory,
  ) =>
      form<F, String?>(context, fieldFactory);

  F form<F extends FormField<V>, V>(
    BuildContext context,
    FormFieldFactory<F, V> fieldFactory,
  ) =>
      fieldFactory(context, this);

  // bool get hasValue => key.currentState != null;
  // T getValue<T>() => key.currentState?.value as T;
}

class _AsyncValidationExecutorInvoker {
  final AsyncValidatorExecutor_<String?> executor;

  _AsyncValidationExecutorInvoker(this.executor);

  Validator getValidator(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return (v) => executor.execute(
        ValidationTarget(value: v, locale: locale, onCompleted: () {}));
  }
}

// build_runnerベースのtyped property
// @viewModelProperties
// final Map<Symbol, PropertyDescriptor> properties;
// T get n => properties.get('n');
