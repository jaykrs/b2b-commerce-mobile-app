import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class VerticalStepIndicator extends StatelessWidget {
  const VerticalStepIndicator({
    super.key,
    this.height = 50,
    this.isStart = false,
    this.isActive = false,
    this.isEnd = false,
  });

  final double height;
  final bool isStart;
  final bool isActive;
  final bool isEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDefaults.margin,
      ),
      child: Column(
        children: [
          if (!isStart)
            Container(
              height: height / 2,
              width: Responsive.wp(context, 3 / 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey,
              ),
            ),
          Container(
            width: Responsive.wp(context, 14 / 4),
            height: Responsive.hp(context, 14 / 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? AppColors.primary : Colors.grey,
                width: Responsive.wp(context, 3 / 4),
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: !isStart ? height / 2 : height,
            width: Responsive.wp(context, 3 / 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey,
              borderRadius: isEnd ? AppDefaults.borderRadius : null,
            ),
          )
        ],
      ),
    );
  }
}
