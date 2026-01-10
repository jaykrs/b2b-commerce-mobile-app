import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/product_tile_square.dart';
import '../../core/constants/constants.dart';

class BrandProductPage extends StatefulWidget {
  final int brandId;
  final String brandName;

  const BrandProductPage({
    super.key,
    required this.brandId,
    required this.brandName,
  });

  @override
  State<BrandProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<BrandProductPage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.products}?brandId=${widget.brandId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        setState(() {
          products = data.map((e) => Product.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint('Failed to load brand products: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching brand products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName),
        leading: const AppBackButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('No products found'))
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.65, // adjust lower to reduce overflow
                    ),
                    itemBuilder: (context, index) {
                      return ProductTileSquare(data: products[index]);
                    },
                  )),
    );
  }
}
