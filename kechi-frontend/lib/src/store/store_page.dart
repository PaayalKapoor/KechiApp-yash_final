import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kechi/src/profile/main_screen/view/profile_page.dart';
import 'package:kechi/src/store/scan_page.dart';
import 'package:kechi/src/store/consumables_page.dart';
import 'package:kechi/src/store/widgets/product_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Sunsilk Shampoo',
      'price': 2499,
      'originalPrice': 2999,
      'image': 'assets/images/sunsilk.jpg',
      'rating': 4.8,
      'liked': false,
      'brand': 'Sunsilk',
      'banner': '20% OFF',
    },
    {
      'name': 'Kesh King Conditioner',
      'price': 1850,
      'originalPrice': 2200,
      'image': 'assets/images/kesh.jpg',
      'rating': 4.6,
      'liked': false,
      'brand': 'Kesh King',
      'banner': 'New',
    },
    {
      'name': 'Loreal Conditioner',
      'price': 3200,
      'originalPrice': 3800,
      'image': 'assets/images/l_cond.jpg',
      'rating': 4.9,
      'liked': false,
      'brand': 'Loreal',
      'banner': 'Best Seller',
    },
    {
      'name': 'Loreal Shampoo',
      'price': 2175,
      'originalPrice': 2500,
      'image': 'assets/images/l_shampoo.jpg',
      'rating': 4.7,
      'liked': false,
      'brand': 'Loreal',
      'banner': '15% OFF',
    },
    {
      'name': 'Loreal Spray',
      'price': 1699,
      'originalPrice': 1999,
      'image': 'assets/images/l_spray.jpg',
      'rating': 4.5,
      'liked': false,
      'brand': 'Loreal',
      'banner': null,
    },
    {
      'name': 'Dove Shampoo',
      'price': 1925,
      'originalPrice': 2300,
      'image': 'assets/images/dove.jpg',
      'rating': 4.4,
      'liked': false,
      'brand': 'Dove',
      'banner': 'Limited Time',
    },
  ];

  final List<String> _categories = [
    'All Products',
    'Hair Care',
    'Styling',
    'Treatments',
    'Tools',
    'Accessories',
  ];

  int _selectedCategoryIndex = 0;
  int _selectedSection = 0;
  final List<String> _sections = ['Products', 'Consumables', 'Online Orders'];
  final List<String> _carouselImages = [
    'assets/images/brand1.png',
    'assets/images/brand2.png',
    'assets/images/brand3.png',
  ];

  // Cart: product index -> quantity
  Map<int, int> cart = {};
  // Filter state
  Set<String> selectedCategories = {};
  // Sort state
  String? sortType;

  // Add favorites list
  final List<Map<String, dynamic>> _favorites = [];

  // Add saved items list
  final List<Map<String, dynamic>> _savedForLater = [];

  // Add cart total calculation
  double get _cartTotal {
    return cart.entries.fold(0.0, (sum, entry) {
      final product = _products[entry.key];
      return sum + (product['price'] * entry.value);
    });
  }

  // Search state
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtering
    List<Map<String, dynamic>> filteredProducts = _products.where((product) {
      final matchesCategory = selectedCategories.isEmpty ||
          selectedCategories.contains('All Products') ||
          selectedCategories.any((cat) => product['name']
              .toString()
              .toLowerCase()
              .contains(cat.toLowerCase()));
      final matchesSearch = _searchQuery.isEmpty ||
          product['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    // Sorting
    if (sortType == 'Price: Low to High') {
      filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (sortType == 'Price: High to Low') {
      filteredProducts.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (sortType == 'Rating') {
      filteredProducts.sort((a, b) => b['rating'].compareTo(a['rating']));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: (_selectedSection == 0 && _showSearchBar)
            ? Container(
                height: 44,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F8FE),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFE3E8F1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: TextStyle(fontSize: 16),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Text('Store',
                style: TextStyle(
                    color: Color(0xFF1A73E8), fontWeight: FontWeight.bold)),
        actions: [
          if (_selectedSection == 0 && !_showSearchBar)
            IconButton(
              icon: Icon(Icons.search, color: Color(0xFF1A73E8)),
              onPressed: () {
                setState(() {
                  _showSearchBar = true;
                });
              },
            ),
          if (_selectedSection == 0 && _showSearchBar)
            IconButton(
              icon: Icon(Icons.close, color: Color(0xFF1A73E8)),
              onPressed: () {
                setState(() {
                  _showSearchBar = false;
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
            ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Color(0xFF1A73E8)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritesPage(
                        favorites: _favorites,
                        onRemoveFavorite: (product) {
                          setState(() {
                            _favorites.remove(product);
                            // Update the liked status in _products
                            final index = _products.indexWhere(
                                (p) => p['name'] == product['name']);
                            if (index != -1) {
                              _products[index]['liked'] = false;
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              if (_favorites.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _favorites.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon:
                    Icon(Icons.shopping_bag_outlined, color: Color(0xFF1A73E8)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cart: cart,
                        products: _products,
                        savedItems: _savedForLater,
                        onUpdateQuantity: (productIndex, quantity) {
                          setState(() {
                            if (quantity > 0) {
                              cart[productIndex] = quantity;
                            } else {
                              cart.remove(productIndex);
                            }
                          });
                        },
                        onRemoveItem: (productIndex) {
                          setState(() {
                            cart.remove(productIndex);
                          });
                        },
                        onSaveForLater: (product) {
                          setState(() {
                            if (!_savedForLater.contains(product)) {
                              _savedForLater.add(product);
                              final index = _products.indexOf(product);
                              if (index != -1) {
                                cart.remove(index);
                              }
                            }
                          });
                        },
                        onMoveToCart: (product) {
                          setState(() {
                            _savedForLater.remove(product);
                            final index = _products.indexOf(product);
                            if (index != -1) {
                              cart[index] = 1;
                            }
                          });
                        },
                        onRemoveSaved: (product) {
                          setState(() {
                            _savedForLater.remove(product);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.values
                          .fold(0, (sum, quantity) => sum + quantity)
                          .toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Row(
            children: List.generate(_sections.length, (i) {
              final selected = _selectedSection == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedSection = i),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? Color(0xFF1A73E8) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Color(0xFF1A73E8), width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        _sections[i],
                        style: TextStyle(
                          color: selected ? Colors.white : Color(0xFF1A73E8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F8FE),
      body: CustomScrollView(
        slivers: [
          // Branding Carousel - Only show for Products and Consumables
          if (_selectedSection == 0 || _selectedSection == 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 140,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  ),
                  items: _carouselImages.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String img = entry.value;
                    return GestureDetector(
                      onTap: () {
                        // For demo: Brand 1 = Loreal
                        if (idx == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrandStorePage(
                                brand: 'Loreal',
                                products: _products
                                    .where((p) => p['brand'] == 'Loreal')
                                    .toList(),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: AssetImage(img),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          // Categories
          if (_selectedSection == 0)
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategoryIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: _selectedCategoryIndex == index
                              ? Color(0xFF1A73E8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: _selectedCategoryIndex == index
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          // Filter & Sort
          if (_selectedSection == 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF1A73E8),
                        elevation: 0,
                        side: BorderSide(color: Color(0xFF1A73E8)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      icon: Icon(Icons.filter_list_outlined),
                      label: Text('Filter'),
                      onPressed: () async {
                        final result = await showModalBottomSheet<Set<String>>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) {
                            Set<String> tempSelected =
                                Set.from(selectedCategories);
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Filter by Category',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      SizedBox(height: 5),
                                      ..._categories
                                          .map((cat) => CheckboxListTile(
                                                activeColor: Color(0xFF1A73E8),
                                                value:
                                                    tempSelected.contains(cat),
                                                title: Text(cat),
                                                onChanged: (val) {
                                                  setModalState(() {
                                                    if (val == true) {
                                                      tempSelected.add(cat);
                                                    } else {
                                                      tempSelected.remove(cat);
                                                    }
                                                  });
                                                },
                                              )),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, selectedCategories),
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(
                                                context, tempSelected),
                                            child: Text('Apply'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                        if (result != null) {
                          setState(() {
                            selectedCategories = result;
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      icon: Icon(Icons.sort),
                      label: Text('Sort'),
                      onPressed: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) {
                            String? tempSort = sortType;
                            return StatefulBuilder(
                              builder: (context, setModalState) {
                                return Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Sort by',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      SizedBox(height: 16),
                                      RadioListTile<String>(
                                        value: 'Price: Low to High',
                                        groupValue: tempSort,
                                        title: Text('Price: Low to High'),
                                        onChanged: (val) =>
                                            setModalState(() => tempSort = val),
                                      ),
                                      RadioListTile<String>(
                                        value: 'Price: High to Low',
                                        groupValue: tempSort,
                                        title: Text('Price: High to Low'),
                                        onChanged: (val) =>
                                            setModalState(() => tempSort = val),
                                      ),
                                      RadioListTile<String>(
                                        value: 'Rating',
                                        groupValue: tempSort,
                                        title: Text('Rating'),
                                        onChanged: (val) =>
                                            setModalState(() => tempSort = val),
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, sortType),
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(
                                                context, tempSort),
                                            child: Text('Apply'),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                        if (result != null) {
                          setState(() {
                            sortType = result;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          // Products Grid
          if (_selectedSection == 0)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildProductCard(filteredProducts, index);
                  },
                  childCount: filteredProducts.length,
                ),
              ),
            ),

          if (_selectedSection == 1)
            SliverFillRemaining(
              child: ConsumablesPage(
                carouselImages: _carouselImages,
              ),
            ),
          if (_selectedSection == 2)
            SliverFillRemaining(
              child: _OnlineOrdersSection(),
            ),
        ],
      ),
      floatingActionButton: (_selectedSection == 0)
          ? FloatingActionButton(
              backgroundColor: Color(0xFF1A73E8),
              child: Icon(Icons.qr_code_scanner, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanPage(),
                  ),
                );
              },
            )
          : null,
    );
  }

  Widget _buildProductCard(List<Map<String, dynamic>> products, int index) {
    final product = products[index];
    final originalIndex = _products.indexOf(product);
    int quantity = cart[originalIndex] ?? 0;

    return ProductCard(
      product: product,
      quantity: quantity,
      onUpdateQuantity: (newQuantity) {
        setState(() {
          if (newQuantity > 0) {
            cart[originalIndex] = newQuantity;
          } else {
            cart.remove(originalIndex);
          }
        });
      },
      onToggleFavorite: () {
        setState(() {
          product['liked'] = !(product['liked'] ?? false);
          if (product['liked']) {
            if (!_favorites.contains(product)) {
              _favorites.add(product);
            }
          } else {
            _favorites.remove(product);
          }
        });
      },
      isFavorite: product['liked'] ?? false,
    );
  }
}

// Update BrandStorePage to StatefulWidget
class BrandStorePage extends StatefulWidget {
  final String brand;
  final List<Map<String, dynamic>> products;
  const BrandStorePage({required this.brand, required this.products});

  @override
  _BrandStorePageState createState() => _BrandStorePageState();
}

class _BrandStorePageState extends State<BrandStorePage> {
  // Cart: product index -> quantity
  Map<int, int> cart = {};

  void _updateCart(int productIndex, int quantity) {
    setState(() {
      if (quantity > 0) {
        cart[productIndex] = quantity;
      } else {
        cart.remove(productIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('${widget.brand} Store',
            style: TextStyle(
                color: Color(0xFF1A73E8), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF1A73E8)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon:
                    Icon(Icons.shopping_bag_outlined, color: Color(0xFF1A73E8)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        cart: cart,
                        products: widget.products,
                        savedItems: [],
                        onUpdateQuantity: (productIndex, quantity) {
                          setState(() {
                            if (quantity > 0) {
                              cart[productIndex] = quantity;
                            } else {
                              cart.remove(productIndex);
                            }
                          });
                        },
                        onRemoveItem: (productIndex) {
                          setState(() {
                            cart.remove(productIndex);
                          });
                        },
                        onSaveForLater: (product) {},
                        onMoveToCart: (product) {},
                        onRemoveSaved: (product) {},
                      ),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.values
                          .fold(0, (sum, quantity) => sum + quantity)
                          .toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F8FE),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];
            int quantity = cart[index] ?? 0;

            return ProductCard(
              product: product,
              quantity: quantity,
              onUpdateQuantity: (newQuantity) {
                _updateCart(index, newQuantity);
              },
              onToggleFavorite: () {
                setState(() {
                  product['liked'] = !(product['liked'] ?? false);
                });
              },
              isFavorite: product['liked'] ?? false,
            );
          },
        ),
      ),
    );
  }
}

// Add FavoritesPage class
class FavoritesPage extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;
  final Function(Map<String, dynamic>) onRemoveFavorite;

  const FavoritesPage({
    Key? key,
    required this.favorites,
    required this.onRemoveFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('Favorites',
            style: TextStyle(
                color: Color(0xFF1A73E8), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF1A73E8)),
      ),
      backgroundColor: Color(0xFFF5F8FE),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add products to your favorites',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return ProductCard(
                  product: product,
                  showQuantityControls: false,
                  onToggleFavorite: () => onRemoveFavorite(product),
                  isFavorite: true,
                );
              },
            ),
    );
  }
}

// Update CartPage to StatefulWidget
class CartPage extends StatefulWidget {
  final Map<int, int> cart;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> savedItems;
  final Function(int, int) onUpdateQuantity;
  final Function(int) onRemoveItem;
  final Function(Map<String, dynamic>) onSaveForLater;
  final Function(Map<String, dynamic>) onMoveToCart;
  final Function(Map<String, dynamic>) onRemoveSaved;

  const CartPage({
    Key? key,
    required this.cart,
    required this.products,
    required this.savedItems,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onSaveForLater,
    required this.onMoveToCart,
    required this.onRemoveSaved,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<int, int> _localCart;
  late List<Map<String, dynamic>> _localSavedItems;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _localCart = Map.from(widget.cart);
    _localSavedItems = List.from(widget.savedItems);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateLocalCart(int productIndex, int quantity) {
    setState(() {
      if (quantity > 0) {
        _localCart[productIndex] = quantity;
      } else {
        _localCart.remove(productIndex);
      }
      widget.onUpdateQuantity(productIndex, quantity);
    });
  }

  void _removeFromCart(int productIndex) {
    setState(() {
      _localCart.remove(productIndex);
      widget.onRemoveItem(productIndex);
    });
  }

  void _saveForLater(Map<String, dynamic> product) {
    setState(() {
      if (!_localSavedItems.contains(product)) {
        _localSavedItems.add(product);
        final index = widget.products.indexOf(product);
        if (index != -1) {
          _localCart.remove(index);
        }
        widget.onSaveForLater(product);
      }
    });
  }

  void _moveToCart(Map<String, dynamic> product) {
    setState(() {
      _localSavedItems.remove(product);
      final index = widget.products.indexOf(product);
      if (index != -1) {
        _localCart[index] = 1;
      }
      widget.onMoveToCart(product);
    });
  }

  void _removeSaved(Map<String, dynamic> product) {
    setState(() {
      _localSavedItems.remove(product);
      widget.onRemoveSaved(product);
    });
  }

  double get _cartTotal {
    return _localCart.entries.fold(0.0, (sum, entry) {
      final product = widget.products[entry.key];
      return sum + (product['price'] * entry.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('Shopping Cart',
            style: TextStyle(
                color: Color(0xFF1A73E8), fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Color(0xFF1A73E8)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF1A73E8),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF1A73E8),
          tabs: [
            Tab(text: 'Cart (${_localCart.length})'),
            Tab(text: 'Saved (${_localSavedItems.length})'),
          ],
        ),
      ),
      backgroundColor: Color(0xFFF5F8FE),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Cart Tab
          _localCart.isEmpty
              ? _buildEmptyState('Your cart is empty', 'Add items to your cart')
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _localCart.length,
                        itemBuilder: (context, index) {
                          final entry = _localCart.entries.elementAt(index);
                          final productIndex = entry.key;
                          final quantity = entry.value;
                          final product = widget.products[productIndex];

                          return _buildCartItem(
                            context,
                            product,
                            quantity,
                            () => _updateLocalCart(productIndex, quantity - 1),
                            () => _updateLocalCart(productIndex, quantity + 1),
                            () => _removeFromCart(productIndex),
                            () => _saveForLater(product),
                            isSaved: false,
                          );
                        },
                      ),
                    ),
                    if (_localCart.isNotEmpty) _buildCartSummary(context),
                  ],
                ),
          // Saved Items Tab
          _localSavedItems.isEmpty
              ? _buildEmptyState('No saved items', 'Save items for later')
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _localSavedItems.length,
                  itemBuilder: (context, index) {
                    final product = _localSavedItems[index];
                    return _buildCartItem(
                      context,
                      product,
                      1,
                      null,
                      null,
                      () => _removeSaved(product),
                      () => _moveToCart(product),
                      isSaved: true,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context,
      Map<String, dynamic> product,
      int quantity,
      VoidCallback? onDecrease,
      VoidCallback? onIncrease,
      VoidCallback onRemove,
      VoidCallback onAction,
      {required bool isSaved}) {
    final TextEditingController quantityController =
        TextEditingController(text: quantity.toString());
    final FocusNode quantityFocus = FocusNode();
    String? errorText;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.asset(
              product['image'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Rs.${product['originalPrice'].toStringAsFixed(0)}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Rs.${product['price'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isSaved && onDecrease != null && onIncrease != null)
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(0xFF1A73E8),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24,
                                child: IconButton(
                                  icon: Icon(Icons.remove,
                                      color: Colors.white, size: 16),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      onDecrease();
                                      errorText = null;
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                              Container(
                                width: 18,
                                child: TextField(
                                  controller: quantityController,
                                  focusNode: quantityFocus,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    errorText: errorText,
                                    errorStyle: TextStyle(
                                      color: Colors.red[200],
                                      fontSize: 8,
                                      height: 0.8,
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    final newQuantity =
                                        int.tryParse(value) ?? 0;
                                    setState(() {
                                      if (newQuantity > 0 &&
                                          newQuantity <= 99) {
                                        final index =
                                            widget.products.indexOf(product);
                                        if (index != -1) {
                                          widget.onUpdateQuantity(
                                              index, newQuantity);
                                          errorText = null;
                                        }
                                      } else if (newQuantity > 99) {
                                        errorText = 'Max 99';
                                        quantityController.text =
                                            quantity.toString();
                                      } else {
                                        final index =
                                            widget.products.indexOf(product);
                                        if (index != -1) {
                                          widget.onRemoveItem(index);
                                          quantityController.text = '0';
                                        }
                                      }
                                    });
                                    quantityFocus.unfocus();
                                  },
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      quantityController.text = '0';
                                    } else {
                                      final numValue = int.tryParse(value) ?? 0;
                                      if (numValue > 99) {
                                        errorText = 'Max 99';
                                      } else {
                                        errorText = null;
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                child: IconButton(
                                  icon: Icon(Icons.add,
                                      color: Colors.white, size: 16),
                                  onPressed: () {
                                    if (quantity < 99) {
                                      onIncrease();
                                      errorText = null;
                                    } else {
                                      errorText = 'Max 99';
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 32,
                            child: IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.shopping_cart_outlined
                                    : Icons.bookmark_border,
                                color: Color(0xFF1A73E8),
                                size: 20,
                              ),
                              onPressed: onAction,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: onRemove,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rs.${_cartTotal.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Checkout functionality coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add the Online Orders section widget at the end of the file
class _OnlineOrdersSection extends StatefulWidget {
  @override
  State<_OnlineOrdersSection> createState() => _OnlineOrdersSectionState();
}

class _OnlineOrdersSectionState extends State<_OnlineOrdersSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> newOrders = [
    {
      'id': '61832',
      'name': 'Nilesh Shah',
      'mobile': '8862025917',
      'payment': 'Prepaid',
      'delivery': 'Pickup',
      'date': 'April 12, 2025 2:00 PM',
      'items': 2,
      'total': 700,
      'address': 'D3 flat no. 20, ABC Apartments, Chembur, Mumbai - 400074',
      'status': 'New',
      'products': [
        {'name': 'Sunsilk Shampoo', 'qty': 2, 'price': 350},
        {'name': 'Loreal Conditioner', 'qty': 1, 'price': 350},
      ],
      'deliveryCharges': 0,
      'discount': 100,
      'couponCode': 'WELCOME100',
      'subtotal': 1050,
    },
    {
      'id': '61569',
      'name': 'Nilesh Shah',
      'mobile': '8862025917',
      'payment': 'COD',
      'delivery': 'Pickup',
      'date': 'April 12, 2025 2:00 PM',
      'items': 2,
      'total': 700,
      'address': 'D3 flat no. 20, ABC Apartments, Chembur, Mumbai - 400074',
      'status': 'New',
      'products': [
        {'name': 'Mamaearth Onion shampoo', 'qty': 2, 'price': 350},
        {'name': 'Mamaearth Ubtan Facewash', 'qty': 1, 'price': 350},
      ],
      'deliveryCharges': 0,
      'discount': 0,
      'couponCode': null,
      'subtotal': 1050,
    },
  ];
  final List<Map<String, dynamic>> oldOrders = [];

  // Add search state for orders
  final TextEditingController _orderSearchController = TextEditingController();
  String _orderSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _orderSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: Color(0xFF1A73E8),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1A73E8),
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'New'),
              Tab(text: 'Old'),
            ],
          ),
        ),
        // Search bar below the tabs
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFF5F8FE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xFFE3E8F1)),
            ),
            child: TextField(
              controller: _orderSearchController,
              decoration: InputDecoration(
                hintText: 'Search by Order ID or Mobile...',
                border: InputBorder.none,
                isDense: true,
                prefixIcon: Icon(Icons.search, color: Color(0xFFB0B8C1)),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              style: TextStyle(fontSize: 16),
              onChanged: (value) {
                setState(() {
                  _orderSearchQuery = value.trim();
                });
              },
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(newOrders),
              _buildOrderList(oldOrders),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders) {
    // Filter orders by mobile or order id
    final filteredOrders = _orderSearchQuery.isEmpty
        ? orders
        : orders.where((order) {
            final mobile = order['mobile']?.toString() ?? '';
            final id = order['id']?.toString() ?? '';
            return mobile.contains(_orderSearchQuery) ||
                id.contains(_orderSearchQuery);
          }).toList();
    if (filteredOrders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: TextStyle(color: Colors.grey[500], fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return GestureDetector(
          onTap: () => _showOrderDetails(context, order),
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID #${order['id']}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                SizedBox(height: 4),
                Text(order['name'],
                    style: TextStyle(fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Text('Mob No. ${order['mobile']}',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 14)),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        final String message =
                            'Hello, I have received your order #${order['id']}.';
                        final String url =
                            'https://wa.me/${order['mobile']}?text=${Uri.encodeComponent(message)}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Could not launch WhatsApp')),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: FaIcon(FontAwesomeIcons.whatsapp,
                            color: Colors.green[700], size: 18),
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        final Uri callUrl = Uri.parse('tel:${order['mobile']}');
                        try {
                          if (await canLaunchUrl(callUrl)) {
                            await launchUrl(callUrl,
                                mode: LaunchMode.externalNonBrowserApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Could not launch phone call')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Could not launch phone call')),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.phone,
                          color: Colors.blue[700],
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildPaymentChip(order['payment']),
                    SizedBox(width: 8),
                    _buildDeliveryChip(order['delivery']),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order['date'],
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 13)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Total Items - ${order['items']}',
                            style: TextStyle(fontSize: 13)),
                        Text('Grand Total - Rs.${order['total']}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A73E8),
                                fontSize: 15)),
                      ],
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

  Widget _buildPaymentChip(String payment) {
    if (payment == 'Prepaid') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFF1A73E8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 4),
            Text('Prepaid',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xFF1A73E8).withOpacity(0.08),
          border: Border.all(color: Color(0xFF1A73E8)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(Icons.hourglass_bottom, color: Color(0xFF1A73E8), size: 18),
            SizedBox(width: 4),
            Text('COD',
                style: TextStyle(
                    color: Color(0xFF1A73E8), fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
  }

  Widget _buildDeliveryChip(String delivery) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFF1A73E8)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(Icons.storefront, color: Color(0xFF1A73E8), size: 18),
          SizedBox(width: 4),
          Text('Pickup',
              style: TextStyle(
                  color: Color(0xFF1A73E8), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    // Calculate subtotal from products
    double subtotal = order['products'].fold(0.0, (sum, product) {
      return sum + (product['price'] * product['qty']);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Order Status and actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Status:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.share, color: Color(0xFF1A73E8)),
                              onPressed: () {
                                final String orderDetails = '''
Order Details:
Order ID: #${order['id']}
Customer: ${order['name']}
Mobile: ${order['mobile']}
Date: ${order['date']}
Payment: ${order['payment']}
Delivery: ${order['delivery']}

Items:
${order['products'].map((prod) => '- ${prod['name']} (${prod['qty']} x Rs.${prod['price']})').join('\n')}

Subtotal: Rs.${subtotal.toStringAsFixed(0)}
${order['discount'] > 0 ? 'Discount (${order['couponCode']}): -Rs.${order['discount']}' : ''}
Delivery Charges: Rs.${order['deliveryCharges']}
Grand Total: Rs.${order['total']}

Address: ${order['address']}
''';
                                Share.share(orderDetails,
                                    subject: 'Order #${order['id']} Details');
                              },
                              tooltip: 'Share',
                            ),
                            IconButton(
                              icon: Icon(Icons.print, color: Color(0xFF1A73E8)),
                              onPressed: () async {
                                // Show print format selection dialog
                                final printFormat = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select Print Format'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.description,
                                                color: Color(0xFF1A73E8)),
                                            title: Text('A4 Paper'),
                                            onTap: () =>
                                                Navigator.pop(context, 'a4'),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.receipt_long,
                                                color: Color(0xFF1A73E8)),
                                            title: Text('Thermal Paper'),
                                            onTap: () => Navigator.pop(
                                                context, 'thermal'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                if (printFormat == null) return;

                                final pdf = pw.Document();

                                if (printFormat == 'a4') {
                                  // A4 format
                                  pdf.addPage(
                                    pw.Page(
                                      pageFormat: PdfPageFormat.a4,
                                      build: (pw.Context context) {
                                        return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Header(
                                              level: 0,
                                              child: pw.Text('Order Details',
                                                  style: pw.TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          pw.FontWeight.bold)),
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                pw.Text(
                                                    'Order ID: #${order['id']}',
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                                pw.Text(order['date']),
                                              ],
                                            ),
                                            pw.SizedBox(height: 10),
                                            pw.Text(
                                                'Customer: ${order['name']}'),
                                            pw.Text(
                                                'Mobile: ${order['mobile']}'),
                                            pw.Text(
                                                'Address: ${order['address']}'),
                                            pw.SizedBox(height: 10),
                                            pw.Row(
                                              children: [
                                                pw.Container(
                                                  padding:
                                                      pw.EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                  decoration: pw.BoxDecoration(
                                                    color: PdfColors.blue,
                                                    borderRadius:
                                                        pw.BorderRadius
                                                            .circular(5),
                                                  ),
                                                  child: pw.Text(
                                                    order['payment'],
                                                    style: pw.TextStyle(
                                                        color: PdfColors.white),
                                                  ),
                                                ),
                                                pw.SizedBox(width: 10),
                                                pw.Container(
                                                  padding:
                                                      pw.EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                  decoration: pw.BoxDecoration(
                                                    border: pw.Border.all(
                                                        color: PdfColors.blue),
                                                    borderRadius:
                                                        pw.BorderRadius
                                                            .circular(5),
                                                  ),
                                                  child: pw.Text(
                                                    order['delivery'],
                                                    style: pw.TextStyle(
                                                        color: PdfColors.blue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Header(
                                                level: 1,
                                                child: pw.Text('Items')),
                                            pw.Table(
                                              border: pw.TableBorder.all(
                                                  color: PdfColors.grey300),
                                              children: [
                                                pw.TableRow(
                                                  decoration: pw.BoxDecoration(
                                                      color: PdfColors.grey200),
                                                  children: [
                                                    pw.Padding(
                                                        padding:
                                                            pw.EdgeInsets.all(
                                                                5),
                                                        child: pw.Text('Item',
                                                            style: pw.TextStyle(
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold))),
                                                    pw.Padding(
                                                        padding:
                                                            pw.EdgeInsets.all(
                                                                5),
                                                        child: pw.Text('Qty',
                                                            style: pw.TextStyle(
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold))),
                                                    pw.Padding(
                                                        padding:
                                                            pw.EdgeInsets.all(
                                                                5),
                                                        child: pw.Text('Price',
                                                            style: pw.TextStyle(
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold))),
                                                    pw.Padding(
                                                        padding:
                                                            pw.EdgeInsets.all(
                                                                5),
                                                        child: pw.Text('Total',
                                                            style: pw.TextStyle(
                                                                fontWeight: pw
                                                                    .FontWeight
                                                                    .bold))),
                                                  ],
                                                ),
                                                ...order['products']
                                                    .map((prod) => pw.TableRow(
                                                          children: [
                                                            pw.Padding(
                                                                padding:
                                                                    pw.EdgeInsets
                                                                        .all(5),
                                                                child: pw.Text(
                                                                    prod[
                                                                        'name'])),
                                                            pw.Padding(
                                                                padding:
                                                                    pw.EdgeInsets
                                                                        .all(5),
                                                                child: pw.Text(
                                                                    prod['qty']
                                                                        .toString())),
                                                            pw.Padding(
                                                                padding:
                                                                    pw.EdgeInsets
                                                                        .all(5),
                                                                child: pw.Text(
                                                                    'Rs.${prod['price']}')),
                                                            pw.Padding(
                                                                padding:
                                                                    pw.EdgeInsets
                                                                        .all(5),
                                                                child: pw.Text(
                                                                    'Rs.${prod['qty'] * prod['price']}')),
                                                          ],
                                                        )),
                                              ],
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Container(
                                              padding: pw.EdgeInsets.all(10),
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                    color: PdfColors.grey300),
                                                borderRadius:
                                                    pw.BorderRadius.circular(5),
                                              ),
                                              child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.end,
                                                children: [
                                                  pw.Text(
                                                      'Subtotal: Rs.${subtotal.toStringAsFixed(0)}'),
                                                  if (order['discount'] > 0)
                                                    pw.Text(
                                                        'Discount (${order['couponCode']}): -Rs.${order['discount']}'),
                                                  pw.Text(
                                                      'Delivery Charges: Rs.${order['deliveryCharges']}'),
                                                  pw.Divider(),
                                                  pw.Text(
                                                    'Grand Total: Rs.${order['total']}',
                                                    style: pw.TextStyle(
                                                        fontWeight:
                                                            pw.FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  // Thermal paper format
                                  pdf.addPage(
                                    pw.Page(
                                      pageFormat: PdfPageFormat.roll80,
                                      build: (pw.Context context) {
                                        return pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Center(
                                              child: pw.Text(
                                                'ARROWS SALON',
                                                style: pw.TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Center(
                                              child: pw.Text(
                                                'Order Receipt',
                                                style: pw.TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            pw.SizedBox(height: 10),
                                            pw.Text(
                                                'Order ID: #${order['id']}'),
                                            pw.Text('Date: ${order['date']}'),
                                            pw.Text(
                                                'Customer: ${order['name']}'),
                                            pw.Text(
                                                'Mobile: ${order['mobile']}'),
                                            pw.Text(
                                                'Address: ${order['address']}'),
                                            pw.SizedBox(height: 5),
                                            pw.Text(
                                                'Payment: ${order['payment']}'),
                                            pw.Text(
                                                'Delivery: ${order['delivery']}'),
                                            pw.SizedBox(height: 10),
                                            pw.Divider(),
                                            pw.Text('Items:',
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold)),
                                            pw.SizedBox(height: 5),
                                            ...order['products']
                                                .map((prod) => pw.Column(
                                                      crossAxisAlignment: pw
                                                          .CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        pw.Text(prod['name']),
                                                        pw.Row(
                                                          mainAxisAlignment: pw
                                                              .MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            pw.Text(
                                                                '${prod['qty']} x Rs.${prod['price']}'),
                                                            pw.Text(
                                                                'Rs.${prod['qty'] * prod['price']}'),
                                                          ],
                                                        ),
                                                        pw.SizedBox(height: 5),
                                                      ],
                                                    )),
                                            pw.Divider(),
                                            pw.SizedBox(height: 5),
                                            pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                pw.Text('Subtotal:'),
                                                pw.Text(
                                                    'Rs.${subtotal.toStringAsFixed(0)}'),
                                              ],
                                            ),
                                            if (order['discount'] > 0)
                                              pw.Row(
                                                mainAxisAlignment: pw
                                                    .MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  pw.Text(
                                                      'Discount (${order['couponCode']}):'),
                                                  pw.Text(
                                                      '-Rs.${order['discount']}'),
                                                ],
                                              ),
                                            pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                pw.Text('Delivery:'),
                                                pw.Text(
                                                    'Rs.${order['deliveryCharges']}'),
                                              ],
                                            ),
                                            pw.Divider(),
                                            pw.Row(
                                              mainAxisAlignment: pw
                                                  .MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                pw.Text('Total:',
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                                pw.Text('Rs.${order['total']}',
                                                    style: pw.TextStyle(
                                                        fontWeight: pw
                                                            .FontWeight.bold)),
                                              ],
                                            ),
                                            pw.SizedBox(height: 20),
                                            pw.Center(
                                              child: pw.Text(
                                                'Thank you for your order!',
                                                style: pw.TextStyle(
                                                    fontWeight:
                                                        pw.FontWeight.bold),
                                              ),
                                            ),
                                            pw.SizedBox(height: 5),
                                            pw.Center(
                                              child: pw.Text(
                                                'Please visit again',
                                                style:
                                                    pw.TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }

                                await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async =>
                                      pdf.save(),
                                  name: 'Order_${order['id']}.pdf',
                                );
                              },
                              tooltip: 'Print',
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order ID #${order['id']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(order['date'],
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(order['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Address: ${order['address']}',
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 14)),
                    Row(
                      children: [
                        Text('Mob No. ${order['mobile']}',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 14)),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final String message =
                                'Hello, I have received your order #${order['id']}.';
                            final String url =
                                'https://wa.me/${order['mobile']}?text=${Uri.encodeComponent(message)}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Could not launch WhatsApp')),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: FaIcon(FontAwesomeIcons.whatsapp,
                                color: Colors.green[700], size: 18),
                          ),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () async {
                            final Uri callUrl =
                                Uri.parse('tel:${order['mobile']}');
                            try {
                              if (await canLaunchUrl(callUrl)) {
                                await launchUrl(callUrl,
                                    mode: LaunchMode
                                        .externalNonBrowserApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Could not launch phone call')),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Could not launch phone call')),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.blue[700],
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        _buildPaymentChip(order['payment']),
                        SizedBox(width: 8),
                        _buildDeliveryChip(order['delivery']),
                      ],
                    ),
                    SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F8FE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order['products'].map<Widget>((prod) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        _buildProductImage(prod['name']),
                                        SizedBox(width: 8),
                                        Text(prod['name'],
                                            style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                    Text('${prod['qty']} x Rs.${prod['price']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F8FE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildPriceRow('Total Items', '${order['items']}'),
                          _buildPriceRow(
                              'Subtotal', 'Rs.${subtotal.toStringAsFixed(0)}'),
                          if (order['discount'] > 0)
                            _buildPriceRow('Discount (${order['couponCode']})',
                                '-Rs.${order['discount']}'),
                          _buildPriceRow('Delivery Charges',
                              'Rs.${order['deliveryCharges']}'),
                          Divider(),
                          _buildPriceRow('Grand Total', 'Rs.${order['total']}',
                              isBold: true),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Order Actions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle_outline,
                                          color: Colors.green[700],
                                          size: 24,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Accept',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            Colors.amber[700]!.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.swap_horiz_outlined,
                                          color: Colors.amber[700],
                                          size: 24,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Suggest',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.amber[700],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFEBEE),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red[700],
                                          size: 24,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Reject',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper to get product image by name
  Widget _buildProductImage(String productName) {
    // Map product names to image asset paths (add more as needed)
    final Map<String, String> productImages = {
      'Sunsilk Shampoo': 'assets/images/sunsilk.jpg',
      'Loreal Conditioner': 'assets/images/l_cond.jpg',
      'Mamaearth Onion shampoo': 'assets/images/sunsilk.jpg', // fallback
      'Mamaearth Ubtan Facewash': 'assets/images/l_cond.jpg', // fallback
      // Add more mappings as needed
    };
    final String? asset = productImages[productName];
    if (asset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          asset,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child:
            Icon(Icons.image_not_supported, color: Colors.grey[400], size: 20),
      );
    }
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
