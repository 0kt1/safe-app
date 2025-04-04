class User {
  final String userName;
  final String deviceId;
  final String phoneNumber;
  final String role;
  final String linkedbankAccount;

  User({
    required this.userName,
    required this.deviceId,
    required this.phoneNumber,
    required this.role,
    required this.linkedbankAccount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['username'] ?? 'Unknown',
      deviceId: json['deviceid'] ?? 'Unavailable',
      phoneNumber: json['phoneNumber'] ?? 'N/A',
      role: json['role'] ?? 'N/A',
      linkedbankAccount: json['linkedbankAccount'] ?? 'N/A',
    );
  }
}
