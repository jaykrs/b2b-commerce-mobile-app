import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../constants/app_defaults.dart';

class AppSettingsListTile extends StatelessWidget {
  const AppSettingsListTile(
      {super.key, required this.label, this.trailing, this.onTap, this.icons});

  final String label;
  final Widget? trailing;
  final void Function()? onTap;
  final Widget? icons;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDefaults.borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (icons != null) ...[
                    icons!,
                    SizedBox(width: Responsive.wp(context, 12 / 4)),
                  ],
                  if (icons == null) ...[
                    SizedBox(width: Responsive.wp(context, 12 / 4)),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const Spacer(),
                  if (trailing != null) trailing!,
                ],
              ),
              const Divider(thickness: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
