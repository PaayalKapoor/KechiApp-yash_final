import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:kechi/theme.dart';
import 'package:flutter/services.dart';
import 'package:kechi/src/profile/profile_screens/contact_us/view/contactus_page.dart';
import 'package:kechi/src/profile/profile_screens/manage_branch/view/managebranch_screen.dart';
import 'package:kechi/src/profile/profile_screens/refer&earn/view/referearn_screen.dart';
import 'package:kechi/src/profile/profile_screens/promotions/view/promotions_screen.dart';

class SalonFormPage extends StatefulWidget {
  @override
  _SalonFormPageState createState() => _SalonFormPageState();
}

class _SalonFormPageState extends State<SalonFormPage> {
  bool hasMultipleStylists = false;
  bool hasSalon = false;
  List<String> selectedCategories = [];

  List<String> categories = [
    "Hair Styling",
    "Makeup",
    "Hair Cut",
    "Pedicure & Manicure",
    "Waxing & Hair Removal",
  ];

  final TextEditingController salonNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController openingTimeController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  String? selectedCity = 'Bhavnagar';

  InputDecoration _buildInputDecoration(String? label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 14,
        color: Colors.black,
      ),
      floatingLabelStyle: TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 13,
        color: Colors.black,
      ),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      decoration: _buildInputDecoration(label).copyWith(
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 16,
      ),
    );
  }

  Widget _buildFormContent({required bool isSmallScreen}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service At",
            style: TextStyle(
                fontFamily: "PlusJakartaSans",
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor),
          ),
          SizedBox(
            height: 10,
          ),
          _buildTextField("Salon Name", salonNameController),
          SizedBox(height: 16),
          DropdownButtonFormField2(
            decoration: _buildInputDecoration("City"),
            value: selectedCity,
            isExpanded: true,
            items: ["Bhavnagar", "Mumbai", "Ahemdabad"]
                .map((gender) => DropdownMenuItem<String>(
                      value: gender,
                      child: Text(
                        gender,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.black,
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCity = value;
              });
            },
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: 250,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor,
                    blurRadius: 8,
                  )
                ],
              ),
              elevation: 8,
              scrollbarTheme: ScrollbarThemeData(
                thickness: MaterialStateProperty.all(4),
                thumbColor: MaterialStateProperty.all(AppTheme.primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          _buildMultiSelectDropdown(),
          SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            maxLines: 5,
            decoration: _buildInputDecoration("Description"),
          ),
          SizedBox(height: 16),
          _buildTextField("Address", locationController),
          SizedBox(height: 16),
          _buildTextField("Pincode", pincodeController),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Latitude", latitudeController)),
              SizedBox(width: 10),
              Expanded(
                  child: _buildTextField("Longitude", longitudeController)),
              IconButton(
                icon: Icon(Icons.my_location, color: Colors.blue),
                tooltip: "Refresh Location",
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
          SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Have Multiple Stylists?"),
            activeColor: Colors.blue,
            value: hasMultipleStylists,
            onChanged: (value) {
              setState(() {
                hasMultipleStylists = value;
              });
            },
          ),
          SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Have Multiple Branches?"),
            activeColor: Colors.blue,
            value: hasSalon,
            onChanged: (value) {
              setState(() {
                hasSalon = value;
              });
            },
          ),
          SizedBox(height: 16),
          Text("Opening Hour",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  fontFamily: "PlusJakartaSans")),
          SizedBox(height: 10),
          TextField(
            controller: openingTimeController,
            decoration: _buildInputDecoration("Opening Time"),
            onTap: () async {
              FocusScope.of(context)
                  .requestFocus(FocusNode()); // prevent keyboard
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() {
                  openingTimeController.text = picked.format(context);
                });
              }
            },
          ),
          SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: isSmallScreen ? double.infinity : 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ContactUsPage(), // Navigate to NewScreen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  "Save",
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectDropdown() {
    final isFocused = FocusNode();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Focus(
        focusNode: isFocused,
        onFocusChange: (hasFocus) {
          setState(() {});
        },
        child: GestureDetector(
          onTap: () async {
            isFocused.requestFocus();

            await showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return AlertDialog(
                      title: Text(
                        "Select Category",
                        style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: categories.map((category) {
                            return CheckboxListTile(
                              title: Text(
                                category,
                                style: TextStyle(
                                    fontFamily: "PlusJakartaSans",
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              value: selectedCategories.contains(category),
                              onChanged: (bool? value) {
                                setStateDialog(() {
                                  if (value == true &&
                                      !selectedCategories.contains(category)) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                });
                                setState(() {});
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
            );

            isFocused.unfocus();
            setState(() {});
          },
          child: InputDecorator(
            isFocused: isFocused.hasFocus || selectedCategories.isNotEmpty,
            isEmpty: selectedCategories.isEmpty,
            decoration: InputDecoration(
              labelText: "Select Category",
              labelStyle:
                  TextStyle(fontFamily: "PlusJakartaSans", fontSize: 14),
              floatingLabelStyle: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 13,
                  color: Colors.black),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue, width: 1),
              ),
            ),
            child: selectedCategories.isEmpty
                ? null
                : Text(
                    selectedCategories.join(', '),
                    style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoColumnForm({required bool isSmallScreen}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              SizedBox(
                width: 620,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Service At",
                      style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        width: 300,
                        child:
                            _buildTextField("Salon Name", salonNameController)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField2(
                          decoration: _buildInputDecoration("City"),
                          value: selectedCity,
                          isExpanded: true,
                          items: ["Bhavnagar", "Mumbai", "Ahemdabad"]
                              .map((city) => DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(
                                      city,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'PlusJakartaSans',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCity = value;
                            });
                          },
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            width: 250,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor,
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            elevation: 8,
                          ),
                        )),
                  ),
                ],
              ),
              _buildMultiSelectDropdown(),
              TextFormField(
                controller: descriptionController,
                maxLines: 5,
                decoration: _buildInputDecoration("Description"),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 300, // You can adjust the width as needed
                      child: _buildTextField("Address", locationController),
                    ),
                  ),
                  SizedBox(
                      width:
                          16), // You can adjust the spacing between the fields
                  Expanded(
                    child: TextFormField(
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pincode is required';
                        }
                        if (value.length != 6) {
                          return 'Enter a valid 6-digit pincode';
                        }
                        return null;
                      },
                      decoration: _buildInputDecoration("Pincode"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField("Latitude", latitudeController),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField("Longitude", longitudeController),
                  ),
                  IconButton(
                    icon: Icon(Icons.my_location, color: Colors.blue),
                    tooltip: "Refresh Location",
                    onPressed: _getCurrentLocation,
                  ),
                ],
              ),
              SizedBox(height: 2),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Have Multiple Stylists?"),
                activeColor: Colors.blue,
                value: hasMultipleStylists,
                onChanged: (value) {
                  setState(() {
                    hasMultipleStylists = value;
                  });
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Have Multiple Branches?"),
                activeColor: Colors.blue,
                value: hasSalon,
                onChanged: (value) {
                  setState(() {
                    hasSalon = value;
                  });
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Opening Hour",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          fontFamily: "PlusJakartaSans")),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: openingTimeController,
                      decoration: _buildInputDecoration("Opening Time"),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            openingTimeController.text = picked.format(context);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: isSmallScreen ? double.infinity : 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ContactUsPage(), // Navigate to NewScreen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  "Save",
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 500,
            width: 500, // Adjust the height as needed
            child: Image.asset(
              'assets/images/customer.png', // or use NetworkImage
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20), // spacing below the image
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Check if the screen size is large enough for tablet or web layout
                bool isDesktopOrTablet = constraints.maxWidth > 800;

                return isDesktopOrTablet
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Left: Image
                            _buildImageSection(),
                            SizedBox(width: 20),
                            // Right: Form
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(24.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: _buildTwoColumnForm(
                                          isSmallScreen: false)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              // Full-width image
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: Image.asset(
                                      'assets/images/profile_page.jpg',
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            'Error loading profile image: $error');
                                        return Container(
                                          width: double.infinity,
                                          height: 300,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.image_not_supported,
                                              size: 50),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // Overlapping avatar
                              Positioned(
                                bottom: -40,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        color: AppTheme.primaryColor, width: 3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: CircleAvatar(
                                          radius: 36,
                                          backgroundImage: AssetImage(
                                              'assets/images/customer.png'),
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Add padding only to the form content
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildFormContent(isSmallScreen: true),
                          ),
                        ],
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
