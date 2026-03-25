import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
import 'network_image.dart';

class BundleTileSquare extends StatelessWidget {
  const BundleTileSquare({
    super.key,
    required this.data,
  });

  final Product data;

  static const String baseUrl = Config.ImagebaseUrl;

  /// ✅ Extract first image and append base URL
  String getFirstImageUrl(String? images) {
    if (images == null || images.isEmpty) return '';

    final list = images
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (list.isEmpty) return '';

    return baseUrl + list.first;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = getFirstImageUrl(data.productImage);

    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bundleProduct,
            arguments: {
              'productId': data.id,
            },
          );
        },
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          width: 176,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.1,
              color: AppColors.placeholder,
            ),
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: imageUrl.isNotEmpty
                      ? NetworkImageWithLoader(
                          imageUrl,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '₹${data.price.toStringAsFixed(0)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '₹${data.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
