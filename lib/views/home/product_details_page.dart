import 'dart:convert';
import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/cartStorage.dart';
import 'package:EazySupplies/core/constants/localStorageService.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../../core/components/app_back_button.dart';
import '../../core/components/buy_now_row_button.dart';
import '../../core/components/price_and_quantity.dart';
import '../../core/components/product_images_slider.dart';
import '../../core/components/review_row_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/api_config.dart';

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

      setState(() {
        product = Product.fromJson(response.data['data']);
        isLoading = false;
      });
    } on DioException catch (e) {
      setState(() => isLoading = false);
      debugPrint('Dio error: ${e.message}');
    } catch (e) {
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

    if (existingQty > 0) {
      setState(() {
        quantity = existingQty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = product?.productImage
            ?.split(',') // split by comma
            .map((e) => e.trim()) // remove spaces
            .where((e) => e.isNotEmpty) // ignore empty strings
            .toList() ??
        [];

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
                    final id = product?.id?.toString();
                    if (id == null) return;

                    final isInCart = await CartStorage.isInCart(id);

                    if (!isInCart) {
                      // Add item with qty = 1
                      await CartStorage.addToCart(id, 1);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item added to cart'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      // Increase qty if already in cart
                      await CartStorage.increaseQty(id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item quantity updated'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
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
                            Text(product!.description ??
                                "No description available."),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding),
                        child: Column(
                          children: [
                            const Divider(thickness: 0.1),
                            ReviewRowButton(totalStars: 0),
                            const Divider(thickness: 0.1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
