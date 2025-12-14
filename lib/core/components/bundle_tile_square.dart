import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/dummy_bundle_model.dart';
import '../routes/app_routes.dart';
import 'network_image.dart';

class BundleTileSquare extends StatelessWidget {
  const BundleTileSquare({
    super.key,
    required this.data,
  });

  final BundleModel data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        // onTap: () {
        //   Navigator.pushNamed(context, AppRoutes.bundleProduct);
        // },
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bundleProduct,
            arguments: {
              'productId': data.id,
            },
          );
        },

        borderRadius: AppDefaults.borderRadius,
        child: Container(
          width: 176,
          padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
          decoration: BoxDecoration(
            border: Border.all(width: 0.1, color: AppColors.placeholder),
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: NetworkImageWithLoader(
                    data.productImage ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.black, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '\₹${data.price.toStringAsFixed(0)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '\₹${data.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// class BundleTileSquare extends StatelessWidget {
//   const BundleTileSquare({
//     super.key,
//     required this.data,
//   });

//   final BundleModel data;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.scaffoldBackground,
//       borderRadius: AppDefaults.borderRadius,
//       child: InkWell(
//         onTap: () {
//           Navigator.pushNamed(context, AppRoutes.bundleProduct);
//         },
//         borderRadius: AppDefaults.borderRadius,
//         child: Container(
//           width: 176,
//           padding: const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
//           decoration: BoxDecoration(
//             border: Border.all(width: 0.1, color: AppColors.placeholder),
//             borderRadius: AppDefaults.borderRadius,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: AspectRatio(
//                   aspectRatio: 1 / 1,
//                   child: NetworkImageWithLoader(
//                     //data.productImage,
//                     "https://www.gettyimages.in/photos/ice-cream",
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     data.name,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.black),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   // Text(
//                   //   data.itemNames.join(','),
//                   //   maxLines: 1,
//                   //   overflow: TextOverflow.ellipsis,
//                   // ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Text(
//                     '\$${data.price.toInt()}',
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.black),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     '\$${data.price.toInt()}',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           decoration: TextDecoration.lineThrough,
//                         ),
//                   ),
//                   const Spacer(),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
