import "package:flutter/material.dart";
import "package:kechi/theme.dart";
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

final Map<String, bool> discountsPublished = {
  'percentage_discount': false,
  'exclusive_offers': false,
  'flat_discount': false,
};

final Map<String, Color> categoryColors = {
  'percentage_discount': Colors.blue,
  'exclusive_offers': Colors.orange,
  'flat_discount': Colors.purple,
};

double getLinearProgress() {
  int publishedCount = discountsPublished.values.where((v) => v).length;
  return publishedCount * 0.05; // each is worth 5%
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  List<Discount> _allDiscounts = [];

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
          title: Text(
            "Promotions",
            style: TextStyle(
                fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 310,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Icon(Icons.speed,
                                      color: AppTheme.primaryColor),
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
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _navigateToCoverageDetail,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  AppTheme.primaryColor,
                                ),
                              ),
                              child: Text(
                                "Improve Coverage Now",
                                style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
                              AssetImage('assets/images/discount.jpg'),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "View active discounts",
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
              ],
            ),
          ),
        ));
  }
}

class TrackDiscountsScreen extends StatefulWidget {
  final List<Discount> discounts;

  const TrackDiscountsScreen({required this.discounts});

  @override
  _TrackDiscountsScreenState createState() => _TrackDiscountsScreenState();
}

class _TrackDiscountsScreenState extends State<TrackDiscountsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Discount> _allDiscounts = [];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    _allDiscounts = widget.discounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Track Discounts",
          style: TextStyle(
              fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              labelStyle: const TextStyle(
                fontFamily: "PlusJakartaSans",
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: "PlusJakartaSans",
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              labelColor: Colors.deepOrange, // Active tab text color
              unselectedLabelColor: Colors.grey, // Inactive tab text color
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3, color: Colors.deepOrange),
                insets: EdgeInsets.symmetric(horizontal: 24.0),
              ),
              tabs: const [
                Tab(text: "Active"),
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DiscountListTab(type: 'active', discounts: _allDiscounts),
          DiscountListTab(type: 'upcoming', discounts: _allDiscounts),
          DiscountListTab(type: 'past', discounts: _allDiscounts),
        ],
      ),
    );
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

  Discount({
    required this.category,
    required this.title,
    required this.code,
    required this.audience,
    required this.minPurchase,
    required this.discount,
    required this.startDate,
    required this.endDate,
  });
}

class DiscountListTab extends StatelessWidget {
  final String type;
  final List<Discount> discounts;

  DiscountListTab({required this.type, required this.discounts});

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

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredDiscounts();

    if (filtered.isEmpty) {
      return Center(child: Text("No $type discounts"));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final discount = filtered[index];
        return _buildDiscountCard(discount);
      },
    );
  }

  Widget _buildDiscountCard(Discount discount) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Display Row
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.green),
                SizedBox(width: 6),
                Text(
                  "${DateFormat('dd MMM yyyy').format(discount.startDate)} - ${DateTime.now().isAfter(discount.endDate) ? 'Expired' : 'Present'}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Code as Tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              discount.code.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Title (Bold)
          Text(
            discount.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6),

          // Discount Info
          Text(
            "Flat ${discount.discount} off upto Rs.${discount.minPurchase} for ${discount.audience} users",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),

          // View Details Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "VIEW DETAILS",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.deepOrange),
            ],
          ),
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
      'subtitle': 'Percentage Discounts',
      'coverage': '+20% Coverage',
      'category': 'percentage_discount',
    },
    {
      'title': 'Peak Customer Delight',
      'subtitle': 'Deal of the Day',
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
  String? selectedSpecialDiscount;
  int selectedTabIndex = 0;
  String? _generatedCode;
  late List<String> tabs;
  late List<String> imagePaths;

  @override
  void initState() {
    super.initState();
    if (widget.category == 'percentage_discount') {
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

  Widget _buildSpecialDiscountsTab() {
    final options = [
      'Buy 1 get 1 free',
      'Buy 2 get 1 free',
    ];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Special Discounts",
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          ...options.map((option) {
            final selected = selectedSpecialDiscount == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSpecialDiscount = option;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.deepOrange.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: selected ? Colors.deepOrange : Colors.grey.shade300,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.check_circle : Icons.circle_outlined,
                      color: selected ? Colors.deepOrange : Colors.grey,
                    ),
                    SizedBox(width: 12),
                    Text(
                      option,
                      style: TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: selected ? Colors.deepOrange : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: selectedSpecialDiscount == null
                ? null
                : () {
                    setState(() {
                      selectedTabIndex = 1; // Go to Target Audience tab
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              "Continue",
              style: TextStyle(
                fontFamily: "PlusJakartaSans",
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
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
                    color: Color(0xFFFFEAE0), // soft peach tone
                  ),
                  child: Icon(Icons.local_offer_rounded,
                      size: 32, color: Colors.deepOrange),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  "Flat off setup",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "PlusJakartaSans",
                  ),
                ),
                const SizedBox(height: 12),

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
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
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

  Widget _buildTargetAudienceTab() {
    return Form(
      key: _audienceFormKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Define Discount Category",
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
                    child: Text(type),
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
                  label: "Discount Applicable",
                  prefixIcon: _discountCategory == 'Products'
                      ? Icons.shopping_bag
                      : _discountCategory == 'Services'
                          ? Icons.room_service
                          : Icons.category,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: _buildInputDecoration(
                  label: "Target Audience",
                  prefixIcon: Icons.people,
                ),
                isExpanded: true,
                dropdownColor: Colors.grey[100],
                items: ['New', 'Repeat', 'Loyal'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child:
                        Text(type, style: TextStyle(color: Colors.grey[900])),
                  );
                }).toList(),
                value: selectedAudience,
                validator: (value) =>
                    value == null ? "Please select an audience type" : null,
                onChanged: (value) {
                  setState(() {
                    selectedAudience = value;
                    if (selectedAudience == 'New') {
                      _limitController.text = '1';
                    } else {
                      _limitController
                          .clear(); // optional, or set a default like '3'
                    }
                  });
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
                  if (_audienceFormKey.currentState!.validate()) {
                    setState(() {
                      selectedTabIndex = 1;
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
                          backgroundImage:
                              AssetImage("assets/images/customer_discount.jpg"),
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
                              fontSize: 12,
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
      final code = 'FLAT${DateTime.now().millisecondsSinceEpoch % 100000}';
      _codeController.text = code;
      _generatedCode = code;
      _codeController.selection = TextSelection.collapsed(offset: code.length);
    }

    InputDecoration _buildInputDecoration(String label, IconData icon,
        {Widget? suffixIcon}) {
      return InputDecoration(
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
                  decoration:
                      _buildInputDecoration("Coupon Title", Icons.text_fields),
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
                      icon: Icon(Icons.refresh, color: AppTheme.primaryColor),
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
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a usage limit';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
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
                        _selectedDiscount = val == 'Amount' ? "250" : null;
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
                  _discountType == 'Amount' ? inrDiscounts : percentDiscounts,
                  setInnerState,
                ),
                const SizedBox(height: 20),
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
                        selectedTabIndex = 2;
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
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    DateTime _focusedDay = DateTime.now();
    DateTime _selectedDay = DateTime.now();
    DateTime? _startDate = DateTime.now();
    DateTime? _endDate;
    bool isSelectingStartDate = true;

    final TextEditingController _startDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    final TextEditingController _endDateController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
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
                      color: isSelectingStartDate ? Colors.white : Colors.black,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
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
                      color:
                          !isSelectingStartDate ? Colors.white : Colors.black,
                      fontFamily: "PlusJakartaSans",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: "Start Date",
                  prefixIcon:
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
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
                    borderSide:
                        BorderSide(color: AppTheme.primaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: "End Date",
                  prefixIcon:
                      Icon(Icons.calendar_today, color: Colors.grey[600]),
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
                    borderSide:
                        BorderSide(color: AppTheme.primaryColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
              ),
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
                  if (_startDate == null || _endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Please select both start and end dates!",
                          style: TextStyle(fontFamily: "PlusJakartaSans"),
                        ),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  if (_endDate!.isBefore(_startDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "End date cannot be before start date!",
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
                                          "FLATDEAL",
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
                                          "Flat $_selectedDiscount off on orders above ₹$_minPurchaseValue for $selectedAudience users",
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
                                  _buildDetailRow(
                                      "Discount Categroy", _discountCategory),
                                  _buildDetailRow(
                                      "Discount start date",
                                      DateFormat('d MMMM yyyy')
                                          .format(_startDate!)),
                                  _buildDetailRow(
                                      "Discount end date",
                                      DateFormat('d MMMM yyyy')
                                          .format(_endDate!)),
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
                                final createdDiscount = Discount(
                                  category: _discountCategory,
                                  title: _titleController.text.trim(),
                                  code: _generatedCode!,
                                  audience: selectedAudience!,
                                  minPurchase: _minPurchaseValue!,
                                  discount: _selectedDiscount!,
                                  startDate: _startDate!,
                                  endDate: _endDate!,
                                );

                                Navigator.pop(context, {
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

  @override
  Widget build(BuildContext context) {
    String pageTitle;
    if (widget.category == 'flat_discount') {
      pageTitle = 'Flat Deal Setup';
    } else if (widget.category == 'percentage_discount') {
      pageTitle = 'Percentage Discount Setup';
    } else {
      pageTitle = 'Deal of the Day Setup';
    }
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitConfirmationDialog(context);
        return shouldExit ?? false; // false means: stay on page
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            pageTitle,
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.3),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              final shouldExit = await _showExitConfirmationDialog(context);
              if (shouldExit ?? false) {
                Navigator.pop(context); // go back to DiscountTilePage
              }
            },
          ),
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
                          vertical: 6, horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Color(0xFFFFF3E0) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            color:
                                isSelected ? Colors.orange : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
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
                          SizedBox(height: 6),
                          Text(
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
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IndexedStack(
                    index: selectedTabIndex,
                    children: [
                      if (widget.category == 'percentage_discount')
                        Container(
                          color: Colors.white,
                          child: _buildSpecialDiscountsTab(),
                        ),
                      Container(
                        color: Colors.white,
                        child: _buildTargetAudienceTab(),
                      ),
                      Container(
                        color: Colors.white,
                        child: _buildDiscountValueTab(),
                      ),
                      Container(
                        color: Colors.white,
                        child: _buildScheduleTab(),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
