import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/product_tile_square.dart';
import '../../core/constants/constants.dart';
//import '../../core/models/product_model.dart';

class NewItemsPage extends StatefulWidget {
  const NewItemsPage({super.key});

  @override
  State<NewItemsPage> createState() => _NewItemsPageState();
}

class _NewItemsPageState extends State<NewItemsPage> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewItems();
  }

  Future<void> fetchNewItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.14:3000/api/products/new'),
      );

      if (response.statusCode == 200) {
       // final List<dynamic> data = jsonDecode(response.body);
       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
       
        final List<dynamic> data = jsonResponse['data'];   
        setState(() {
          products = data
              .map((e) => Product.fromJson(e))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint('Failed to load new items: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching new items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Item'),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? const Center(child: Text('No new items found'))
                  : GridView.builder(
                      padding:
                          const EdgeInsets.only(top: AppDefaults.padding),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 0.64,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductTileSquare(
                          data: products[index],
                        );
                      },
                    ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import '../../core/components/app_back_button.dart';
// import '../../core/components/product_tile_square.dart';
// import '../../core/constants/constants.dart';

// class NewItemsPage extends StatelessWidget {
//   const NewItemsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('New Item'),
//         leading: const AppBackButton(),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//           child: GridView.builder(
//             padding: const EdgeInsets.only(top: AppDefaults.padding),
//             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 200,
//               childAspectRatio: 0.64,
//               mainAxisSpacing: 16,
//             ),
//             itemCount: 8,
//             itemBuilder: (context, index) {
//               return ProductTileSquare(
//                 data: Dummy.products.first,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
