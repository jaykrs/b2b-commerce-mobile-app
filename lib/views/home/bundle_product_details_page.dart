import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/core/constants/api_config.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/buy_now_row_button.dart';
import '../../core/components/price_and_quantity.dart';
import '../../core/components/product_images_slider.dart';
import '../../core/components/review_row_button.dart';
import '../../core/constants/constants.dart';
import '../../core/models/dummy_bundle_model.dart';
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
  BundleModel? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.products}?productId=${widget.productId}',
            ),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];
        setState(() {
          product = BundleModel.fromJson(data);
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

  @override
  Widget build(BuildContext context) {
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
                        images: [
                          product!.productImage ??
                              'https://i.imgur.com/NOuZzbe.png',
                        ],
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
                            PriceAndQuantityRow(
                              currentPrice: product!.price,
                              orginalPrice: product!.mrp ?? product!.price,
                              quantity: 1,
                            ),
                            const SizedBox(height: AppDefaults.padding / 2),
                            BundleMetaData(
                              category: product!.category.name,
                              brand: product!.brand.name,
                              stock: product!.stock,
                            ),
                            PackDetails(
                              description: product!.description,
                            ),
                            const ReviewRowButton(totalStars: 5),
                            const Divider(thickness: 0.1),
                            BuyNowRow(
                              onBuyButtonTap: () {
                                debugPrint('Buy Now: ${product!.id}');
                              },
                              onCartButtonTap: () {
                                debugPrint('Add to cart: ${product!.id}');
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

// import 'package:flutter/material.dart';

// import '../../core/components/app_back_button.dart';
// import '../../core/components/buy_now_row_button.dart';
// import '../../core/components/price_and_quantity.dart';
// import '../../core/components/product_images_slider.dart';
// import '../../core/components/review_row_button.dart';
// import '../../core/constants/constants.dart';
// import 'components/bundle_meta_data.dart';
// import 'components/bundle_pack_details.dart';

// class BundleProductDetailsPage extends StatelessWidget {
//   const BundleProductDetailsPage({super.key, required int productId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const AppBackButton(),
//         title: const Text('Product Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const ProductImagesSlider(
//               images: [
//                 'https://i.imgur.com/NOuZzbe.png',
//                 'https://i.imgur.com/NOuZzbe.png',
//                 'https://i.imgur.com/NOuZzbe.png',
//               ],
//             ),
//             /* <---- Product Data -----> */
//             Padding(
//               padding: const EdgeInsets.all(AppDefaults.padding),
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Bundle Pack',
//                       style:
//                           Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                     ),
//                   ),
//                   const PriceAndQuantityRow(
//                     currentPrice: 20,
//                     orginalPrice: 30,
//                     quantity: 2,
//                   ),
//                   const SizedBox(height: AppDefaults.padding / 2),
//                   const BundleMetaData(),
//                   const PackDetails(),
//                   const ReviewRowButton(totalStars: 5),
//                   const Divider(thickness: 0.1),
//                   BuyNowRow(
//                     onBuyButtonTap: () {},
//                     onCartButtonTap: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
