// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "layouts": {
    "screen": {
      "menuTitle": "Menu"
    }
  },
  "screens": {
    "home": {
      "title": "Home",
      "description": "HOME Screen. Please select the function from menu."
    },
    "ffi": {
      "title": "FFI",
      "noResult": "(no result)",
      "errorResult": "ERROR! {error}\n{stackTrace}",
      "pathTextForm": {
        "label": "File path to open",
        "hint": "Input file path"
      },
      "runButton": "Run"
    }
  }
};
static const Map<String,dynamic> ja = {
  "layouts": {
    "screen": {
      "menuTitle": "メニュー"
    }
  },
  "screens": {
    "home": {
      "title": "ホーム",
      "description": "ホーム画面です。メニューから機能を選択してください。"
    },
    "ffi": {
      "title": "FFI",
      "noResult": "（結果がありません）",
      "errorResult": "エラー！　{error}\n{stackTrace}",
      "pathTextForm": {
        "label": "開くファイルのパス",
        "hint": "ファイルパスを入力"
      },
      "runButton": "実行"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ja": ja};
}
