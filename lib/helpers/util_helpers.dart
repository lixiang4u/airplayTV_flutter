import 'dart:io';

bool isMobile() {
  if (Platform.isAndroid || Platform.isIOS) {
    return true;
  }
  return false;
}
