class SalonOwnerLoginRequest {
  final String email;
  final String password;

  SalonOwnerLoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class SalonOwnerLoginResponse {
  final String? token;
  final dynamic user;
  final String? error;
  final String? message;

  SalonOwnerLoginResponse({this.token, this.user, this.error, this.message});

  factory SalonOwnerLoginResponse.fromJson(Map<String, dynamic> json) {
    return SalonOwnerLoginResponse(
      token: json['token'],
      user: json['user'],
      error: json['error'],
      message: json['message'],
    );
  }
} 