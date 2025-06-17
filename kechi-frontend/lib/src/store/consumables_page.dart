import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kechi/src/store/scan_issue_page.dart';

class ConsumablesPage extends StatefulWidget {
  final List<String> carouselImages;

  const ConsumablesPage({
    Key? key,
    required this.carouselImages,
  }) : super(key: key);

  @override
  _ConsumablesPageState createState() => _ConsumablesPageState();
}

class _ConsumablesPageState extends State<ConsumablesPage> {
  // Sample database of products
  final List<Map<String, dynamic>> _products = [
    {
      'sku': 'SKU001',
      'name': 'Hair Color - Black',
      'category': 'Hair Color',
      'quantity': 10,
      'image': 'assets/images/sunsilk.jpg',
    },
    {
      'sku': 'SKU002',
      'name': 'Hair Color - Brown',
      'category': 'Hair Color',
      'quantity': 15,
      'image': 'assets/images/l_cond.jpg',
    },
    {
      'sku': 'SKU003',
      'name': 'Shampoo - Professional',
      'category': 'Shampoo',
      'quantity': 20,
      'image': 'assets/images/l_shampoo.jpg',
    },
  ];

  // Sample database of artists
  final List<Map<String, dynamic>> _artists = [
    {
      'id': 'A001',
      'name': 'John Doe',
      'services': ['Hair Cutting', 'Hair Coloring', 'Hair Styling'],
      'branch': 'Main Branch',
    },
    {
      'id': 'A002',
      'name': 'Jane Smith',
      'services': ['Hair Coloring', 'Hair Straightening', 'Facial'],
      'branch': 'Parel Branch',
    },
    {
      'id': 'A003',
      'name': 'Mike Johnson',
      'services': ['Hair Cutting', 'Spa', 'Hair Treatment'],
      'branch': 'Chembur Branch',
    },
  ];

  // List to store issued products
  final List<Map<String, dynamic>> _issuedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Cards
            _buildModernActionCard(
              title: 'Issue Consumables/Resources',
              subtitle: 'Scan or manually assign products to artists',
              icon: Icons.qr_code_scanner_rounded,
              color: Color(0xFF4C7EFF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanIssuePage(
                      products: _products,
                      artists: _artists,
                      onIssue: (product, artist) {
                        setState(() {
                          _issuedProducts.add({
                            'product': product,
                            'artist': artist,
                            'issueDate': DateTime.now(),
                            'status': 'Issued',
                          });
                        });
                      },
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16),

            _buildModernActionCard(
              title: 'View Issued Products',
              subtitle: 'Monitor and manage all product assignments',
              icon: Icons.list_alt_rounded,
              color: Color(0xFF4C7EFF),
              onTap: () {
                // TODO: Implement view issued products page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1D29),
                          letterSpacing: 0.1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Color(0xFF8B8E98),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFBCC1CC),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
