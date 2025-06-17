import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kechi/src/auth/login/salon_owner/view/login_screen.dart';
import 'package:kechi/src/auth/signup/salon_owner/controller/signup_controller.dart';
import 'package:kechi/src/auth/signup/salon_owner/model/signup_model.dart';

class SalonRegistrationPage extends StatefulWidget {
  @override
  _SalonRegistrationPageState createState() => _SalonRegistrationPageState();
}

class _SalonRegistrationPageState extends State<SalonRegistrationPage> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _pincodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  final _signupController = SalonOwnerSignupController();
  
  // State
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;
  String _fullPhoneNumber = '';
  bool _otpVerified = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _pincodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Input decoration builder
  InputDecoration _buildInputDecoration({
    String? label,
    String? hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      labelStyle: const TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 14,
        color: Colors.black,
      ),
      floatingLabelStyle: const TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 13,
        color: Colors.black,
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.primaryColor),
      ),
    );
  }

  // Text field builder
  Widget _buildTextField(
    TextEditingController controller, {
    required String label,
    String? hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: validator != null 
          ? AutovalidateMode.onUserInteraction 
          : AutovalidateMode.disabled,
      cursorColor: AppTheme.primaryColor,
      decoration: _buildInputDecoration(
        label: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      style: const TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 16,
      ),
    );
  }

  // Image section
  Widget _buildImageSection() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Image.asset(
        'assets/images/salon_owner.png',
        fit: BoxFit.contain,
        width: double.infinity,
      ),
    );
  }

  // Text section
  Widget _buildTextSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Manage, Grow, Succeed – Your Salon, Your Rules!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Simplify your bookings, grow your client base, and elevate your business. The future of salon success begins now!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Validators
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your salon name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your pincode';
    }
    if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null;
  }

  String? _validateAddressLine1(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter address line 1';
    }
    return null;
  }

  // Handle send OTP
  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final otpResponse = await _signupController.sendOtp(_fullPhoneNumber);
    
    setState(() {
      _isLoading = false;
      if (otpResponse.error != null) {
        _errorMessage = otpResponse.error;
      } else {
        _currentStep = 1;
      }
    });
  }

  // Handle verify OTP
  Future<void> _handleVerifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final verifyResponse = await _signupController.verifyOtp(
      _fullPhoneNumber, 
      _otpController.text
    );
    
    setState(() {
      _isLoading = false;
      if (verifyResponse.type == 'success') {
        _otpVerified = true;
      } else {
        _errorMessage = verifyResponse.error ?? 'OTP verification failed';
      }
    });
  }

  // Handle resend OTP
  Future<void> _handleResendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final resendResponse = await _signupController.resendOtp(_fullPhoneNumber);
    
    setState(() {
      _isLoading = false;
      if (resendResponse.error != null) {
        _errorMessage = resendResponse.error;
      }
    });
  }

  // Handle signup
  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final signupRequest = SalonOwnerSignupRequest(
      name: _nameController.text,
      email: _emailController.text,
      phone: _fullPhoneNumber,
      password: _passwordController.text,
      addressLine1: _addressLine1Controller.text,
      addressLine2: _addressLine2Controller.text,
      pincode: _pincodeController.text,
    );

    final signupResponse = await _signupController.signup(signupRequest);
    
    setState(() {
      _isLoading = false;
      if (signupResponse.error != null) {
        _errorMessage = signupResponse.error;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  // Build registration form (Step 1)
  Widget _buildRegistrationForm(bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? double.infinity : 900,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 8),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSmallScreen) ...[
              _buildImageSection(),
              const SizedBox(height: 16),
              _buildTextSection(),
              const SizedBox(height: 20),
            ],
            
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!, 
                  style: const TextStyle(color: Colors.red)
                ),
              ),

            _buildTextField(
              _nameController,
              label: "Salon Name",
              prefixIcon: Icons.person,
              validator: _validateName,
            ),
            const SizedBox(height: 10),

            _buildTextField(
              _emailController,
              label: "Email",
              prefixIcon: Icons.email,
              validator: _validateEmail,
            ),
            const SizedBox(height: 10),

            IntlPhoneField(
              cursorColor: AppTheme.primaryColor,
              decoration: _buildInputDecoration(
                label: "Phone Number",
                hintText: "Enter your contact number",
                prefixIcon: Icons.phone,
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) {
                _fullPhoneNumber = phone.number;
              },
              validator: (phone) {
                if (phone == null || phone.number.isEmpty) {
                  return 'Enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),

            _buildTextField(
              _addressLine1Controller,
              label: "Address Line 1",
              hintText: "Building name, street name, area",
              prefixIcon: Icons.location_on,
              validator: _validateAddressLine1,
            ),
            const SizedBox(height: 10),

            _buildTextField(
              _addressLine2Controller,
              label: "Address Line 2",
              hintText: "Landmark, nearby location (optional)",
              prefixIcon: Icons.location_city,
            ),
            const SizedBox(height: 10),

            _buildTextField(
              _pincodeController,
              label: "Pincode",
              hintText: "6-digit postal code",
              prefixIcon: Icons.pin_drop,
              validator: _validatePincode,
            ),
            const SizedBox(height: 10),

            _buildTextField(
              _passwordController,
              label: "Password",
              prefixIcon: Icons.lock,
              isPassword: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 10),

            _buildTextField(
              _confirmPasswordController,
              label: "Confirm Password",
              prefixIcon: Icons.lock,
              isPassword: true,
              validator: _validateConfirmPassword,
            ),
            const SizedBox(height: 20),

            Center(
              child: SizedBox(
                width: isSmallScreen ? double.infinity : 200,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Next", style: AppTheme.buttonTextStyle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build OTP verification form (Step 2)
  Widget _buildOtpVerificationForm(bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!, 
                style: const TextStyle(color: Colors.red)
              ),
            ),

          const Text(
            "Mobile Number Verification",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "PlusJakartaSans",
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            "We've sent a 4-digit code to your mobile number. Please enter it below.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: "PlusJakartaSans",
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _otpController,
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter OTP',
              counterText: '',
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: _otpController.text.length == 4 && !_otpVerified && !_isLoading
                ? _handleVerifyOtp
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    _otpVerified ? "Verified" : "Verify",
                    style: const TextStyle(color: Colors.white),
                  ),
          ),
          const SizedBox(height: 8),

          Center(
            child: GestureDetector(
              onTap: _isLoading ? null : _handleResendOtp,
              child: Text(
                "Didn't receive a code? Resend",
                style: TextStyle(
                  color: AppTheme.secondaryColor,
                  fontFamily: "PlusJakartaSans",
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: SizedBox(
              width: isSmallScreen ? double.infinity : 200,
              child: ElevatedButton(
                onPressed: _otpVerified && !_isLoading ? _handleSignup : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Submit", style: AppTheme.buttonTextStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build step layout
  Widget _buildStepLayout(Widget formWidget, bool isSmallScreen) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSmallScreen
            ? Column(
                children: [formWidget],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildImageSection(),
                        const SizedBox(height: 16),
                        _buildTextSection(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: formWidget,
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Salon Registration",
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          
          if (_currentStep == 0) {
            return _buildStepLayout(
              _buildRegistrationForm(isSmallScreen), 
              isSmallScreen
            );
          } else {
            return _buildStepLayout(
              _buildOtpVerificationForm(isSmallScreen), 
              isSmallScreen
            );
          }
        },
      ),
    );
  }
}