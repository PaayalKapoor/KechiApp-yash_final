class OtpRequest {
  final String mobile;
  final String? otp;

  OtpRequest({required this.mobile, this.otp});

  Map<String, dynamic> toJson() => {
        'mobile': mobile,
        if (otp != null) 'otp': otp,
      };
}

class OtpResponse {
  final String? message;
  final String? error;
  final bool? verified;
  final String? type;

  OtpResponse({this.message, this.error, this.verified, this.type});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      message: json['message'],
      error: json['error'],
      verified: json['verified'],
      type: json['type'],
    );
  }
} 