import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kechi/src/profile/profile_screens/contact_us/view/contactus_page.dart';
import 'package:kechi/src/profile/profile_screens/manage_branch/view/managebranch_screen.dart';
import 'package:kechi/theme.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kechi/src/profile/profile_screens/promotions/view/promotions_screen.dart';
import "package:kechi/src/profile/profile_screens/edit_profile/view/edit_profilepage.dart";

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController ReferralController = TextEditingController();
  final TextEditingController LoyaltyController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
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
        title: Text(
          "Refer & Earn",
          style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your image and rewards card stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width > 600 ? 450 : 270,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/kechi1.jpg'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: 30,
                  right: 30,
                  child: Container(
                    height: 72,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/reward.jpg'),
                      ),
                      SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Rewards",
                            style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "400 Points",
                            style: TextStyle(
                              fontFamily: "PlusJakartaSans",
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // TabBar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Salon Referrals"),
                Tab(text: "Artist Referrals"),
              ],
              indicatorColor: AppTheme.primaryColor,
              labelColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                fontFamily: "PlusJakartaSans",
                fontWeight: FontWeight.bold,
              ),
            ),

            // TabBar content
            const SizedBox(height: 20),
            Builder(
              builder: (_) {
                if (_tabController.index == 0) {
                  return _salonReferralContent();
                } else {
                  return _artistReferralContent();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _salonReferralContent() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "One Referral Equal to (points)",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "100"),
              enabled: false,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "One Loyalty Point Equal to (INR)",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "0.25"),
              enabled: false,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No. of Salons to Refer",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "5"),
              enabled: false,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Minimum Loyalty Points Required for Conversion to INR",
              style: TextStyle(
                  fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 2,
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "100"),
              enabled: false,
            ),
            SizedBox(
              height: 30,
            ),
            DottedBorder(
              color: AppTheme.primaryColor,
              borderType: BorderType.RRect,
              dashPattern: [10, 5],
              strokeWidth: 2,
              radius: Radius.circular(12),
              child: Container(
                height: 72,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Copy Referral Code",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "heILGHOdvzDNCNPonzVN",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontFamily: "PlusJakartaSans",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.share, color: AppTheme.primaryColor),
                          onPressed: () {
                            Share.share(
                                'Use my referral code: heILGHOdvzDNCNPonzVN & Join Kechi Today!');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: AppTheme.primaryColor),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: "heILGHOdvzDNCNPonzVN"),
                            );
                            // Optional: Show a confirmation snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                "Referral code copied to clipboard",
                                style: TextStyle(fontFamily: "PlusJakartaSans"),
                              )),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(16),
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
                        backgroundImage: AssetImage("assets/images/link.jpg"),
                        radius: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Invite your Friends to Install Kechi and Sign up using your Referral Code!",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/wallet.jpg"),
                        radius: 20,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          "Get Rewards & Loyalty Points upon Successful Registration!",
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildTextDialog(
      String label, TextEditingController controller, hintText) {
    return TextFormField(
      cursorColor: AppTheme.primaryColor,
      controller: controller,
      decoration: InputDecoration(
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: "PlusJakartaSans"),
      ),
    );
  }

  Widget _artistReferralContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "One Referral Equal to (points)",
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          _buildTextDialog(
              "Loyalty Points", ReferralController, "Enter Loyalty Points"),
          SizedBox(
            height: 10,
          ),
          Text(
            "One Loyalty Point Equal to (INR)",
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          _buildTextDialog("INR", LoyaltyController, "Enter INR"),
          SizedBox(
            height: 10,
          ),
          Text(
            "No. Of Artists to Refer",
            style: TextStyle(
              fontFamily: "PlusJakartaSans",
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          TextField(
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12)),
                labelText: "5"),
            enabled: false,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Minimum Loyalty Points Required for Conversion to INR",
            style: TextStyle(
                fontFamily: "PlusJakartaSans", fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 2,
          ),
          TextField(
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primaryColor),
                    borderRadius: BorderRadius.circular(12)),
                labelText: "100"),
            enabled: false,
          ),
          SizedBox(height: 30),
          Container(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.all(16),
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
                      backgroundImage: AssetImage("assets/images/artist1.jpg"),
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Your Employees Refer Artists to Join your Salon through their Referral Code!",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/wallet.jpg"),
                      radius: 20,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "You Reward your Employees Upon Successful Registration!",
                        style: TextStyle(
                          fontFamily: "PlusJakartaSans",
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
