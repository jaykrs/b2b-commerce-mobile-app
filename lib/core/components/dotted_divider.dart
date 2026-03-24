import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.isVertical = false,
    this.color,
  });

  final Color? color;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            30,
            (index) => Container(
              margin: const EdgeInsets.all(3),
              width: Responsive.wp(context, 1 / 4),
              height: Responsive.hp(context, 8 / 8),
              color: color ?? Colors.black,
            ),
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            30,
            (index) => Container(
              margin: const EdgeInsets.all(3),
              width: Responsive.wp(context, 8 / 4),
              height: Responsive.hp(context, 0 / 8),
              color: color ?? Colors.black,
            ),
          ),
        ),
      );
    }
  }
}
