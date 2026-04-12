import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
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
  static const String baseUrl = Config.ImagebaseUrl;

  int quantity = 0;

  @override
  void initState() {
    super.initState();
    loadQuantity();
  }

  /// ✅ Load initial quantity
  void loadQuantity() async {
    final qty = await CartStorage.getItemQty(widget.data.id.toString());

    setState(() {
      quantity = qty;
    });
  }

  /// ✅ Update quantity
  void onQuantityChanged(int newQty) async {
    if (await CartStorage.isInCart(widget.data.id.toString())) {
      await CartStorage.updateCartQty(widget.data.id.toString(), newQty);
    } else if (await CartStorage.isNotInCart(widget.data.id.toString()) &&
        newQty > 0) {
      await CartStorage.addToCart(widget.data.id.toString(), newQty);
    } else if (await CartStorage.isInCart(widget.data.id.toString()) &&
        newQty == 0) {
      await CartStorage.removeFromCart(widget.data.id.toString());
    }

    setState(() {
      quantity = newQty;
    });
  }

  /// ✅ Remove item
  void removeItem() async {
    if (await CartStorage.isInCart(widget.data.id.toString())) {
      await CartStorage.removeFromCart(widget.data.id.toString());
    }

    setState(() {
      quantity = 0;
    });
  }

  /// ✅ Extract first image
  String getFirstImageUrl(String? images) {
    if (images == null || images.isEmpty) return '';

    final list = images
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (list.isEmpty) return '';

    return baseUrl + list.first;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = getFirstImageUrl(widget.data.productImage);

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
                maxLines: 1,
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
                  Text(
                    '₹${widget.data.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Quantity Controls
              Row(
                children: [
                  IconButton(
                    onPressed: () {
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
