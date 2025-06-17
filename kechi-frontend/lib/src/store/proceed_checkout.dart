import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kechi/config.dart';

// API Configuration
// const String apiBaseUrl = 'http://192.168.1.8:3000'; // For all devices
// const String apiBaseUrl = 'http://10.0.2.2:3000'; // For Android Emulator
// const String apiBaseUrl = 'http://localhost:3000'; // For iOS Simulator
// const String apiBaseUrl = 'http://192.168.1.17:3000'; // For physical devices

class ProceedCheckoutPage extends StatefulWidget {
  final int itemCount;
  const ProceedCheckoutPage({Key? key, required this.itemCount})
      : super(key: key);

  @override
  State<ProceedCheckoutPage> createState() => _ProceedCheckoutPageState();
}

class _ProceedCheckoutPageState extends State<ProceedCheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController =
      TextEditingController(text: '+91');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  bool _isPickup = true;
  bool _isPhoneVerified = false;
  bool _isVerifying = false;
  String? _phoneError;
  bool _showVerify = false;

  // Simulated DB of verified numbers
  static final Set<String> _verifiedNumbers = {};

  // Sample database
  static final Map<String, Map<String, String>> _sampleDB = {
    '7058223924': {
      'name': 'Om Manglani',
      'email': 'om.manglani@example.com',
      'address1': '101, Shanti Nagar',
      'address2': 'Near City Mall',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'pincode': '400001',
      'pickup': 'true',
    },
    '8862025918': {
      'name': 'Purab Keshwani',
      'email': 'purab.keshwani@example.com',
      'address1': '202, Green Park',
      'address2': 'Opp. Metro Station',
      'city': 'Delhi',
      'state': 'Delhi',
      'pincode': '110001',
      'pickup': 'false',
    },
    '9869912008': {
      'name': 'Nilesh Shah',
      'email': 'nilesh.shah@example.com',
      'address1': '303, Lake View',
      'address2': 'Sector 5',
      'city': 'Ahmedabad',
      'state': 'Gujarat',
      'pincode': '380001',
      'pickup': 'true',
    },
  };

  Future<void> _verifyPhone() async {
    setState(() {
      _isVerifying = true;
      _phoneError = null;
    });

    final phone = _phoneController.text.trim();
    if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      setState(() {
        _isVerifying = false;
        _phoneError = 'Enter a valid 10-digit phone number';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/otp/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': phone}),
      );

      final responseData = jsonDecode(response.body);
      print('Send OTP Response: $responseData');
      if (response.statusCode == 200 && responseData['type'] == 'success') {
        setState(() {
          _isVerifying = false;
          _showVerify = true;
        });
        _showOtpDialog(phone);
      } else {
        setState(() {
          _isVerifying = false;
          _phoneError = responseData['message'] ?? 'Failed to send OTP';
        });
      }
    } catch (e) {
      print('Network Error: $e');
      setState(() {
        _isVerifying = false;
        _phoneError = 'Network error: $e';
      });
    }
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _isPhoneVerified = false;
      _phoneError = null;
      if (value.length == 10 && RegExp(r'^\d{10}$').hasMatch(value)) {
        final user = _sampleDB[value];
        if (user != null) {
          _nameController.text = user['name'] ?? '';
          _emailController.text = user['email'] ?? '';
          _address1Controller.text = user['address1'] ?? '';
          _address2Controller.text = user['address2'] ?? '';
          _cityController.text = user['city'] ?? '';
          _stateController.text = user['state'] ?? '';
          _pincodeController.text = user['pincode'] ?? '';
          _isPickup = user['pickup'] == 'true';
          _showVerify = false;
        } else {
          _nameController.clear();
          _emailController.clear();
          _address1Controller.clear();
          _address2Controller.clear();
          _cityController.clear();
          _stateController.clear();
          _pincodeController.clear();
          _showVerify = true;
        }
      } else {
        _showVerify = false;
      }
    });
  }

  void _showOtpDialog(String phone) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        List<TextEditingController> controllers =
            List.generate(4, (_) => TextEditingController());
        List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('OTP Verification',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('OTP has been sent to $phone on message.'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          autofocus: index == 0,
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty && index < 3) {
                              focusNodes[index + 1].requestFocus();
                            } else if (val.isEmpty && index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          try {
                            final response = await http.post(
                              Uri.parse('$apiBaseUrl/otp/resend'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({'mobile': phone}),
                            );
                            final responseData = jsonDecode(response.body);
                            if (response.statusCode == 200 &&
                                responseData['type'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('OTP resent!'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(responseData['message'] ??
                                      'Failed to resend OTP'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Network error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Resend OTP'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final code = controllers.map((c) => c.text).join();
                          if (code.length != 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter all 4 digits'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            final response = await http.post(
                              Uri.parse('$apiBaseUrl/otp/verify'),
                              headers: {'Content-Type': 'application/json'},
                              body: jsonEncode({
                                'mobile': phone,
                                'otp': code,
                              }),
                            );
                            final responseData = jsonDecode(response.body);
                            if (response.statusCode == 200 &&
                                responseData['type'] == 'success') {
                              Navigator.of(context).pop();
                              setState(() {
                                _isPhoneVerified = true;
                                _showVerify = false;
                                _verifiedNumbers.add(phone);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Phone number verified!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      responseData['message'] ?? 'Invalid OTP'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Network error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4C7EFF);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Walk-in order',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextField(_nameController, 'Name'),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(_codeController, 'Code +91',
                      enabled: false),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      _buildTextField(
                        _phoneController,
                        'Phone',
                        keyboardType: TextInputType.phone,
                        errorText: _phoneError,
                        onChanged: _onPhoneChanged,
                      ),
                      if (_showVerify)
                        Positioned(
                          right: 4,
                          child: ElevatedButton(
                            onPressed: _isVerifying
                                ? null
                                : () {
                                    _verifyPhone();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPhoneVerified
                                  ? Colors.green
                                  : primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: _isVerifying
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(
                                    _isPhoneVerified ? 'Verified' : 'Verify'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(_address1Controller, 'Address Line 1'),
            const SizedBox(height: 16),
            _buildTextField(_address2Controller, 'Address Line 2'),
            const SizedBox(height: 16),
            _buildTextField(_cityController, 'City'),
            const SizedBox(height: 16),
            _buildTextField(_stateController, 'State'),
            const SizedBox(height: 16),
            _buildTextField(_pincodeController, 'Pincode',
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            const Text(
              'Choose One:',
              style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildChoiceButton('Pickup', _isPickup, () {
                  setState(() => _isPickup = true);
                }),
                const SizedBox(width: 16),
                _buildChoiceButton('Delivery', !_isPickup, () {
                  setState(() => _isPickup = false);
                }),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPhoneVerified
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          // Proceed to payment logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Proceeding to payment...'),
                              backgroundColor: primaryColor,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Proceed To Payment',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text,
      String? errorText,
      bool enabled = true,
      void Function(String)? onChanged}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (value) {
        if (hint == 'Phone' && !_isPhoneVerified) {
          return 'Please verify your phone number';
        }
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        hintStyle: const TextStyle(color: Color(0xFFBCC1CC)),
      ),
      style: const TextStyle(fontSize: 16, color: Color(0xFF1E1D1D)),
    );
  }

  Widget _buildChoiceButton(String label, bool selected, VoidCallback onTap) {
    const primaryColor = Color(0xFF4C7EFF);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? primaryColor.withOpacity(0.08) : Colors.white,
          border: Border.all(color: primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            if (selected)
              const Icon(Icons.check, color: primaryColor, size: 18),
            if (selected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? primaryColor : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}