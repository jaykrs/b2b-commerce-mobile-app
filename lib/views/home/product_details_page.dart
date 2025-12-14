import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/buy_now_row_button.dart';
import '../../core/components/price_and_quantity.dart';
import '../../core/components/product_images_slider.dart';
import '../../core/components/review_row_button.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/api_config.dart';
import '../../core/models/dummy_bundle_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId; // receive productId

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  BundleModel? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.products}?productId=${widget.productId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          product = BundleModel.fromJson(jsonResponse['data']);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  onCartButtonTap: () {},
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
                        images: [
                          'https://i.imgur.com/3o6ons9.png',
                          'https://i.imgur.com/3o6ons9.png',
                          'https://i.imgur.com/3o6ons9.png',
                        ],
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
                          quantity: 1, // default quantity
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
                            ReviewRowButton(totalStars:  0),
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

// import 'package:flutter/material.dart';

// import '../../core/components/app_back_button.dart';
// import '../../core/components/buy_now_row_button.dart';
// import '../../core/components/price_and_quantity.dart';
// import '../../core/components/product_images_slider.dart';
// import '../../core/components/review_row_button.dart';
// import '../../core/constants/app_defaults.dart';

// class ProductDetailsPage extends StatelessWidget {
//   const ProductDetailsPage({super.key, required int productId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         leading: const AppBackButton(),
//         title: const Text('Product Details'),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//           child: BuyNowRow(
//             onBuyButtonTap: () {},
//             onCartButtonTap: () {},
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const ProductImagesSlider(
//               images: [
//                 'https://i.imgur.com/3o6ons9.png',
//                 'https://i.imgur.com/3o6ons9.png',
//                 'https://i.imgur.com/3o6ons9.png',
//               ],
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.all(AppDefaults.padding),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Cauliflower Bangladeshi',
//                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text('Weight: 5Kg'),
//                   ],
//                 ),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//               child: PriceAndQuantityRow(
//                 currentPrice: 20,
//                 orginalPrice: 30,
//                 quantity: 2,
//               ),
//             ),
//             const SizedBox(height: 8),

//             /// Product Details
//             Padding(
//               padding: const EdgeInsets.all(AppDefaults.padding),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Product Details',
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Duis aute veniam veniam qui aliquip irure duis sint magna occaecat dolore nisi culpa do. Est nisi incididunt aliquip  commodo aliqua tempor.',
//                   ),
//                 ],
//               ),
//             ),

//             /// Review Row
//             const Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppDefaults.padding,
//                 // vertical: AppDefaults.padding,
//               ),
//               child: Column(
//                 children: [
//                   Divider(thickness: 0.1),
//                   ReviewRowButton(totalStars: 5),
//                   Divider(thickness: 0.1),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
