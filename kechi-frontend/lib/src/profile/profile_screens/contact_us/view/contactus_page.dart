import 'package:flutter/material.dart';
import 'package:kechi/src/profile/profile_screens/manage_branch/view/managebranch_screen.dart';
import 'package:kechi/src/profile/profile_screens/refer&earn/view/referearn_screen.dart';
import 'package:kechi/theme.dart';
import 'package:kechi/src/profile/profile_screens/promotions/view/promotions_screen.dart';
import "package:kechi/src/profile/profile_screens/edit_profile/view/edit_profilepage.dart";

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: "PlusJakartaSans")),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  

  Widget _subItem(IconData icon, String label, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40, right: 16),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blue[50], // light background
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12)),
        child: Icon(
          icon,
          size: 20,
          color: Colors.blue[300], // adjust as needed
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: "PlusJakartaSans",
        ),
      ),
      onTap: () => _navigate(context, label),
    );
  }

  void _navigate(BuildContext context, String label) {
    Widget destination = ContactUsPage();

    // Define navigation based on the label
    switch (label) {
      case "Manage Branch":
        destination = ManageBranchPage(); // Your custom screen
        break;
      case "Refer & Earn":
        destination = ReferEarnScreen(); // Your custom screen
        break;
      case "Edit Profile":
        destination = SalonFormPage();
        break;
      case "Customer Support":
        destination = ContactUsPage();
        break;
      case "Promotions":
        destination = PromotionsScreen();
        break;
    }

    // Navigate to the determined destination screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // 🟣 App Bar with menu icon
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        title: const Text(
          "Customer Support",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/kechi15.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // Scrollable content
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 800;

              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 2000),
                        child: isWideScreen
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Contact Info
                                  const Expanded(
                                    flex: 2,
                                    child: ContactInfoSection(),
                                  ),
                                  const SizedBox(width: 32),

                                  // Right: Contact Form + Info Card
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Contact Form in fixed-width container
                                        Container(
                                          constraints: const BoxConstraints(
                                              maxWidth: 700),
                                          child: const ContactFormSection(),
                                        ),
                                        const SizedBox(height: 32),

                                        // Card in fixed-width container
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            final double maxWidth = constraints
                                                .maxWidth
                                                .clamp(0, 700);
                                            return Container(
                                              width: maxWidth,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                elevation: 8,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(24),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text("kechi@gmail.com",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "PlusJakartaSans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        "321-221-231",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "PlusJakartaSans",
                                                        ),
                                                      ),
                                                      SizedBox(height: 24),
                                                      Text("Customer Support",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "PlusJakartaSans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        "Available around the clock to address any concerns.",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "PlusJakartaSans"),
                                                      ),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                      Text(
                                                        "Feedback and Suggestions",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "PlusJakartaSans",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          "Help us improve Snappy with your feedback.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "PlusJakartaSans")),
                                                      SizedBox(
                                                        height: 24,
                                                      ),
                                                      Text(
                                                        "Media Inquiries",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "PlusJakartaSans",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                          "Reach us at media@kechi.com.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "PlusJakartaSans")),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ContactInfoSection(),
                                  const SizedBox(height: 32),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    child: const ContactFormSection(),
                                  ),
                                  const SizedBox(height: 32),
                                  Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      elevation: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("kechi@gmail.com",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "PlusJakartaSans",
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              "321-221-231",
                                              style: TextStyle(
                                                fontFamily: "PlusJakartaSans",
                                              ),
                                            ),
                                            SizedBox(height: 24),
                                            Text("Customer Support",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "PlusJakartaSans",
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Available around the clock to address any concerns.",
                                              style: TextStyle(
                                                  fontFamily:
                                                      "PlusJakartaSans"),
                                            ),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            Text(
                                              "Feedback and Suggestions",
                                              style: TextStyle(
                                                  fontFamily: "PlusJakartaSans",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                                "Help us improve Snappy with your feedback.",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "PlusJakartaSans")),
                                            SizedBox(
                                              height: 24,
                                            ),
                                            Text(
                                              "Media Inquiries",
                                              style: TextStyle(
                                                  fontFamily: "PlusJakartaSans",
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text("Reach us at media@kechi.com.",
                                                style: TextStyle(
                                                    fontFamily:
                                                        "PlusJakartaSans")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
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

class ContactInfoSection extends StatelessWidget {
  const ContactInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Us",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: "PlusJakartaSans",
              color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          "Email, call, or complete the form to learn how Kechi can solve your problem.",
          style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        /*const SizedBox(height: 16),
        const Text("info@snappy.io",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const Text("321-221-231"),
        const SizedBox(height: 16),
        const Text("Customer Support",
            style: TextStyle(decoration: TextDecoration.underline)),
        const SizedBox(height: 24),
        _infoCard("Customer Support",
            "Available around the clock to address any concerns."),
        _infoCard("Feedback and Suggestions",
            "Help us improve Snappy with your feedback."),
        _infoCard("Media Inquiries", "Reach us at media@snappypop.com."),*/
      ],
    );
  }

  Widget _infoCard(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}

class ContactFormSection extends StatefulWidget {
  const ContactFormSection({super.key});

  @override
  State<ContactFormSection> createState() => _ContactFormSectionState();
}

class _ContactFormSectionState extends State<ContactFormSection> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    // Proceed with submission
    print("Submitted: ${_firstNameController.text} ...");
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 800;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Get in Touch",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "PlusJakartaSans")),
            const SizedBox(height: 4),
            Center(
              child: const Text(
                "Available around the clock to address any concerns.",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 400;
                return isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                                label: "First name",
                                controller: _firstNameController),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                                label: "Last name",
                                controller: _lastNameController),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          CustomTextField(
                              label: "First name",
                              controller: _firstNameController),
                          const SizedBox(height: 16),
                          CustomTextField(
                              label: "Last name",
                              controller: _lastNameController),
                        ],
                      );
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(label: "Your email", controller: _emailController),
            const SizedBox(height: 16),
            CustomTextField(
                label: "Phone number", controller: _phoneController),
            const SizedBox(height: 16),
            CustomTextField(
              label: "How can we help?",
              maxLines: 4,
              controller: _messageController,
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: isSmallScreen ? double.infinity : 200,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontFamily: "PlusJakartaSans", color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "By contacting us, you agree to our Terms of Service and Privacy Policy.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontFamily: "PlusJakartaSans", fontSize: 12),
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          // <-- this styles your label
          fontFamily: "PlusJakartaSans",
          fontSize: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
