import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

Future<dynamic> _assetToFile(String assetPath) async {
  if (kIsWeb) {
    // For web, return the asset path directly
    return assetPath;
  } else {
    // For mobile platforms, convert to File
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }
}

class GalleryPage extends StatefulWidget {
  final bool isSelectingProfilePhoto;

  const GalleryPage({
    Key? key,
    this.isSelectingProfilePhoto = false,
  }) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  File? _pickedImage;
  String? selectedImagePath;
  int? selectedImageIndex; // Track the selected image index
  bool _isLoading = false;

  final List<String> categories = [
    'Profile',
    'Services',
    'Resources',
    'Shop',
  ];

  final List<String> images = [
    'assets/images/gallery1.png',
    'assets/images/gallery2.png',
    'assets/images/gallery3.png',
    'assets/images/gallery4.png',
    'assets/images/gallery5.png',
    'assets/images/gallery6.png',
    'assets/images/gallery7.png',
    'assets/images/gallery8.png',
    'assets/images/gallery9.png',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showUploadOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a photo"),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from gallery"),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        selectedImageIndex = null; // Reset selected gallery image
      });

      // If selecting for profile photo, return immediately
      if (widget.isSelectingProfilePhoto) {
        Navigator.pop(context, _pickedImage);
      } else {
        Navigator.pop(context); // Just close the bottom sheet
      }
    }
  }

  // Method to handle selecting an image from the gallery
  void _selectGalleryImage(int index) async {
    if (selectedImageIndex == index) {
      // Deselect
      setState(() {
        selectedImageIndex = null;
        _pickedImage = null;
        _isLoading = false;
      });
    } else {
      setState(() {
        selectedImageIndex = index;
        _pickedImage = null;
        _isLoading = true;
      });

      if (widget.isSelectingProfilePhoto) {
        try {
          final result = await _assetToFile(images[index]);
          if (mounted) {
            setState(() {
              if (kIsWeb) {
                selectedImagePath = result; // Store the asset path for web
              } else {
                _pickedImage = result as File; // Store the File for mobile
              }
              _isLoading = false;
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF1A73E8),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: Text(
                    widget.isSelectingProfilePhoto
                        ? 'Select Profile Photo'
                        : 'Gallery',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/gallery_background.png',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Color(0xFF1A73E8)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              /// TabBar with extended underline
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 24),
                    indicator: const UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 3.0, color: Color(0xFF1A73E8)),
                      insets: EdgeInsets.symmetric(
                          horizontal: 4.0), // <-- extended underline
                    ),
                    labelColor: const Color(0xFF1A73E8),
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: categories.map((c) => Tab(text: c)).toList(),
                  ),
                ),
              ),

              /// Gallery Grid
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GalleryCard(
                        imagePath: images[index % images.length],
                        title:
                            '${categories[_tabController.index]} #${index + 1}',
                        likes: 20 + index * 7,
                        isSelectingProfilePhoto: widget.isSelectingProfilePhoto,
                        isSelected: selectedImageIndex == index,
                        onTap: () => _selectGalleryImage(index),
                      );
                    },
                    childCount: images.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.78,
                  ),
                ),
              ),

              if (_pickedImage != null || selectedImagePath != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preview:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _pickedImage != null
                              ? Image.file(_pickedImage!)
                              : Image.asset(selectedImagePath!),
                        ),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          /// FAB: Upload or Use Photo
          Positioned(
            bottom: 20,
            right: 20,
            child: widget.isSelectingProfilePhoto &&
                    (selectedImageIndex != null ||
                        _pickedImage != null ||
                        selectedImagePath != null)
                ? (_isLoading
                    ? FloatingActionButton.extended(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        onPressed: null,
                        icon: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        label: const Text('Loading...'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 6,
                      )
                    : FloatingActionButton.extended(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        onPressed: () async {
                          if (_pickedImage != null) {
                            Navigator.pop(context, _pickedImage);
                          } else if (selectedImageIndex != null) {
                            if (kIsWeb) {
                              Navigator.pop(context, selectedImagePath);
                            } else {
                              final file = await _assetToFile(
                                  images[selectedImageIndex!]);
                              if (mounted) {
                                Navigator.pop(context, file);
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Use Photo'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 6,
                      ))
                : FloatingActionButton.extended(
                    backgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                    onPressed: () => _showUploadOptions(context),
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 6,
                  ),
          ),
        ],
      ),
    );
  }
}

class GalleryCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final int likes;
  final bool isSelectingProfilePhoto;
  final bool isSelected; // Added to track selection state
  final VoidCallback? onTap;

  const GalleryCard({
    required this.imagePath,
    required this.title,
    required this.likes,
    this.isSelectingProfilePhoto = false,
    this.isSelected = false, // Default to not selected
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Add border when selected
          border: isSelected
              ? Border.all(color: const Color(0xFF1A73E8), width: 3)
              : null,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.favorite_border,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '$likes likes',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Selection checkmark indicator
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A73E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
