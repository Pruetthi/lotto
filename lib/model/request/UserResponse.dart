class UserResponse {
  final int uid;
  final String userName;
  final String email;
  final String password;
  final double wallet;
  final DateTime birthday;
  final String image;
  final String status;

  UserResponse({
    required this.uid,
    required this.userName,
    required this.email,
    required this.password,
    required this.wallet,
    required this.birthday,
    required this.image,
    required this.status,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      uid: json['uid'] ?? 0,
      userName: json['user_name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      wallet: double.tryParse(json['wallet'].toString()) ?? 0.0,
      birthday: DateTime.tryParse(json['birthday'] ?? "") ?? DateTime(2000),
      image: json['image'] ?? "",
      status: json['status'] ?? "",
    );
  }
}
