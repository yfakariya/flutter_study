// See LICENCE file in the root.

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exp/layouts/screen.dart';
import 'package:flutter_exp/utils/ffi_sample.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart';
import 'package:riverpod/src/framework.dart';

part 'ffi.freezed.dart';

class FfiScreen extends Screen {
  @override
  Widget createView(BuildContext context, ScopedReader watch) {
    final state = watch(_vmProvider);
    final vm = watch(_vmProvider.notifier);
    return Form(
      // 行けてない
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Text(state.result ?? '(no result)'),
          TextFormField(
            initialValue: state.filePath,
            onFieldSubmitted: (value) => vm.setFilePath(value),
            validator: (value) => vm.validateFilePath(value),
          ),
          ElevatedButton(
            onPressed: vm.run,
            child: Text('Run'),
          )
        ],
      ),
    );
  }

  @override
  String getTitle(BuildContext context, ScopedReader watch) =>
      'First Flutter app.';
}

@freezed
class FfiState with _$FfiState {
  factory FfiState({
    String? filePath,
    String? result,
  }) = FfiStateDefault;
}

class FfiPresenter extends StateNotifier<FfiState> {
  FfiPresenter() : super(FfiState());

  bool get canRun => this.state.filePath != null;

  void Function()? get run => canRun ? _run : null;

  void setFilePath(String filePath) {
    this.state = FfiState(filePath: absolute(filePath));
  }

  final _filePathValidator =
      ValidationBuilder().required().minLength(1).build();

  String? validateFilePath(String? value) => _filePathValidator(value);

  void _run() {
    try {
      final result = doTest(this.state.filePath!);
      this.state = this.state.copyWith(result: result);
    } catch (error, stackTrace) {
      this.state = FfiState(result: 'ERROR! $error\n$stackTrace');
    }
  }
}

final _vmProvider =
    StateNotifierProvider<FfiPresenter, FfiState>((_) => FfiPresenter());
