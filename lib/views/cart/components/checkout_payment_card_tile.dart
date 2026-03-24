import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/constants.dart';

class PaymentCardTile extends StatelessWidget {
  const PaymentCardTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.label,
    required this.isActive,
  });

  final String icon;
  final String label;
  final void Function() onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: isActive
            ? AppColors.coloredBackground
            : AppColors.scaffoldBackground,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            height: Responsive.hp(context, 66 / 8),
            width: Responsive.wp(context, 135 / 4),
            padding: const EdgeInsets.symmetric(),
            decoration: BoxDecoration(
              borderRadius: AppDefaults.borderRadius,
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.placeholder,
                width: isActive ? 1 : 0.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(icon),
                SizedBox(height: Responsive.hp(context, 8 / 8)),
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
