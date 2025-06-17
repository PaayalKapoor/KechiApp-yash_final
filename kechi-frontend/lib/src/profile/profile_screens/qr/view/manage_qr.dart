import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

class ManageQRPage extends StatefulWidget {
  const ManageQRPage({super.key});

  @override
  _ManageQRPageState createState() => _ManageQRPageState();
}

class QRData {
  final String title;
  final String url;
  final String description;
  final IconData icon;
  final Color color;

  QRData({
    required this.title,
    required this.url,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _ManageQRPageState extends State<ManageQRPage> {
  final List<GlobalKey> _qrKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  final List<GlobalKey> _cardKeys = [GlobalKey(), GlobalKey(), GlobalKey()];

  String _businessName = "Arrows Hair & Beauty";
  String _businessHours = "9 AM - 5 PM";
  bool _isCustomizing = false;
  int _currentQRIndex = 0;
  late PageController _qrPageController;

  late List<QRData> _qrDataList;

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessHoursController =
      TextEditingController();
  final TextEditingController _googleReviewController = TextEditingController();
  final TextEditingController _kechiReviewController = TextEditingController();
  final TextEditingController _storeUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeQRData();
    _initializeControllers();
    _qrPageController = PageController(initialPage: 0);
  }

  void _initializeQRData() {
    _qrDataList = [
      QRData(
        title: "Google Reviews",
        url: "https://g.page/r/CXXXXXXXXXXXXXXXXeb8/review",
        description: "Scan to leave a Google review",
        icon: Icons.star,
        color: const Color(0xFF4285F4),
      ),
      QRData(
        title: "Kechi Reviews",
        url: "https://kechi.app/salon/arrows-beauty/reviews",
        description: "Scan to leave a Kechi review",
        icon: Icons.rate_review,
        color: const Color(0xFF1A73E8),
      ),
      QRData(
        title: "Visit Our Store",
        url: "https://kechi.app/salon/arrows-beauty",
        description: "Scan to visit our store page",
        icon: Icons.store,
        color: const Color(0xFF0F9D58),
      ),
    ];
  }

  void _initializeControllers() {
    _businessNameController.text = _businessName;
    _businessHoursController.text = _businessHours;
    _googleReviewController.text = _qrDataList[0].url;
    _kechiReviewController.text = _qrDataList[1].url;
    _storeUrlController.text = _qrDataList[2].url;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessHoursController.dispose();
    _googleReviewController.dispose();
    _kechiReviewController.dispose();
    _storeUrlController.dispose();
    _qrPageController.dispose();
    super.dispose();
  }

  Future<void> _shareQRCode(int index) async {
    try {
      RenderRepaintBoundary boundary = _cardKeys[index]
          .currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file = await File(
                '${tempDir.path}/${_qrDataList[index].title.toLowerCase().replaceAll(' ', '_')}_qr.png')
            .create();
        await file.writeAsBytes(pngBytes);
        await Share.shareXFiles(
          [XFile(file.path)],
          text: '${_qrDataList[index].description} for $_businessName',
          subject: '$_businessName - ${_qrDataList[index].title} QR Code',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR code: $e')),
      );
    }
  }

  Future<void> _shareAllQRCodes() async {
    try {
      List<XFile> files = [];

      for (int i = 0; i < _cardKeys.length; i++) {
        RenderRepaintBoundary boundary = _cardKeys[i]
            .currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          final tempDir = await getTemporaryDirectory();
          final file = await File(
                  '${tempDir.path}/${_qrDataList[i].title.toLowerCase().replaceAll(' ', '_')}_qr.png')
              .create();
          await file.writeAsBytes(pngBytes);
          files.add(XFile(file.path));
        }
      }

      if (files.isNotEmpty) {
        await Share.shareXFiles(
          files,
          text: 'All QR codes for $_businessName',
          subject: '$_businessName - Complete QR Code Set',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR codes: $e')),
      );
    }
  }

  Future<void> _printQRCode(int index) async {
    final pdf = pw.Document();
    RenderRepaintBoundary boundary = _cardKeys[index]
        .currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final imageData = byteData.buffer.asUint8List();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Image(
                    pw.MemoryImage(imageData),
                    width: 500,
                    fit: pw.BoxFit.contain,
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Generated by Kechi App',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }
  }

  Future<void> _downloadQRCode(int index) async {
    try {
      RenderRepaintBoundary boundary = _cardKeys[index]
          .currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Get the app's cache directory
        final cacheDir = await getTemporaryDirectory();
        final qrDir = Directory('${cacheDir.path}/qr_codes');

        // Create qr_codes directory if it doesn't exist
        if (!await qrDir.exists()) {
          await qrDir.create(recursive: true);
        }

        final fileName =
            '${_qrDataList[index].title.toLowerCase().replaceAll(' ', '_')}_qr.png';
        final file = File('${qrDir.path}/$fileName');

        // Write the file
        await file.writeAsBytes(pngBytes);

        // Verify the file was written
        if (await file.exists()) {
          final fileSize = await file.length();
          if (fileSize > 0) {
            // Share the file after saving
            await Share.shareXFiles(
              [XFile(file.path)],
              text: '${_qrDataList[index].description} for $_businessName',
              subject: '$_businessName - ${_qrDataList[index].title} QR Code',
            );
          } else {
            throw Exception('File was created but is empty');
          }
        } else {
          throw Exception('Failed to create file');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving QR code: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _updateQRCodes() {
    setState(() {
      _businessName = _businessNameController.text.isEmpty
          ? _businessName
          : _businessNameController.text;
      _businessHours = _businessHoursController.text.isEmpty
          ? _businessHours
          : _businessHoursController.text;

      // Update QR URLs
      _qrDataList[0] = QRData(
        title: _qrDataList[0].title,
        url: _googleReviewController.text.isEmpty
            ? _qrDataList[0].url
            : _googleReviewController.text,
        description: _qrDataList[0].description,
        icon: _qrDataList[0].icon,
        color: _qrDataList[0].color,
      );

      _qrDataList[1] = QRData(
        title: _qrDataList[1].title,
        url: _kechiReviewController.text.isEmpty
            ? _qrDataList[1].url
            : _kechiReviewController.text,
        description: _qrDataList[1].description,
        icon: _qrDataList[1].icon,
        color: _qrDataList[1].color,
      );

      _qrDataList[2] = QRData(
        title: _qrDataList[2].title,
        url: _storeUrlController.text.isEmpty
            ? _qrDataList[2].url
            : _storeUrlController.text,
        description: _qrDataList[2].description,
        icon: _qrDataList[2].icon,
        color: _qrDataList[2].color,
      );

      _isCustomizing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FE),
      appBar: AppBar(
        title: const Text(
          'QR Code Manager',
          style: TextStyle(
            color: Color(0xFF1A73E8),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A73E8)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(constraints.maxWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_isCustomizing) ...[
                      // QR Type Indicator
                      Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _qrDataList.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentQRIndex == index
                                    ? _qrDataList[index].color
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // QR Code Display
                      SizedBox(
                        height: constraints.maxHeight * 0.6,
                        child: PageView.builder(
                          controller: _qrPageController,
                          itemCount: _qrDataList.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentQRIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return _buildQRCard(index, constraints);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // QR Type Tabs
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          children: List.generate(
                            _qrDataList.length,
                            (index) => Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _qrPageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: _currentQRIndex == index
                                        ? _qrDataList[index].color
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _qrDataList[index].color,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        _qrDataList[index].icon,
                                        color: _currentQRIndex == index
                                            ? Colors.white
                                            : _qrDataList[index].color,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _qrDataList[index].title,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _currentQRIndex == index
                                              ? Colors.white
                                              : _qrDataList[index].color,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            color: const Color(0xFF1A73E8),
                            onTap: () => _shareQRCode(_currentQRIndex),
                          ),
                          _buildActionButton(
                            icon: Icons.print,
                            label: 'Print',
                            color: const Color(0xFF4285F4),
                            onTap: () => _printQRCode(_currentQRIndex),
                          ),
                          _buildActionButton(
                            icon: Icons.edit,
                            label: 'Edit',
                            color: const Color(0xFF5E97F6),
                            onTap: () {
                              setState(() {
                                _isCustomizing = true;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Usage Tips
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Color(0xFFFFA000),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'QR Code Usage Tips',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildTipItem(
                                'Place Google Reviews QR at checkout',
                                Icons.star_border,
                              ),
                              _buildTipItem(
                                'Display Store QR at entrance',
                                Icons.store_outlined,
                              ),
                              _buildTipItem(
                                'Show Kechi Reviews QR after service',
                                Icons.rate_review_outlined,
                              ),
                              _buildTipItem(
                                'Print and laminate for durability',
                                Icons.print_outlined,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Customization Interface
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customize Your QR Codes',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Business Info
                              TextField(
                                controller: _businessNameController,
                                decoration: InputDecoration(
                                  labelText: 'Business Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.business),
                                ),
                                maxLength: 50,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _businessHoursController,
                                decoration: InputDecoration(
                                  labelText: 'Business Hours',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.access_time),
                                  hintText: 'e.g., 9 AM - 5 PM',
                                ),
                                maxLength: 30,
                              ),
                              const SizedBox(height: 20),

                              // QR URLs
                              const Text(
                                'QR Code URLs',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 12),

                              TextField(
                                controller: _googleReviewController,
                                decoration: InputDecoration(
                                  labelText: 'Google Reviews URL',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.star,
                                      color: _qrDataList[0].color),
                                  hintText: 'https://g.page/r/...',
                                ),
                                maxLength: 200,
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: _kechiReviewController,
                                decoration: InputDecoration(
                                  labelText: 'Kechi Reviews URL',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.rate_review,
                                      color: _qrDataList[1].color),
                                  hintText:
                                      'https://kechi.app/salon/.../reviews',
                                ),
                                maxLength: 200,
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: _storeUrlController,
                                decoration: InputDecoration(
                                  labelText: 'Store Page URL',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: Icon(Icons.store,
                                      color: _qrDataList[2].color),
                                  hintText: 'https://kechi.app/salon/...',
                                ),
                                maxLength: 200,
                              ),

                              const SizedBox(height: 24),

                              // Action Buttons
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _updateQRCodes,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A73E8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Apply Changes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCustomizing = false;
                                    });
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQRCard(int index, BoxConstraints constraints) {
    final qrData = _qrDataList[index];
    final maxWidth = constraints.maxWidth * 0.9;
    final qrSize = (maxWidth * 0.5).clamp(150.0, 250.0);

    return RepaintBoundary(
      key: _cardKeys[index],
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                qrData.color.withOpacity(0.1),
                qrData.color.withOpacity(0.05),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: qrData.color,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          qrData.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          qrData.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business Name
                  Text(
                    _businessName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // QR Code
                  RepaintBoundary(
                    key: _qrKeys[index],
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: qrData.color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: qrData.url,
                        version: QrVersions.auto,
                        size: qrSize,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        embeddedImage:
                            const AssetImage('assets/logo_small.png'),
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(40, 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: qrData.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      qrData.description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: qrData.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Business Hours
                  Text(
                    'Open Daily: $_businessHours',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF4285F4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
