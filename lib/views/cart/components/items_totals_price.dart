import 'package:flutter/material.dart';

import '../../../core/components/dotted_divider.dart';
import '../../../core/constants/constants.dart';
import 'item_row.dart';

class ItemTotalsAndPrice extends StatelessWidget {
  const ItemTotalsAndPrice({
    super.key,
    required this.totalPrice, // store totalPrice
  });

  final double totalPrice; // add this

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        children: [
          // const ItemRow(
          //   title: 'Total Item',
          //   value: '6', // you can also make this dynamic later
          // ),
          // const ItemRow(
          //   title: 'Weight',
          //   value: '33 Kg', // dynamic later if needed
          // ),
          // const ItemRow(
          //   title: 'Price',
          //   value: '\$ 82.25', // optional dynamic
          // ),
          // const ItemRow(
          //   title: 'Discount',
          //   value: '\$ 12.25', // optional dynamic
          // ),
         
          const DottedDivider(),
          ItemRow(
            title: 'Total Price',
            value: '₹${totalPrice.toStringAsFixed(2)}', // use the passed value
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import '../../../core/components/dotted_divider.dart';
// import '../../../core/constants/constants.dart';
// import 'item_row.dart';

// class ItemTotalsAndPrice extends StatelessWidget {
//   const ItemTotalsAndPrice({
//     super.key, required double totalPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.all(AppDefaults.padding),
//       child: Column(
//         children: [
//           ItemRow(
//             title: 'Total Item',
//             value: '6',
//           ),
//           ItemRow(
//             title: 'Weight',
//             value: '33 Kg',
//           ),
//           ItemRow(
//             title: 'Price',
//             value: '\$ 82.25',
//           ),
//           ItemRow(
//             title: 'Price',
//             value: '\$ 12.25',
//           ),
//           DottedDivider(),
//           ItemRow(
//             title: 'Total Price',
//             value: '\$ 70.25',
//           ),
//         ],
//       ),
//     );
//   }
// }
