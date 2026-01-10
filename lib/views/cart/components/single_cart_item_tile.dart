import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:EazySupplies/core/routes/app_routes.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';

class SingleCartItemTile extends StatelessWidget {
  const SingleCartItemTile({
    super.key,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
  final void Function(String productId, int newQty) onQuantityChanged;
  final void Function(String productId) onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDefaults.padding,
        vertical: AppDefaults.padding / 2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Thumbnail
              // SizedBox(
              //   width: 70,
              //   child: AspectRatio(
              //     aspectRatio: 1 / 1,
              //     child: NetworkImageWithLoader(
              //       imageUrl,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              SizedBox(
                width: 70,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.bundleProduct,
                        arguments: {
                          'productId': int.parse(productId),
                        },
                      );
                    },
                    child: NetworkImageWithLoader(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Quantity and Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            onQuantityChanged(productId, quantity + 1),
                        icon: SvgPicture.asset(AppIcons.addQuantity),
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$quantity',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            onQuantityChanged(productId, quantity - 1);
                          } else {
                            onRemove(productId);
                          }
                        },
                        icon: SvgPicture.asset(AppIcons.removeQuantity),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),

              // Price and Delete
              Column(
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    onPressed: () => onRemove(productId),
                    icon: SvgPicture.asset(AppIcons.delete),
                  ),
                  const SizedBox(height: 16),
                  Text('₹${(price * quantity).toStringAsFixed(2)}'),
                ],
              )
            ],
          ),
          const Divider(thickness: 0.1),
        ],
      ),
    );
  }
}

// class SingleCartItemTile extends StatelessWidget {
//   const SingleCartItemTile({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppDefaults.padding,
//         vertical: AppDefaults.padding / 2,
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               /// Thumbnail
//               const SizedBox(
//                 width: 70,
//                 child: AspectRatio(
//                   aspectRatio: 1 / 1,
//                   child: NetworkImageWithLoader(
//                     'https://i.imgur.com/4YEHvGc.png',
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),

//               /// Quantity and Name
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Sulphurfree Bura',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.copyWith(color: Colors.black),
//                         ),
//                         Text(
//                           '570 Ml',
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {},
//                         icon: SvgPicture.asset(AppIcons.addQuantity),
//                         constraints: const BoxConstraints(),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           '1',
//                           style:
//                               Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: SvgPicture.asset(AppIcons.removeQuantity),
//                         constraints: const BoxConstraints(),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               const Spacer(),

//               /// Price and Delete labelLarge
//               Column(
//                 children: [
//                   IconButton(
//                     constraints: const BoxConstraints(),
//                     onPressed: () {},
//                     icon: SvgPicture.asset(AppIcons.delete),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text('\$20'),
//                 ],
//               )
//             ],
//           ),
//           const Divider(thickness: 0.1),
//         ],
//       ),
//     );
//   }
// }
