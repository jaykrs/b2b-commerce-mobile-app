import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';

class ProductAvatarWithQuanitty extends StatelessWidget {
  const ProductAvatarWithQuanitty({
    super.key,
    required this.productImage,
    required this.quantity,
  });

  final String productImage;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          padding: const EdgeInsets.all(AppDefaults.padding / 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          width: Responsive.wp(context, 50 / 4),
          height: Responsive.hp(context, 50 / 8),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(productImage, fit: BoxFit.contain),
          ),
        ),
        if (quantity > 0)
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary,
                    width: Responsive.wp(context, 2 / 4)),
              ),
              child: Text(
                'x$quantity',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black),
              ),
            ),
          )
      ],
    );
  }
}
