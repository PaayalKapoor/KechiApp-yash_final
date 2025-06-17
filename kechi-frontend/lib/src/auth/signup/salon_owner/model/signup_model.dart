class SalonOwnerSignupRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String addressLine1;
  final String addressLine2;
  final String pincode;

  SalonOwnerSignupRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.addressLine1,
    required this.addressLine2,
    required this.pincode
  });

  Map<String, dynamic> toJson() => {
        "salonName": name,
        "email": email,
        "phone": phone,
        "password": password,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "pincode": pincode
      };
}

class SalonOwnerSignupResponse {
  final String message;
  final dynamic user;
  final String? error;

  SalonOwnerSignupResponse({required this.message, this.user, this.error});

  factory SalonOwnerSignupResponse.fromJson(Map<String, dynamic> json) {
    return SalonOwnerSignupResponse(
      message: json['message'] ?? '',
      user: json['user'],
      error: json['error'],
    );
  }
} 