import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SystemUtils {
  static void exitApp() {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        // Apple does not like  this, as it is against their Human Interface Guidelines.
        exit(0);
      } else if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        // Not sure if SystemNavigator.pop(); would work for other platforms
      }
    } else {}
  }
}