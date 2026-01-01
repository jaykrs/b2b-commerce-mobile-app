import 'package:flutter/material.dart';
import 'package:grocery/core/models/userModel.dart';

import '../constants/constants.dart';
import '../routes/app_routes.dart';
import 'network_image.dart';

class ProductTileSquare extends StatelessWidget {
  const ProductTileSquare({
    super.key,
    required this.data,
  });

  final Product data;

  @override
  Widget build(BuildContext context) {
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
              width: 1, // border width
            ),
            borderRadius: AppDefaults.borderRadius, // rounded corners
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
            children: [
              // Product Image
              SizedBox(
                height: 100,
                child: NetworkImageWithLoader(
                  data.productImage ?? "",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),

              // Product Name
              Text(
                data.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black, fontSize: 14),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

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
              const SizedBox(height: 6),

              // Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // center row
                children: [
                  Text(
                    '₹${data.price.toStringAsFixed(1)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  if (data.mrp != null)
                    Text(
                      '₹${data.mrp!.toStringAsFixed(1)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 12,
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
