import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/constants.dart';

class PriceAndQuantityRow extends StatefulWidget {
  const PriceAndQuantityRow({
    super.key,
    required this.currentPrice,
    required this.orginalPrice,
    required this.quantity,
  });

  final double currentPrice;
  final double orginalPrice;
  final int quantity;

  @override
  State<PriceAndQuantityRow> createState() => _PriceAndQuantityRowState();
}

class _PriceAndQuantityRowState extends State<PriceAndQuantityRow> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void onQuantityIncrease() {
    setState(() {
      quantity++;
    });
  }

  void onQuantityDecrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.currentPrice * quantity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Price & Quantity Row */
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Original Price
            Text(
              '₹${widget.orginalPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
            ),
            const SizedBox(width: AppDefaults.padding),
            // Current Price
            Text(
              '₹${widget.currentPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            // Quantity Buttons
            Row(
              children: [
                IconButton(
                  onPressed: onQuantityIncrease,
                  icon: SvgPicture.asset(AppIcons.addQuantity),
                  constraints: const BoxConstraints(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: onQuantityDecrease,
                  icon: SvgPicture.asset(AppIcons.removeQuantity),
                  constraints: const BoxConstraints(),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 8),

        /* Total Price */
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

// class PriceAndQuantityRow extends StatefulWidget {
//   const PriceAndQuantityRow({
//     super.key,
//     required this.currentPrice,
//     required this.orginalPrice,
//     required this.quantity,
//   });

//   final double currentPrice;
//   final double orginalPrice;
//   final int quantity;

//   @override
//   State<PriceAndQuantityRow> createState() => _PriceAndQuantityRowState();
// }

// class _PriceAndQuantityRowState extends State<PriceAndQuantityRow> {
//   int quantity = 1;

//   onQuantityIncrease() {
//     quantity++;
//     setState(() {});
//   }

//   onQuantityDecrease() {
//     if (quantity > 1) {
//       quantity--;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     quantity = widget.quantity;
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         /* <---- Price -----> */
//         Text(
//           '\₹$orginalPrice',
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 decoration: TextDecoration.lineThrough,
//               ),
//         ),
//         const SizedBox(width: AppDefaults.padding),
//         Text(
//           '\$20',
//           style: Theme.of(context)
//               .textTheme
//               .headlineSmall
//               ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
//         ),
//         const Spacer(),

//         /* <---- Quantity -----> */
//         Row(
//           children: [
//             IconButton(
//               onPressed: onQuantityIncrease,
//               icon: SvgPicture.asset(AppIcons.addQuantity),
//               constraints: const BoxConstraints(),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 '$quantity',
//                 style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//               ),
//             ),
//             IconButton(
//               onPressed: onQuantityDecrease,
//               icon: SvgPicture.asset(AppIcons.removeQuantity),
//               constraints: const BoxConstraints(),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
