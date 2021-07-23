// See LICENCE file in the root.

// ignore_for_file: avoid_print
// ignore_for_file: public_member_api_docs
// ignore_for_file: use_key_in_widget_constructors

import 'dart:async' as async;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../components/form/form_builder_presenter.dart';
import '../components/form/form_companion_mixin.dart';
import '../l10n/locale_keys.g.dart';
import '../layouts/screen.dart';

part 'form.freezed.dart';

class FormScreen extends Screen {
  @override
  Widget createView(BuildContext context, ScopedReader watch) => FormBuilder(
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
  // TODO(yfakariya): Code-gen with build_runner
  PropertyDescriptor<String, void> get stringValue =>
      getProperty('stringValue');

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
                (x) => (v, l, _) async {
                      print(
                          'Validating asynchronously...$v, ${v == null}, ${v?.runtimeType}');
                      await Future<void>.delayed(const Duration(seconds: 3));
                      print('Validated asynchronously.');
                      return null;
                    },
              ],
            ),
        );

  @override
  async.FutureOr<void> doSubmit(BuildContext context) async {
    try {
      print('Doing submittion asynchronously...');
      await Future<void>.delayed(const Duration(seconds: 3));
      print('Done submittion asynchronously: stringValue:${stringValue.value}');
    }
    // ignore: avoid_catches_without_on_clauses
    catch (error, stackTrace) {
      print('$error\n$stackTrace');
    }
  }
}

final _vmProvider =
    StateNotifierProvider<AFormPresenter, AFormState>((_) => AFormPresenter());
