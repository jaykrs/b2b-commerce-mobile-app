import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/network_image.dart';
import '../../../../core/models/dummy_product_model.dart';

class OrderDetailsProductTile extends StatelessWidget {
  const OrderDetailsProductTile({
    super.key,
    required this.data,
  });

  final ProductModel data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: Responsive.hp(context, 80 / 8),
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: NetworkImageWithLoader(
              data.cover,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: Responsive.wp(context, 16 / 4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
              ),
              SizedBox(height: Responsive.hp(context, 8 / 8)),
              Text(data.weight)
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${data.price.toInt()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: Responsive.hp(context, 8 / 8)),
            Text(
              '3x',
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )
      ],
    );
  }
}
