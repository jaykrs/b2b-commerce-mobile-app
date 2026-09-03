import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
import '../utils/product_image_url.dart';
import 'network_image.dart';

class BundleTileSquare extends StatefulWidget {
  const BundleTileSquare({
    super.key,
    required this.data,
  });

  final Product data;

  @override
  State<BundleTileSquare> createState() => _BundleTileSquareState();
}

class _BundleTileSquareState extends State<BundleTileSquare> {
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    loadQuantity();
  }

  /// ✅ Load initial quantity
  void loadQuantity() async {
    final qty = await CartStorage.getItemQty(widget.data.id.toString());

    if (!mounted) return;
    setState(() {
      quantity = qty;
    });
  }

  /// ✅ Update quantity
  void onQuantityChanged(int newQty) async {
    final productId = widget.data.id.toString();
    final normalizedQty = newQty.clamp(0, widget.data.stock).toInt();
    final isInCart = await CartStorage.isInCart(productId);

    if (normalizedQty <= 0) {
      if (isInCart) await CartStorage.removeFromCart(productId);
    } else if (isInCart) {
      await CartStorage.updateCartQty(productId, normalizedQty);
    } else {
      await CartStorage.addToCart(productId, normalizedQty);
    }

    if (!mounted) return;
    setState(() {
      quantity = normalizedQty;
    });
  }

  /// ✅ Remove item
  void removeItem() async {
    if (await CartStorage.isInCart(widget.data.id.toString())) {
      await CartStorage.removeFromCart(widget.data.id.toString());
    }

    if (!mounted) return;
    setState(() {
      quantity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = buildProductImageUrls(
      widget.data.productImage,
      version: widget.data.updatedAt,
    );
    final imageUrl = imageUrls.isEmpty ? '' : imageUrls.first;

    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bundleProduct,
            arguments: {
              'productId': widget.data.id,
            },
          );
        },
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.42,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.1,
              color: AppColors.placeholder,
            ),
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: imageUrl.isNotEmpty
                      ? NetworkImageWithLoader(
                          imageUrl,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.image_not_supported),
                ),
              ),

              const SizedBox(height: 8),

              /// Name
              Text(
                widget.data.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
              ),

              const SizedBox(height: 8),

              /// Price
              Row(
                children: [
                  Text(
                    '₹${widget.data.price.toStringAsFixed(0)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 4),
                  if (widget.data.mrp != null &&
                      widget.data.mrp! > widget.data.price)
                    Text(
                      '₹${widget.data.mrp!.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.black45,
                          ),
                    ),
                ],
              ),
              if (widget.data.mrp != null &&
                  widget.data.mrp! > widget.data.price)
                Text(
                  '${(((widget.data.mrp! - widget.data.price) / widget.data.mrp!) * 100).round()}% OFF',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF1B7F4B),
                        fontWeight: FontWeight.w800,
                      ),
                ),

              const SizedBox(height: 8),

              /// Quantity Controls
              Row(
                children: [
                  IconButton(
                    onPressed: quantity >= widget.data.stock
                        ? null
                        : () {
                            onQuantityChanged(quantity + 1);
                          },
                    icon: SvgPicture.asset(
                      AppIcons.addQuantity,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '$quantity',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) {
                        onQuantityChanged(quantity - 1);
                      } else {
                        removeItem();
                      }
                    },
                    icon: SvgPicture.asset(AppIcons.removeQuantity,
                        width: 24, height: 24),
                  ),
                ],
              ),
              const SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
