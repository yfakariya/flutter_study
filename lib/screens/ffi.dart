// See LICENCE file in the root.

// ignore_for_file: public_member_api_docs
// ignore_for_file: use_key_in_widget_constructors

import 'dart:async';

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
import '../models/ffi_sample.dart';

part 'ffi.freezed.dart';

class FfiScreen extends Screen {
  @override
  Widget createView(BuildContext context, ScopedReader watch) => FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: FfiForm(),
      );

  @override
  String getTitle(BuildContext context, ScopedReader watch) =>
      LocaleKeys.screens_ffi_title.tr();
}

class FfiForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final state = watch(_vmProvider);
    final vm = watch(_vmProvider.notifier);

    return Column(
      children: [
        Text(
          state.maybeMap(
                completed: (s) => s.result,
                orElse: () => null,
              ) ??
              LocaleKeys.screens_ffi_noResult.tr(),
        ),
        FormBuilderTextField(
          name: vm.filePath.name,
          validator: vm.filePath.getValidator(context),
          decoration: InputDecoration(
            labelText: LocaleKeys.screens_ffi_pathTextForm_label.tr(),
            hintText: LocaleKeys.screens_ffi_pathTextForm_hint.tr(),
          ),
        ),
        ElevatedButton(
          onPressed: vm.submit(context),
          child: Text(LocaleKeys.screens_ffi_runButton.tr()),
        )
      ],
    );
  }
}

@freezed
class FfiState with _$FfiState {
  factory FfiState.completed({
    String? result,
    required String filePath,
  }) = FfiStateCompleted;

  factory FfiState.partial() = FfiStatePartial;
}

class FfiPresenter extends FormBuilderPresenter<FfiState> {
  PropertyDescriptor<String, void> get filePath => getProperty('filePath');

  FfiPresenter()
      : super(
          initialState: FfiState.partial(),
          propertiesBuilder: PropertyDescriptorsBuilder()
            ..add<String>(
              name: 'filePath',
              validatorFactories: [
                FormBuilderValidators.required,
                (x) => FormBuilderValidators.minLength(x, 1)
              ],
            ),
        );

  @override
  FutureOr<void> doSubmit(BuildContext context) {
    try {
      final result = doTest(filePath.value);
      state = FfiState.completed(
        filePath: filePath.value,
        result: result,
      );
    }
    // ignore: avoid_catches_without_on_clauses
    catch (error, stackTrace) {
      state = FfiState.completed(
        filePath: filePath.value,
        result: LocaleKeys.screens_ffi_errorResult.tr(
          namedArgs: {
            'error': error.toString(),
            'stackTrace': stackTrace.toString(),
          },
        ),
      );
    }
  }
}

final _vmProvider =
    StateNotifierProvider<FfiPresenter, FfiState>((_) => FfiPresenter());
