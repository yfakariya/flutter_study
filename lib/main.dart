// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exp/l10n/codegen_loader.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/codegen_loader.g.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ja')],
      path: 'resources/langs',
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: ProviderScope(
        child: const App(),
      ),
    ),
  );
}
