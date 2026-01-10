import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:EazySupplies/core/models/userModel.dart';
import '../../core/components/app_back_button.dart';
import '../../core/components/bundle_tile_square.dart';
import '../../core/constants/constants.dart';
import '../../core/models/dummy_bundle_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/constants/get_bundels.dart'; // If needed for Product

class PopularPackPage extends StatelessWidget {
  final TagModel tag;

  const PopularPackPage({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final bundles = tag.product;

    return Scaffold(
      appBar: AppBar(title: Text(tag.name)),
      body: bundles.isEmpty
          ? const Center(child: Text('No products available'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.73,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: bundles.length,
              itemBuilder: (context, index) {
                return BundleTileSquare(data: bundles[index]);
              },
            ),
    );
  }
}
