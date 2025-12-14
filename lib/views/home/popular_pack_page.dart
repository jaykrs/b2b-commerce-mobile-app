import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/core/constants/get_bundels.dart';
import 'package:http/http.dart' as http;

import '../../core/components/app_back_button.dart';
import '../../core/components/bundle_tile_square.dart';
import '../../core/constants/constants.dart';
import '../../core/models/dummy_bundle_model.dart'; // your BundleModel
import '../../core/routes/app_routes.dart';

class PopularPackPage extends StatefulWidget {
  const PopularPackPage({super.key});

  @override
  State<PopularPackPage> createState() => _PopularPackPageState();
}

class _PopularPackPageState extends State<PopularPackPage> {
  List<BundleModel> bundles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBundles();
  }

  Future<void> loadBundles() async {
    final data = await getBundles();
    setState(() {
      bundles = data;
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      padding: const EdgeInsets.only(top: AppDefaults.padding),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 0.73,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: bundles.length,
                      itemBuilder: (context, index) {
                        return BundleTileSquare(
                          data: bundles[index],
                        );
                      },
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(AppDefaults.padding * 2),
                decoration: const BoxDecoration(
                  color: Colors.white60,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.createMyPack);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.shoppingBag),
                      const SizedBox(width: AppDefaults.padding),
                      const Text('Create Own Pack'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../core/components/app_back_button.dart';
// import '../../core/components/bundle_tile_square.dart';
// import '../../core/constants/constants.dart';
// import '../../core/routes/app_routes.dart';

// class PopularPackPage extends StatelessWidget {
//   const PopularPackPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Popular Packs'),
//         leading: const AppBackButton(),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//               child: GridView.builder(
//                 padding: const EdgeInsets.only(top: AppDefaults.padding),
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent: 200,
//                   childAspectRatio: 0.73,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                 ),
//                 itemCount: 8,
//                 itemBuilder: (context, index) {
//                   return BundleTileSquare(
//                     data: Dummy.bundles.first,
//                   );
//                 },
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               left: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(AppDefaults.padding * 2),
//                 decoration: const BoxDecoration(
//                   color: Colors.white60,
//                 ),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, AppRoutes.createMyPack);
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SvgPicture.asset(AppIcons.shoppingBag),
//                       const SizedBox(width: AppDefaults.padding),
//                       const Text('Create Own Pack'),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
