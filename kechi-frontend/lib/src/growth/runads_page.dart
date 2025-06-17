import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kechi/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RunadsPage extends StatefulWidget {
  const RunadsPage({Key? key}) : super(key: key);

  @override
  _RunadsPageState createState() => _RunadsPageState();
}

class _RunadsPageState extends State<RunadsPage> {
  final PageController _imagePageController = PageController();
  final PageController _cardPageController = PageController();
  int _imagePageIndex = 0;
  int _cardPageIndex = 0;

  final List<String> imageList = [
    'assets/images/runads.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];

  final List<Map<String, dynamic>> cardData = [
    {
      "title": "Get New Leads",
      "leads": "250",
      "reach": "> 80,000",
      "platforms": ["fb.jpg", "insta.jpg"],
      "duration": "30 days",
      "container_title": "Get new customers using Leads:",
      "container_content":
          "Generate daily new leads by showing your ads to potential customers in your target area"
    },
    {
      "title": "Get Whatsapps",
      "leads": "400",
      "reach": "> 150,000",
      "platforms": ["fb.jpg", "insta.jpg"],
      "duration": "45 days",
      "container_title": "Get messages on Whatsapp:",
      "container_content":
          "Directly receive Whatsapp message from potential customers by showing your ads in your target area"
    },
    {
      "title": "Get Website Traffic",
      "leads": "200",
      "reach": "> 60,000",
      "platforms": ["fb.jpg", "insta.jpg"],
      "duration": "30 days",
      "container_title": "Drive customers to your website:",
      "container_content": "Customers will be driven directly to your website"
    },
    {
      "title": "App Installs",
      "leads": "100",
      "reach": "> 45,000",
      "platforms": ["fb.jpg", "insta.jpg"],
      "duration": "45 days",
      "container_title": "Get new targeted users for your app:",
      "container_content": "Get new targeted users for your app"
    }
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_imagePageController.hasClients && mounted) {
        _imagePageIndex = (_imagePageIndex + 1) % imageList.length;
        _imagePageController.animateToPage(
          _imagePageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    _cardPageController.addListener(() {
      final index = _cardPageController.page?.round() ?? 0;
      if (_cardPageIndex != index) {
        setState(() => _cardPageIndex = index);
      }
    });
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _cardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.grey,
        title: const Text(
          "Grow Your Business",
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F0FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Text & Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Running Ad For The First Time ?",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Run small budget ads first before making your final decision",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          shadowColor: Colors.black54,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          "Try Ad",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 90,
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PageView.builder(
                      controller: _imagePageController,
                      itemCount: imageList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imageList[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Customize your package",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Create your own package that is suitable for your business & goals. You can customize by,",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Ensures vertical centering
            children: [
              SizedBox(
                width: 35,
                height: 35,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Slight rounding
                  child: Image.asset(
                    "assets/images/target_audience.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Goal",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 80,
              ),
              SizedBox(
                width: 30,
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Slight rounding
                  child: Image.asset(
                    "assets/images/reward.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Budget",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Slight rounding
                  child: Image.asset(
                    "assets/images/platform.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "Platforms",
                style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Slight rounding
                      child: Image.asset(
                        "assets/images/ad_settings.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Ad Settings",
                    style: TextStyle(
                      fontFamily: "PlusJakartaSans",
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          // Card carousel with indicator
          ...cardData.map((card) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("LEADS",
                              style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(card["leads"],
                              style: const TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("REACH",
                              style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(card["reach"],
                              style: const TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("PLATFORMS",
                              style: TextStyle(
                                  fontFamily: "PlusJakartaSans",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54)),
                          const SizedBox(height: 4),
                          Row(
                            children:
                                List.generate(card['platforms'].length, (p) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Image.asset(
                                  "assets/logo/${card['platforms'][p]}",
                                  width: 20,
                                  height: 20,
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Duration: ${card['duration']}",
                      style: const TextStyle(
                        fontFamily: "PlusJakartaSans",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GrowBusinessPage(
                              card: card,
                              initialFacebookBudget: 0,
                              initialInstagramBudget: 0,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0058D1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Customize Package",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "PlusJakartaSans",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ]),
      ),
    );
  }
}

class GrowBusinessPage extends StatefulWidget {
  final Map<String, dynamic> card;
  final int initialFacebookBudget;
  final int initialInstagramBudget;

  const GrowBusinessPage({
    Key? key,
    required this.card,
    this.initialFacebookBudget = 0,
    this.initialInstagramBudget = 0,
  }) : super(key: key);

  @override
  State<GrowBusinessPage> createState() => _GrowBusinessPageState();
}

class _GrowBusinessPageState extends State<GrowBusinessPage> {
  late int facebookBudget;
  late int instagramBudget;

  String formatNumber(int number) {
    if (number >= 100000) {
      return "${(number / 100000).toStringAsFixed(number % 100000 == 0 ? 0 : 1)}L";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 1)}K";
    } else {
      return number.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    facebookBudget = widget.initialFacebookBudget;
    instagramBudget = widget.initialInstagramBudget;
  }

  void _increment(String platform) {
    setState(() {
      if (platform == 'facebook') {
        facebookBudget = facebookBudget < 2000 ? 2000 : facebookBudget + 100;
      } else {
        instagramBudget = instagramBudget < 2000 ? 2000 : instagramBudget + 100;
      }
    });
    print('Products: $facebookBudget');
    print('Services: $instagramBudget');
  }

  void _decrement(String platform) {
    setState(() {
      if (platform == 'facebook') {
        if (facebookBudget == 2000) {
          facebookBudget = 0;
        } else if (facebookBudget > 0) {
          facebookBudget -= 100;
        }
      } else {
        if (instagramBudget == 2000) {
          instagramBudget = 0;
        } else if (instagramBudget > 0) {
          instagramBudget -= 100;
        }
      }
    });
    print('Products: $facebookBudget');
    print('Services: $instagramBudget');
  }

  Widget _budgetRow(String platform, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Image.asset(
              platform == 'facebook'
                  ? 'assets/logo/fb.jpg'
                  : 'assets/logo/insta.jpg',
              width: 20,
              height: 20,
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey.shade300,
              margin: EdgeInsets.symmetric(horizontal: 10),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "PlusJakartaSans",
              ),
            ),
            Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _decrement(platform),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _increment(platform),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(horizontal: 0),
      collapsedIconColor: Colors.grey[500],
      title: Text(
        question,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "PlusJakartaSans",
            fontSize: 13),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Text(
            answer,
            style: TextStyle(
                color: Colors.grey[700],
                fontFamily: "PlusJakartaSans",
                fontSize: 12),
          ),
        ),
      ],
    );
  }

  int _calculateViews(int fb, int insta) {
    // Example: 1 budget = 10 views
    return (fb + insta) * 10;
  }

  String _calculateLeadRange(int fb, int insta) {
    int total = ((fb + insta) / 100).round();
    int min = (total * 0.8).floor(); // 20% less
    int max = (total * 1.2).ceil(); // 20% more
    return "$min–$max";
  }

  int _calculateDays(int fb, int insta) {
    // Example: 200 per day minimum, so days = total budget / 200
    int total = fb + insta;
    if (total == 0) return 0;
    return (total / 200).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.grey,
        title: Text(
          card['title'] ?? '',
          style: TextStyle(
            fontFamily: "PlusJakartaSans",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Set your advertising objectives and then our expert will take care of everything, like",
                      style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Ensures vertical centering
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8), // Slight rounding
                          child: Image.asset(
                            "assets/images/target_audience.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Targetting",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8), // Slight rounding
                          child: Image.asset(
                            "assets/images/content_writing.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: const Text(
                          "Content Writing",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Ensures vertical centering
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8), // Slight rounding
                          child: Image.asset(
                            "assets/images/ad_designing.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Designing",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8), // Slight rounding
                          child: Image.asset(
                            "assets/images/ad_optimization.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: const Text(
                          "Optimizing",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card['container_title'] ?? '',
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          card['container_content'] ?? '',
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
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              "Total Budget",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            _budgetRow('facebook', facebookBudget),
            _budgetRow('instagram', instagramBudget),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Estimated Result",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              content: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Estimated results are based on the data from the campaigns we've done in India so far.\n\nThese results might change depending on the type of business, prices and the areas we're targeting.",
                                  style: TextStyle(
                                    fontFamily: "PlusJakartaSans",
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.info_outline,
                            size: 18, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[200],
                            child: FaIcon(
                              FontAwesomeIcons.eye,
                              color: Colors.grey[500],
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            formatNumber(_calculateViews(
                                facebookBudget, instagramBudget)),
                            style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Center(
                            child: Text(
                              "VIEWS",
                              style: TextStyle(
                                fontFamily: "PlusJakartaSans",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey[200],
                            child: FaIcon(
                              FontAwesomeIcons.arrowUpRightDots,
                              color: Colors.grey[500],
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "${_calculateLeadRange(facebookBudget, instagramBudget)}",
                            style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "LEADS",
                            style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontSize: 13,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "You will spend only ₹${facebookBudget + instagramBudget} in total and ad will run for ${_calculateDays(facebookBudget, instagramBudget)} days.",
                    style: TextStyle(
                      fontFamily: "PlusJakartaSans",
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 5,
            ),
            SizedBox(height: 12),
            Text(
              "Frequently asked Questions",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "PlusJakartaSans",
                  color: Colors.black),
            ),
            SizedBox(height: 12),
            _buildFAQTile(
              question: "Where will my ad be shown?",
              answer:
                  "Your ad will be shown in the specific target area of your choice. This can include a list of local areas, city, state, or PAN India.",
            ),
            _buildFAQTile(
              question: "Which ad image will be used while running my ad?",
              answer:
                  "In the next step, you will be asked to provide your ad image or you can even ask our design professional to make a customized design for you based on your requirement.",
            ),
            _buildFAQTile(
              question: "Who will do audience targeting & optimization?",
              answer:
                  "Audience targeting and optimization is done by experts with the help of AI based systems to get best results.",
            ),
            _buildFAQTile(
              question:
                  "Which Facebook page and ad account will be used to publish the ad?",
              answer:
                  "Your Facebook page and Our Ad account will be used to publish your ad.",
            ),
            _buildFAQTile(
              question: "When will my ad be published?",
              answer:
                  "Your ad will be published once the design and settings are finalized.",
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {}, // Add your logic here
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
          child: Text("Next"),
        ),
      ),
    );
  }
}
