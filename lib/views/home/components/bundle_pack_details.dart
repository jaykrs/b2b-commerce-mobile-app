import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/constants/constants.dart';

class PackDetails extends StatelessWidget {
  final String description;

  const PackDetails({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* <---- Title -----> */
          Text(
            'Product Details',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: AppDefaults.padding / 2),

          /* <---- Description -----> */
          Html(
            data: description,
            style: {
              "body": Style(
                fontSize: FontSize(Responsive.sp(context, 14)),
              ),
            },
          )
        ],
      ),
    );
  }
}
