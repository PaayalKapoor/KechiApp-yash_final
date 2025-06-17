import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:kechi/routes.dart';
import 'package:kechi/src/auth/login/salon_owner/controller/login_controller.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String selectedLanguage;

  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final _loginController = SalonOwnerLoginController();

  int _otpTimerSeconds = 60;
  bool _canResendOTP = false;
  Timer? _otpTimer;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    startOTPTimer();
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

  Future<void> _handleResendOTP() async {
    if (!_canResendOTP) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _loginController.resendOtp(widget.phoneNumber);
      if (response.error != null) {
        setState(() {
          _errorMessage = response.error;
        });
      } else {
        startOTPTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.selectedLanguage == 'English'
                  ? 'OTP resent successfully!'
                  : widget.selectedLanguage == 'हिंदी'
                      ? 'OTP सफलतापूर्वक पुनः भेजा गया!'
                      : '¡Código OTP reenviado con éxito!',
            ),
            backgroundColor: Color(0xFF2B93F5),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend OTP. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF2B93F5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF2B93F5), width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          if (index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            _focusNodes[index].unfocus();
                          }
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context), // Close on outside tap
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.selectedLanguage == 'English'
                        ? 'Verification Code'
                        : widget.selectedLanguage == 'हिंदी'
                            ? 'सत्यापन कोड'
                            : 'Código de verificación',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                widget.selectedLanguage == 'English'
                    ? 'Enter the code sent to ${widget.phoneNumber}'
                    : widget.selectedLanguage == 'हिंदी'
                        ? '${widget.phoneNumber} पर भेजे गए कोड को दर्ज करें'
                        : 'Ingrese el código enviado a ${widget.phoneNumber}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 24),
              _buildOTPBoxes(),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _canResendOTP ? _handleResendOTP : null,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: _canResendOTP
                              ? (widget.selectedLanguage == 'English'
                                  ? 'Did not receive code? '
                                  : widget.selectedLanguage == 'हिंदी'
                                      ? 'कोड नहीं मिला? '
                                      : '¿No recibió el código? ')
                              : (widget.selectedLanguage == 'English'
                                  ? 'Resend code in '
                                  : widget.selectedLanguage == 'हिंदी'
                                      ? 'कोड पुनः भेजें '
                                      : 'Reenviar código en '),
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        if (!_canResendOTP)
                          TextSpan(
                            text: '${_otpTimerSeconds}s',
                            style: TextStyle(
                              color: Color(0xFF2B93F5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (_canResendOTP)
                          TextSpan(
                            text: widget.selectedLanguage == 'English'
                                ? 'Resend'
                                : widget.selectedLanguage == 'हिंदी'
                                    ? 'पुनः भेजें'
                                    : 'Reenviar',
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
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement OTP verification
                    Navigator.pushNamed(context, Routes.Main);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B93F5),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.selectedLanguage == 'English'
                        ? 'Submit'
                        : widget.selectedLanguage == 'हिंदी'
                            ? 'सत्यापित करें'
                            : 'Submcar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _otpTimer?.cancel();
    super.dispose();
  }
}
