// See LICENCE file in the root.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exp/screens/home.dart';

import 'screens/ffi.dart';

typedef RouterFunction = Widget Function(BuildContext);

class RouteData {
  final String title;
  final String route;
  final IconData icon;
  final RouterFunction routerFunction;
  RouteData._(this.title, this.route, this.icon, this.routerFunction);
}

const homeRoute = '/';
const ffiRoute = '/ffi';

final appRouteData = [
  RouteData._(
    'Home',
    homeRoute,
    Icons.home,
    (_) => HomeScreen(),
  ),
  RouteData._(
    'FFI',
    ffiRoute,
    Icons.home,
    (_) => FfiScreen(),
  ),
];

final appRoutes = {for (final r in appRouteData) r.route: r.routerFunction};

const initialRoute = homeRoute;
