// See LICENCE file in the root.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

String doTest(String filePath) {
  final pFilePath = filePath.toNativeUtf16();
  final hFile = CreateFile(
    pFilePath,
    FILE_READ_ACCESS,
    FILE_SHARE_READ,
    Pointer.fromAddress(NULL),
    OPEN_EXISTING,
    0,
    NULL,
  );

  final error = GetLastError();
  if (hFile == INVALID_HANDLE_VALUE) {
    return 'Failed to open file "$filePath". Error is ${error}.';
  }

  final success = CloseHandle(hFile);
  return 'Succeeded to open file "$filePath". Error was ${error}, CloseHandle returns ${success}';
}
