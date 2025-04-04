import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeapp/components/side_drawer.dart';

class DetectAppsScreen extends StatefulWidget {
  @override
  _DetectAppsScreenState createState() => _DetectAppsScreenState();
}

class _DetectAppsScreenState extends State<DetectAppsScreen> {
  static const platform = MethodChannel('com.example.safeapp/app_blocker');
  List<Map<String, dynamic>> filteredApps = []; // List of filtered apps
  Map<String, bool> selectedApps = {}; // To track checkbox selections
  bool isLoading = false; // Loading state

  @override
  void initState() {
    super.initState();
    fetchFilteredApps();
  }

  // Future<void> fetchFilteredApps() async {
  //   try {
  //     final List<dynamic> apps = await platform.invokeMethod('getFilteredApps');
  //     setState(() {
  //       filteredApps = List<String>.from(apps);
  //       selectedApps = {
  //         for (var app in filteredApps) app: false
  //       }; // Initialize selection map
  //     });
  //   } on PlatformException catch (e) {
  //     print("Failed to get filtered apps: '${e.message}'.");
  //   }
  // }

  Future<void> fetchFilteredApps() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      final List<dynamic> apps = await platform.invokeMethod('getFilteredApps');

      setState(() {
        filteredApps = apps
            .map((app) => {
                  "packageName": app["packageName"],
                  "appName": app["appName"],
                  "icon": app["icon"]
                })
            .toList();
        selectedApps = {
          for (var app in filteredApps) app["packageName"]: false
        };

        isLoading = false; // Hide loading indicator
      });
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false; // Hide loading indicator on error
      });
      print("Failed to get filtered apps: '${e.message}'.");
    }
  }

  Future<void> uninstallSelectedApps() async {
    final selectedPackages = selectedApps.entries
        .where((entry) => entry.value) // Only selected apps
        .map((entry) => entry.key)
        .toList();

    if (selectedPackages.isNotEmpty) {
      try {
        await platform.invokeMethod('uninstallApps', selectedPackages);
        print("here");
        setState(() {
          filteredApps
              .removeWhere((app) => selectedApps[app["packageName"]] == true);
          selectedApps.removeWhere((app, isSelected) => isSelected);
        });
      } on PlatformException catch (e) {
        print("Failed to uninstall apps: '${e.message}'.");
      }
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Safe Apps Monitor")),
  //     body: filteredApps.isEmpty
  //         ? Center(child: Text("No unauthorized apps found!"))
  //         : Column(
  //             children: [
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: filteredApps.length,
  //                   itemBuilder: (context, index) {
  //                     String app = filteredApps[index];
  //                     return CheckboxListTile(
  //                       title: Text(app),
  //                       value: selectedApps[app] ?? false,
  //                       onChanged: (bool? value) {
  //                         setState(() {
  //                           selectedApps[app] = value ?? false;
  //                         });
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(16.0),
  //                 child: ElevatedButton(
  //                   onPressed: uninstallSelectedApps,
  //                   child: Text("Uninstall Selected Apps"),
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Safe Apps Monitor",
            style: GoogleFonts.inter(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const SideDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : filteredApps.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.greenAccent, size: 50),
                      SizedBox(height: 10),
                      Text(
                        "No unauthorized apps found!",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Safe App has detected some unauthorized apps on your device not downloaded from playstore or system apps. Please select the apps you want to uninstall.",
                        style:
                            GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredApps.length,
                        itemBuilder: (context, index) {
                          var app = filteredApps[index];
                          if (app["packageName"]
                              .contains("com.example.safeapp"))
                            return const SizedBox.shrink(); // Hide SafeApp
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              tileColor: Colors.black.withOpacity(
                                  0.2), // Slight transparency for a better look
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Row(
                                children: [
                                  // // Icon(Icons.apps,
                                  // //     color: Colors.white70,
                                  // //     size: 20), // Subtle app icon
                                  // const SizedBox(width: 5),
                                  // Expanded(
                                  //   child: Text(
                                  //     app,
                                  //     style: const TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: 16,
                                  //         fontWeight: FontWeight.w500,
                                  //         ),
                                  //   ),
                                  // ),

                                  app["icon"] != null
                                      ? Image.memory(
                                          base64Decode(app["icon"]),
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(Icons.apps,
                                          color: Colors.white70, size: 40),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      app["appName"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              value: selectedApps[app["packageName"]] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedApps[app["packageName"]] =
                                      value ?? false;
                                });
                              },
                              activeColor: Colors.tealAccent.shade700,
                              checkColor: Colors.white,
                              controlAffinity: ListTileControlAffinity
                                  .leading, // Checkbox on left
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: uninstallSelectedApps,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Uninstall Selected Apps",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
