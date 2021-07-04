// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:form_validator/form_validator.dart';

import '../l10n/locale_keys.g.dart';

class EasyLocalizerFormValidationLocale extends FormValidatorLocale {
  final BuildContext _context;

  EasyLocalizerFormValidationLocale(this._context);

  @override
  String name() => this._context.locale.toLanguageTag();

  @override
  String email(String v) =>
      LocaleKeys.utils_validator_email.tr(namedArgs: {"value": v});

  @override
  String ip(String v) =>
      LocaleKeys.utils_validator_ip.tr(namedArgs: {"value": v});

  @override
  String ipv6(String v) =>
      LocaleKeys.utils_validator_ipv6.tr(namedArgs: {"value": v});

  @override
  String maxLength(String v, int n) => LocaleKeys.utils_validator_maxLength
      .tr(namedArgs: {"value": v, "length": n.toString()});

  @override
  String minLength(String v, int n) => LocaleKeys.utils_validator_minLength
      .tr(namedArgs: {"value": v, "length": n.toString()});

  @override
  String phoneNumber(String v) =>
      LocaleKeys.utils_validator_phoneNumber.tr(namedArgs: {"value": v});

  @override
  String required() => LocaleKeys.utils_validator_required.tr();

  @override
  String url(String v) =>
      LocaleKeys.utils_validator_url.tr(namedArgs: {"value": v});
}
