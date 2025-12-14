import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery/core/constants/get_bundels.dart';
import 'package:grocery/core/models/dummy_bundle_model.dart';
import 'package:http/http.dart' as http;

import '../../../core/components/bundle_tile_square.dart';
import '../../../core/components/title_and_action_button.dart';
import '../../../core/constants/constants.dart';
import '../../../core/routes/app_routes.dart';

class PopularPacks extends StatefulWidget {
  const PopularPacks({super.key});

  @override
  State<PopularPacks> createState() => _PopularPacksState();
}

class _PopularPacksState extends State<PopularPacks> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and action button
        TitleAndActionButton(
          title: 'Popular Products',
          onTap: () => Navigator.pushNamed(context, AppRoutes.popularItems),
        ),

        const SizedBox(height: 8),

        // Show loader, empty state, or horizontal list
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : bundles.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No popular packs found'),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: AppDefaults.padding),
                    child: Row(
                      children: bundles.map((bundle) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(right: AppDefaults.padding),
                          child: BundleTileSquare(data: bundle),
                        );
                      }).toList(),
                    ),
                  ),
      ],
    );
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:grocery/core/models/dummy_bundle_model.dart';
// import 'package:http/http.dart' as http;

// import '../../../core/components/bundle_tile_square.dart';
// import '../../../core/components/title_and_action_button.dart';
// import '../../../core/constants/constants.dart';
// import '../../../core/routes/app_routes.dart';

// class PopularPacks extends StatefulWidget {
//   const PopularPacks({super.key});

//   @override
//   State<PopularPacks> createState() => _PopularPacksState();
// }

// class _PopularPacksState extends State<PopularPacks> {
//   List<BundleModel > bundles = []; // Replace Bundle with your model class
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBundles();
//   }

//   // Fetch data from API
//   Future<void> fetchBundles() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://192.168.18.14:3000/api/products'));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);

//         setState(() {
//           bundles = data
//               .map((e) => BundleModel .fromJson(e))
//               .toList(); // Implement fromJson in your model
//           isLoading = false;
//         });
//       } else {
//         // Handle error
//         setState(() => isLoading = false);
//         debugPrint('Failed to load bundles: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       debugPrint('Error fetching bundles: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title and action button
//         TitleAndActionButton(
//           title: 'Popular Packs',
//           onTap: () => Navigator.pushNamed(context, AppRoutes.popularItems),
//         ),

//         const SizedBox(height: 8),

//         // Show loader or horizontal list
//         isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.only(left: AppDefaults.padding),
//                 child: Row(
//                   children: bundles.map((bundle) {
//                     return Padding(
//                       padding:
//                           const EdgeInsets.only(right: AppDefaults.padding),
//                       child: BundleTileSquare(data: bundle),
//                     );
//                   }).toList(),
//                 ),
//               ),
//       ],
//     );
//   }
// }
