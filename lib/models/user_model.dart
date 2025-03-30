class User {
  final String userName;
  final String deviceId;
  final String phoneNumber;

  User({
    required this.userName,
    required this.deviceId,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'] ?? 'Unknown',
      deviceId: json['deviceId'] ?? 'Unavailable',
      phoneNumber: json['phoneNumber'] ?? 'N/A',
    );
  }
}
