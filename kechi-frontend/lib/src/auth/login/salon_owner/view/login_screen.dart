import 'package:flutter/material.dart';
import 'package:kechi/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kechi/src/auth/forgot_password/view/forgot_password.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'otp_screen.dart';
import 'package:kechi/src/auth/login/salon_owner/controller/login_controller.dart';
import 'package:kechi/src/auth/login/salon_owner/model/login_model.dart';
import 'package:kechi/src/auth/signup/salon_owner/model/otp_model.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Current selected language, defaults to English
  String dropdownValue = 'English';

  // Controls whether the password is visible or hidden
  bool isPasswordVisible = false;
  bool showOTPSection = false;

  // Key to validate the form inputs
  final _formKey = GlobalKey<FormState>();

  // Controllers to access and manage text field contents
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isEmailLogin = true;
  int _otpTimerSeconds = 60;
  bool _canResendOTP = false;
  Timer? _otpTimer;

  final _loginController = SalonOwnerLoginController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (!isEmailLogin) {
      startOTPTimer();
    }
  }

  void startOTPTimer() {
    setState(() {
      _otpTimerSeconds = 60;
      _canResendOTP = false;
    });
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_otpTimerSeconds > 0) {
          _otpTimerSeconds--;
        } else {
          _canResendOTP = true;
          timer.cancel();
        }
      });
    });
  }

  // Handles the login button press
  // Currently just navigates to appointments screen
  // In a real app, this would validate credentials with a backend
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final loginRequest = SalonOwnerLoginRequest(
        email: emailController.text,
        password: passwordController.text,
      );
      final response = await _loginController.login(loginRequest);
      if (response.error != null) {
        setState(() {
          _isLoading = false;
          _errorMessage = response.error;
        });
        return;
      }
      // Fetch user data by email
      final userData = await _loginController.fetchUserData(email: emailController.text);
      setState(() {
        _isLoading = false;
      });
      if (userData != null) {
        // Navigate to MainApp and remove all previous routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.Main,
          (route) => false,
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch user data.';
        });
      }
    }
  }

  Future<void> _handleInstagramLogin() async {
    final url = 'https://www.instagram.com/accounts/login';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleFacebookLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _loginController.signInWithFacebook();
      
      if (result != null && result['error'] == null && result['user'] != null) {
        // Navigate to MainApp and remove all previous routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.Main,
          (route) => false,
        );
      } else {
        setState(() {
          _errorMessage = result?['error'] ?? 'Facebook sign in failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Facebook';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _loginController.signInWithGoogle();
      
      if (result != null && result['error'] == null && result['user'] != null) {
        // Navigate to MainApp and remove all previous routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.Main,
          (route) => false,
        );
      } else {
        setState(() {
          _errorMessage = result?['error'] ?? 'Google sign in failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in with Google';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void resendOTP() async {
    if (_canResendOTP) {
      String phone = phoneController.text;
      // Remove any non-digit characters and keep only the last 10 digits
      phone = phone.replaceAll(RegExp(r'\D'), '');
      if (phone.length > 10) {
        phone = phone.substring(phone.length - 10);
      }
      final otpResp = await _loginController.sendOtp(phone);
      if (otpResp.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(otpResp.error!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        startOTPTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              dropdownValue == 'English'
                  ? 'OTP resent successfully!'
                  : dropdownValue == 'हिंदी'
                      ? 'OTP सफलतापूर्वक पुनः भेजा गया!'
                      : '¡Código OTP reenviado con éxito!',
            ),
            backgroundColor: Color(0xFF2B93F5),
          ),
        );
      }
    }
  }

  // Clean up controllers when the widget is disposed
  // This prevents memory leaks
  @override
  void dispose() {
    _otpTimer?.cancel();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget _buildOTPBoxes() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth =
            constraints.maxWidth < 300 ? constraints.maxWidth : 300;
        return Center(
          child: SizedBox(
            width: maxWidth,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF2B93F5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Color(0xFF2B93F5), width: 2),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color.fromARGB(255, 43, 147, 245)),
      prefixIcon: Icon(icon, color: Color.fromARGB(255, 43, 147, 245)),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  Widget _buildEmailPhoneToggleInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isEmailLogin)
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'We will send you an OTP on this number',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: isEmailLogin
                    ? TextFormField(
                        key: ValueKey('email'),
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Color(0xFF2B93F5)),
                          prefixIcon:
                              Icon(Icons.email, color: Color(0xFF2B93F5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Color(0xFF2B93F5), width: 2),
                          ),
                        ),
                      )
                    : IntlPhoneField(
                        key: ValueKey('phone'),
                        controller: phoneController,
                        initialCountryCode: 'IN',
                        decoration: InputDecoration(
                          labelText: 'Enter phone',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          counterText: "", // 🔥 This removes the 0/10 counter
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Color(0xFF2B93F5), width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 12),
                        ),
                        onChanged: (phone) {
                          if (phone.number.length == 10) {
                            print(
                                'Complete phone number: ${phone.completeNumber}');
                          }
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return 'Enter your phone number';
                          }
                          return null;
                        },
                      ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(
                  isEmailLogin ? Icons.phone : Icons.email,
                  color: Color(0xFF2B93F5),
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    isEmailLogin = !isEmailLogin;
                  });
                },
              ),
            ),
          ],
        ),
        if (!isEmailLogin) ...[
          SizedBox(height: 24),
          // Replace the existing Continue button implementation with this:
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _loginWithPhone();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2B93F5),
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          if (showOTPSection) ...[
            SizedBox(height: 32),
            Text(
              'Enter the Verification Code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildOTPBoxes(),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _canResendOTP ? resendOTP : null,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Did not receive OTP? ',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          color: Color(0xFF2B93F5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement OTP verification
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2B93F5),
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
        if (isEmailLogin) ...[
          SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: _buildInputDecoration(
              'Password',
              Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Color(0xFF2B93F5),
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter password';
              }
              if (value!.length < 6) {
                return 'Password too short';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: // Replace the existing forgot password button implementation with:
                TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => ForgotPasswordDialog(
                    selectedLanguage: dropdownValue,
                  ),
                );
              },
              child: Text(
                dropdownValue == 'English'
                    ? 'Forgot Password?'
                    : dropdownValue == 'हिंदी'
                        ? 'पासवर्ड भूल गए?'
                        : '¿Olvidaste tu contraseña?',
                style: GoogleFonts.plusJakartaSans(
                  color: Color.fromARGB(255, 43, 147, 245),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          _buildLoginButton(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  dropdownValue == 'English'
                      ? 'OR '
                      : dropdownValue == 'हिंदी'
                          ? 'या'
                          : 'O ',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          SizedBox(height: 20),
          _buildSocialLoginButtons(),
        ],
      ],
    );
  }

  // Creates a styled login button that adapts to the selected language
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity, // Button takes full width
      height: 55,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 43, 147, 245).withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 3, // Subtle shadow
        ),
        // Button text changes based on selected language
        child: _isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                dropdownValue == 'English'
                    ? 'Log In'
                    : dropdownValue == 'हिंदी'
                        ? 'लॉग इन करें'
                        : 'Iniciar sesión',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialLoginButton(
          'assets/images/google_icon.webp',
          _handleGoogleSignIn,
        ),
        _buildSocialLoginButton(
          'assets/logo/fb.jpg',
          _handleFacebookLogin,
        ),
        _buildSocialLoginButton(
          'assets/logo/insta.jpg',
          _handleInstagramLogin,
        ),
      ],
    );
  }

  Widget _buildSocialLoginButton(String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }

  // Creates a social login button with custom styling
  // Parameters:
  // - label: Button text that changes with language
  // - assetPath: Path to the social platform's icon
  // - onPressed: Function to handle button press
  Widget _buildSocialButton({
    required String label,
    required String assetPath,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        // Social platform icon
        icon: Image.asset(
          assetPath,
          height: 24,
          width: 24,
        ),
        // Button text
        label: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // White button with border
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(255, 43, 147, 245)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color.fromARGB(255, 43, 147, 245).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 28,
        ),
      ),
    );
  }

  Future<void> _loginWithPhone() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    String phone = phoneController.text;
    // Remove any non-digit characters and keep only the last 10 digits
    phone = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.length > 10) {
      phone = phone.substring(phone.length - 10);
    }
    print('Sending OTP to: $phone');
    final otpResp = await _loginController.sendOtp(phone);
    print('OTP API response: error=${otpResp.error}, message=${otpResp.message}');
    setState(() {
      _isLoading = false;
    });
    if (otpResp.error != null) {
      setState(() {
        _errorMessage = otpResp.error;
      });
      return;
    }
    // Show OTP dialog
    final otp = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => OTPVerificationScreen(
        phoneNumber: phone,
        selectedLanguage: dropdownValue,
      ),
    );
    if (otp != null && otp.length == 4) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final verifyResp = await _loginController.verifyOtp(phone, otp);
      print('OTP Verify API response: error=${verifyResp.error}, type=${verifyResp.type}, message=${verifyResp.message}');
      if (verifyResp.type == 'success') {
        // Fetch user data by phone
        final userData = await _loginController.fetchUserData(phone: phone);
        setState(() {
          _isLoading = false;
        });
        if (userData != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.Main,
            (route) => false,
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to fetch user data.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = verifyResp.error ?? 'OTP verification failed.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background container with gradient and salon image
          Container(
            decoration: BoxDecoration(
              // Blue gradient background
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 43, 147, 245).withOpacity(0.9),
                  Color.fromARGB(255, 43, 147, 245).withOpacity(0.7),
                ],
              ),
            ),
            // Salon image overlay with transparency
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/salon2.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(1),
                    BlendMode.dstATop,
                  ),
                ),
              ),
            ),
          ),

          // Language selector dropdown in top-right corner
          Positioned(
            top: 44,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              // Semi-transparent container with border
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              // Dropdown for language selection
              child: Theme(
                data: Theme.of(context).copyWith(
                  popupMenuTheme: PopupMenuThemeData(
                    color: Colors.white,
                    elevation: 10,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.language, color: Colors.white),
                    dropdownColor: Colors.white,
                    // Styling for selected language text
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    // Custom builder for dropdown items
                    selectedItemBuilder: (BuildContext context) {
                      return ['English', 'हिंदी', 'Español']
                          .map<Widget>((String item) {
                        return Center(
                          child: Text(
                            item,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    // Dropdown menu items for each language
                    items: [
                      DropdownMenuItem(
                        value: 'English',
                        child: Text(
                          'English',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'हिंदी',
                        child: Text(
                          'हिंदी',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Español',
                        child: Text(
                          'Español',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    // Update selected language when changed
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          // Main login form in draggable bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.7, // Start at 70% of screen height
            minChildSize: 0.6, // Can't drag below 60%
            maxChildSize: 1.0, // Can expand to full screen
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                // White card with rounded top corners and shadow
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 43, 147, 245).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                // Login form with validation
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: <Widget>[
                        // Drag handle indicator at top
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          dropdownValue == 'English'
                              ? 'Welcome Back!'
                              : dropdownValue == 'हिंदी'
                                  ? 'वापसी पर स्वागत है!'
                                  : '¡Bienvenido de nuevo!',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          dropdownValue == 'English'
                              ? 'Sign in to continue'
                              : dropdownValue == 'हिंदी'
                                  ? 'जारी रखने के लिए साइन इन करें'
                                  : 'Iniciar sesión para continuar',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        _buildEmailPhoneToggleInput(),
                        SizedBox(height: 24),
                        _buildLoginButton(),
                        SizedBox(height: 24),
                        Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildSocialLoginButtons(),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dropdownValue == 'English'
                                  ? "Don't have an account? "
                                  : dropdownValue == 'हिंदी'
                                      ? 'खाता नहीं है? '
                                      : '¿No tienes una cuenta? ',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.Signup);
                              },
                              child: Text(
                                dropdownValue == 'English'
                                    ? 'Sign Up'
                                    : dropdownValue == 'हिंदी'
                                        ? 'साइन अप करें'
                                        : 'Regístrate',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Color.fromARGB(255, 43, 147, 245),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ForgotPasswordPage handles password reset functionality
// It provides a simple form to enter email for password reset instructions
