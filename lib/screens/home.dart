// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';

import '../l10n/locale_keys.g.dart';
import '../layouts/screen.dart';

class HomeScreen extends Screen {
  @override
  Widget createView(BuildContext context, ScopedReader watch) =>
      Text(LocaleKeys.screens_home_title).tr();

  @override
  String getTitle(BuildContext context, ScopedReader watch) =>
      LocaleKeys.screens_home_title.tr();
}
