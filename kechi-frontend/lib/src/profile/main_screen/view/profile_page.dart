import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kechi/shared/widgets/bottom_navbar.dart';
import 'package:kechi/src/profile/profile_screens/customers/view/customer_page.dart';
import 'package:kechi/src/profile/profile_screens/gallery/view/gallery_page.dart';
import 'package:kechi/src/profile/profile_screens/inventory/INITIAL/inventory_initial.dart';
import 'package:kechi/src/profile/profile_screens/slots/view/slot_page.dart';
import 'package:kechi/src/profile/profile_screens/services/view/service_page.dart';
import 'package:kechi/src/profile/profile_screens/wallet/view/wallet.dart';
import 'package:kechi/src/profile/profile_screens/reviews/view/reviews.dart';
import 'package:kechi/src/profile/profile_screens/chats/view/chat_page.dart';
import 'package:kechi/src/profile/profile_screens/qr/view/manage_qr.dart';
import 'package:kechi/src/profile/profile_screens/manage_branch/view/managebranch_screen.dart';
import 'package:kechi/src/profile/profile_screens/promotions/view/promotions_screen.dart';
import 'package:kechi/src/profile/profile_screens/refer&earn/view/referearn_screen.dart';
import 'package:kechi/src/profile/profile_screens/edit_profile/view/edit_profilepage.dart';
import 'package:kechi/src/profile/profile_screens/contact_us/view/contactus_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.light(
        primary: Color(0xFF1A73E8),
        secondary: Color(0xFF4285F4),
        surface: Colors.white,
        background: Colors.white,
      ),
    ),
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _profileImagePath; // Add this for web platform
  File? _backgroundImage;
  String? _backgroundImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Request camera permission when the app launches
    _requestCameraPermission();
  }

  // Method to request camera permission
  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      // Show a dialog to inform the user
      _showPermissionDeniedDialog();
    }
  }

  // Method to show permission denied dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text(
          'This app requires camera access to take profile pictures. Please enable camera permission in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Open app settings
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Method to get profile image
  ImageProvider _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_profileImagePath != null) {
      return AssetImage(_profileImagePath!);
    } else {
      return AssetImage('assets/images/default_profile.jpg');
    }
  }

  // Method to get background image
  ImageProvider _getBackgroundImage() {
    if (_backgroundImage != null) {
      return FileImage(_backgroundImage!);
    } else if (_backgroundImagePath != null) {
      return AssetImage(_backgroundImagePath!);
    } else {
      // Default image from assets
      return const AssetImage('assets/images/gallery1.png');
    }
  }

  // Method to show image selection options
  void _showProfileImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      if (await Permission.camera.isGranted) {
                        _pickImage(ImageSource.camera);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        _showPermissionDeniedDialog();
                      }
                    },
                  ),
                  _buildImageOptionButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(context); // Close bottom sheet
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryPage(
                            isSelectingProfilePhoto: true,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          if (result is File) {
                            _profileImage = result;
                            _profileImagePath = null;
                          } else if (result is String) {
                            _profileImagePath = result;
                            _profileImage = null;
                          }
                        });
                        print('Profile image set!');
                      } else {
                        print('No image selected.');
                      }
                    },
                  ),
                  if (_profileImage != null || _profileImagePath != null)
                    _buildImageOptionButton(
                      icon: Icons.delete,
                      label: 'Remove',
                      onTap: () {
                        setState(() {
                          _profileImage = null;
                          _profileImagePath = null;
                        });
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A73E8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to show background image selection options
  void _showBackgroundImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Background Image',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () async {
                      if (await Permission.camera.isGranted) {
                        _pickBackgroundImage(ImageSource.camera);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        _showPermissionDeniedDialog();
                      }
                    },
                  ),
                  _buildImageOptionButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryPage(
                            isSelectingProfilePhoto: true,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          if (result is File) {
                            _backgroundImage = result;
                            _backgroundImagePath = null;
                          } else if (result is String) {
                            _backgroundImagePath = result;
                            _backgroundImage = null;
                          }
                        });
                      }
                    },
                  ),
                  if (_backgroundImage != null || _backgroundImagePath != null)
                    _buildImageOptionButton(
                      icon: Icons.delete,
                      label: 'Remove',
                      onTap: () {
                        setState(() {
                          _backgroundImage = null;
                          _backgroundImagePath = null;
                        });
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A73E8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build image option button
  Widget _buildImageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A73E8).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color(0xFF1A73E8),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // Method to pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to pick background image
  Future<void> _pickBackgroundImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _backgroundImage = File(pickedFile.path);
          _backgroundImagePath = null;
        });
      }
    } catch (e) {
      print('Error picking background image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting background image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _showBackgroundImageOptions(context);
              },
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _getBackgroundImage(),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF1A73E8).withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Dark gradient overlay at the bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.45),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Kechi Assured badge
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kechi Assured',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Main content centered
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showProfileImageOptions(context);
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: _getProfileImage(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Arrows Hair & Beauty',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewsPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '4.8 (8 Reviews)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Premium beauty services',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Status Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerPage(),
                          ),
                        );
                      },
                      child: _buildStatusCard(
                        '137',
                        'Customers',
                        Color(0xFF1A73E8),
                        Icons.people_alt_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicePage(),
                          ),
                        );
                      },
                      child: _buildStatusCard(
                        '42',
                        'Services',
                        Color(0xFF1A73E8),
                        Icons.spa_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletPage(),
                          ),
                        );
                      },
                      child: _buildStatusCard(
                        '₹ 12,500',
                        'Wallet',
                        Color(0xFF5E97F6),
                        Icons.account_balance_wallet_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Onboarding Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Onboarding',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.edit_outlined,
                          title: 'Edit Profile',
                          subtitle: 'Update your profile information',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalonFormPage(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.access_time_outlined,
                          title: 'Slots',
                          subtitle: 'Manage your availability',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ArtistAvailabilityScheduler()),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.qr_code_outlined,
                          title: 'Manage QR Code',
                          subtitle: 'Generate and manage your QR code',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageQRPage(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.photo_library_outlined,
                          title: 'Gallery',
                          subtitle: 'Showcase your best work',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GalleryPage()),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Wallet',
                          subtitle: 'View your transaction details',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WalletPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Communication Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Communication',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.star_border_outlined,
                          title: 'Reviews',
                          subtitle: 'See what clients say about you',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewsPage(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.chat_bubble_outline,
                          title: 'Chats',
                          subtitle: 'Connect with your clients',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.contacts_outlined,
                          title: 'Contact Us',
                          subtitle: 'Get support and assistance',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactUsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Maintenance Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maintenance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.inventory_outlined,
                          title: 'Inventory',
                          subtitle: 'Manage your Inventory',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InventoryInitialSetupPage(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.spa_outlined,
                          title: 'Services',
                          subtitle: 'Manage your service offerings',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ServicePage()),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.card_giftcard_outlined,
                          title: 'Packages',
                          subtitle: 'Special offers and bundles',
                          iconColor: Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.people_alt_outlined,
                          title: 'Artists',
                          subtitle: 'Manage your team',
                          iconColor: Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.manage_accounts_outlined,
                          title: 'Customers',
                          subtitle: 'Manage your customers',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerPage(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.account_tree,
                          title: 'Manage Branch',
                          subtitle: 'Manage your branch',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageBranchPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Business Analytics Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Business Analytics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.insights_outlined,
                          title: 'Business Analytics',
                          subtitle: 'Track your performance metrics',
                          iconColor: Color(0xFF1A73E8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Settings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.history_outlined,
                          title: 'History',
                          subtitle: 'View past activities',
                          iconColor: Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.language_outlined,
                          title: 'Languages',
                          subtitle: 'Change your language preferences',
                          iconColor: Color(0xFF1A73E8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Others Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Others',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileOption(
                          icon: Icons.campaign,
                          title: 'Promotions',
                          subtitle: 'Promote your salon',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PromotionsScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        ProfileOption(
                          icon: Icons.share,
                          title: 'Refer & Earn',
                          subtitle: 'Refer and Earn more money',
                          iconColor: Color(0xFF1A73E8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReferEarnScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Help & Support Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Help & Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSupportOption(
                          'FAQs',
                          Icons.question_answer_outlined,
                          Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        _buildSupportOption(
                          'Help',
                          Icons.help_outline,
                          Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        _buildSupportOption(
                          'Privacy Policy',
                          Icons.privacy_tip_outlined,
                          Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        _buildSupportOption(
                          'Terms and Conditions',
                          Icons.description_outlined,
                          Color(0xFF1A73E8),
                        ),
                        Divider(
                            height: 1,
                            thickness: 1,
                            indent: 70,
                            endIndent: 20,
                            color: Colors.grey.withOpacity(0.1)),
                        _buildSupportOption(
                          'About',
                          Icons.info_outline,
                          Color(0xFF1A73E8),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red[700],
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    const SizedBox(height: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      String value, String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback? onTap;

  const ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
