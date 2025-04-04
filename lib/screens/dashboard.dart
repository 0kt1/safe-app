import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeapp/components/side_drawer.dart';
import 'package:safeapp/services/foreground_monitor_service.dart';
import 'package:safeapp/services/network_security_service.dart';
import 'package:usage_stats/usage_stats.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Application> installedApps = [];
  Map<String?, int> appUsage = {};
  bool isLoading = true;

  String foregroundApp = "Unknown";
  final ForegroundMonitorService _monitorService = ForegroundMonitorService();

  // final NetworkSecurityService _networkSecurityService = NetworkSecurityService();
  bool isPublicWiFi = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkNetworkSecurity(context);
    });

    _monitorService.startMonitoring(); // ✅ Ensure monitoring starts
    _monitorService.appStream.listen((appPackage) {
      if (mounted) {
        setState(() {
          foregroundApp = appPackage;
        });
      }

      // print("Foreground App: $foregroundApp"); // Debugging line
    });

    fetchAppsAndUsage();
  }

  // Future<void> checkNetworkSecurity(BuildContext context) async {
  //   bool onPublicWiFi = await _networkSecurityService.isUsingPublicWiFi();
  //   if (mounted) {
  //     setState(() {
  //       isPublicWiFi = onPublicWiFi;
  //     });
  //   }
  // }

  void checkNetworkSecurity(BuildContext context) async {
    NetworkSecurityService networkSecurityService = NetworkSecurityService();
    bool onPublicWiFi = await networkSecurityService.isUsingPublicWiFi(context);

    if (mounted) {
      setState(() {
        isPublicWiFi = onPublicWiFi;
      });
    }

    if (isPublicWiFi) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Warning: You are using a public Wi-Fi!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You're on a secure network.")),
      );
    }
  }

  Future<void> fetchAppsAndUsage() async {
    bool? hasPermission = await UsageStats.checkUsagePermission();
    if (!hasPermission!) {
      UsageStats.grantUsagePermission();
      return; // Stop execution until permission is granted
    }

    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true, onlyAppsWithLaunchIntent: true);

    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 1));

    List<UsageInfo> usageData =
        await UsageStats.queryUsageStats(startDate, endDate);
    Map<String?, int> usageMap = {};

    for (var usage in usageData) {
      usageMap[usage.packageName] =
          int.tryParse(usage.totalTimeInForeground ?? '0') ?? 0;
    }

    setState(() {
      installedApps = apps;
      appUsage = usageMap;
      isLoading = false;
    });
  }

  int get totalUsageTime {
    return appUsage.values.fold(0, (sum, time) => sum + time);
  }

  @override
Widget build(BuildContext context) {
  return NeumorphicApp(
    debugShowCheckedModeBanner: false,
    title: 'SafeApp Dashboard',
    themeMode: ThemeMode.light,
    theme: const NeumorphicThemeData(
      baseColor: Color(0xFF0F172A),
      lightSource: LightSource.topLeft,
      depth: 4,
      shadowLightColor: Colors.white24,
      shadowDarkColor: Colors.black87,
    ),
    home: Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: NeumorphicAppBar(
        title: Text(
          'SafeApp Dashboard',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        color: const Color(0xFF0F172A),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const SideDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPublicWiFi)
                    Neumorphic(
                      padding: const EdgeInsets.all(16),
                      style: NeumorphicStyle(
                        depth: 4,
                        color: Colors.red.shade100.withOpacity(0.15),
                        shadowLightColor: Colors.black,
                        shadowDarkColor: Colors.black,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi, color: Colors.redAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "⚠️ You're on a public Wi-Fi. Avoid sensitive activities.",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 2,
                      color: const Color(0xFF1E293B),
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.visibility, color: Colors.lightBlueAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Foreground App",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                foregroundApp,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryCard(),
                  const SizedBox(height: 24),
                  Text(
                    "Installed Apps Usage",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: _buildAppList(),
                  ),
                ],
              ),
            ),
    ),
  );
}


Widget _buildSummaryCard() {
  return Card(
    color: const Color(0xFF1E293B),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Usage Summary",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Total Installed Apps: ${installedApps.length}",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ),
          Text(
            "Total Usage: ${(totalUsageTime / 60000).toStringAsFixed(1)} mins",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAppList() {
  return ListView.builder(
    itemCount: installedApps.length,
    itemBuilder: (context, index) {
      Application app = installedApps[index];
      int usageTime = appUsage[app.packageName] ?? 0;
      double usagePercentage =
          totalUsageTime > 0 ? (usageTime / totalUsageTime) * 100 : 0;

      return Card(
        color: const Color(0xFF1E293B),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: app is ApplicationWithIcon
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(app.icon, width: 50, height: 50),
                )
              : const Icon(Icons.apps, size: 50, color: Colors.white70),
          title: Text(
            app.appName,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                "Usage: ${(usageTime / 60000).toStringAsFixed(1)} mins "
                "(${usagePercentage.toStringAsFixed(1)}%)",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: usagePercentage / 100,
                  backgroundColor: Colors.grey.shade800,
                  color: usagePercentage > 30
                      ? Colors.redAccent
                      : Colors.lightBlueAccent,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("App Usage Dashboard")),
  //     body: isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : Padding(
  //             padding: const EdgeInsets.all(12.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text("Current Foreground App:",
  //                     style: TextStyle(fontSize: 18)),
  //                 const SizedBox(height: 10),
  //                 if (isPublicWiFi) // 🚨 Show warning only if on public Wi-Fi
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       color: Colors.red.shade100,
  //                       borderRadius: BorderRadius.circular(10),
  //                       border: Border.all(color: Colors.red, width: 1),
  //                     ),
  //                     child: const Row(
  //                       children: [
  //                         Icon(Icons.warning, color: Colors.red),
  //                         SizedBox(width: 10),
  //                         Expanded(
  //                           child: Text(
  //                             "⚠️ Warning: You're on a public Wi-Fi network. "
  //                             "Avoid using financial apps to prevent security risks.",
  //                             style: TextStyle(fontSize: 16),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 Text(
  //                   foregroundApp,
  //                   style: const TextStyle(
  //                       fontSize: 22,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.blue),
  //                 ),
  //                 _buildSummaryCard(),
  //                 const SizedBox(height: 10),
  //                 Expanded(child: _buildAppList()),
  //               ],
  //             ),
  //           ),
  //   );
  // }

  // Widget _buildSummaryCard() {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text("Usage Summary",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //           const SizedBox(height: 10),
  //           Text("Total Installed Apps: ${installedApps.length}",
  //               style: const TextStyle(fontSize: 16)),
  //           Text(
  //               "Total Usage: ${(totalUsageTime / 60000).toStringAsFixed(1)} mins",
  //               style: const TextStyle(fontSize: 16)),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildAppList() {
  //   return ListView.builder(
  //     itemCount: installedApps.length,
  //     itemBuilder: (context, index) {
  //       Application app = installedApps[index];
  //       int usageTime = appUsage[app.packageName] ?? 0;
  //       double usagePercentage =
  //           totalUsageTime > 0 ? (usageTime / totalUsageTime) * 100 : 0;

  //       return Card(
  //         elevation: 3,
  //         margin: const EdgeInsets.symmetric(vertical: 6),
  //         child: ListTile(
  //           leading: app is ApplicationWithIcon
  //               ? Image.memory(app.icon, width: 50, height: 50)
  //               : const Icon(Icons.apps, size: 50),
  //           title: Text(app.appName,
  //               style: const TextStyle(fontWeight: FontWeight.bold)),
  //           subtitle: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Usage: ${(usageTime / 60000).toStringAsFixed(1)} mins "
  //                 "(${usagePercentage.toStringAsFixed(1)}%)",
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //               const SizedBox(height: 6),
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: LinearProgressIndicator(
  //                   value: usagePercentage / 100,
  //                   backgroundColor: Colors.grey.shade300,
  //                   color:
  //                       usagePercentage > 30 ? Colors.redAccent : Colors.blue,
  //                   minHeight: 8,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
