// GrowthScreen represents the main analytics and growth tracking interface for salon owners
// It provides insights into business metrics, branding tools, and growth strategies
import 'package:flutter/material.dart';
import 'package:kechi/src/profile/profile_screens/refer&earn/view/referearn_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kechi/src/growth/promotions_screen.dart';
import 'package:kechi/src/growth/runads_page.dart'; // For sharing growth stats with others

enum VerificationStatus { notStarted, inProgress, verified }

// StatefulWidget is used because this screen needs to maintain state like selected tabs
class GrowthScreen extends StatefulWidget {
  const GrowthScreen({Key? key}) : super(key: key);
  @override
  _GrowthScreenState createState() => _GrowthScreenState();
}

class _GrowthScreenState extends State<GrowthScreen> {
  // Method to share growth statistics through platform's native share dialog
  // This allows salon owners to share their success metrics on social media or messaging apps
  void _shareGrowthStats() {
    Share.share(
      'Check out my salon\'s growth!\n\n'
      '🌟 Social Media Followers: 2.5K\n' // Key metrics displayed with emojis for visual appeal
      '⭐ Online Rating: 4.8\n'
      '🔄 Customer Retention: 78%\n\n'
      'Download our app to book your next appointment!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFFF5F8FE), // Light blue background for better readability
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents back button from showing
        elevation: 0, // Removes shadow under AppBar
        backgroundColor: Colors.transparent, // Makes AppBar transparent
        flexibleSpace: Container(
          // Gradient background in AppBar for visual appeal
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A73E8),
                Color(0xFF4285F4)
              ], // Google blue gradient
            ),
          ),
        ),
        title: Text(
          'Salon Growth',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Action buttons in AppBar for quick access to sharing and tips
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: _shareGrowthStats, // Share growth statistics
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showGrowthTips(context); // Show growth tips dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Growth Summary Card
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1A73E8).withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Growth Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Social Media\nFollowers',
                        '2.5K',
                        Icons.people_outline,
                        Color(0xFF1A73E8),
                      ),
                      _buildStatCard(
                        'Google\nRating',
                        '4.5',
                        Icons.star_outline,
                        Colors.amber,
                      ),
                      _buildStatCard(
                        'Kechi\nRating',
                        '4.8',
                        Icons.star_outline,
                        Colors.amber,
                      ),
                      _buildStatCard(
                        'Growth Rate',
                        '15%',
                        Icons.repeat,
                        Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branding Tools',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Remove the duplicate Kechi Assured section from the home page and update the button handler:
                  _buildBrandingTool(
                    'Kechi Assured',
                    'Get verified and boost your salon\'s credibility',
                    Icons.verified_outlined,
                    () {
                      // Show Kechi Assured section in a modal bottom sheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1A73E8).withOpacity(0.95),
                                Color(0xFF4285F4).withOpacity(0.95),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF1A73E8).withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                top: -20,
                                child: Icon(
                                  Icons.verified,
                                  size: 100,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Kechi Assured',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Elevate your salon\'s credibility with premium verification',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    _buildVerificationItems(),
                                    SizedBox(height: 20),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _showKechiAssuredDetails(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Color(0xFF1A73E8),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          'Get Verified',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Branding Tools Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branding Tools',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildBrandingTool(
                    'Social Media Kit',
                    'Create and share professional posts',
                    Icons.camera_alt_outlined,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RunadsPage()));
                    },
                  ),
                  SizedBox(height: 12),
                  _buildBrandingTool(
                    'Salon Promotion',
                    'Create special offers and campaigns',
                    Icons.campaign_outlined,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PromotionsScreen()));
                    },
                  ),
                  SizedBox(height: 12),
                  _buildBrandingTool(
                    'Customer Reviews',
                    'Manage and showcase testimonials',
                    Icons.rate_review_outlined,
                    () {
                      // Handle reviews
                    },
                  ),
                ],
              ),
            ),

            // Growth Strategies Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Growth Strategies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildStrategyCard(
                    'Loyalty Program',
                    'Reward your regular customers',
                    'Set up a points-based system',
                    Icons.card_giftcard_outlined,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReferEarnScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildStrategyCard(
                    'Referral System',
                    'Grow through word of mouth',
                    'Incentivize customer referrals',
                    Icons.share_outlined,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReferEarnScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 12),
                  _buildStrategyCard(
                    'Online Presence',
                    'Boost your digital visibility',
                    'Optimize social media profiles',
                    Icons.language_outlined,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReferEarnScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Show growth assistant
            _showGrowthAssistant(context);
          },
          backgroundColor: Color(0xFF1A73E8),
          icon: Icon(Icons.trending_up, color: Colors.white),
          label: Text('Growth Assistant',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: const Color.fromARGB(137, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingTool(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF1A73E8).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF1A73E8)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStrategyCard(String title, String subtitle, String description,
      IconData icon, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A73E8).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Color(0xFF1A73E8)),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: onPressed,
            child: Text('Learn More'),
            style: TextButton.styleFrom(
              foregroundColor: Color(0xFF1A73E8),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  void _showGrowthTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Growth Tips'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTipItem('Engage with customers on social media regularly'),
            _buildTipItem('Offer seasonal promotions and packages'),
            _buildTipItem('Collect and showcase customer testimonials'),
            _buildTipItem('Partner with local businesses'),
            _buildTipItem('Maintain consistent branding across all channels'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Color(0xFF1A73E8), size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(tip),
          ),
        ],
      ),
    );
  }

  void _showGrowthAssistant(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Growth Assistant',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildAssistantOption(
              'Create Marketing Campaign',
              'Design and launch promotional campaigns',
              Icons.campaign_outlined,
            ),
            _buildAssistantOption(
              'Analyze Performance',
              'View detailed growth analytics',
              Icons.analytics_outlined,
            ),
            _buildAssistantOption(
              'Get Recommendations',
              'Personalized growth suggestions',
              Icons.lightbulb_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistantOption(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFF1A73E8).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Color(0xFF1A73E8)),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Handle assistant option
      },
    );
  }

  Widget _buildAssuredStatus(VerificationStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case VerificationStatus.notStarted:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
        text = 'Not Started';
        break;
      case VerificationStatus.inProgress:
        backgroundColor = Colors.amber.withOpacity(0.2);
        textColor = Colors.amber[800]!;
        text = 'In Progress';
        break;
      case VerificationStatus.verified:
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        text = 'Verified';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildVerificationItems() {
    return Column(
      children: [
        _buildVerificationItem(
          'Business Registration',
          'Verify your business documents',
          VerificationStatus.notStarted,
        ),
        SizedBox(height: 12),
        _buildVerificationItem(
          'Professional Certifications',
          'Upload salon and staff certifications',
          VerificationStatus.notStarted,
        ),
        SizedBox(height: 12),
        _buildVerificationItem(
          'Insurance Coverage',
          'Show proof of business insurance',
          VerificationStatus.notStarted,
        ),
        SizedBox(height: 12),
        _buildVerificationItem(
          'Safety Compliance',
          'Verify safety and hygiene standards',
          VerificationStatus.notStarted,
        ),
      ],
    );
  }

  Widget _buildVerificationItem(
      String title, String subtitle, VerificationStatus status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case VerificationStatus.notStarted:
        statusColor = Colors.white.withOpacity(0.5);
        statusIcon = Icons.radio_button_unchecked;
        break;
      case VerificationStatus.inProgress:
        statusColor = Colors.amber;
        statusIcon = Icons.pending;
        break;
      case VerificationStatus.verified:
        statusColor = Colors.greenAccent;
        statusIcon = Icons.check_circle;
        break;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showKechiAssuredDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kechi Assured',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Premium Business Verification',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    _buildVerificationUploadSection(
                      'Business Registration',
                      'Upload your business registration certificate, permits, and other legal documents',
                      [
                        'Business License',
                        'Operating Permit',
                        'Tax Registration'
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildVerificationUploadSection(
                      'Professional Certifications',
                      'Upload professional certificates and qualifications of your staff',
                      [
                        'Beautician License',
                        'Professional Training Certificates',
                        'Specialization Certificates'
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildVerificationUploadSection(
                      'Insurance Coverage',
                      'Upload your business insurance documentation',
                      [
                        'Liability Insurance',
                        'Property Insurance',
                        'Worker\'s Compensation'
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildVerificationUploadSection(
                      'Safety Compliance',
                      'Upload health and safety certificates and inspection reports',
                      [
                        'Safety Inspection Report',
                        'Health Department Certificate',
                        'Fire Safety Compliance'
                      ],
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Handle verification submission
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Submit for Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildVerificationUploadSection(
      String title, String description, List<String> documents) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          ...documents
              .map((doc) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        // Handle document upload
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFF1A73E8).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Color(0xFF1A73E8),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                doc,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF1A73E8),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
