class UserModel {
  final String username;
  final String accessToken;

  UserModel({required this.accessToken,  required this.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      accessToken: json['accessoken'] ?? '',
      username: json['username'] ?? '',
    );
  }

}