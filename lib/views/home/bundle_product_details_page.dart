import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../../core/components/app_back_button.dart';
import '../../core/components/buy_now_row_button.dart';
import '../../core/components/price_and_quantity.dart';
import '../../core/components/product_images_slider.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/product_image_url.dart';
import 'components/bundle_meta_data.dart';
import 'components/bundle_pack_details.dart';

class BundleProductDetailsPage extends StatefulWidget {
  final int productId;

  const BundleProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  State<BundleProductDetailsPage> createState() =>
      _BundleProductDetailsPageState();
}

class _BundleProductDetailsPageState extends State<BundleProductDetailsPage> {
  Product? product;
  bool isLoading = true;
  int quantity = 1;
  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    _loadCartQuantity();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await ApiClient.dio.get(ApiConfig.products,
          queryParameters: {"productId": widget.productId});

      if (response.statusCode == 200) {
        final data = response.data['data'];
        setState(() {
          product = Product.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching product: $e');
      setState(() => isLoading = false);
    }
  }

  void onQuantityChanged(int newQuantity) {
    setState(() {
      quantity = newQuantity; // update parent
    });
  }

  Future<void> _loadCartQuantity() async {
    final id = widget.productId.toString();
    final existingQty = await CartStorage.getItemQty(id);

    if (existingQty > 0) {
      setState(() {
        quantity = existingQty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = buildProductImageUrls(
      product?.productImage,
      version: product?.updatedAt,
    );
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(product?.name ?? 'Product Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
              ? const Center(child: Text('Product not found'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ProductImagesSlider(
                        images: imageUrls,
                      ),

                      /// Product Data
                      Padding(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                product!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            // PriceAndQuantityRow(
                            //   currentPrice: product!.price,
                            //   orginalPrice: product!.mrp ?? product!.price,
                            //   quantity: 1,
                            // ),
                            PriceAndQuantityRow(
                              currentPrice: product!.price,
                              orginalPrice: product!.mrp ?? product!.price,
                              quantity: quantity,
                              onQuantityIncrease: () =>
                                  onQuantityChanged(quantity + 1),
                              onQuantityDecrease: () {
                                if (quantity > 1) {
                                  onQuantityChanged(quantity - 1);
                                }
                              },
                            ),
                            const SizedBox(height: AppDefaults.padding / 2),
                            BundleMetaData(
                              category: product!.category.name,
                              brand: product!.brand.name,
                              stock: product!.stock,
                            ),
                            PackDetails(
                              description: product?.description ?? '',
                            ),
                            // const ReviewRowButton(totalStars: 5),
                            const Divider(thickness: 0.1),
                            BuyNowRow(
                              onBuyButtonTap: () {
                                debugPrint('Buy Now: ${product!.id}');
                              },
                              // onCartButtonTap: () {
                              //   debugPrint('Add to cart: ${product!.id}');
                              // },
                              onCartButtonTap: () async {
                                final id = product?.id.toString();
                                if (id == null) return;

                                final isInCart = await CartStorage.isInCart(id);

                                if (!isInCart) {
                                  // Add item with current quantity from parent state
                                  await CartStorage.addToCart(id, quantity);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Item added to cart'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // Update quantity in cart to match current quantity in UI
                                  await CartStorage.updateCartQty(id, quantity);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Item quantity updated in cart'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
