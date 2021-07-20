// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exp/components/form/form_builder_presenter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../l10n/locale_keys.g.dart';
import '../layouts/screen.dart';
import '../models/ffi_sample.dart';

part 'ffi.freezed.dart';

class FfiScreen extends Screen {
  @override
  Widget createView(BuildContext context, ScopedReader watch) {
    final state = watch(_vmProvider);
    final vm = watch(_vmProvider.notifier);
    return vm.createForm(
      child: Column(
        children: [
          Text(
            state.maybeMap(
                  completed: (s) => s.result,
                  orElse: () => null,
                ) ??
                LocaleKeys.screens_ffi_noResult.tr(),
          ),
          FormBuilderTextField(
            name: 'filePath',
            validator: FormBuilderValidators.compose<String>([
              FormBuilderValidators.required(context),
              FormBuilderValidators.minLength(context, 1),
            ]),
            decoration: InputDecoration(
              labelText: LocaleKeys.screens_ffi_pathTextForm_label.tr(),
              hintText: LocaleKeys.screens_ffi_pathTextForm_hint.tr(),
            ),
          ),
          ElevatedButton(
            onPressed: vm.submit,
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
  factory FfiState.completed({
    String? result,
    required String filePath,
  }) = FfiStateCompleted;

  factory FfiState.partial() = FfiStatePartial;
}

class FfiPresenter extends FormBuilderPresenter<FfiState> {
  final TextEditingController filePathController = TextEditingController();

  @override
  bool get isCompleted => this.state is FfiStateCompleted;

  FfiPresenter() : super(FfiState.partial());

  @override
  void dispose() {
    this.filePathController.dispose();
    super.dispose();
  }

  @override
  void commitValues(
    Map<String, FormBuilderFieldState<FormBuilderField, dynamic>> fields,
  ) {
    this.state = FfiState.completed(
      filePath: fields["filePath"]!.value as String,
    );
  }

  @override
  void doSubmit() {
    final state = this.state;
    if (!(state is FfiStateCompleted)) {
      return;
    }

    try {
      final result = doTest(state.filePath);
      this.state = state.copyWith(result: result);
    }
    // ignore: avoid_catches_without_on_clauses
    catch (error, stackTrace) {
      this.state = state.copyWith(
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
