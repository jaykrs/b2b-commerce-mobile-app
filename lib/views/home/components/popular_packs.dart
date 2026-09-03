import 'package:flutter/material.dart';
import 'package:EazySupplies/core/constants/apiCall.dart';
import 'package:EazySupplies/core/models/userModel.dart';

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
  List<TagModel> tags = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTagProducts();
  }

  Future<void> loadTagProducts() async {
    final data = await getProductListBasedOnTags();
    if (!mounted) return;
    setState(() {
      tags = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : tags.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No products found'),
                  )
                : Column(
                    children: tags.map((tag) {
                      if (tag.product.isEmpty) return const SizedBox();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 TAG TITLE
                          TitleAndActionButton(
                            title: tag.name,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.popularItems,
                                  arguments: tag);
                            },
                          ),

                          const SizedBox(height: 4),

                          /// 🔹 TAG PRODUCTS
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(
                                left: AppDefaults.padding),
                            child: Row(
                              children: tag.product.map((bundle) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: AppDefaults.padding),
                                  child: BundleTileSquare(data: bundle),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ),
      ],
    );
  }
}
