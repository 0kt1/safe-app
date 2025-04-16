// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/error_codes.dart' as local_auth_error;

// class BiometricAuthentication extends StatefulWidget {
//   const BiometricAuthentication({super.key});

//   @override
//   State<BiometricAuthentication> createState() => _BiometricAuthenticationState();
// }

// class _BiometricAuthenticationState extends State<BiometricAuthentication> {

//   Future<void> authenticateUser() async {
//   bool isAuthorized = false;
//   try {
//     isAuthorized = await _localAuthentication.authenticate(
//       localizedReason: "Please authenticate to see account balance",
//       useErrorDialogs: true,
//       stickyAuth: false,
//     );
//   } on PlatformException catch (exception) {
//     if (exception.code == local_auth_error.notAvailable ||
//         exception.code == local_auth_error.passcodeNotSet ||
//         exception.code == local_auth_error.notEnrolled) {
//       // Handle this exception here.
//     }
//   }

//   if (!mounted) return;

//   setState(() {
//     _isUserAuthorized = isAuthorized;
//   });
// }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }