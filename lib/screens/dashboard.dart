import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:usage_stats/usage_stats.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Application> installedApps = [];
  Map<String?, int> appUsage = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppsAndUsage();
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
    return Scaffold(
      appBar: AppBar(title: const Text("App Usage Dashboard")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 10),
                  Expanded(child: _buildAppList()),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Usage Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Total Installed Apps: ${installedApps.length}",
                style: const TextStyle(fontSize: 16)),
            Text(
                "Total Usage: ${(totalUsageTime / 60000).toStringAsFixed(1)} mins",
                style: const TextStyle(fontSize: 16)),
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
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: app is ApplicationWithIcon
                ? Image.memory(app.icon, width: 50, height: 50)
                : const Icon(Icons.apps, size: 50),
            title: Text(app.appName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Usage: ${(usageTime / 60000).toStringAsFixed(1)} mins",
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: usagePercentage / 100,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
