import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final int? quantity;
  final Function(int)? onUpdateQuantity;
  final Function()? onToggleFavorite;
  final bool showQuantityControls;
  final bool showFavoriteButton;
  final bool isFavorite;

  const ProductCard({
    Key? key,
    required this.product,
    this.quantity,
    this.onUpdateQuantity,
    this.onToggleFavorite,
    this.showQuantityControls = true,
    this.showFavoriteButton = true,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late TextEditingController quantityController;
  late FocusNode quantityFocus;
  String? errorText;

  @override
  void initState() {
    super.initState();
    quantityController =
        TextEditingController(text: widget.quantity?.toString() ?? '0');
    quantityFocus = FocusNode();
  }

  @override
  void dispose() {
    quantityController.dispose();
    quantityFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.product['image'],
                    fit: BoxFit.cover,
                  ),
                  if (widget.product['banner'] != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Color(0xFF1A73E8).withOpacity(0.8),
                        ),
                        child: Text(
                          widget.product['banner'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  if (widget.showFavoriteButton)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.onToggleFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isFavorite
                                ? Colors.pink
                                : Color(0xFF1A73E8),
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Name and Rating Row
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            '${widget.product['rating']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Price and Add to Cart Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                '₹${widget.product['originalPrice'].toStringAsFixed(0)}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                '₹${widget.product['price'].toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Color(0xFF1A73E8),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (widget.showQuantityControls) _buildQuantityControls(),
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

  Widget _buildQuantityControls() {
    final quantity = widget.quantity ?? 0;

    if (quantity == 0) {
      return GestureDetector(
        onTap: () {
          if (widget.onUpdateQuantity != null) {
            widget.onUpdateQuantity!(1);
            quantityController.text = '1';
          }
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xFF1A73E8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          ),
        ),
      );
    }

    return Container(
      height: 28,
      constraints: BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
        color: Color(0xFF1A73E8),
        borderRadius: BorderRadius.circular(6),
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
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.remove, color: Colors.white, size: 16),
              onPressed: () {
                if (widget.onUpdateQuantity != null) {
                  if (quantity > 1) {
                    widget.onUpdateQuantity!(quantity - 1);
                    quantityController.text = (quantity - 1).toString();
                    errorText = null;
                  } else {
                    widget.onUpdateQuantity!(0);
                    quantityController.text = '0';
                  }
                }
              },
            ),
          ),
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            child: Center(
              child: TextField(
                controller: quantityController,
                focusNode: quantityFocus,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
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
                  final newQuantity = int.tryParse(value) ?? 0;
                  if (widget.onUpdateQuantity != null) {
                    if (newQuantity > 0 && newQuantity <= 99) {
                      widget.onUpdateQuantity!(newQuantity);
                      errorText = null;
                    } else if (newQuantity > 99) {
                      errorText = 'Max 99';
                      quantityController.text = quantity.toString();
                    } else {
                      widget.onUpdateQuantity!(0);
                      quantityController.text = '0';
                    }
                  }
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
          ),
          SizedBox(
            width: 24,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.add, color: Colors.white, size: 16),
              onPressed: () {
                if (widget.onUpdateQuantity != null) {
                  if (quantity < 99) {
                    widget.onUpdateQuantity!(quantity + 1);
                    quantityController.text = (quantity + 1).toString();
                    errorText = null;
                  } else {
                    errorText = 'Max 99';
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
