import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  static const platform = MethodChannel('device_admin_channel');
  bool _isAdminActive = false;
  bool _isProfileOwner = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    setState(() => _isLoading = true);
    try {
      _isAdminActive = await platform.invokeMethod('isAdminActive') ?? false;
      _isProfileOwner = await platform.invokeMethod('isProfileOwner') ?? false;
    } on PlatformException catch (e) {
      debugPrint("Failed to check admin status: ${e.message}");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _requestAdminPrivileges() async {
    setState(() => _isLoading = true);
    try {
      await platform.invokeMethod('requestDeviceAdmin');
      // Wait a moment and check status again
      await Future.delayed(const Duration(seconds: 1));
      await _checkAdminStatus();
    } on PlatformException catch (e) {
      debugPrint("Failed to request admin: ${e.message}");
      _showErrorSnackbar("Failed to request admin privileges");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _blockApplication(String packageName) async {
    if (packageName.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final result = await platform.invokeMethod('admin:blockApplication', {
        'targetPackage': packageName,
      });
      
      if (result['success'] == true) {
        _showSuccessSnackbar("Application blocked successfully");
      } else {
        if (result['errorCode'] == 'OWNERSHIP_REQUIRED') {
          _showProfileOwnerDialog();
        } else {
          _showErrorSnackbar(result['message'] ?? "Failed to block application");
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'OWNERSHIP_REQUIRED') {
        _showProfileOwnerDialog();
      } else {
        _showErrorSnackbar(e.message ?? "Failed to block application");
      }
    }
    setState(() => _isLoading = false);
  }

  void _showProfileOwnerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Profile Ownership Required"),
        content: const Text(
          "This feature requires your app to be the profile owner. "
          "This typically requires special provisioning in enterprise scenarios.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Security Profile")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAdminStatusCard(),
                  const SizedBox(height: 20),
                  _buildBlockAppSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildAdminStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Status",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _isAdminActive ? Icons.verified : Icons.warning,
                  color: _isAdminActive ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(_isAdminActive ? "Admin Active" : "Admin Not Active"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  _isProfileOwner ? Icons.verified : Icons.warning,
                  color: _isProfileOwner ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(_isProfileOwner ? "Profile Owner" : "Not Profile Owner"),
              ],
            ),
            const SizedBox(height: 20),
            if (!_isAdminActive)
              ElevatedButton(
                onPressed: _requestAdminPrivileges,
                child: const Text("Enable Admin Privileges"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockAppSection() {
    final packageController = TextEditingController();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Block Application",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: packageController,
              decoration: const InputDecoration(
                labelText: "Package Name",
                hintText: "com.example.app",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _blockApplication(packageController.text),
              child: const Text("Block Application"),
            ),
            if (!_isProfileOwner)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Note: Some features may require profile ownership",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
      ),
    );
  }
}