// See LICENCE file in the root.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:meta/meta.dart';

import 'form_companion_mixin.dart';
import 'form_presenter.dart';

/// [FormStateAdapter] implementation for [FormBuilderState].
class _FormBuilderStateAdapter implements FormStateAdapter {
  final FormBuilderState _state;

  @override
  AutovalidateMode get autovalidateMode =>
      _state.widget.autovalidateMode ?? AutovalidateMode.disabled;

  _FormBuilderStateAdapter(this._state);

  @override
  bool validate() => _state.validate();

  @override
  void save() => _state.save();
}

/// Base class for presenters which binds to a form using [FormBuilder].
abstract class FormBuilderPresenter<T> extends FormPresenter<T> {
  /// Creates [FormBuilderPresenter] with its initial state.
  FormBuilderPresenter({
    required T initialState,
    required PropertyDescriptorsBuilder propertiesBuilder,
  }) : super(
          initialState: initialState,
          properties: propertiesBuilder,
        );

  @override
  FormStateAdapter? maybeFormStateOf(BuildContext context) =>
      _maybeFormStateOf(context);

  _FormBuilderStateAdapter? _maybeFormStateOf(BuildContext context) {
    final state = FormBuilder.of(context);
    return state == null ? null : _FormBuilderStateAdapter(state);
  }

  @override
  @protected
  @visibleForOverriding
  bool canSubmit(BuildContext context) {
    final formState = _maybeFormStateOf(context);
    if (formState == null ||
        formState.autovalidateMode == AutovalidateMode.disabled) {
      // Should be manual validation in doSubmit(), so returns true here.
      return true;
    }

    // More efficient than base implementation.
    return formState._state.fields.values.every((f) => !f.hasError) &&
        properties.values.every((p) => !p.hasPendingAsyncValidations);
  }

  @protected
  @visibleForOverriding
  @override
  VoidCallback buildDoSubmit(BuildContext context) {
    final formState = _maybeFormStateOf(context);

    return () async {
      if (formState != null) {
        if (formState.autovalidateMode != AutovalidateMode.disabled) {
          formState.save();
          for (final field in formState._state.value.entries) {
            properties[field.key]?.setDynamicValue(field.value);
          }
        }
      }

      await doSubmit(context);
    };
  }

  @override
  @protected
  void saveFields(FormStateAdapter formState) {
    formState.save();
    if (formState is _FormBuilderStateAdapter) {
      for (final field in formState._state.value.entries) {
        properties[field.key]?.setDynamicValue(field.value);
      }
    }
  }
}
