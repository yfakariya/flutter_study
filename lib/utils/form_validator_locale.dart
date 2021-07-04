// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:form_validator/form_validator.dart';

class EasyLocalizerFormValidationLocale extends FormValidatorLocale {
  final BuildContext _context;

  EasyLocalizerFormValidationLocale(this._context);

  @override
  String name() => this._context.locale.toLanguageTag();

  @override
  String email(String v) => 'utils.validator.email'.tr(namedArgs: {"value": v});

  @override
  String ip(String v) => 'utils.validator.ip'.tr(namedArgs: {"value": v});

  @override
  String ipv6(String v) => 'utils.validator.ipv6'.tr(namedArgs: {"value": v});

  @override
  String maxLength(String v, int n) => 'utils.validator.maxLength'
      .tr(namedArgs: {"value": v, "length": n.toString()});

  @override
  String minLength(String v, int n) => 'utils.validator.minLength'
      .tr(namedArgs: {"value": v, "length": n.toString()});

  @override
  String phoneNumber(String v) =>
      'utils.validator.phoneNumber'.tr(namedArgs: {"value": v});

  @override
  String required() => 'utils.validator.required'.tr();

  @override
  String url(String v) => 'utils.validator.url'.tr(namedArgs: {"value": v});
}
