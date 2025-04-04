import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safeapp/components/side_drawer.dart';

class FinancialAppsScreen extends StatefulWidget {
  const FinancialAppsScreen({super.key});

  @override
  State<FinancialAppsScreen> createState() => _FinancialAppsScreenState();
}

class _FinancialAppsScreenState extends State<FinancialAppsScreen> {
  final List<String> financialPackageNames = [
    'com.google.android.apps.nbu.paisa.user', // Google Pay
    'net.one97.paytm', // Paytm
    'com.phonepe.app', // PhonePe
    'com.mobikwik_new', // MobiKwik
    'com.freecharge.android', // Freecharge
    'com.amazon.mShop.android.shopping', // Amazon (for Pay later etc.)
    'in.amazon.mShop.android.shopping',
    'com.fss.iob6'
  ];

  List<Application> installedFinancialApps = [];

  @override
  void initState() {
    super.initState();
    _getInstalledFinancialApps();
  }

  Future<void> _getInstalledFinancialApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: false,
      includeAppIcons: true,
    );

    setState(() {
      installedFinancialApps = apps
          .where((app) => financialPackageNames.contains(app.packageName))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Financial Apps",
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
      body: installedFinancialApps.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: installedFinancialApps.length,
              itemBuilder: (context, index) {
                final app = installedFinancialApps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 90,
                    borderRadius: 20,
                    blur: 15,
                    alignment: Alignment.center,
                    border: 1.5,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    child: ListTile(
                      leading: app is ApplicationWithIcon
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: MemoryImage(app.icon),
                            )
                          : const Icon(Icons.account_balance_wallet,
                              color: Colors.white),
                      title: Text(app.appName,
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          DeviceApps.openApp(app.packageName);
                        },
                        child: Text("Open",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
