import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class StarsRow extends StatelessWidget {
  const StarsRow({
    super.key,
    required this.label,
    required this.maxValue,
    required this.totalPercentage,
  });

  final String label;
  final String maxValue;
  final double totalPercentage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          SizedBox(width: Responsive.wp(context, 8 / 4)),
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: AppDefaults.borderRadius,
              child: SizedBox(
                height: Responsive.hp(context, 10 / 8),
                child: LinearProgressIndicator(
                  value: totalPercentage / 100,
                  color: AppColors.primary,
                  backgroundColor: AppColors.cardColor,
                ),
              ),
            ),
          ),
          SizedBox(width: Responsive.wp(context, 16 / 4)),
          Expanded(
            flex: 1,
            child: Text(
              maxValue,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
