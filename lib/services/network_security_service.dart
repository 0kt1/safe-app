import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

class NetworkSecurityService {
  // final List<String> trustedSSIDs = ["HomeWiFi", "OfficeNetwork"]; // ✅ Add your safe Wi-Fi names

  // Future<bool> isUsingPublicWiFi() async {
  //   List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity(); // ✅ Correct type
  //   print("Connectivity Results: $connectivityResults"); // Debugging line
  //   if (connectivityResults.contains(ConnectivityResult.wifi)) {
  //     String? ssid = await WifiInfo().getWifiName(); // ✅ Get current Wi-Fi name
  //     print("Current SSID: $ssid"); // Debugging line
  //     if (ssid == null || !trustedSSIDs.contains(ssid)) {
  //       return true; // 🚨 It's a public Wi-Fi
  //     }
  //   }
  //   return false; // ✅ Safe network
  // }

  // Checks if Location Services are enabled
  Future<bool> _isLocationEnabled(BuildContext context) async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      await _showLocationDialog(context);
    }
    return isEnabled;
  }

  Future<bool> isUsingPublicWiFi(BuildContext context) async {

    PermissionStatus status = await Permission.location.request();


    if (status.isGranted) {
      // Ensure location services are enabled
      bool isLocationEnabled = await _isLocationEnabled(context);
      if (!isLocationEnabled) return false;

      List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
      print("Connectivity Results: $connectivityResults"); // Debugging line
      
      String? ssid = await WifiInfo().getWifiName(); // ✅ Get current Wi-Fi name
      print("Current SSID: $ssid"); // Debugging line
      
      return connectivityResults.contains(ConnectivityResult.wifi);
    } else if (status.isDenied) {
      // User denied permission; ask again with an explanation
      await _showPermissionDialog(context);
      return false;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
      return false;
    }

    return false;
  }


  /// Shows a dialog explaining why location permission is needed
  Future<void> _showPermissionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: const Text("This app needs location permission to check your Wi-Fi network security."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Permission.location.request();
              },
              child: const Text("Grant Permission"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  /// Show a dialog if Location Services are disabled
  Future<void> _showLocationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Services Disabled"),
          content: const Text(
              "To check Wi-Fi security, please enable Location Services in your device settings."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
