import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class BundleMetaData extends StatelessWidget {
  final String category;
  final String brand;
  final int stock;

  const BundleMetaData({
    super.key,
    required this.category,
    required this.brand,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(
            label: 'Category',
            value: category,
          ),
          SizedBox(height: Responsive.hp(context, 8 / 8)),
          _MetaRow(
            label: 'Brand',
            value: brand,
          ),
          SizedBox(height: Responsive.hp(context, 8 / 8)),
          _MetaRow(
            label: 'Stock',
            value: stock > 0 ? 'In Stock ($stock)' : 'Out of Stock',
            valueColor: stock > 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        SizedBox(
          width: Responsive.wp(context, 80 / 4),
          child: Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),

        /// Value
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: valueColor ?? Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}


// class BundleMetaData extends StatelessWidget {
//   final String category;
//   final String brand;
//   final int stock;

//   const BundleMetaData({
//     super.key,
//     required this.category,
//     required this.brand,
//     required this.stock,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           /// Category
//           Expanded(
//             child: _MetaItem(
//               title: category,
//               label: 'Category',
//             ),
//           ),

//           /// Brand
//           Expanded(
//             child: _MetaItem(
//               title: brand,
//               label: 'Brand',
//             ),
//           ),

//           /// Stock
//           Expanded(
//             child: _MetaItem(
//               title: stock.toString(),
//               label: stock > 0 ? 'In Stock' : 'Out of Stock',
//               valueColor: stock > 0 ? Colors.green : Colors.red,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Reusable widget
// class _MetaItem extends StatelessWidget {
//   final String title;
//   final String label;
//   final Color? valueColor;

//   const _MetaItem({
//     required this.title,
//     required this.label,
//     this.valueColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           title,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: valueColor ?? Colors.black,
                
//               ),
//         ),
//         SizedBox(height: Responsive.hp(context, 4/8)),
//         Text(
//           label,
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//       ],
//     );
//   }
// }

