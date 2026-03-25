import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
import 'network_image.dart';

class ProductTileSquare extends StatelessWidget {
  const ProductTileSquare({
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
      borderRadius: AppDefaults.borderRadius,
      color: AppColors.scaffoldBackground,
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.productDetails,
          arguments: data.id,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300, // border color
              width: Responsive.wp(context, 1 / 4), // border width
            ),
            borderRadius: AppDefaults.borderRadius, // rounded corners
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // center horizontally
            children: [
              // Product Image
              SizedBox(
                height: Responsive.hp(context, 100 / 8),
                child: NetworkImageWithLoader(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: Responsive.hp(context, 8 / 8)),

              // Product Name
              Text(
                data.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black, fontSize: Responsive.sp(context, 14)),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Responsive.hp(context, 4 / 8)),

              // Package weight
              if ((data.pkgGwt ?? data.dimension) != null)
                Text(
                  data.pkgGwt ?? data.dimension ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: Responsive.hp(context, 6 / 8)),

              // Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // center row
                children: [
                  Text(
                    '₹${data.price.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: Responsive.wp(context, 6 / 4)),
                  if (data.mrp != null)
                    Text(
                      '₹${data.mrp!.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: Responsive.sp(context, 12),
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
