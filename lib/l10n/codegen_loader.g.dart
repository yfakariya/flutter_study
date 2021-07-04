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
  },
  "utils": {
    "validator": {
      "minLength": "The field must be at least {length} characters long",
      "maxLength": "The field must be at most {length} characters long",
      "email": "The field is not a valid email address",
      "phoneNumber": "The field is not a valid phone number",
      "required": "The field is required",
      "ip": "The field is not a valid IP address",
      "ipv6": "The field is not a valid IPv6 address",
      "url": "The field is not a valid URL address"
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
  },
  "utils": {
    "validator": {
      "minLenth": "{length}文字以上でなければなりません",
      "maxLenth": "{length}文字以下でなければなりません",
      "email": "メールアドレスとして正しくありません",
      "phoneNumber": "電話番号として正しくありません",
      "required": "必ず入力してください",
      "ip": "IPアドレスとして正しくありません",
      "ipv6": "IP v6アドレスとして正しくありません",
      "url": "URLとして正しくありません"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ja": ja};
}
