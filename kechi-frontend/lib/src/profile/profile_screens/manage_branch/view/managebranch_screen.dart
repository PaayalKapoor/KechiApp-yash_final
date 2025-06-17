import 'package:flutter/material.dart';
import 'package:kechi/src/profile/profile_screens/contact_us/view/contactus_page.dart';
import 'package:kechi/src/profile/profile_screens/promotions/view/promotions_screen.dart';
import 'package:kechi/src/profile/profile_screens/refer&earn/view/referearn_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kechi/theme.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import "package:kechi/src/profile/profile_screens/edit_profile/view/edit_profilepage.dart";

class Branch {
  String name;
  String phone;
  String password;
  final String confirmpassword;
  String email;
  String type;
  bool status;
  String latitude;
  String longitude;
  String imagePath;

  Branch({
    required this.name,
    required this.phone,
    required this.password,
    required this.confirmpassword,
    required this.email,
    required this.type,
    required this.status,
    this.latitude = '',
    this.longitude = '',
    this.imagePath = '',
  });
}

class ManageBranchPage extends StatefulWidget {
  @override
  _ManageBranchPageState createState() => _ManageBranchPageState();
}

class _ManageBranchPageState extends State<ManageBranchPage> {
  List<Branch> branches = [];

  final _searchController = TextEditingController();

  String _highlightedBranch = '';

  void _searchBranches() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    final matched = branches
        .where((branch) =>
            branch.name.toLowerCase().contains(query) ||
            branch.email.toLowerCase().contains(query) ||
            branch.phone.contains(query))
        .toList();

    setState(() {
      _highlightedBranch = matched.isNotEmpty ? matched.first.name : '';

      // Only reorder `branches`, don't update `_filteredBranches`
      branches.sort((a, b) {
        if (matched.contains(a) && !matched.contains(b)) return -1;
        if (!matched.contains(a) && matched.contains(b)) return 1;
        return 0;
      });
    });
  }

  Widget _buildSearchBar(bool isCompact) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search branch',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          Container(
            height: 50,
            width: isCompact ? 40 : 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: isCompact
                ? IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _searchBranches,
                  )
                : TextButton(
                    onPressed: _searchBranches,
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    branches = [];
  }

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  Widget _phoneField() {
    return IntlPhoneField(
      cursorColor: AppTheme.primaryColor,
      controller: _phoneController,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontFamily: "PlusJakartaSans"),
        labelText: 'Phone',
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
      ),
      initialCountryCode: 'IN', // default to India or your preference
      onChanged: (phone) {
        if (phone.number.length == 10) {
          print('Complete phone number: ${phone.completeNumber}');
        }
      },
      validator: (phone) {
        if (phone == null || phone.number.length != 10) {
          return 'Enter valid 10-digit number';
        }
        return null;
      },
    );
  }

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

  Widget _buildDialogTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      cursorColor: AppTheme.primaryColor,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: validator != null
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: "PlusJakartaSans"),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  Widget _buildBranchList() {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? branches
        : branches
            .where((branch) =>
                branch.name.toLowerCase().contains(query) ||
                branch.email.toLowerCase().contains(query) ||
                branch.phone.contains(query))
            .toList();

    return filtered.isEmpty
        ? Center(
            child: Text(
              'No branches found.',
              style: TextStyle(fontFamily: "PlusJakartaSans"),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.white,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: DataTable(
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(
                        label: Text(
                      'S/N',
                      style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text('Branch Name',
                            style: TextStyle(
                                fontFamily: "PlusJakartaSans",
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Branch Type',
                            style: TextStyle(
                                fontFamily: "PlusJakartaSans",
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Contact Info',
                            style: TextStyle(
                                fontFamily: "PlusJakartaSans",
                                fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(
                                fontFamily: "PlusJakartaSans",
                                fontWeight: FontWeight.bold))),
                  ],
                  rows: List.generate(
                    filtered.length,
                    (index) {
                      final branch = filtered[index];
                      return DataRow(cells: [
                        DataCell(Text(
                          '${index + 1}',
                          style: TextStyle(fontFamily: "PlusJakartaSans"),
                        )),
                        DataCell(
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: branch.imagePath.isNotEmpty &&
                                        File(branch.imagePath).existsSync()
                                    ? FileImage(File(branch.imagePath))
                                    : null,
                                child: branch.imagePath.isEmpty
                                    ? Icon(Icons.store)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(branch.name),
                            ],
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: branch.type == 'Main Branch'
                                  ? Colors.red[100]
                                  : Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              branch.type,
                              style: TextStyle(
                                  color: branch.type == 'Main Branch'
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "PlusJakartaSans"),
                            ),
                          ),
                        ),
                        DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                branch.email,
                                style: TextStyle(
                                    fontFamily: "PlusJakartaSans",
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(branch.phone,
                                  style: TextStyle(
                                    fontFamily: "PlusJakartaSans",
                                  )),
                            ],
                          ),
                        ),
                        DataCell(
                          Switch(
                            value: branch.status,
                            onChanged: (val) {
                              setState(() {
                                branch.status = val;
                              });
                            },
                            activeColor: Colors.blue[300],
                          ),
                        ),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🟣 App Bar with menu icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Manage Branch',
          style: TextStyle(
              fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final _formKey = GlobalKey<FormState>();
              _formKey.currentState?.validate();

              String _selectedType = 'Sub Branch';
              bool _status = true;
              XFile? _pickedImage;

              final position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              _latitudeController.text = position.latitude.toString();
              _longitudeController.text = position.longitude.toString();

              final Branch? newBranch = await showDialog<Branch>(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (context, setState) {
                    final isWide = MediaQuery.of(context).size.width > 600;

                    return Dialog(
                      backgroundColor: Colors.white,
                      insetPadding: const EdgeInsets.all(16),
                      child: Container(
                        width: isWide ? 600 : double.infinity,
                        padding: const EdgeInsets.all(24),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Add New Branch',
                                  style: TextStyle(
                                    fontFamily: "PlusJakartaSans",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Name and Phone
                                isWide
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: _buildDialogTextField(
                                              _nameController,
                                              'Name',
                                              validator: (value) =>
                                                  value == null || value.isEmpty
                                                      ? 'Name is required'
                                                      : null,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          _phoneField(),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _buildDialogTextField(
                                            _nameController,
                                            'Name',
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                    ? 'Name is required'
                                                    : null,
                                          ),
                                          const SizedBox(height: 8),
                                          _phoneField(),
                                        ],
                                      ),
                                const SizedBox(height: 8),

                                // Password and Confirm Password
                                isWide
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: _buildDialogTextField(
                                              _passwordController,
                                              'Password',
                                              obscureText: true,
                                              validator: (value) =>
                                                  value != null &&
                                                          value.length < 6
                                                      ? 'Min 6 characters'
                                                      : null,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildDialogTextField(
                                              _confirmPasswordController,
                                              'Confirm Password',
                                              obscureText: true,
                                              validator: (value) => value !=
                                                      _passwordController.text
                                                  ? 'Passwords do not match'
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _buildDialogTextField(
                                            _passwordController,
                                            'Password',
                                            obscureText: true,
                                            validator: (value) =>
                                                value != null &&
                                                        value.length < 6
                                                    ? 'Min 6 characters'
                                                    : null,
                                          ),
                                          const SizedBox(height: 8),
                                          _buildDialogTextField(
                                            _confirmPasswordController,
                                            'Confirm Password',
                                            obscureText: true,
                                            validator: (value) => value !=
                                                    _passwordController.text
                                                ? 'Passwords do not match'
                                                : null,
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 8),

                                _buildDialogTextField(
                                  _emailController,
                                  'Email',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    }
                                    final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                                    return emailRegex.hasMatch(value)
                                        ? null
                                        : 'Enter a valid email';
                                  },
                                ),
                                const SizedBox(height: 8),

                                // Latitude & Longitude
                                isWide
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: _buildDialogTextField(
                                                _latitudeController,
                                                'Latitude'),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: _buildDialogTextField(
                                                _longitudeController,
                                                'Longitude'),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          _buildDialogTextField(
                                              _latitudeController, 'Latitude'),
                                          const SizedBox(height: 8),
                                          _buildDialogTextField(
                                              _longitudeController,
                                              'Longitude'),
                                        ],
                                      ),
                                const SizedBox(height: 8),

                                // Branch Type
                                DropdownButtonFormField<String>(
                                  value: _selectedType,
                                  isExpanded:
                                      true, // Prevents overflow by allowing full width
                                  decoration: InputDecoration(
                                    labelText: 'Branch Type',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppTheme.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: AppTheme.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  items: ['Main Branch', 'Sub Branch']
                                      .map((type) => DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedType = value);
                                    }
                                  },
                                ),

                                const SizedBox(height: 8),

                                // Status
                                Row(
                                  children: [
                                    const Text('Status',
                                        style: TextStyle(
                                            fontFamily: "PlusJakartaSans",
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Switch(
                                      value: _status,
                                      onChanged: (val) {
                                        setState(() => _status = val);
                                      },
                                      activeColor: AppTheme.primaryColor,
                                      activeTrackColor: Colors.blue[50],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Image Picker
                                Row(
                                  children: [
                                    _pickedImage != null
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: FileImage(
                                                File(_pickedImage!.path)),
                                          )
                                        : const CircleAvatar(
                                            radius: 30,
                                            child: Icon(Icons.image,
                                                color: AppTheme.primaryColor),
                                            backgroundColor: Color.fromRGBO(
                                                227, 242, 253, 1),
                                          ),
                                    const SizedBox(width: 10),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        final image = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        if (image != null) {
                                          setState(() => _pickedImage = image);
                                        }
                                      },
                                      icon: const Icon(Icons.upload,
                                          color: AppTheme.primaryColor),
                                      label: const Text("Upload Image",
                                          style: TextStyle(
                                              fontFamily: "PlusJakartaSans",
                                              color: AppTheme.primaryColor)),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      child: const Text('Cancel',
                                          style: TextStyle(
                                              fontFamily: "PlusJakartaSans",
                                              color: AppTheme.primaryColor)),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      child: const Text('Save',
                                          style: TextStyle(
                                              fontFamily: "PlusJakartaSans",
                                              color: AppTheme.primaryColor)),
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          final newBranch = Branch(
                                            name: _nameController.text,
                                            phone: _phoneController.text,
                                            password: _passwordController.text,
                                            confirmpassword:
                                                _confirmPasswordController.text,
                                            email: _emailController.text,
                                            latitude: _latitudeController.text,
                                            longitude:
                                                _longitudeController.text,
                                            type: _selectedType,
                                            status: _status,
                                            imagePath: _pickedImage?.path ?? '',
                                          );
                                          Navigator.pop(context, newBranch);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              );

              if (newBranch != null) {
                setState(() {
                  branches.add(newBranch);
                  _searchBranches();
                });
              }
            },
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Banner Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width < 600
                    ? 180
                    : 300, // Responsive height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/kechi4.jpg'), // your banner image
                    fit: BoxFit.cover,
                    alignment: MediaQuery.of(context).size.width < 600
                        ? Alignment(0.0, 0.0)
                        : Alignment(0.0, 0.35),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

// Form Card (Everything inside here)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Heading + Search Row with LayoutBuilder
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 500;

                          return isNarrow
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Branch List',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "PlusJakartaSans",
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.blue[50],
                                          child: Text(
                                            branches.length.toString(),
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              fontFamily: "PlusJakartaSans",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    _buildSearchBar(isNarrow),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      'Branch List',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "PlusJakartaSans",
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.blue[50],
                                      child: Text(
                                        branches.length.toString(),
                                        style: TextStyle(
                                          color: Colors.blue[300],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: "PlusJakartaSans",
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Flexible(child: _buildSearchBar(false)),
                                  ],
                                );
                        },
                      ),

                      SizedBox(height: 16),

                      // Branch List Table
                      _buildBranchList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
