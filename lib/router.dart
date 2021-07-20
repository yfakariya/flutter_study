// See LICENCE file in the root.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'l10n/locale_keys.g.dart';
import 'screens/ffi.dart';
import 'screens/form.dart';
import 'screens/home.dart';

typedef RouterFunction = Widget Function(BuildContext);

class RouteData {
  final String titleKey;
  final String route;
  final IconData icon;
  final RouterFunction routerFunction;
  RouteData._(this.titleKey, this.route, this.icon, this.routerFunction);
}

const homeRoute = '/';
const ffiRoute = '/ffi';
const formRoute = '/form';

final appRouteData = [
  RouteData._(
    LocaleKeys.screens_home_title,
    homeRoute,
    Icons.home,
    (_) => HomeScreen(),
  ),
  RouteData._(
    LocaleKeys.screens_ffi_title,
    ffiRoute,
    Icons.home,
    (_) => FfiScreen(),
  ),
  RouteData._(
    LocaleKeys.screens_form_title,
    formRoute,
    Icons.input,
    (_) => FormScreen(),
  ),
];

final appRoutes = {for (final r in appRouteData) r.route: r.routerFunction};

const initialRoute = homeRoute;
