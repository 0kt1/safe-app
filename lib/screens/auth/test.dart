import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthPage extends StatefulWidget {
  @override
  _BiometricAuthPageState createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {
  final LocalAuthentication localAuth = LocalAuthentication();
  String _message = 'Checking biometrics...';
  List<BiometricType> _availableBiometrics = [];

  Future<bool> authenticateIsAvailable() async {
    try {
      final isDeviceSupported = await localAuth.isDeviceSupported();
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      return isDeviceSupported && canCheckBiometrics;
    } catch (e) {
      setState(() {
        _message = 'Error checking biometric support: $e';
      });
      return false;
    }
  }

  Future<void> _checkBiometrics() async {
    final available = await authenticateIsAvailable();
    if (!available) {
      setState(() {
        _message = 'Biometric not available or supported.';
      });
      return;
    }

    try {
      final List<BiometricType> biometrics =
          await localAuth.getAvailableBiometrics();
      setState(() {
        _availableBiometrics = biometrics;
        print("_availableBiometrics: $_availableBiometrics");
        _message = 'Available biometrics: ${biometrics.join(', ')}';
      });
    } catch (e) {
      setState(() {
        _message = 'Error fetching biometrics: $e';
      });
    }
  }

  Future<void> _authenticate() async {
    final available = await authenticateIsAvailable();
    if (!available) {
      setState(() {
        _message = 'Biometric not available or not supported on this device.';
      });
      return;
    }

    try {
      final bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _message = didAuthenticate
            ? '✅ Authentication successful!'
            : '❌ Authentication failed!';
      });
    } catch (e) {
      setState(() {
        _message = 'Authentication error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Auth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(_message, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (_availableBiometrics.isNotEmpty)
              Text(
                'Available: ${_availableBiometrics.map((e) => e.toString().split('.').last).join(', ')}',
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _authenticate,
              icon: Icon(Icons.lock),
              label: Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}