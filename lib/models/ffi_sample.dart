// See LICENCE file in the root.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

bool _isFirst = true;

void _ensureFfiInitialized() {
  // We must call GetLastError() before any FFI call because it always returns 0 for first call.
  if (_isFirst) {
    GetLastError();
    _isFirst = false;
  }
}

String doTest(String filePath) {
  _ensureFfiInitialized();

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
