import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/constants.dart';

class PriceAndQuantityRow extends StatelessWidget {
  final double currentPrice;
  final double orginalPrice;
  final int quantity; // comes from parent
  final VoidCallback onQuantityIncrease;
  final VoidCallback onQuantityDecrease;

  const PriceAndQuantityRow({
    super.key,
    required this.currentPrice,
    required this.orginalPrice,
    required this.quantity,
    required this.onQuantityIncrease,
    required this.onQuantityDecrease,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = currentPrice * quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${orginalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
            const SizedBox(width: AppDefaults.padding),
            Text(
              '₹${currentPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: onQuantityDecrease,
                  icon: SvgPicture.asset(AppIcons.removeQuantity),
                  constraints: const BoxConstraints(),
                ),
                Text(
                  '$quantity',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                IconButton(
                  onPressed: onQuantityIncrease,
                  icon: SvgPicture.asset(AppIcons.addQuantity),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Total: ₹${totalPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../constants/constants.dart';

// class PriceAndQuantityRow extends StatelessWidget {
//   final double currentPrice;
//   final double orginalPrice;
//   final int quantity;
//   final VoidCallback onQuantityIncrease;
//   final VoidCallback onQuantityDecrease;

//   const PriceAndQuantityRow({
//     super.key,
//     required this.currentPrice,
//     required this.orginalPrice,
//     required this.quantity,
//     required this.onQuantityIncrease,
//     required this.onQuantityDecrease,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalPrice = currentPrice * quantity;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('₹${orginalPrice.toStringAsFixed(2)}',
//                 style: const TextStyle(decoration: TextDecoration.lineThrough)),
//             const SizedBox(width: 16),
//             Text('₹${currentPrice.toStringAsFixed(2)}'),
//             const Spacer(),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: onQuantityDecrease,
//                   icon: const Icon(Icons.remove),
//                 ),
//                 Text('$quantity'), // <-- comes from parent
//                 IconButton(
//                   onPressed: onQuantityIncrease,
//                   icon: const Icon(Icons.add),
//                 ),
//               ],
//             )
//           ],
//         ),
//         Text('Total: ₹${totalPrice.toStringAsFixed(2)}'),
//       ],
//     );
//   }
// }


// // class PriceAndQuantityRow extends StatelessWidget {
// //   final double currentPrice;
// //   final double orginalPrice;
// //   final int quantity;
// //   final VoidCallback onQuantityIncrease;
// //   final VoidCallback onQuantityDecrease;

// //   const PriceAndQuantityRow({
// //     super.key,
// //     required this.currentPrice,
// //     required this.orginalPrice,
// //     required this.quantity,
// //     required this.onQuantityIncrease,
// //     required this.onQuantityDecrease,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final totalPrice = currentPrice * quantity;

// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //             Text(
// //               '₹${orginalPrice.toStringAsFixed(2)}',
// //               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
// //                     color: Colors.black,
// //                     fontWeight: FontWeight.bold,
// //                     decoration: TextDecoration.lineThrough,
// //                   ),
// //             ),
// //             const SizedBox(width: 16),
// //             Text(
// //               '₹${currentPrice.toStringAsFixed(2)}',
// //               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
// //                     color: Colors.green,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //             ),
// //             const Spacer(),
// //             Row(
// //               children: [
// //                 IconButton(
// //                   onPressed: onQuantityDecrease,
// //                   icon: SvgPicture.asset(AppIcons.removeQuantity),
// //                   constraints: const BoxConstraints(),
// //                 ),
// //                 Text(
// //                   '$quantity',
// //                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black,
// //                       ),
// //                 ),
// //                 IconButton(
// //                   onPressed: onQuantityIncrease,
// //                   icon: SvgPicture.asset(AppIcons.addQuantity),
// //                   constraints: const BoxConstraints(),
// //                 ),
// //               ],
// //             )
// //           ],
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           'Total: ₹${totalPrice.toStringAsFixed(2)}',
// //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.green,
// //               ),
// //         ),
// //       ],
// //     );
// //   }
// // }


