import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../../core/components/app_back_button.dart';
import '../../core/components/buy_now_row_button.dart';
import '../../core/components/price_and_quantity.dart';
import '../../core/components/product_images_slider.dart';
import '../../core/components/review_row_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/api_config.dart';
import '../../core/utils/product_image_url.dart';
import 'components/bundle_meta_data.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId; // receive productId

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
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
      final response = await ApiClient.dio.get(
        ApiConfig.products,
        queryParameters: {
          "productId": widget.productId,
        },
      );

      if (!mounted) return;
      setState(() {
        product = Product.fromJson(
          Map<String, dynamic>.from(response.data['data']),
        );
        isLoading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint('Dio error: ${e.message}');
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      debugPrint('Unexpected error: $e');
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

    if (mounted && existingQty > 0) {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Product Details'),
      ),
      bottomNavigationBar: product == null
          ? null
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: BuyNowRow(
                  onBuyButtonTap: () {},
                  //onCartButtonTap: () {},
                  onCartButtonTap: () async {
                    final id = product?.id.toString();
                    if (id == null) return;
                    final wasInCart = await CartStorage.isInCart(id);
                    if (wasInCart) {
                      await CartStorage.updateCartQty(id, quantity);
                    } else {
                      await CartStorage.addToCart(id, quantity);
                    }
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(wasInCart
                            ? 'Cart quantity updated to $quantity'
                            : '$quantity item(s) added to cart'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
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
                      //   product!.productImage ??
                      //       [product!.productImage ?? ""],
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(AppDefaults.padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  'Weight: ${product!.pkgGwt ?? product!.dimension ?? "-"}'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding),
                        child: PriceAndQuantityRow(
                          currentPrice: product!.price,
                          orginalPrice: product!.mrp ?? product!.price,
                          quantity: quantity,
                          onQuantityIncrease: () =>
                              onQuantityChanged(quantity + 1),
                          onQuantityDecrease: () {
                            if (quantity > 1) onQuantityChanged(quantity - 1);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDefaults.padding,
                        ),
                        child: BundleMetaData(
                          category: product!.category.name,
                          brand: product!.brand.name,
                          brandImage: product!.brand.image,
                          stock: product!.stock,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Html(
                              data: product!.description ??
                                  "No description available.",
                              style: {
                                "body": Style(
                                  fontSize:
                                      FontSize(Responsive.sp(context, 14)),
                                ),
                              },
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding),
                        child: Column(
                          children: [
                            Divider(thickness: 0.1),
                            ReviewRowButton(totalStars: 0),
                            Divider(thickness: 0.1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
