import 'package:device_apps/device_apps.dart';
import '../models/financial_app.dart';

class AppDetector {
  static const List<String> financialAppPackages = [
    'com.google.android.apps.nbu.paisa.user', // Google Pay
    'com.phonepe.app', // PhonePe
    'net.one97.paytm', // Paytm
    'com.whatsapp', // Example: WhatsApp Pay
    'com.amazon.mShop.android.shopping', // Amazon Pay
    ''
    // Add more trusted financial apps
  ];

  static Future<List<FinancialApp>> getInstalledFinancialApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      onlyAppsWithLaunchIntent: true,
    );

    List<FinancialApp> financialApps = [];

    for (var app in apps) {
      if (financialAppPackages.contains(app.packageName)) {
        financialApps.add(FinancialApp(
          appName: app.appName,
          packageName: app.packageName,
          iconPath: app is ApplicationWithIcon
              ? String.fromCharCodes(app.icon) // Convert icon to string
              : '',
        ));
      }
    }

    return financialApps;
  }
}
