import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String selectedLanguage;

  const ForgotPasswordDialog({
    Key? key,
    required this.selectedLanguage,
  }) : super(key: key);

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  bool isEmailMethod = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
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
                        ? 'Reset Password'
                        : widget.selectedLanguage == 'हिंदी'
                            ? 'पासवर्ड रीसेट करें'
                            : 'Restablecer contraseña',
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
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isEmailMethod = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isEmailMethod ? Color(0xFF2B93F5) : Colors.grey[200],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.selectedLanguage == 'English'
                            ? 'Email'
                            : widget.selectedLanguage == 'हिंदी'
                                ? 'ईमेल'
                                : 'Correo',
                        style: TextStyle(
                          color: isEmailMethod ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => isEmailMethod = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !isEmailMethod ? Color(0xFF2B93F5) : Colors.grey[200],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.selectedLanguage == 'English'
                            ? 'SMS'
                            : widget.selectedLanguage == 'हिंदी'
                                ? 'एसएमएस'
                                : 'SMS',
                        style: TextStyle(
                          color: !isEmailMethod ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                widget.selectedLanguage == 'English'
                    ? 'Enter your ${isEmailMethod ? 'email' : 'phone number'} to receive reset instructions'
                    : widget.selectedLanguage == 'हिंदी'
                        ? '${isEmailMethod ? 'ईमेल' : 'फोन नंबर'} दर्ज करें'
                        : 'Ingrese su ${isEmailMethod ? 'correo' : 'número de teléfono'}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: isEmailMethod ? emailController : phoneController,
                keyboardType: isEmailMethod
                    ? TextInputType.emailAddress
                    : TextInputType.phone,
                decoration: InputDecoration(
                  hintText: isEmailMethod ? 'example@email.com' : '+91 XXXXXXXXXX',
                  prefixIcon: Icon(
                    isEmailMethod ? Icons.email : Icons.phone,
                    color: Color(0xFF2B93F5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF2B93F5), width: 2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement password reset logic
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.selectedLanguage == 'English'
                              ? 'Reset instructions sent!'
                              : widget.selectedLanguage == 'हिंदी'
                                  ? 'रीसेट निर्देश भेज दिए गए हैं!'
                                  : '¡Instrucciones de restablecimiento enviadas!',
                        ),
                        backgroundColor: Color(0xFF2B93F5),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2B93F5),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.selectedLanguage == 'English'
                        ? 'Send Instructions'
                        : widget.selectedLanguage == 'हिंदी'
                            ? 'निर्देश भेजें'
                            : 'Enviar instrucciones',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}