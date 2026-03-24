import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class AnimatedDots extends StatelessWidget {
  const AnimatedDots({
    super.key,
    required this.totalItems,
    required this.currentIndex,
  });

  final int totalItems;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalItems,
        (index) => AnimatedContainer(
          duration: AppDefaults.duration,
          height: Responsive.hp(context, 5 / 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 25 : 15,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primary
                : const Color(0xFF9FC5A6),
            borderRadius: AppDefaults.borderRadius,
          ),
        ),
      ),
    );
  }
}
