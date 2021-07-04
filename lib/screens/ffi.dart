// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../l10n/locale_keys.g.dart';
import '../layouts/screen.dart';
import '../models/ffi_sample.dart';
import '../utils/form_validator_locale.dart';

part 'ffi.freezed.dart';

class FfiScreen extends Screen {
  final _filePathFieldKey =
      GlobalKey<FormFieldState>(debugLabel: 'FfiScreen.filePath');

  @override
  Widget createView(BuildContext context, ScopedReader watch) {
    final state = watch(_vmProvider);
    final vm = watch(_vmProvider.notifier);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () => vm.setIsValid([_filePathFieldKey.currentState]),
      child: Column(
        children: [
          Text(state.result ?? LocaleKeys.screens_ffi_noResult.tr()),
          TextFormField(
            key: _filePathFieldKey,
            controller: vm.filePathController,
            validator: (value) => vm.validateFilePath(context, value),
            decoration: InputDecoration(
              labelText: LocaleKeys.screens_ffi_pathTextForm_label.tr(),
              hintText: LocaleKeys.screens_ffi_pathTextForm_hint.tr(),
            ),
          ),
          ElevatedButton(
            onPressed: vm.run,
            child: Text(LocaleKeys.screens_ffi_runButton).tr(),
          )
        ],
      ),
    );
  }

  @override
  String getTitle(BuildContext context, ScopedReader watch) =>
      LocaleKeys.screens_ffi_title.tr();
}

@freezed
class FfiState with _$FfiState {
  factory FfiState({
    String? result,
    required bool isValid,
  }) = FfiStateDefault;
}

class FfiPresenter extends StateNotifier<FfiState> {
  final TextEditingController filePathController = TextEditingController();

  FfiPresenter() : super(FfiState(isValid: false));

  @override
  void dispose() {
    this.filePathController.dispose();
    super.dispose();
  }

  void setIsValid(List<FormFieldState?> fieldStates) {
    this.state = this.state.copyWith(
          isValid: fieldStates.every((e) => e?.isValid == true),
        );
  }

  String? validateFilePath(BuildContext context, String? value) =>
      ValidationBuilder(
        locale: EasyLocalizerFormValidationLocale(context),
      ).required().minLength(1).build()(value);

  VoidCallback? get run => this.state.isValid ? this._run : null;

  void _run() {
    assert(this.state.isValid);
    final filePath = filePathController.text;
    try {
      final result = doTest(filePath);
      this.state = this.state.copyWith(result: result);
    } catch (error, stackTrace) {
      this.state = this.state.copyWith(
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
