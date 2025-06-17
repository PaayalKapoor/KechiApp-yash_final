import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kechi/src/auth/signup/salon_owner/model/signup_model.dart';
import 'package:kechi/src/auth/signup/salon_owner/model/otp_model.dart';
import 'package:kechi/config.dart';

class SalonOwnerSignupController {
  static const String baseUrl = apiBaseUrl;

  Future<OtpResponse> sendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile}),
    );
    return OtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<OtpResponse> verifyOtp(String mobile, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile, 'otp': otp}),
    );
    return OtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<OtpResponse> resendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/otp/resend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile}),
    );
    return OtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<SalonOwnerSignupResponse> signup(SalonOwnerSignupRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salonowner/signup/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return SalonOwnerSignupResponse.fromJson(data);
    } else {
      return SalonOwnerSignupResponse(
        message: '',
        user: null,
        error: data['error'] ?? 'Signup failed',
      );
    }
  }
} 