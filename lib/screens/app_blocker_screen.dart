// // // import 'package:flutter/material.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:safeapp/services/app_blocker_service.dart';

// // // class AppBlockerScreen extends StatefulWidget {
// // //   const AppBlockerScreen({super.key});

// // //   @override
// // //   _AppBlockerScreenState createState() => _AppBlockerScreenState();
// // // }

// // // class _AppBlockerScreenState extends State<AppBlockerScreen> {
// // //   List<String> _installedApps = [];
// // //   List<String> _blockedApps = [];
// // //   bool _isBlockingActive = false;
// // //   bool _isAdminGranted = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadData();
// // //   }

// // //   Future<void> _loadData() async {
// // //     // Load installed apps (you'll need to implement this)
// // //     _installedApps = await PackageManager.getInstalledApps();
    
// // //     _blockedApps = await AppBlockerService.getBlockedApps();
// // //     setState(() {});
// // //   }

// // //   Future<void> _toggleAppBlocking(bool value) async {
// // //     setState(() => _isBlockingActive = value);
// // //     if (value) {
// // //       await AppBlockerService.startBlocking();
// // //     } else {
// // //       await AppBlockerService.stopBlocking();
// // //     }
// // //   }

// // //   Future<void> _toggleAppBlock(String packageName, bool blocked) async {
// // //     setState(() {
// // //       if (blocked) {
// // //         _blockedApps.add(packageName);
// // //       } else {
// // //         _blockedApps.remove(packageName);
// // //       }
// // //     });
// // //     await AppBlockerService.setBlockedApps(_blockedApps);
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('App Blocker')),
// // //       body: Column(
// // //         children: [
// // //           SwitchListTile(
// // //             title: const Text('Enable App Blocking'),
// // //             value: _isBlockingActive,
// // //             onChanged: _isAdminGranted ? _toggleAppBlocking : null,
// // //           ),
// // //           if (!_isAdminGranted)
// // //             ListTile(
// // //               title: const Text('Device admin permissions required'),
// // //               trailing: ElevatedButton(
// // //                 onPressed: () async {
// // //                   await AppBlockerService.requestAdmin();
// // //                   setState(() => _isAdminGranted = true);
// // //                 },
// // //                 child: const Text('Grant'),
// // //               ),
// // //             ),
// // //           Expanded(
// // //             child: ListView.builder(
// // //               itemCount: _installedApps.length,
// // //               itemBuilder: (context, index) {
// // //                 final app = _installedApps[index];
// // //                 return CheckboxListTile(
// // //                   title: Text(app),
// // //                   value: _blockedApps.contains(app),
// // //                   onChanged: (value) => _toggleAppBlock(app, value ?? false),
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:device_apps/device_apps.dart';
// // import 'package:safeapp/services/app_blocker_service.dart';

// // class AppBlockerScreen extends StatefulWidget {
// //   const AppBlockerScreen({super.key});

// //   @override
// //   _AppBlockerScreenState createState() => _AppBlockerScreenState();
// // }

// // class _AppBlockerScreenState extends State<AppBlockerScreen> {
// //   List<String> _installedApps = [];
// //   List<String> _blockedApps = [];
// //   bool _isBlockingActive = false;
// //   bool _isAdminGranted = false;
// //   bool _isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadData();
// //   }

// //   Future<void> _loadData() async {
// //     setState(() => _isLoading = true);
    
// //     // Get installed apps as package names
// //     final apps = await DeviceApps.getInstalledApplications(
// //       includeAppIcons: false,
// //       onlyAppsWithLaunchIntent: true,
// //     );
    
// //     _installedApps = apps.map((app) => app.packageName).toList();
// //     _blockedApps = await AppBlockerService.getBlockedApps();
    
// //     setState(() => _isLoading = false);
// //   }

// //   Future<void> _toggleAppBlocking(bool value) async {
// //     setState(() => _isBlockingActive = value);
// //     if (value) {
// //       await AppBlockerService.startBlocking();
// //     } else {
// //       await AppBlockerService.stopBlocking();
// //     }
// //   }

// //   // Future<void> _toggleAppBlock(String packageName, bool blocked) async {
// //   //   setState(() {
// //   //     if (blocked) {
// //   //       _blockedApps.add(packageName);
// //   //     } else {
// //   //       _blockedApps.remove(packageName);
// //   //     }
// //   //   });
// //   //   await AppBlockerService.setBlockedApps(_blockedApps);
// //   // }

// //   Future<void> _toggleAppBlock(String packageName, bool blocked) async {
// //   final newBlockedApps = List<String>.from(_blockedApps); // Create new mutable list
  
// //   setState(() {
// //     if (blocked) {
// //       if (!newBlockedApps.contains(packageName)) {
// //         newBlockedApps.add(packageName);
// //       }
// //     } else {
// //       newBlockedApps.remove(packageName);
// //     }
// //     _blockedApps = newBlockedApps;
// //   });
  
// //   await AppBlockerService.setBlockedApps(_blockedApps);
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('App Blocker')),
// //       body: _isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : Column(
// //               children: [
// //                 SwitchListTile(
// //                   title: const Text('Enable App Blocking'),
// //                   value: _isBlockingActive,
// //                   onChanged: _isAdminGranted ? _toggleAppBlocking : null,
// //                 ),
// //                 if (!_isAdminGranted)
// //                   ListTile(
// //                     title: const Text('Device admin permissions required'),
// //                     trailing: ElevatedButton(
// //                       onPressed: () async {
// //                         await AppBlockerService.requestAdmin();
// //                         setState(() => _isAdminGranted = true);
// //                       },
// //                       child: const Text('Grant'),
// //                     ),
// //                   ),
// //                 const Divider(),
// //                 const Padding(
// //                   padding: EdgeInsets.all(8.0),
// //                   child: Text('Select Apps to Block:'),
// //                 ),
// //                 Expanded(
// //                   child: ListView.builder(
// //                     itemCount: _installedApps.length,
// //                     itemBuilder: (context, index) {
// //                       final packageName = _installedApps[index];
// //                       return FutureBuilder<Application?>(
// //                         future: DeviceApps.getApp(packageName),
// //                         builder: (context, snapshot) {
// //                           final app = snapshot.data;
// //                           return CheckboxListTile(
// //                             title: Text(app?.appName ?? packageName),
// //                             subtitle: Text(packageName),
// //                             value: _blockedApps.contains(packageName),
// //                             onChanged: (value) => _toggleAppBlock(packageName, value ?? false),
// //                           );
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:device_apps/device_apps.dart';
// import 'package:safeapp/services/app_blocker_service.dart';

// class AppBlockerScreen extends StatefulWidget {
//   const AppBlockerScreen({super.key});

//   @override
//   State<AppBlockerScreen> createState() => _AppBlockerScreenState();
// }

// class _AppBlockerScreenState extends State<AppBlockerScreen> {
//   List<Application> _installedApps = [];
//   List<String> _blockedApps = [];
//   bool _isBlockingActive = false;
//   bool _isAdminGranted = false;
//   bool _isLoading = true;
//   bool _showSystemApps = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     setState(() => _isLoading = true);
    
//     try {
//       // Get all installed apps
//       final apps = await DeviceApps.getInstalledApplications(
//         includeAppIcons: true,
//         includeSystemApps: _showSystemApps,
//         onlyAppsWithLaunchIntent: true,
//       );

//       // Sort alphabetically
//       apps.sort((a, b) => a.appName.compareTo(b.appName));
      
//       // Get currently blocked apps
//       final blocked = await AppBlockerService.getBlockedApps();

//       setState(() {
//         _installedApps = apps.cast<Application>();
//         _blockedApps = blocked;
//       });
//     } catch (e) {
//       debugPrint("Error loading apps: $e");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _toggleAppBlocking(bool value) async {
//     setState(() => _isBlockingActive = value);
//     if (value) {
//       await AppBlockerService.startBlocking();
//     } else {
//       await AppBlockerService.stopBlocking();
//     }
//   }

//   Future<void> _toggleAppBlock(Application app, bool blocked) async {
//     final newBlockedApps = List<String>.from(_blockedApps);
    
//     setState(() {
//       if (blocked) {
//         if (!newBlockedApps.contains(app.packageName)) {
//           newBlockedApps.add(app.packageName);
//         }
//       } else {
//         newBlockedApps.remove(app.packageName);
//       }
//       _blockedApps = newBlockedApps;
//     });
    
//     await AppBlockerService.setBlockedApps(_blockedApps);
//   }

//   Future<void> _forceStopApp(String packageName) async {
//     final success = await AppBlockerService.forceStopApp(packageName);
//     if (success) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('App force stopped successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to force stop app')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('App Blocker'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _loadData,
//           ),
//           IconButton(
//             icon: Icon(_showSystemApps ? Icons.lock : Icons.lock_open),
//             onPressed: () {
//               setState(() => _showSystemApps = !_showSystemApps);
//               _loadData();
//             },
//             tooltip: _showSystemApps ? 'Hide system apps' : 'Show system apps',
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Control Panel
//                 Card(
//                   margin: const EdgeInsets.all(8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       children: [
//                         SwitchListTile(
//                           title: const Text('Enable Background Blocking'),
//                           subtitle: const Text('Automatically stops blocked apps'),
//                           value: _isBlockingActive,
//                           onChanged: _isAdminGranted ? _toggleAppBlocking : null,
//                         ),
//                         if (!_isAdminGranted)
//                           ListTile(
//                             title: const Text('Admin Permissions Required'),
//                             trailing: FilledButton(
//                               onPressed: () async {
//                                 await AppBlockerService.requestAdmin();
//                                 setState(() => _isAdminGranted = true);
//                               },
//                               child: const Text('Enable Admin'),
//                             ),
//                           ),
//                         const Divider(height: 20),
//                         Text(
//                           '${_blockedApps.length} apps blocked',
//                           style: Theme.of(context).textTheme.titleSmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
                
//                 // App List
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _installedApps.length,
//                     itemBuilder: (context, index) {
//                       final app = _installedApps[index];
//                       final isBlocked = _blockedApps.contains(app.packageName);
                      
//                       return Card(
//                         margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         child: ListTile(
//                           leading: app is ApplicationWithIcon
//                               ? CircleAvatar(
//                                   backgroundImage: MemoryImage(app.icon),
//                                 )
//                               : const CircleAvatar(
//                                   child: Icon(Icons.android),
//                                 ),
//                           title: Text(app.appName),
//                           subtitle: Text(
//                             app.packageName,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(
//                                   isBlocked ? Icons.block : Icons.check_circle,
//                                   color: isBlocked ? Colors.red : Colors.green,
//                                 ),
//                                 onPressed: () => _toggleAppBlock(app, !isBlocked),
//                                 tooltip: isBlocked ? 'Unblock app' : 'Block app',
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.stop),
//                                 onPressed: () => _forceStopApp(app.packageName),
//                                 tooltip: 'Force stop now',
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }