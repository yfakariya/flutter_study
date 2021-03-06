// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router.dart';

abstract class Screen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
        appBar: AppBar(
          title: Text(
            getTitle(context, watch),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Text('layouts.screen.menuTitle'.tr()),
              ),
              ...appRouteData.map(
                (e) => ListTile(
                  title: Text(e.titleKey).tr(),
                  onTap: () => Navigator.pushNamed(context, e.route),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: createView(context, watch),
        ),
      );

  @protected
  String getTitle(BuildContext context, ScopedReader watch);

  @protected
  Widget createView(BuildContext context, ScopedReader watch);
}
