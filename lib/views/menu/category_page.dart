import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/core/constants/api_config.dart';
import 'package:grocery/core/models/userModel.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/product_tile_square.dart';
import '../../core/constants/constants.dart';

class CategoryProductPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
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
        Uri.parse('${ApiConfig.products}?categoryId=${widget.categoryId}'),
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
        debugPrint('Failed to load category products: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching category products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
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
