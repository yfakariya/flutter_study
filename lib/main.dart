// See LICENCE file in the root.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'l10n/codegen_loader.g.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ja')],
      path: 'resources/langs',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const ProviderScope(
        child: App(),
      ),
    ),
  );
}
