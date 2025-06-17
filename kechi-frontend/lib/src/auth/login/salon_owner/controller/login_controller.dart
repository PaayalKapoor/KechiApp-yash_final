import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kechi/src/auth/login/salon_owner/model/login_model.dart';
import 'package:kechi/src/auth/signup/salon_owner/model/otp_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kechi/config.dart';

class SalonOwnerLoginController {
  static const String baseUrl = apiBaseUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<SalonOwnerLoginResponse> login(SalonOwnerLoginRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salonowner/signin/email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return SalonOwnerLoginResponse.fromJson(data);
    } else {
      return SalonOwnerLoginResponse(
        token: null,
        user: null,
        error: data['error'] ?? 'Login failed',
        message: data['message'],
      );
    }
  }

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // Reset state so user can try again
        await _googleSignIn.signOut();
        return {'error': 'Google sign in was cancelled', 'user': null};
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Only send email to backend for login
        final response = await http.post(
          Uri.parse('$baseUrl/salonowner/signin/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': user.email}),
        );

        if (response.statusCode == 200) {
          // Fetch user data from backend using email
          final userData = await fetchUserData(email: user.email);
          return {
            'error': null,
            'user': userData,
            'token': userCredential.credential?.token
          };
        } else {
          // Reset state so user can try again
          await _googleSignIn.signOut();
          return {
            'error': jsonDecode(response.body)['error'] ??
                'Failed to register user with backend',
            'user': null
          };
        }
      }

      // Reset state so user can try again
      await _googleSignIn.signOut();
      return {'error': 'Failed to get user data', 'user': null};
    } catch (e) {
      // Reset state so user can try again
      await _googleSignIn.signOut();
      return {'error': e.toString(), 'user': null};
    }
  }

  Future<Map<String, dynamic>?> signInWithFacebook() async {
    try {
      // Trigger the authentication flow
      final LoginResult result = await _facebookAuth.login();

      if (result.status != LoginStatus.success) {
        return {
          'error': 'Facebook sign in was cancelled or failed',
          'user': null
        };
      }

      // Get user data from Facebook
      final userData = await _facebookAuth.getUserData();
      if (userData == null || userData['email'] == null) {
        await _facebookAuth.logOut();
        return {'error': 'Failed to get user data from Facebook', 'user': null};
      }

      // Send email to backend for login
      final response = await http.post(
        Uri.parse('$baseUrl/salonowner/signin/facebook'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': userData['email']}),
      );

      if (response.statusCode == 200) {
        // Fetch user data from backend using email
        final backendUserData = await fetchUserData(email: userData['email']);
        return {'error': null, 'user': backendUserData};
      } else {
        // Reset state so user can try again
        await _facebookAuth.logOut();
        return {
          'error': jsonDecode(response.body)['error'] ??
              'Failed to register user with backend',
          'user': null
        };
      }
    } catch (e) {
      // Reset state so user can try again
      await _facebookAuth.logOut();
      return {'error': e.toString(), 'user': null};
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
    ]);
  }

  Future<OtpResponse> sendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/otp/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile}),
    );
    return OtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<OtpResponse> verifyOtp(String mobile, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/otp/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile, 'otp': otp}),
    );
    return OtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<OtpResponse> resendOtp(String mobile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/otp/resend'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile}),
    );
    return OtpResponse.fromJson(jsonDecode(response.body));
  }

  Future<Map<String, dynamic>?> fetchUserData(
      {String? email, String? phone}) async {
    final uri = Uri.parse('$baseUrl/salonowner/get/data').replace(
        queryParameters: email != null ? {'email': email} : {'phone': phone});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['user'];
    } else {
      return null;
    }
  }
}
