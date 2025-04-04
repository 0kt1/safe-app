import 'package:flutter/services.dart';

class SecurityService {
  static void enableScreenSecurity() {
    // Prevent Screenshots & Screen Recording
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static void disableScreenSecurity() {
    // Allow Screenshots & Screen Recording
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}
