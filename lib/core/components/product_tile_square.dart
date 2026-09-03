import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:EazySupplies/core/models/userModel.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
import '../utils/product_image_url.dart';
import 'network_image.dart';

class ProductTileSquare extends StatelessWidget {
  const ProductTileSquare({
    super.key,
    required this.data,
  });

  final Product data;

  @override
  Widget build(BuildContext context) {
    final imageUrls = buildProductImageUrls(
      data.productImage,
      version: data.updatedAt,
    );
    final imageUrl = imageUrls.isEmpty ? '' : imageUrls.first;
    return Material(
      borderRadius: AppDefaults.borderRadius,
      color: Colors.white,
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
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: AppDefaults.borderRadius,
            boxShadow: AppDefaults.boxShadow,
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                textAlign: TextAlign.left,
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
                  textAlign: TextAlign.left,
                ),
              SizedBox(height: Responsive.hp(context, 6 / 8)),

              // Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '₹${data.price.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: Responsive.wp(context, 6 / 4)),
                  if (data.mrp != null && data.mrp! > data.price)
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
              if (data.mrp != null && data.mrp! > data.price) ...[
                const SizedBox(height: 4),
                Text(
                  '${(((data.mrp! - data.price) / data.mrp!) * 100).round()}% OFF',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF1B7F4B),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
              if ((data.pkgUnit ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('/${data.pkgUnit}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black54)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
