import 'package:EazySupplies/core/constants/apiClients.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/api_config.dart';
import 'package:EazySupplies/core/models/userModel.dart';

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
      final response = await ApiClient.dio.get(ApiConfig.products,
          queryParameters: {'status': 1, 'category_ids': widget.categoryId, 'paginate': 100});

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];

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
                    padding: const EdgeInsets.symmetric(vertical: AppDefaults.padding),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      return ProductTileSquare(data: products[index]);
                    },
                  )),
    );
  }
}
