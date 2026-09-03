import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/product_tile_square.dart';
import '../../core/constants/constants.dart';
//import '../../core/models/product_model.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Product> products = [];
  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchSearchResults(query);
    });
  }

  Future<void> fetchSearchResults(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        products = [];
        isLoading = false;
      });
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.18.14:3000/api/products/search?q=$query',
        ),
      );

      if (response.statusCode == 200) {
        //final List<dynamic> data = jsonDecode(response.body);
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
        debugPrint('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: const AppBackButton(),
      ),
      body: Column(
        children: [
          /// Search Field
          Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: TextField(
              controller: _controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search Field',
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(AppDefaults.padding),
                  child: SvgPicture.asset(AppIcons.search),
                ),
                suffixIconConstraints: const BoxConstraints(),
              ),
            ),
          ),

          /// Result Count
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              child: Text(
                '${products.length} Products Found',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black),
              ),
            ),
          ),

          /// Results Grid
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                        padding:
                            const EdgeInsets.only(top: AppDefaults.padding),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        scrollCacheExtent: const ScrollCacheExtent.pixels(900),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return ProductTileSquare(
                            data: products[index],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../core/components/app_back_button.dart';
// import '../../core/components/product_tile_square.dart';
// import '../../core/constants/constants.dart';

// class SearchResultPage extends StatelessWidget {
//   const SearchResultPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Results'),
//         leading: const AppBackButton(),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(AppDefaults.padding),
//             child: TextField(
//               decoration: InputDecoration(
//                 labelText: 'Search Field',
//                 suffixIcon: Padding(
//                   padding: const EdgeInsets.all(AppDefaults.padding),
//                   child: SvgPicture.asset(AppIcons.search),
//                 ),
//                 suffixIconConstraints: const BoxConstraints(),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//               child: Text(
//                 '33 Products Found',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyLarge
//                     ?.copyWith(color: Colors.black),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.only(top: AppDefaults.padding),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.85,
//               ),
//               itemCount: 16,
//               itemBuilder: (context, index) {
//                 return ProductTileSquare(
//                   data: Dummy.products.first,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
