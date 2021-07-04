// See LICENCE file in the root.

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exp/layouts/screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends Screen {
  @override
  Widget createView(BuildContext context, ScopedReader watch) =>
      Text('screens.home.description').tr();

  @override
  String getTitle(BuildContext context, ScopedReader watch) =>
      'screens.home.title'.tr();
}
