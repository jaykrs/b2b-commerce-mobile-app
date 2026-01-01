import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/core/models/userModel.dart';
import 'package:http/http.dart' as http;

import '../../../core/components/product_tile_square.dart';
import '../../../core/constants/constants.dart';
//import '../../../core/models/product_model.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({super.key});

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.14:3000/api/products'),
      );

      if (response.statusCode == 200) {
        //final List<dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       
        final List<dynamic> data = jsonResponse['data'];   
        setState(() {
          products = data.map((e) => Product.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(child: Text('No products found'))
              : GridView.builder(
                  padding: const EdgeInsets.only(top: AppDefaults.padding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductTileSquare(
                      data: products[index],
                    );
                  },
                ),
    );
  }
}

// import 'package:flutter/material.dart';

// import '../../../core/components/product_tile_square.dart';
// import '../../../core/constants/constants.dart';

// class ProductGridView extends StatelessWidget {
//   const ProductGridView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GridView.builder(
//         padding: const EdgeInsets.only(top: AppDefaults.padding),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           childAspectRatio: 0.85,
//         ),
//         itemCount: 16,
//         itemBuilder: (context, index) {
//           return ProductTileSquare(data: Dummy.products.first);
//         },
//       ),
//     );
//   }
// }
