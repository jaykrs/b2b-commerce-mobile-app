import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiCall.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../../../core/components/product_tile_square.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';

class OurNewItem extends StatefulWidget {
  const OurNewItem({super.key});

  @override
  State<OurNewItem> createState() => _OurNewItemState();
}

class _OurNewItemState extends State<OurNewItem> {
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBundles();
  }

  Future<void> loadBundles() async {
    final data = await getProducts();
    setState(() {
      products = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndActionButton(
          title: 'Top Products',
          onTap: () => Navigator.pushNamed(context, AppRoutes.newItems),
        ),
        SizedBox(height: 8),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No products found'),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: AppDefaults.padding),
                    child: Row(
                      children: products.map((bundle) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(right: AppDefaults.padding),
                          child: ProductTileSquare(data: bundle),
                        );
                      }).toList(),
                    ),
                  ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// import '../../../core/components/product_tile_square.dart';
// import '../../../core/components/title_and_action_button.dart';
// import '../../../core/constants/constants.dart';
// import '../../../core/routes/app_routes.dart';

// class OurNewItem extends StatelessWidget {
//   const OurNewItem({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TitleAndActionButton(
//           title: 'Top Products',
//           onTap: () => Navigator.pushNamed(context, AppRoutes.newItems),
//         ),
//         SingleChildScrollView(
//           padding: const EdgeInsets.only(left: AppDefaults.padding),
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//               Dummy.products.length,
//               (index) => ProductTileSquare(data: Dummy.products[index]),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
