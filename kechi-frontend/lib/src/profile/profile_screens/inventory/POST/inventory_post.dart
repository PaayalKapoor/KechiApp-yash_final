import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InventoryDashboard extends StatefulWidget {
  const InventoryDashboard({super.key});

  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard>
    with TickerProviderStateMixin {
  // Matching your app's theme colors
  static const Color primaryColor = Color(0xFF4C7EFF);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  int? _hoveredIndex;

  final List<InventoryItem> inventoryItems = [
    InventoryItem(
      icon: Icons.warehouse_outlined,
      title: 'WAREHOUSE',
      subtitle: 'Manage locations & stock',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: Icons.person,
      title: 'VENDOR',
      subtitle: 'Supplier management',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: FontAwesomeIcons.boxOpen,
      title: 'PRODUCTS',
      subtitle: 'Product catalog & details',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: FontAwesomeIcons.basketShopping,
      title: 'CONSUMABLES',
      subtitle: 'Consumable catalog & details',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: Icons.description_outlined,
      title: 'PURCHASE ORDERS',
      subtitle: 'Manage purchase orders',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: Icons.qr_code_2,
      title: 'PRINT BARCODE',
      subtitle: 'Generate & print codes',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: Icons.shopping_cart_checkout_rounded,
      title: 'INWARD',
      subtitle: 'Receive inventory',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
    InventoryItem(
      icon: Icons.fire_truck,
      title: 'TRANSFER',
      subtitle: 'Move between locations',
      color: const Color(0xFF4C7EFF),
      gradient: [const Color(0xFF4C7EFF), const Color(0xFF6366F1)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_backgroundController);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildModernAppBar(),
      body: Stack(
        children: [
          _buildSubtleBackground(),
          _buildMainContent(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      backgroundColor: surfaceColor,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'INVENTORY',
        style: TextStyle(
          color: Color(0xFF4C7EFF),
          fontWeight: FontWeight.w900,
          fontSize: 22,
          letterSpacing: 1.5,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildSubtleBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.2,
              colors: [
                primaryColor.withOpacity(0.03),
                backgroundColor,
                primaryColor.withOpacity(0.01),
              ],
            ),
          ),
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: SubtleParticlesPainter(_backgroundAnimation.value),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(child: _buildModernGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildModernGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: inventoryItems.length,
      itemBuilder: (context, index) {
        return _buildUltraModernCard(inventoryItems[index], index);
      },
    );
  }

  Widget _buildUltraModernCard(InventoryItem item, int index) {
    return GestureDetector(
      onTap: () => _navigateToTab(item.title),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _navigateToTab(item.title),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.color.withOpacity(0.1),
                          item.color.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: item.color.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      size: 28,
                      color: item.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: 0.8,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      item.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        color: textSecondary,
                        height: 1.1,
                        fontWeight: FontWeight.w500,
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
  }

  void _navigateToTab(String tabName) {
    print('Navigating to: $tabName');

    // Create a styled snackbar matching your theme
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.launch_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Opening $tabName module...',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        elevation: 8,
      ),
    );
  }
}

class InventoryItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradient;

  InventoryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradient,
  });
}

// Custom painter for subtle background particles
class SubtleParticlesPainter extends CustomPainter {
  final double animationValue;

  SubtleParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4C7EFF).withOpacity(0.02)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final x = (size.width * (i * 0.15 + animationValue * 0.05)) % size.width;
      final y =
          (size.height * (i * 0.08 + animationValue * 0.03)) % size.height;
      final radius = (math.sin(animationValue + i) + 1) * 1.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
