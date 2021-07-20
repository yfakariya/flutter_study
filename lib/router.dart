// See LICENCE file in the root.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'screens/ffi.dart';
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
];

final appRoutes = {for (final r in appRouteData) r.route: r.routerFunction};

const initialRoute = homeRoute;
