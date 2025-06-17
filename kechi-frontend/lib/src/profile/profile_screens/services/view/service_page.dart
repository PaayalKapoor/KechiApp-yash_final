import 'package:flutter/material.dart';
import 'dart:ui';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

// Custom painter for the curved bottom edge
class CurvedBottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF1A73E8)
      ..style = PaintingStyle.fill;
      
    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.25, 
      0, 
      size.width * 0.5, 
      size.height * 0.25
    );
    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height * 0.5, 
      size.width, 
      size.height * 0.25
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ServicePageState extends State<ServicePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = [
    'All Services',
    'Hair',
    'Facial',
    'Tanning',
    'Nails',
    'Massage'
  ];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  // Animation controller for service cards
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: _buildSearchAndTabs(),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = salonServices[index % salonServices.length];

                    // Staggered animation for each card
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final delay = index * 0.2;
                        final slideAnimation = Tween<Offset>(
                          begin: Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              delay.clamp(0.0, 0.9),
                              (delay + 0.4).clamp(0.0, 1.0),
                              curve: Curves.easeOutQuint,
                            ),
                          ),
                        );

                        return SlideTransition(
                          position: slideAnimation,
                          child: FadeTransition(
                            opacity: _animationController,
                            child: child,
                          ),
                        );
                      },
                      child: _buildServiceCard(service),
                    );
                  },
                  childCount: salonServices.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildAppBar() {
  return SliverAppBar(
    expandedHeight: 150,
    pinned: true,
    backgroundColor: Colors.transparent,
    flexibleSpace: FlexibleSpaceBar(
      titlePadding: EdgeInsets.only(left: 16, bottom: 16),
      title: Text(
        'Salon Services',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      background: Stack(
        fit: StackFit.expand,
        children: [
          // Beautiful gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A73E8),
                  Color(0xFF1A73E8),
                ],
              ),
            ),
          ),
          // Pattern overlay
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/images/services_background.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Elegant wavy design at bottom
          Positioned(
            bottom: -2,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: CurvedBottomPainter(),
              size: Size(MediaQuery.of(context).size.width, 30),
            ),
          ),
          // Premium salon badge
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Premium Salon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.filter_list_rounded, color: Colors.white),
        onPressed: () {
          // Show filter options
        },
      ),
    ],
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    ),
  );
}



 Widget _buildSearchAndTabs() {
  return Column(
    children: [
      // Search bar remains the same
      Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                isSearching = value.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search services...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(Icons.search, color: Color(0xFF1A73E8)),
              suffixIcon: isSearching
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          isSearching = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),

      // Updated Category tabs with elegant design
      Container(
        height: 90,
        margin: EdgeInsets.only(top: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            bool isSelected = _tabController.index == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _tabController.animateTo(index);
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF1A73E8).withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Color(0xFF1A73E8) : Colors.grey.shade200,
                    width: 1.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: Color(0xFF1A73E8).withOpacity(0.15),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ] : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF1A73E8) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getTabIconData(categories[index]),
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        size: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Color(0xFF1A73E8) : Colors.grey.shade800,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
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
  );
}

IconData _getTabIconData(String category) {
  switch (category) {
    case 'All Services':
      return Icons.grid_view_rounded;
    case 'Hair':
      return Icons.content_cut;
    case 'Facial':
      return Icons.face;
    case 'Tanning':
      return Icons.wb_sunny_outlined;
    case 'Nails':
      return Icons.spa;
    case 'Massage':
      return Icons.healing;
    default:
      return Icons.spa;
  }
}

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final discountPercentage = "10%";
    final originalPrice = service['originalPrice'];
    final discountedPrice = service['price'];
    final duration = service['duration'];
    final category = service['category'];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Handle service selection
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => _buildServiceDetails(service),
              );
            },
            splashColor: Color(0xFF1A73E8).withOpacity(0.1),
            highlightColor: Color(0xFF1A73E8).withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service image with overlay and badges
                Stack(
                  children: [
                    Hero(
                      tag: 'service-${service['name']}',
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          image: DecorationImage(
                            image: AssetImage(
                              service['imagePath'] != null && service['imagePath']!.isNotEmpty
                                  ? service['imagePath']!
                                  : 'assets/images/placeholder.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    
                    // Discount badge - Updated design
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              discountPercentage + ' OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Duration badge - Updated design
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$duration min',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Category badge - Updated design with gradient
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.8],
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            _getCategoryIcon(category),
                            SizedBox(width: 6),
                            Text(
                              category,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Service details
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Service name
                          Expanded(
                            child: Text(
                              service['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Favorite button - Updated design
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                size: 18,
                                color: Color(0xFF1A73E8),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Short description
                      Text(
                        service['description'].split('.')[0] + '.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 16),

                      // Price and action row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '\₹${originalPrice.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '\₹${discountedPrice.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: Color(0xFF1A73E8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Action buttons in a row - Updated design
                          Row(
                            children: [
                              _buildActionButton(
                                Icons.edit,
                                Color(0xFF1A73E8),
                                () {},
                              ),
                              SizedBox(width: 8),
                              _buildActionButton(
                                Icons.delete,
                                Colors.red,
                                () {},
                              ),
                            ],
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
  }

  Widget _getCategoryIcon(String category) {
    IconData iconData;
    switch (category) {
      case 'Hair Colouring':
      case 'Hair Styling':
        iconData = Icons.content_cut;
        break;
      case 'Facial & Skincare':
        iconData = Icons.face;
        break;
      case 'Tanning':
        iconData = Icons.wb_sunny_outlined;
        break;
      default:
        iconData = Icons.spa;
    }
    return Icon(iconData, size: 14, color: Colors.white);
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: color),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildServiceDetails(Map<String, dynamic> service) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button and header
            Stack(
              children: [
                // Service image
                Hero(
                  tag: 'service-${service['name']}',
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          service['imagePath'] != null && service['imagePath']!.isNotEmpty
                              ? service['imagePath']!
                              : 'assets/images/placeholder.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1A73E8).withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      _getCategoryIcon(service['category']),
                                      SizedBox(width: 6),
                                      Text(
                                        service['category'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.8 (120)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Close button - Updated design
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, size: 20, color: Color(0xFF1A73E8)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                
                // Pull handle at the top
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Service details content
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and duration in a card - Updated design
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '\₹${service['originalPrice'].toStringAsFixed(1)}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '\₹${service['price'].toStringAsFixed(1)}',
                                        style: TextStyle(
                                          color: Color(0xFF1A73E8),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.blue.shade200,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Duration',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Color(0xFF1A73E8),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${service['duration']} min',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Description with icon - Updated design
                      _buildSectionHeader(Icons.description_outlined, 'Description'),
                      SizedBox(height: 12),
                      Text(
                        service['description'],
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),

                      SizedBox(height: 24),

                      // What's included with icon - Updated design
                      _buildSectionHeader(Icons.check_circle_outline, 'What\'s included'),
                      SizedBox(height: 12),
                      ...service['includes']
                          .map<Widget>((item) => Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 2),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFF1A73E8).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Color(0xFF1A73E8),
                                        size: 14,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),

                      SizedBox(height: 24),

                      // Staff with icon - Updated design
                      _buildSectionHeader(Icons.people_outline, 'Available Staff'),
                      SizedBox(height: 16),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF4285F4),
                                          Color(0xFF1A73E8),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'S${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Staff ${index + 1}',
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 24),

                      // Reviews section
                      _buildSectionHeader(Icons.star_outline, 'Reviews'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '4.8',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Based on 120 reviews',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16),
                      
                      // Review list - just a sample
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    'JD',
                                    style: TextStyle(
                                      color: Color(0xFF1A73E8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jane Doe',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  '2 days ago',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Amazing service! The staff was professional and friendly. I\'m very satisfied with the results and will definitely come back.',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      // View all reviews button
                      TextButton(
                        onPressed: () {
                          // Show all reviews
                        },
                        child: Text(
                          'View all 120 reviews',
                          style: TextStyle(
                            color: Color(0xFF1A73E8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom action buttons
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Edit button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle edit service
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.edit_outlined),
                      label: Text('Edit Service'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF1A73E8),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFF1A73E8)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Delete button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle delete service with confirmation
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Service?'),
                              content: Text(
                                'Are you sure you want to delete this service? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.grey.shade700),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle delete
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Delete'),
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete_outline),
                      label: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade600,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF1A73E8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xFF1A73E8),
            size: 18,
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Add new service
      },
      backgroundColor: Color(0xFF1A73E8),
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: Icon(Icons.add),
      label: Text(
        'Add Service',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

// Wave painter for decorative element in app bar
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.lineTo(0, size.height * 0.8);

    // Create wave pattern
    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height * 0.6);
    final secondEndPoint = Offset(size.width, size.height * 0.8);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


// Sample data
final List<Map<String, dynamic>> salonServices = [
  {
    'name': 'Hot Toffee',
    'category': 'Hair Colouring',
    'originalPrice': 500.0,
    'price': 450.0,
    'duration': 60.0,
    'imagePath': 'assets/images/hot_toffee.jpg',
    'description':
        'Our Hot Toffee treatment gives your hair a rich, warm brown color with caramel highlights that catch the light beautifully. Perfect for adding dimension and warmth to your look.',
    'includes': [
      'Professional consultation',
      'Premium color products',
      'Deep conditioning treatment',
      'Styling after coloring'
    ]
  },
  {
    'name': 'Sparkling Amber',
    'category': 'Hair Colouring',
    'originalPrice': 500.0,
    'price': 450.0,
    'duration': 60.0,
    'imagePath': 'assets/images/sparkling_amber.jpg',
    'description':
        'Sparkling Amber is a stunning copper-gold color service that adds radiance and vibrant warmth to your hair. This signature treatment creates a multidimensional effect that shimmers with movement.',
    'includes': [
      'Professional consultation',
      'Premium color products',
      'Deep conditioning treatment',
      'Styling after coloring'
    ]
  },
  {
    'name': 'Strands',
    'category': 'Hair Styling',
    'originalPrice': 150.0,
    'price': 135.0,
    'duration': 60.0,
    'imagePath': 'assets/images/strands.jpg',
    'description':
        'Our Strands styling service focuses on creating the perfect texture and definition for your hair type. Whether you want beachy waves, sleek straightness, or defined curls, this service will give you the look you desire.',
    'includes': [
      'Consultation on style options',
      'Premium styling products',
      'Heat protection treatment',
      'Finishing spray for long-lasting hold'
    ]
  },
  {
    'name': 'The Colorist',
    'category': 'Hair Styling',
    'originalPrice': 300.0,
    'price': 270.0,
    'duration': 60.0,
    'imagePath': 'assets/images/the_colorist.jpg',
    'description':
        'The Colorist is our premium color service performed by our master colorists. This service includes custom color formulation and expert application techniques to achieve your perfect shade.',
    'includes': [
      'Extended consultation',
      'Custom color formulation',
      'Premium color products',
      'Treatment mask',
      'Blowout styling'
    ]
  },
  {
    'name': 'A Cut Above',
    'category': 'Hair Styling',
    'originalPrice': 250.0,
    'price': 225.0,
    'duration': 60.0,
    'imagePath': 'assets/images/a_cut_above.jpg',
    'description':
        'A Cut Above is our signature haircut service that includes a thorough consultation, precision cutting, and expert styling. Our stylists are trained in the latest techniques to create the perfect cut for your face shape and lifestyle.',
    'includes': [
      'Style consultation',
      'Shampoo and conditioning',
      'Precision cutting',
      'Styling with premium products',
      'Style tips for home maintenance'
    ]
  },
  {
    'name': 'Lovely Lather',
    'category': 'Hair Styling',
    'originalPrice': 250.0,
    'price': 225.0,
    'duration': 60.0,
    'imagePath': 'assets/images/lovely_lather.jpg',
    'description':
        'Lovely Lather is our luxurious shampooing and conditioning treatment that uses premium products to cleanse, nourish, and revitalize your hair. Includes a relaxing scalp massage for the ultimate pampering experience.',
    'includes': [
      'Premium shampoo and conditioner',
      '10-minute scalp massage',
      'Hot towel treatment',
      'Relaxing aromatherapy',
      'Style finishing'
    ]
  },
  {
    'name': 'Fair Skin',
    'category': 'Facial & Skincare',
    'originalPrice': 500.0,
    'price': 450.0,
    'duration': 90.0,
    'imagePath': 'assets/images/fair_skin.jpg',
    'description':
        'Our Fair Skin facial is designed to brighten and even out skin tone. This treatment includes gentle exfoliation, vitamin C infusion, and targeted treatments to reduce hyperpigmentation and reveal radiant skin.',
    'includes': [
      'Skin analysis',
      'Gentle brightening cleanser',
      'Enzymatic exfoliation',
      'Vitamin C mask',
      'Brightening serum application',
      'SPF protection'
    ]
  },
  {
    'name': 'Twilight Tans',
    'category': 'Tanning',
    'originalPrice': 500.0,
    'price': 450.0,
    'duration': 90.0,
    'imagePath': 'assets/images/twilight_tans.jpg',
    'description':
        'Twilight Tans offers a natural-looking, streak-free tan that develops gradually for a subtle sun-kissed glow. Perfect for special occasions or anytime you want a healthy radiance without sun damage.',
    'includes': [
      'Full body exfoliation prep',
      'Custom tanning solution application',
      'Moisturizing treatment',
    ],
  },
  // Closing the salonServices list
];
