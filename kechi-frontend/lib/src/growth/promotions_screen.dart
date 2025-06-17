import 'dart:math';
import "package:flutter/material.dart";
import "package:kechi/theme.dart";
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kechi/src/profile/profile_screens/contact_us/view/contactus_page.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

final Map<String, bool> discountsPublished = {
  'deal_discount': false,
  'exclusive_offers': false,
  'flat_discount': false,
};

final Map<String, Color> categoryColors = {
  'deal_discount': Colors.blue,
  'exclusive_offers': const Color.fromARGB(255, 48, 41, 193),
  'flat_discount': Colors.purple,
};

class Speedometer extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const Speedometer({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5, // Wider than tall
      child: CustomPaint(
        painter: _SpeedometerPainter(progress),
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double progress;

  _SpeedometerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.7 / 2;
    final startAngle = pi;
    final sweepAngle = pi;

    // Draw arc
    final arcPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Draw progress arc
    final progressPaint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );

    // Draw needle
    final angle = startAngle + sweepAngle * progress.clamp(0.0, 1.0);
    final needleLength = radius - 8;
    final needlePaint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 4;
    final needleEnd = Offset(
      center.dx + needleLength * cos(angle),
      center.dy + needleLength * sin(angle),
    );
    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw center circle
    final centerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 10, centerPaint);
    canvas.drawCircle(center, 10, Paint()..color = Colors.deepOrange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  List<Discount> _allDiscounts = [];

  double getLinearProgress() {
    // Each discount is worth 5%
    return _allDiscounts.length * 0.05;
  }

  // This method is called after a discount is created and confirmed
  void _onDiscountCreated(String category, Discount discount) {
    setState(() {
      discountsPublished[category] = true;
      _allDiscounts.add(discount);
    });
  }

  // This method is called when the user taps "Improve Coverage Now"
  Future<void> _navigateToCoverageDetail() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CoverageDetailScreen(),
      ),
    );
    if (result != null &&
        result.containsKey('category') &&
        result.containsKey('discount')) {
      _onDiscountCreated(result['category'], result['discount']);
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formatCategoryName(String key) {
      return key
          .split('_')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
    }

    String getGrowthMessage(double progress) {
      final percentage = (progress * 100).round();

      if (percentage <= 20) {
        return "Low growth\nImprove coverage to maximise growth";
      } else if (percentage <= 40) {
        return "Emerging presence\nGet your brand out there and grow";
      } else if (percentage <= 60) {
        return "Steady growth\nOpportunities await you to grow more";
      } else if (percentage <= 80) {
        return "Strong Visibility\nBuild a household brand and maximise growth";
      } else {
        return "Exceptional Performance\nTake it to the next level";
      }
    }

    final publishedColors = discountsPublished.entries
        .where((entry) => entry.value)
        .map((entry) => categoryColors[entry.key]!)
        .toList();

    if (publishedColors.length == 1) {
      publishedColors.add(publishedColors.first);
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
          shadowColor: Colors.grey,
          surfaceTintColor: Colors.grey,
          title: Text(
            "Promotions",
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Promotions Progress",
                          style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${(getLinearProgress() * 100).round()}%",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "PlusJakartaSans",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 12,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: getLinearProgress(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: publishedColors.isNotEmpty
                                    ? LinearGradient(colors: publishedColors)
                                    : LinearGradient(
                                        colors: [Colors.grey, Colors.grey]),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: discountsPublished.keys.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: categoryColors[category],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      _formatCategoryName(category),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                      height: 60,
                                      child: Speedometer(
                                          progress: getLinearProgress())),
                                  SizedBox(height: 4),
                                  Text(
                                    "GROWTH\nMETER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "PlusJakartaSans",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getGrowthMessage(getLinearProgress())
                                          .split('\n')
                                          .first,
                                      style: TextStyle(
                                        fontFamily: "PlusJakartaSans",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      getGrowthMessage(getLinearProgress())
                                                  .split('\n')
                                                  .length >
                                              1
                                          ? getGrowthMessage(
                                                  getLinearProgress())
                                              .split('\n')[1]
                                          : '',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: "PlusJakartaSans"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 48, // increased from 40
                            child: ElevatedButton(
                              onPressed: _navigateToCoverageDetail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 12), // added padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Improve Coverage Now",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      14, // optional: you can reduce to 13 if space is still tight
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 24),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TrackDiscountsScreen(discounts: _allDiscounts)),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/preview_discount.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "View Active Discounts",
                            style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 18, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to Discount Performance screen
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage('assets/images/performance.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "View Discount Performance",
                                style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Track orders, sales and revenue of your discounts",
                                style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 18, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.blue[50],
                      border: Border.all(color: AppTheme.primaryColor)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How it Works",
                        style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "1. Create discounts.",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "2. Set parameters like discount type and validity period.",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "3. Publish your discounts to make them available to customers.",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "4. Track performance and watch your numbers grow.",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 13,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class TrackDiscountsScreen extends StatefulWidget {
  final List<Discount> discounts;

  const TrackDiscountsScreen({super.key, required this.discounts});

  @override
  _TrackDiscountsScreenState createState() => _TrackDiscountsScreenState();
}

class _TrackDiscountsScreenState extends State<TrackDiscountsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Discount> _allDiscounts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _allDiscounts = widget.discounts;
  }

  void _stopDiscount(Discount discount) {
    final index = _allDiscounts.indexOf(discount);
    if (index != -1) {
      final oldDiscount = _allDiscounts[index];
      final stoppedDiscount = Discount(
          category: discount.category,
          title: discount.title,
          code: discount.code,
          audience: discount.audience,
          minPurchase: discount.minPurchase,
          discount: discount.discount,
          startDate: discount.startDate,
          endDate: DateTime.now(),
          usageLimitPerUser: discount.usageLimitPerUser);
      setState(() {
        _allDiscounts[index] = stoppedDiscount;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Discount Stopped. Tap to Undo',
            style: TextStyle(fontFamily: "PlusJakartaSans"),
          ),
          backgroundColor: Colors.redAccent,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _allDiscounts[index] = oldDiscount;
              });
            },
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Track Discounts",
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryColor,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Material(
            color: Colors.white,
            elevation: 0,
            child:
                _buildCustomTabBar(), // Your custom TabBar with rounded indicator
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DiscountListTab(
                    type: 'active',
                    discounts: _allDiscounts,
                    onStop: _stopDiscount),
                DiscountListTab(type: 'upcoming', discounts: _allDiscounts),
                DiscountListTab(type: 'past', discounts: _allDiscounts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.deepOrange,
        unselectedLabelColor: Colors.black,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelStyle: const TextStyle(
          fontFamily: "PlusJakartaSans",
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: "PlusJakartaSans",
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        indicator: RoundedTabIndicator(
          color: Colors.deepOrange,
          height: 4,
          radius: 6,
        ),
        tabs: const [
          Tab(text: "Active"),
          Tab(text: "Upcoming"),
          Tab(text: "Past"),
        ],
      ),
    );
  }
}

class RoundedTabIndicator extends Decoration {
  final Color color;
  final double height;
  final double radius;

  const RoundedTabIndicator({
    required this.color,
    required this.height,
    this.radius = 4,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedPainter(this, onChanged);
  }
}

class _RoundedPainter extends BoxPainter {
  final RoundedTabIndicator decoration;

  _RoundedPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill;

    final indicatorWidth = configuration.size!.width;
    final xPos = offset.dx;
    final yPos = offset.dy + configuration.size!.height - decoration.height;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(xPos, yPos, indicatorWidth, decoration.height),
      Radius.circular(decoration.radius),
    );

    canvas.drawRRect(rect, paint);
  }
}

class Discount {
  final String category;
  final String title;
  final String code;
  final String audience;
  final int minPurchase;
  final String discount;
  final DateTime startDate;
  final DateTime endDate;
  final int usageLimitPerUser;

  Discount({
    required this.category,
    required this.title,
    required this.code,
    required this.audience,
    required this.minPurchase,
    required this.discount,
    required this.startDate,
    required this.endDate,
    required this.usageLimitPerUser,
  });
}

class DiscountListTab extends StatelessWidget {
  final String type;
  final List<Discount> discounts;
  final void Function(Discount)? onStop;

  DiscountListTab({required this.type, required this.discounts, this.onStop});

  List<Discount> getFilteredDiscounts() {
    final now = DateTime.now();

    if (type == 'active') {
      return discounts
          .where((d) => now.isAfter(d.startDate) && now.isBefore(d.endDate))
          .toList();
    } else if (type == 'upcoming') {
      return discounts.where((d) => now.isBefore(d.startDate)).toList();
    } else {
      return discounts.where((d) => now.isAfter(d.endDate)).toList();
    }
  }

  void _showDiscountPreview(BuildContext context, Discount discount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title
                Center(
                  child: Text(
                    "Discount Details",
                    style: const TextStyle(
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Details
                _buildDetailRow("Discount Applicable On", discount.category),
                _buildDetailRow("Target Audience", discount.audience),
                _buildDetailRow("Coupon Title", discount.title),
                _buildDetailRow("Coupon Code", discount.code),
                _buildDetailRow("Usage Limit per User",
                    discount.usageLimitPerUser.toString()),
                _buildDetailRow("Discount Type",
                    discount.discount.contains('%') ? "Percent" : "Amount"),
                _buildDetailRow("Discount Amount", discount.discount),
                _buildDetailRow("Minimum Purchase", "₹${discount.minPurchase}"),
                _buildDetailRow(
                  "Start Date & Time",
                  DateFormat('dd MMM yyyy, hh:mm a').format(discount.startDate),
                ),
                _buildDetailRow(
                  "End Date & Time",
                  DateFormat('dd MMM yyyy, hh:mm a').format(discount.endDate),
                ),

                const SizedBox(height: 32),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredDiscounts();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_discounts.jpg', // replace with your image
              width: 160,
              height: 160,
            ),
            const Text(
              "No discounts found",
              style: TextStyle(
                fontFamily: "PlusJakartaSans",
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                "60% of Salons run discounts on Kechi. Setup now to ensure you do not miss out on growth",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final discount = filtered[index];
        return _buildDiscountCard(context, discount);
      },
    );
  }

  Widget _buildDiscountCard(BuildContext context, Discount discount) {
    final isActive = type == 'active';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Range
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF5E6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today,
                    size: 13, color: Color(0xFF30825C)),
                const SizedBox(width: 6),
                Text(
                  "${DateFormat('dd MMM yyyy').format(discount.startDate)} - ${DateFormat('dd MMM yyyy').format(discount.endDate)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF30825C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Coupon Code
          Text(
            discount.code.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            discount.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            "Flat ${discount.discount} off upto Rs.${discount.minPurchase} for ${discount.audience} users",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),

          // Sponsorship Info (optional)
          Text(
            "💰 100% of the discount sponsored by the Restaurant",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 14),

          // View Details CTA
          GestureDetector(
            onTap: () => _showDiscountPreview(context, discount),
            child: Row(
              children: const [
                Text(
                  "VIEW DETAILS",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios,
                    size: 13, color: AppTheme.primaryColor),
              ],
            ),
          ),
          if (isActive && onStop != null) ...[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => onStop!(discount),
              icon: Icon(Icons.stop_circle, color: Colors.white),
              label: Text(
                "Stop Discount",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CoverageDetailScreen extends StatelessWidget {
  CoverageDetailScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> discountOptions = [
    {
      'title': 'Peak Customer Delight',
      'subtitle': 'Flat Deals',
      'coverage': '+20% Coverage',
      'category': 'flat_discount',
    },
    {
      'title': 'Peak Customer Delight',
      'subtitle': 'Deal of the Day',
      'coverage': '+20% Coverage',
      'category': 'deal_discount',
    },
    {
      'title': 'Peak Customer Delight',
      'subtitle': 'Exclusive Offers',
      'coverage': '+20% Coverage',
      'category': 'exclusive_offers',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.grey,
        title: Text(
          "Discount Progress",
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Increase progress by setting up\nfollowing discount types",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView.builder(
                itemCount: discountOptions.length,
                itemBuilder: (context, index) {
                  final data = discountOptions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () async {
                        final result =
                            await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscountSetupPage(
                              category: data['category'],
                            ),
                          ),
                        );
                        if (result != null &&
                            result.containsKey('category') &&
                            result.containsKey('discount')) {
                          Navigator.pop(context, result);
                        }
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            height: 100,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xFFF9F9F9),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 16),
                                      Text(
                                        data['title'],
                                        style: TextStyle(
                                          fontFamily: "PlusJakartaSans",
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        data['subtitle'],
                                        style: TextStyle(
                                          fontFamily: "PlusJakartaSans",
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -10,
                            left: 16,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                data['coverage'],
                                style: TextStyle(
                                  color: Colors.blue[500],
                                  fontFamily: "PlusJakartaSans",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountSetupPage extends StatefulWidget {
  final String category;
  const DiscountSetupPage({Key? key, required this.category}) : super(key: key);

  @override
  _DiscountSetupPageState createState() => _DiscountSetupPageState();
}

class _DiscountSetupPageState extends State<DiscountSetupPage> {
  List<Map<String, dynamic>> customDeals = [];
  List<String> selectedSpecialDiscount = [];
  int selectedTabIndex = 0;
  String? _generatedCode;
  late List<String> tabs;
  late List<String> imagePaths;

  int? _usageLimitPerUser;

  void _showCustomDealDialog() {
    String? x;
    String? y;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Buy X Get Y Free",
            style: TextStyle(
                fontFamily: "PlusJakartaSans",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: _buildInputDecoration(
                  label: "Choose X",
                  hintText: "Define X",
                ),
                value: x,
                items: ["Product", "Service"]
                    .map((val) => DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                            style: TextStyle(fontFamily: "PlusJakartaSans"),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  x = val;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _buildInputDecoration(
                    label: "Choose Y", hintText: "Define Y"),
                value: y,
                items: ["Product", "Service"]
                    .map((val) => DropdownMenuItem(
                          value: val,
                          child: Text(
                            val,
                            style: TextStyle(fontFamily: "PlusJakartaSans"),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  y = val;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (x != null && y != null) {
                  final newDescription = 'Buy $x Get $y Free';
                  final alreadyExists = customDeals.any(
                    (deal) => deal['description'] == newDescription,
                  );
                  if (alreadyExists) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text("Offer already created"),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  setState(() {
                    customDeals.add({
                      'title': 'Custom BOGO Deal',
                      'description': newDescription,
                      'footer':
                          'Boost your order values and create maximum customer delight',
                      'x': x,
                      'y': y,
                    });
                    selectedSpecialDiscount = [newDescription];
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                "Save",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    String _getTitleForCategory(String category) {
      switch (category) {
        case 'flat_discount':
          return 'Flat Deal Setup';
        case 'deal_discount':
          return 'Deal of the Day Setup';
        case 'exclusive_offers':
          return 'Exclusive Offer Setup';
        default:
          return 'Discount Setup';
      }
    }

    String _getTitleForDiscount(String category) {
      switch (category) {
        case 'flat_discount':
          return 'FLATDEAL';
        case 'deal_discount':
          return 'BOGO';
        case 'exclusive_offers':
          return 'EXCLUSIVE';
        default:
          return 'DISCOUNT';
      }
    }

    _bannerTitle = _getTitleForDiscount(widget.category);
    _pageTitle = _getTitleForCategory(widget.category);

    if (widget.category == 'deal_discount') {
      tabs = [
        'Discounts',
        'Target Audience',
        'Discount Value',
        'Discount Schedule'
      ];
      imagePaths = [
        'assets/images/discount.jpg',
        'assets/images/target_audience.jpg',
        'assets/images/discount.jpg',
        'assets/images/schedule.jpg',
      ];
    } else {
      tabs = ['Target Audience', 'Discount Value', 'Discount Schedule'];
      imagePaths = [
        'assets/images/target_audience.jpg',
        'assets/images/discount.jpg',
        'assets/images/schedule.jpg',
      ];
    }
  }

  String _getDiscountTitle(String category) {
    final discount = _selectedDiscount ?? '[discount]';
    final minPurchase =
        _minPurchaseValue != null ? '₹$_minPurchaseValue' : '[min purchase]';
    final audience = selectedAudience ?? '[audience]';
    switch (category) {
      case 'flat_discount':
        return 'Flat $discount off on orders above $minPurchase for $audience users';
      case 'deal_discount':
        final dealText = selectedSpecialDiscount.isNotEmpty
            ? selectedSpecialDiscount.join(', ')
            : 'BOGO';
        return '$dealText on orders above $minPurchase for $audience users';
      case 'exclusive_offers':
        return '$discount off on orders above $minPurchase for $audience users';
      default:
        return 'Discount';
    }
  }

  String get _discountTitle => _getDiscountTitle(widget.category);

  Widget _buildSpecialDiscountsTab() {
    final options = [...customDeals];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Section: Heading & Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose a Deal of the Day",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Create a BOGO offer for your customers",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  // Middle Section: Either message or list of deals
                  Expanded(
                    child: options.isEmpty
                        ? Center(
                            child: Text(
                              "No deals yet. Tap + to add.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "PlusJakartaSans",
                                fontSize: 13,
                              ),
                            ),
                          )
                        : Column(
                            children: options.map((deal) {
                              final isSelected = selectedSpecialDiscount
                                  .contains(deal['description']);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: DealCard(
                                  title: deal['description']!,
                                  description: deal['title']!,
                                  footerNote: deal['footer']!,
                                  isSelected: isSelected,
                                  onSelect: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedSpecialDiscount
                                            .remove(deal['description']);
                                      } else {
                                        selectedSpecialDiscount
                                            .add(deal['description']);
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                  ),

                  // Bottom Section: Continue button
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: selectedSpecialDiscount.isEmpty
                          ? null
                          : () {
                              setState(() {
                                selectedTabIndex = 1;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, String>? getSelectedDealXY() {
    if (customDeals.isEmpty) return null;
    final deal = customDeals.first;
    return {'x': deal['x'], 'y': deal['y']};
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context,
      {required String title}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with circular background
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFEAE0),
                  ),
                  child: Icon(Icons.local_offer_rounded,
                      size: 32, color: Colors.deepOrange),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "PlusJakartaSans",
                  ),
                ),

                // Clarification Message Box
                // Clarification Message Box (Tappable)
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Replace this with your actual customer support navigation logic
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFFDF4F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.support_agent,
                            size: 20, color: Colors.deepOrange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "In case of any clarification reach out to Kechi Customer Support",
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey[800],
                              fontFamily: "PlusJakartaSans",
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 14, color: Colors.deepOrange),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Subtext
                Text(
                  "Are you sure you want to go back?\nDoing this will reset your ongoing setup.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    fontFamily: "PlusJakartaSans",
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Yes, Exit",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: "PlusJakartaSans",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Continue Setup",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: "PlusJakartaSans",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _minPurchaseController = TextEditingController();
  int? _minPurchaseValue;

  final TextEditingController repeatController =
      TextEditingController(text: "2");
  final TextEditingController loyalController =
      TextEditingController(text: "5");
  final GlobalKey<FormState> _audienceFormKey = GlobalKey<FormState>();

  String? selectedAudience;
  String _discountCategory = "Both";

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _limitController.dispose();
    repeatController.dispose();
    loyalController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? label,
    String? hintText,
    bool isPassword = false,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      autovalidateMode: validator != null
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      cursorColor: AppTheme.primaryColor,
      controller: controller,
      obscureText: isPassword,
      decoration: _buildInputDecoration(
        label: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      style: TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 16,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    String? label,
    String? hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      isDense: true,
      prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
      labelStyle: TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 14,
        color: Colors.grey[700],
        fontWeight: FontWeight.w600,
      ),
      floatingLabelStyle: TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 13,
        color: AppTheme.primaryColor,
        fontWeight: FontWeight.w700,
      ),
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  final List<String> allProducts = [
    "Shampoo",
    "Conditioner",
    "Hair Color",
    "Hair Oil",
    "Serum"
  ];
  final List<String> allServices = [
    "Haircut",
    "Facial",
    "Manicure",
    "Pedicure",
    "Massage"
  ];

  String? _dealApplicableType; // "Products" or "Services"
  List<String> _selectedItems = [];

  final TextEditingController _productSelectController =
      TextEditingController();
  final TextEditingController _serviceSelectController =
      TextEditingController();

  List<String> _selectedProducts = [];
  List<String> _selectedServices = [];

  void _showMultiSelectDialog(
    BuildContext context, {
    required String title,
    required List<String> options,
    required List<String> selectedItems,
    required TextEditingController controller,
  }) {
    final List<String> tempSelected = List.from(selectedItems);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: options.map((item) {
                    final isSelected = tempSelected.contains(item);
                    return CheckboxListTile(
                      title: Text(item),
                      value: isSelected,
                      onChanged: (checked) {
                        setState(() {
                          if (checked!) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                ),
              ),
              child: const Text("Cancel",
                  style: TextStyle(
                      fontFamily: "PlusJakartaSans", color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppTheme.primaryColor,
                ),
              ),
              child: const Text("Confirm",
                  style: TextStyle(
                      fontFamily: "PlusJakartaSans", color: Colors.white)),
              onPressed: () {
                setState(() {
                  selectedItems
                    ..clear()
                    ..addAll(tempSelected); // ✅ Updates the original list
                  controller.text = selectedItems.join(', ');
                });
                print('Products: $_selectedProducts');
                print('Services: $_selectedServices');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTargetAudienceTab() {
    bool isDealOfTheDay = widget.category == 'deal_discount';
    return Form(
      key: _audienceFormKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDealOfTheDay) ...[
                        Text(
                          "Discount Applicable On",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Builder(
                          builder: (context) {
                            final deal = getSelectedDealXY();
                            if (deal == null) return SizedBox.shrink();
                            final x = deal['x'];
                            final y = deal['y'];

                            Widget buildField(String type) {
                              if (type == 'Product') {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                  child: TextFormField(
                                    readOnly: true,
                                    enableInteractiveSelection: false,
                                    cursorColor: Colors.transparent,
                                    controller: _productSelectController,
                                    onTap: () => _showMultiSelectDialog(
                                      context,
                                      title: 'Select Products',
                                      options: allProducts,
                                      selectedItems: _selectedProducts,
                                      controller: _productSelectController,
                                    ),
                                    decoration: _buildInputDecoration(
                                      label: "Choose Products",
                                      prefixIcon: Icons.shopping_bag,
                                    ),
                                  ),
                                );
                              } else if (type == 'Service') {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                  child: TextFormField(
                                    readOnly: true,
                                    enableInteractiveSelection: false,
                                    cursorColor: Colors.transparent,
                                    controller: _serviceSelectController,
                                    onTap: () => _showMultiSelectDialog(
                                      context,
                                      title: 'Select Services',
                                      options: allServices,
                                      selectedItems: _selectedServices,
                                      controller: _serviceSelectController,
                                    ),
                                    decoration: _buildInputDecoration(
                                      label: "Choose Services",
                                      prefixIcon: Icons.supervised_user_circle,
                                    ),
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            }

                            if (x == y) {
                              return Column(
                                children: [
                                  buildField(x!),
                                  const SizedBox(height: 20),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  buildField(x!),
                                  const SizedBox(height: 20),
                                  buildField(y!),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ] else ...[
                        Text(
                          "Discount Applicable On",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField<String>(
                          value: _discountCategory,
                          items: ['Both', 'Products', 'Services'].map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _discountCategory = val;
                              });
                            }
                          },
                          decoration: _buildInputDecoration(
                            label: "Select Type",
                            prefixIcon: _discountCategory == 'Products'
                                ? Icons.shopping_bag
                                : _discountCategory == 'Services'
                                    ? Icons.supervised_user_circle
                                    : Icons.category,
                          ),
                        ),
                        if (widget.category == 'exclusive_offers') ...[
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                        if (widget.category == 'exclusive_offers') ...[
                          if (_discountCategory == 'Products' ||
                              _discountCategory == 'Both') ...[
                            TextFormField(
                              readOnly: true,
                              controller: _productSelectController,
                              enableInteractiveSelection: false,
                              onTap: () => _showMultiSelectDialog(
                                context,
                                title: 'Select Products',
                                options: allProducts,
                                selectedItems: _selectedProducts,
                                controller: _productSelectController,
                              ),
                              decoration: _buildInputDecoration(
                                label: "Choose Products",
                                prefixIcon: Icons.shopping_bag,
                              ),
                            ),
                          ],
                          if (_discountCategory == 'Services' ||
                              _discountCategory == 'Both') ...[
                            SizedBox(height: 16),
                            TextFormField(
                              readOnly: true,
                              controller: _serviceSelectController,
                              enableInteractiveSelection: false,
                              onTap: () => _showMultiSelectDialog(
                                context,
                                title: 'Select Services',
                                options: allServices,
                                selectedItems: _selectedServices,
                                controller: _serviceSelectController,
                              ),
                              decoration: _buildInputDecoration(
                                label: "Choose Services",
                                prefixIcon: Icons.room_service,
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                      if (widget.category != 'exclusive_offers') ...[
                        Text(
                          'Define your Customers',
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: "0",
                          enabled: false,
                          decoration: _buildInputDecoration(
                            label: "New Customer",
                            hintText: null,
                            prefixIcon: Icons.person_outline,
                          ),
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 16,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          repeatController,
                          label: "Repeat Customer",
                          hintText: "e.g., 2",
                          prefixIcon: Icons.repeat,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          loyalController,
                          label: "Loyal Customer",
                          hintText: "e.g., 5",
                          prefixIcon: Icons.emoji_events,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Target Audience",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _buildInputDecoration(
                            label: "Target Audience",
                            prefixIcon: Icons.people,
                          ),
                          isExpanded: true,
                          dropdownColor: Colors.grey[100],
                          items: ['All', 'New', 'Repeat', 'Loyal', 'Members']
                              .map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type,
                                  style: TextStyle(color: Colors.grey[900])),
                            );
                          }).toList(),
                          value: selectedAudience,
                          validator: (value) => value == null
                              ? "Please select an audience type"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              selectedAudience = value;
                              if (selectedAudience == 'New') {
                                _limitController.text = '1';
                                _usageLimitPerUser = 1;
                              } else {
                                _limitController.clear();
                                _usageLimitPerUser = null;
                              }
                            });
                          },
                        ),
                      ] else ...[
                        Text(
                          "Target Audience",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          readOnly: true,
                          initialValue: "Members",
                          enabled:
                              false, // This ensures it gets the 'disabled' look
                          decoration: _buildInputDecoration(
                            label: "Target Audience",
                            prefixIcon: Icons.people,
                          ),
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 16,
                            color: Colors.grey, // Makes the text appear muted
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            backgroundColor: AppTheme.primaryColor),
                        onPressed: () {
                          if (selectedAudience == 'New') {
                            _usageLimitPerUser = 1;
                          } else {
                            _usageLimitPerUser =
                                int.tryParse(_limitController.text.trim());
                          }
                          if (_audienceFormKey.currentState!.validate()) {
                            if (widget.category == 'exclusive_offers') {
                              selectedAudience = "Members";
                            }
                            if (isDealOfTheDay) {
                              bool hasSelectedProducts =
                                  _selectedProducts.isNotEmpty;
                              bool hasSelectedServices =
                                  _selectedServices.isNotEmpty;

                              if (isDealOfTheDay) {
                                final deal = getSelectedDealXY();
                                final x = deal?['x'];
                                final y = deal?['y'];
                                bool hasSelectedProducts =
                                    _selectedProducts.isNotEmpty;
                                bool hasSelectedServices =
                                    _selectedServices.isNotEmpty;

                                if (x == y) {
                                  if (x == 'Product' && !hasSelectedProducts) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Please select at least one product"),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }
                                  if (x == 'Service' && !hasSelectedServices) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Please select at least one service"),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }
                                } else {
                                  if (!hasSelectedProducts) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Please select at least one product"),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }
                                  if (!hasSelectedServices) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Please select at least one service"),
                                        backgroundColor: Colors.redAccent,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    return;
                                  }
                                }
                              }
                            }

                            setState(() {
                              selectedTabIndex =
                                  widget.category == 'deal_discount' ? 2 : 1;
                            });
                          }
                        },
                        child: Text(
                          'Save Audience Settings',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: "PlusJakartaSans",
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blue[50],
                            border: Border.all(color: AppTheme.primaryColor)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How it Works",
                              style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/images/customer_discount.jpg"),
                                  radius: 22,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Categorise your customers according to the number of appointments booked!",
                                    style: TextStyle(
                                      fontFamily: "PlusJakartaSans",
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final GlobalKey<FormState> _discountFormKey = GlobalKey<FormState>();

  String _discountType = 'Amount';
  String? _selectedDiscount;
  String _couponTitle = '';

  Widget _buildDiscountValueTab() {
    List<String> inrDiscounts = [
      '₹40',
      '₹50',
      '₹75',
      '₹80',
      '₹100',
      '₹120',
      '₹125',
      '₹150',
      '₹175',
      '₹200',
      '₹250'
    ];
    List<String> percentDiscounts = ['10%', '20%', '30%'];

    void _generateCouponCode() {
      String prefix;

      // Determine prefix based on category
      if (widget.category == 'deal_discount') {
        prefix = 'BOGO';
      } else if (widget.category == 'exclusive_offers') {
        prefix = 'EXCL';
      } else {
        prefix = 'FLAT';
      }

      final code = '$prefix${DateTime.now().millisecondsSinceEpoch % 100000}';
      _codeController.text = code;
      _generatedCode = code;
      _codeController.selection = TextSelection.collapsed(offset: code.length);
    }

    InputDecoration _buildInputDecoration(String label, IconData icon,
        {Widget? suffixIcon}) {
      return InputDecoration(
        isDense: true,
        suffixIcon: suffixIcon,
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.transparent,
        labelStyle: TextStyle(
          fontFamily: "PlusJakartaSans",
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: "PlusJakartaSans",
          fontSize: 13,
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.redAccent, width: 2),
        ),
      );
    }

    Widget _buildDiscountGrid(
        List<String> options, void Function(VoidCallback) setInnerState) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
          color: Colors.white,
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((value) {
            final isSelected = _selectedDiscount == value;

            return GestureDetector(
              onTap: () {
                setInnerState(() {
                  _selectedDiscount = value;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: isSelected ? 60 : 50,
                height: isSelected ? 58 : 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppTheme.primaryColor : Colors.grey[400]!,
                    width: 1.5,
                  ),
                  color: isSelected ? Colors.blue[50] : Colors.white,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: "PlusJakartaSans",
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppTheme.primaryColor : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Form(
          key: _discountFormKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Discount Details",
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      cursorColor: AppTheme.primaryColor,
                      controller: _titleController,
                      decoration: _buildInputDecoration(
                          "Coupon Title", Icons.text_fields),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a coupon title';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _couponTitle = value.trim();
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      cursorColor: AppTheme.primaryColor,
                      controller: _codeController,
                      readOnly: true,
                      decoration: _buildInputDecoration(
                        "Coupon Code",
                        Icons.confirmation_number,
                        suffixIcon: IconButton(
                          icon:
                              Icon(Icons.refresh, color: AppTheme.primaryColor),
                          tooltip: "Generate",
                          onPressed: () {
                            setInnerState(() {
                              _generateCouponCode();
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please generate a coupon code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      cursorColor: AppTheme.primaryColor,
                      controller: _limitController,
                      enabled: selectedAudience != 'New',
                      decoration: _buildInputDecoration(
                          "Usage Limit per User", Icons.repeat),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setInnerState(() {
                          _usageLimitPerUser = int.tryParse(value.trim());
                        });
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a usage limit';
                        }
                        return null;
                      },
                    ),
                    if (widget.category == 'flat_discount' ||
                        widget.category == 'exclusive_offers') ...[
                      SizedBox(height: 16),
                    ],
                    if (widget.category != 'deal_discount') ...[
                      DropdownButtonFormField<String>(
                        value: _discountType,
                        items: ['Amount', 'Percent'].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setInnerState(() {
                              _discountType = val;
                              _selectedDiscount =
                                  val == 'Amount' ? "250" : null;
                            });
                          }
                        },
                        decoration: _buildInputDecoration(
                          "Discount Type",
                          _discountType == 'Amount'
                              ? Icons.currency_rupee
                              : Icons.percent,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _discountType == 'Amount'
                            ? "Pick the flat rupees off value that your customers can redeem"
                            : "Pick the flat percent off value that your customers can redeem",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildDiscountGrid(
                        _discountType == 'Amount'
                            ? inrDiscounts
                            : percentDiscounts,
                        setInnerState,
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorColor: AppTheme.primaryColor,
                      controller: _minPurchaseController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        "Minimum Purchase",
                        Icons.shopping_cart,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a minimum purchase amount';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _minPurchaseValue = int.tryParse(value.trim());
                      },
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          backgroundColor: AppTheme.primaryColor),
                      onPressed: () {
                        if (_discountFormKey.currentState!.validate()) {
                          setState(() {
                            selectedTabIndex =
                                widget.category == 'deal_discount' ? 3 : 2;
                          });
                        }
                      },
                      child: Text(
                        'Save Discount Settings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "PlusJakartaSans",
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    DateTime _focusedDay = DateTime.now();
    DateTime _selectedDay = DateTime.now();
    DateTime? _startDate = DateTime.now();
    DateTime? _endDate;
    TimeOfDay? _startTime = TimeOfDay.now();
    TimeOfDay? _endTime = TimeOfDay.now();
    bool isSelectingStartDate = true;

    String getDiscountCategoryToShow() {
      if (widget.category == 'deal_discount') {
        final deal = getSelectedDealXY();
        final x = deal?['x'];
        final y = deal?['y'];
        if (x != null && y != null) {
          if (x == y) {
            return x == 'Product' ? 'Products' : 'Services';
          } else {
            return 'Both';
          }
        }
        return 'Both';
      }
      // For flat_discount and exclusive_offers, use the dropdown value
      return _discountCategory;
    }

    final discountCategoryToShow = getDiscountCategoryToShow();

    final TextEditingController _startDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    final TextEditingController _endDateController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        DateTime? startDateTime = _startDate != null
            ? DateTime(
                _startDate!.year,
                _startDate!.month,
                _startDate!.day,
                _startTime?.hour ?? 0,
                _startTime?.minute ?? 0,
              )
            : null;

        DateTime? endDateTime = _endDate != null
            ? DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
                _endTime?.hour ?? 0,
                _endTime?.minute ?? 0,
              )
            : null;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/discount_banner.jpeg',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      isSelectingStartDate
                          ? "Set your start date"
                          : "Set your end date",
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isSelectingStartDate
                          ? "Choose when to start your discounts. You can stop the discounts at any time."
                          : "Choose when the discounts should end. You can update it later.",
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text("Start Date"),
                    selected: isSelectingStartDate,
                    onSelected: (_) {
                      setState(() => isSelectingStartDate = true);
                    },
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelectingStartDate
                          ? Colors.white
                          : Colors.grey[700],
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide(
                      color: isSelectingStartDate
                          ? Colors.transparent
                          : Colors.grey, // 🔄 swapped
                      width: 1.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text("End Date"),
                    selected: !isSelectingStartDate,
                    onSelected: (_) {
                      setState(() => isSelectingStartDate = false);
                    },
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: !isSelectingStartDate
                          ? Colors.white
                          : Colors.grey[700],
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide(
                      color: !isSelectingStartDate
                          ? Colors.transparent
                          : Colors.grey, // 🔄 swapped
                      width: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Start Date & Time Row
              if (isSelectingStartDate) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _startDateController,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Start Date",
                          prefixIcon: Icon(Icons.calendar_today,
                              color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          floatingLabelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: _startTime != null
                              ? _startTime!.format(context)
                              : '',
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Start Time",
                          prefixIcon:
                              Icon(Icons.access_time, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          floatingLabelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 2),
                          ),
                        ),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFF1A73E8),
                                    onPrimary: Colors.white,
                                    onSurface: Color(0xFF1A73E8),
                                    surface: Colors.white,
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side:
                                          BorderSide(color: Color(0xFF1A73E8)),
                                    ),
                                    dayPeriodBorderSide:
                                        BorderSide(color: Color(0xFF1A73E8)),
                                    dayPeriodColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hourMinuteColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => states.contains(
                                                    MaterialState.selected)
                                                ? Color(0xFF1A73E8)
                                                    .withOpacity(0.12)
                                                : Colors.transparent),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF1A73E8),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => _startTime = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _endDateController,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "End Date",
                          prefixIcon: Icon(Icons.calendar_today,
                              color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          floatingLabelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text:
                              _endTime != null ? _endTime!.format(context) : '',
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "End Time",
                          prefixIcon:
                              Icon(Icons.access_time, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          floatingLabelStyle: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 13,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: AppTheme.primaryColor, width: 2),
                          ),
                        ),
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xFF1A73E8),
                                    onPrimary: Colors.white,
                                    onSurface: Color(0xFF1A73E8),
                                    surface: Colors.white,
                                  ),
                                  timePickerTheme: TimePickerThemeData(
                                    backgroundColor: Colors.white,
                                    hourMinuteShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side:
                                          BorderSide(color: Color(0xFF1A73E8)),
                                    ),
                                    dayPeriodBorderSide:
                                        BorderSide(color: Color(0xFF1A73E8)),
                                    dayPeriodColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hourMinuteColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => states.contains(
                                                    MaterialState.selected)
                                                ? Color(0xFF1A73E8)
                                                    .withOpacity(0.12)
                                                : Colors.transparent),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF1A73E8),
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => _endTime = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(188, 127, 66, 250),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      if (isSelectingStartDate) {
                        _startDate = selectedDay;
                        _startDateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDay);
                      } else {
                        _endDate = selectedDay;
                        _endDateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDay);
                      }
                    });
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "PlusJakartaSans",
                      color: Colors.white,
                    ),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.white),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.white),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: const Color.fromARGB(215, 26, 115, 232),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () async {
                  if (_generatedCode == null ||
                      selectedAudience == null ||
                      _minPurchaseValue == null ||
                      (widget.category != 'deal_discount' &&
                          _selectedDiscount == null) ||
                      _titleController.text.trim().isEmpty ||
                      startDateTime == null ||
                      endDateTime == null ||
                      _usageLimitPerUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Please fill all required fields!",
                          style: TextStyle(fontFamily: "PlusJakartaSans"),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  if (endDateTime.isBefore(startDateTime)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "End date & time cannot be before start date & time!",
                          style: TextStyle(fontFamily: "PlusJakartaSans"),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 240, 239, 253),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.deepPurple.shade100),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: -1,
                                    left: -1,
                                    child: ClipPath(
                                      clipper: RibbonClipper(),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        color: Colors.deepPurple,
                                        child: Text(
                                          _bannerTitle,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: "PlusJakartaSans",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Text(
                                          _discountTitle,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            fontFamily: "PlusJakartaSans",
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow("Discount Category",
                                      getDiscountCategoryToShow()),
                                  if (widget.category != 'flat_discount')
                                    _buildDetailRow(
                                        "Discount Applicable On",
                                        [
                                          if (_selectedProducts.isNotEmpty)
                                            "Products: ${_selectedProducts.join(', ')}",
                                          if (_selectedServices.isNotEmpty)
                                            "Services: ${_selectedServices.join(', ')}"
                                        ]
                                            .where((s) => s.isNotEmpty)
                                            .join(" | ")),
                                  _buildDetailRow("Discount start date",
                                      "${DateFormat('d MMMM yyyy').format(startDateTime)} • ${DateFormat('hh:mm a').format(startDateTime)}"),
                                  _buildDetailRow("Discount end date",
                                      "${DateFormat('d MMMM yyyy').format(endDateTime)} • ${DateFormat('hh:mm a').format(endDateTime)}"),
                                  _buildDetailRow(
                                      "Target customers", selectedAudience!),
                                  _buildDetailRow("Minimum purchase",
                                      "₹$_minPurchaseValue"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Validate all required fields before proceeding
                                if (_generatedCode == null ||
                                    selectedAudience == null ||
                                    _minPurchaseValue == null ||
                                    (widget.category != 'deal_discount' &&
                                        _selectedDiscount ==
                                            null) || // Only require for non-deal_discount
                                    _titleController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Please fill all required fields!"),
                                      backgroundColor: Colors.redAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                final createdDiscount = Discount(
                                    category: getDiscountCategoryToShow(),
                                    title: _titleController.text.trim(),
                                    code: _generatedCode!,
                                    audience: selectedAudience!,
                                    minPurchase: _minPurchaseValue!,
                                    discount: widget.category == 'deal_discount'
                                        ? (selectedSpecialDiscount.isNotEmpty
                                            ? selectedSpecialDiscount.first
                                            : '')
                                        : (_selectedDiscount ?? ''),
                                    startDate: startDateTime,
                                    endDate: endDateTime,
                                    usageLimitPerUser: _usageLimitPerUser!);

                                Navigator.of(context, rootNavigator: true).pop({
                                  'category': widget.category,
                                  'discount': createdDiscount,
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                minimumSize: Size(double.infinity, 48),
                              ),
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "PlusJakartaSans",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "*By confirming, you also accept to the terms and conditions",
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: "PlusJakartaSans",
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  );

                  if (result != null && result is Map) {
                    Navigator.pop(context, result);
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "PlusJakartaSans",
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  late String _bannerTitle;
  late String _pageTitle;

  @override
  Widget build(BuildContext context) {
    Widget _buildSelectedTabContent() {
      if (widget.category == 'deal_discount') {
        switch (selectedTabIndex) {
          case 0:
            return _buildSpecialDiscountsTab();
          case 1:
            return _buildTargetAudienceTab();
          case 2:
            return _buildDiscountValueTab();
          case 3:
            return _buildScheduleTab();
          default:
            return SizedBox();
        }
      } else {
        switch (selectedTabIndex) {
          case 0:
            return _buildTargetAudienceTab();
          case 1:
            return _buildDiscountValueTab();
          case 2:
            return _buildScheduleTab();
          default:
            return SizedBox();
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitConfirmationDialog(
          context,
          title: _pageTitle,
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            _pageTitle,
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.3),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
            onPressed: () async {
              final shouldExit = await _showExitConfirmationDialog(
                context,
                title: _pageTitle,
              );
              if (shouldExit ?? false) {
                Navigator.pop(context);
              }
            },
          ),
          actions: widget.category == 'deal_discount'
              ? [
                  IconButton(
                    icon: Icon(Icons.add, color: AppTheme.primaryColor),
                    tooltip: "Add Custom Deal",
                    onPressed: () {
                      if (customDeals.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Finish Current Setup",
                              style: TextStyle(fontFamily: "PlusJakartaSans"),
                            ),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      _showCustomDealDialog();
                    },
                  ),
                ]
              : [],
        ),
        body: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(tabs.length, (index) {
                    final isSelected = selectedTabIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFFFFF3E0)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.deepOrange
                                      : const Color.fromRGBO(100, 181, 246, 1),
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(imagePaths[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            SizedBox(
                              width: 64,
                              child: Text(
                                tabs[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.deepOrange
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _buildSelectedTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DealCard extends StatelessWidget {
  final String title;
  final String description;
  final String footerNote;
  final bool isSelected;
  final VoidCallback onSelect;

  const DealCard({
    super.key,
    required this.title,
    required this.description,
    required this.footerNote,
    this.isSelected = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deal Card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding:
              const EdgeInsets.only(top: 32, bottom: 24, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: "PlusJakartaSans",
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 13,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  footerNote,
                  style: const TextStyle(
                    fontFamily: "PlusJakartaSans",
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrange,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Ribbon (badge-style)
        Positioned(
          left: 0,
          top: 0,
          child: ClipPath(
            clipper: RibbonClipper(), // Your custom ribbon clipper
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade100.withOpacity(0.6),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: const Text(
                "BOGO",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cornerRadius = 16.0;
    final path = Path();

    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140, // fixed width for label
          child: Text(
            label,
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            softWrap: true,
            maxLines: 3, // or any number you prefer
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
