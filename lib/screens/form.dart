// See LICENCE file in the root.

import 'dart:async' as async;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../foundation/async_validator.dart';
import '../l10n/locale_keys.g.dart';
import '../layouts/screen.dart';

part 'form.freezed.dart';

// TODO: 無限に非同期バリデーションが実行される
// TODO: 別の画面に行くと死ぬ
// TODO: 別の画面から戻ってくるとGlobalKeyが重複していると言って死ぬ
class FormScreen extends Screen {
  // final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget createView(BuildContext context, ScopedReader watch) => FormBuilder(
        // key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AFormFieldsPane(),
      );

  @override
  String getTitle(BuildContext context, ScopedReader watch) =>
      LocaleKeys.screens_form_title.tr();
}

class AFormFieldsPane extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final vm = watch(_vmProvider.notifier);
    return Column(
      children: [
        FormBuilderTextField(
          name: vm.stringValue.name,
          validator: vm.stringValue.getValidator(context),
          decoration: InputDecoration(
            labelText: LocaleKeys.screens_form_stringValue_label.tr(),
            hintText: LocaleKeys.screens_form_stringValue_hint.tr(),
          ),
        ),
        ElevatedButton(
          onPressed: vm.submit(context),
          child: const Text('Submit'),
        )
      ],
    );
  }
}

@freezed
class AFormState with _$AFormState {
  factory AFormState.partial({
    String? stringValue,
  }) = AFormStatePartial;

  factory AFormState.completed({
    required String stringValue,
  }) = AFormStateCompleted;
}

@visibleForTesting
class AFormPresenter extends FormBuilderPresenter<AFormState> {
// class AFormPresenter extends StateNotifier<AFormState> {
  // @override
  // bool get canSubmit => state is AFormStateCompleted;

  PropertyDescriptor<String> get stringValue => getProperty('stringValue');

  // VoidCallback? get submit => canSubmit ? doSubmit : null;

  // Validator<String> getStringValueValidator(BuildContext context) {
  //   final locale = context.locale;
  //   final formBuilderState = FormBuilder.of(context)!;
  //   VoidCallback onCompleted = formBuilderState.validate;
  //   return FormBuilderValidators.compose([
  //     FormBuilderValidators.required(context),
  //     FormBuilderValidators.minLength(context, 1),
  //     (v) => AsyncValidatorExecutor<String?>(asyncValidator: (_, l) async {
  //           await Future<void>.delayed(Duration(seconds: 3));
  //           return null;
  //         }).execute(
  //           ValidationTarget(
  //             value: v,
  //             locale: locale,
  //             onCompleted: onCompleted,
  //           ),
  //         )
  //   ]);
  // }

  // TODO(yfakariya): Code-gen with build_runner
  // PropertyDescriptor get stringValue => property('stringValue');

  /// Constructor
  AFormPresenter()
      : super(
          initialState: AFormState.partial(),
          propertiesBuilder: PropertyDescriptorsBuilder()
            ..add<String>(
              name: 'stringValue',
              validatorFactories: [
                FormBuilderValidators.required,
                (x) => FormBuilderValidators.minLength(x, 1),
              ],
              asyncValidatorFactories: [
                (x) => (v, l) async {
                      print(
                          'Validating asynchronously...$v, ${v == null}, ${v?.runtimeType}');
                      await Future<void>.delayed(const Duration(seconds: 3));
                      print('Validated asynchronously.');
                      return null;
                    },
              ],
            ),
        );

  // @override
  // void commitValues(Map<String, Object?> propertyValues) {
  //   state = AFormState.completed(
  //     stringValue: propertyValues[stringValue.name]! as String,
  //   );
  // }

  @override
  void doSubmit(Map<String, PropertyDescriptor> properties) {
    _submitAsync(properties)
        .onError((error, stackTrace) => print('$error\n$stackTrace'));
  }

  Future<void> _submitAsync(Map<String, PropertyDescriptor> properties) async {
    print('Doing submittion asynchronously...');
    await Future<void>.delayed(const Duration(seconds: 3));
    print('Done submittion asynchronously: stringValue:${stringValue.value}');
  }
}

final _vmProvider =
    StateNotifierProvider<AFormPresenter, AFormState>((_) => AFormPresenter());

//

String _getParentAssertionMessage(
  String callerClass,
  String requiredWidgetClass,
) =>
    'Failed to get ancestor $requiredWidgetClass widget from BuildContext. '
    '$callerClass must be used under $requiredWidgetClass widget. '
    'Ensure that the $callerClass method called in build() method of descendant widget. '
    'Note that $callerClass cannot be used in same build() method as which creates and returns $requiredWidgetClass.';

abstract class FormPresenter<T> extends StateNotifier<T> {
  // late GlobalKey<FormBuilderState> _formBuilderKey;
  late Map<String, PropertyDescriptor> _properties;

  /// Creates [FormPresenter] with its initial state.
  FormPresenter({
    required T initialState,
    required PropertyDescriptorsBuilder propertiesBuilder,
  }) : super(initialState) {
    // _formBuilderKey = GlobalKey<FormBuilderState>(
    //   debugLabel: runtimeType.toString(),
    // );
    _properties = propertiesBuilder._build(this);
  }

  @visibleForOverriding
  void handleCanceledAsyncValidationError(async.AsyncError error) {
    // nop
  }

  PropertyDescriptor<T> getProperty<T>(String name) =>
      _properties[name]! as PropertyDescriptor<T>;

  FormState _getFormState(BuildContext context) {
    final formState = Form.of(context);
    assert(
        formState != null, _getParentAssertionMessage('FormPresenter', 'Form'));
    return formState!;
  }

  /// Returns whether the state of this presenter is "completed" or not.
  ///
  /// "Completed" means that:
  /// * All fields for the bound form are set.
  /// * There are no validation errors in the fields of the bound form.
  /// * There are no pending async validations in the fields of the bound form.
  /// * Previous async submit logic is not pending.
  bool canSubmit(BuildContext context) =>
      _getFormState(context).validate() &&
      _properties.values.every((p) => !p.hasPendingAsyncValidations);

  /// Returns submit callback suitable for `onClick` callback of button
  /// which represents `submit` of form.
  ///
  /// This proeprty returns `null` when [canSubmit] is `false`;
  /// otherwise, this returns [doSubmit] as function type result.
  /// So, the button will be disabled when [canSubmit] is `false`,
  /// and will be enabled otherwise.
  VoidCallback? submit(BuildContext context) {
    print('submit()');
    if (!canSubmit(context)) {
      print('  canSubmit() -> false');
      return null;
    }

    return buildDoSubmit(context);
  }

  Locale getLocale(BuildContext context) => Localizations.localeOf(context);

  VoidCallback buildOnAsyncValidationCompleted(BuildContext context) =>
      _getFormState(context).validate;

  @protected
  @visibleForOverriding
  VoidCallback? buildDoSubmit(BuildContext context) {
    final formState = _getFormState(context);

    return () {
      if (formState.validate()) {
        // Call onSave of form fields.
        formState.save();

        // All proeprty descriptors should have values via onSave callback here.
        doSubmit(_properties);
      }
    };
  }

  void doSubmit(Map<String, PropertyDescriptor> properties);
}

/// Base class for presenters which binds to a form using [FormBuilder].
abstract class FormBuilderPresenter<T> extends FormPresenter<T> {
  /// Creates [FormBuilderPresenter] with its initial state.
  FormBuilderPresenter({
    required T initialState,
    required PropertyDescriptorsBuilder propertiesBuilder,
  }) : super(
          initialState: initialState,
          propertiesBuilder: propertiesBuilder,
        );

  FormBuilderState _getFormBuilderState(BuildContext context) {
    final formState = FormBuilder.of(context);
    assert(formState != null,
        _getParentAssertionMessage('FormBuilderPresenter', 'FormBuilder'));
    return formState!;
  }

  @override
  bool canSubmit(BuildContext context) {
    print(
        '    fields -> ${_getFormBuilderState(context).fields.values.every((e) => !e.hasError)}([${_getFormBuilderState(context).fields.values.map((e) => !e.hasError).join(', ')}])');
    print(
        '    pendings -> ${_properties.values.every((p) => !p.hasPendingAsyncValidations)}([${_properties.values.map((e) => !e.hasPendingAsyncValidations).join(', ')}])');
    return _getFormBuilderState(context)
            .fields
            .values
            .every((e) => !e.hasError) &&
        _properties.values.every((p) => !p.hasPendingAsyncValidations);
  }

  @override
  VoidCallback buildOnAsyncValidationCompleted(BuildContext context) =>
      _getFormBuilderState(context).validate;

  @protected
  @visibleForOverriding
  @override
  VoidCallback? buildDoSubmit(BuildContext context) {
    final formState = _getFormBuilderState(context);

    return () {
      if (formState.validate()) {
        // Materialize formState.value.
        formState.save();

        for (final field in formState.value.entries) {
          _properties[field.key]?._setDynamicValue(field.value);
        }

        doSubmit(_properties);
      }
    };
  }
}

typedef Validator<T> = String? Function(T? input);
typedef ValidatorFactory<T> = Validator<T> Function(BuildContext context);
typedef AsyncValidatorFactory<T> = AsyncValidator<T> Function(
  BuildContext context,
);
typedef AsyncErrorHandler = void Function(async.AsyncError error);

class _ValueHolder<T> {
  final T value;
  _ValueHolder(this.value);
}

class _AsyncValidatorEntry<T> {
  final AsyncValidatorFactory<T> _factory;
  final AsyncValidatorExecutor<T> _executor;

  bool get validating => _executor.validating;

  _AsyncValidatorEntry(
    this._factory,
    Equality<T?>? equality,
    AsyncErrorHandler? canceledValidationErrorHandler,
  ) : _executor = AsyncValidatorExecutor(
          equality: equality,
          canceledValidationErrorHandler: canceledValidationErrorHandler,
        );

  AsyncValidator<T> createValidator(BuildContext context) => _factory(context);
}

@sealed
class PropertyDescriptor<T> {
  final String name;
  final FormPresenter presenter;
  final List<ValidatorFactory<T>> _validatorFactories;
  final List<_AsyncValidatorEntry<T>> _asynvValidatorEntries;
  _ValueHolder<T>? _value;

  T get value => _value!.value;
  set value(T value) => _value = _ValueHolder(value);
  void _setDynamicValue(dynamic value) => this.value = value as T;
  bool get hasPendingAsyncValidations {
    print(
        'hasPendingAsyncValidations: ${_asynvValidatorEntries.any((e) => e.validating)}([${_asynvValidatorEntries.map((e) => e._executor.status).join(', ')}])');
    return _asynvValidatorEntries.any((e) => e.validating);
  }

  PropertyDescriptor._({
    required this.name,
    required this.presenter,
    List<ValidatorFactory<T>>? validatorFactories,
    List<AsyncValidatorFactory<T>>? asyncValidatorFactories,
    Equality<T?>? equality,
  })  : _validatorFactories = validatorFactories ?? [],
        _asynvValidatorEntries = (asyncValidatorFactories ?? [])
            .map(
              (v) => _AsyncValidatorEntry(
                v,
                equality,
                presenter.handleCanceledAsyncValidationError,
              ),
            )
            .toList();

  String? Function(T?) getValidator(BuildContext context) {
    final locale = presenter.getLocale(context);
    final onCompleted = presenter.buildOnAsyncValidationCompleted(context);
    return FormBuilderValidators.compose([
      ..._validatorFactories.map((f) => f(context)),
      ..._asynvValidatorEntries.map(
        (e) {
          final asyncValidator = e.createValidator(context);
          final executor = e._executor;
          return (v) =>
              executor.validate(asyncValidator, v, locale, onCompleted);
        },
      ),
    ]);
  }
}

class _PropertyDescriptorSource<T> {
  final String name;
  final List<ValidatorFactory<T>> validatorFactories;
  final List<AsyncValidatorFactory<T>> asyncValidatorFactories;

  _PropertyDescriptorSource({
    required this.name,
    required this.validatorFactories,
    required this.asyncValidatorFactories,
  });

  PropertyDescriptor<T> build(
    FormPresenter presenter,
  ) =>
      PropertyDescriptor<T>._(
        name: name,
        presenter: presenter,
        validatorFactories: validatorFactories,
        asyncValidatorFactories: asyncValidatorFactories,
      );
}

@sealed
class PropertyDescriptorsBuilder {
  final Map<String, _PropertyDescriptorSource> _properties = {};

  void add<T>({
    required String name,
    List<ValidatorFactory<T>>? validatorFactories,
    List<AsyncValidatorFactory<T>>? asyncValidatorFactories,
  }) {
    final descriptor = _PropertyDescriptorSource<T>(
      name: name,
      validatorFactories: validatorFactories ?? [],
      asyncValidatorFactories: asyncValidatorFactories ?? [],
    );
    final oldOrNew = _properties.putIfAbsent(name, () => descriptor);
    assert(oldOrNew == descriptor, '$name is already registered.');
  }

  Map<String, PropertyDescriptor> _build(
    FormPresenter presenter,
  ) =>
      _properties.map(
        (key, value) => MapEntry(
          key,
          value.build(presenter),
        ),
      );
}
