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

String _formatMessage(int win32Error) {
  const int flags = FORMAT_MESSAGE_IGNORE_INSERTS |
      FORMAT_MESSAGE_FROM_SYSTEM |
      FORMAT_MESSAGE_ARGUMENT_ARRAY |
      0x00000100; // FORMAT_MESSAGE_ALLOCATE_BUFFER;
  // LPTSTR* ppBuffer, which is pointer to the buffer  to store an pointer to allocated Utf16 string.
  final ppBuffer = calloc.allocate<IntPtr>(sizeOf<IntPtr>());
  try {
    final usedLength = FormatMessage(
      flags,
      nullptr,
      win32Error,
      0, // dwLangId(0) means current thread locale
      ppBuffer.cast<Utf16>(),
      0,
      nullptr,
    );

    // Get LPTSTR value (*(LPTSTR*)).
    final pBuffer = Pointer<Utf16>.fromAddress(ppBuffer.value);
    try {
      if (usedLength > 0) {
        return pBuffer.toDartString(length: usedLength);
      }

      final formatMessageError = GetLastError();
      return 'Failed to call FormatMessage with error code ${formatMessageError} (0x${formatMessageError.toHexString(32)})';
    } finally {
      // LPTSTR pBuffer value was allocated in FormatMessage, so we must free it via LocalFree function.
      LocalFree(pBuffer.address);
    }
  } finally {
    // Frees LPTSTR* buffer.
    calloc.free(ppBuffer);
  }
}

String doTest(String filePath) {
  _ensureFfiInitialized();

  final pFilePath = filePath.toNativeUtf16();
  final hFile = CreateFile(
    pFilePath,
    FILE_READ_ACCESS,
    FILE_SHARE_READ,
    nullptr,
    OPEN_EXISTING,
    0,
    NULL,
  );

  final error = GetLastError();
  if (hFile == INVALID_HANDLE_VALUE) {
    return 'Failed to open file "$filePath". ${_formatMessage(error)} ($error)';
  }

  final success = CloseHandle(hFile);
  return 'Succeeded to open file "$filePath". Error was "${_formatMessage(error)}" (${error}), CloseHandle returns ${success}';
}
