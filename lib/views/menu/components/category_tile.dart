import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.imageLink,
    required this.label,
    this.backgroundColor,
    required this.onTap,
  });

  final String imageLink;
  final String label;
  final Color? backgroundColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      child: InkWell(
        borderRadius: AppDefaults.borderRadius,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDefaults.padding * 1),
              // decoration: BoxDecoration(
              //   color: backgroundColor ?? AppColors.textInputBackground,
              //   shape: BoxShape.circle,
              // ),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.textInputBackground,
                //shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade400, // border color
                  width: 1.5, // border width
                ),
              ),
              child: SizedBox(
                width: 45,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, // background color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getAbbreviation(label),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 2 *
                  (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 12) *
                  1.2,
              // 2 lines * fontSize * lineHeight (approx 1.2)
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: true,
                  applyHeightToLastDescent: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String getAbbreviation(String label) {
  // Split by space or special characters like &
  final words =
      label.split(RegExp(r'\s+|&')).where((w) => w.isNotEmpty).toList();

  // Take only the first 3 words
  final limitedWords = words.take(3).toList();

  if (limitedWords.length == 1) {
    // Single word => take first letter
    return limitedWords[0][0].toUpperCase();
  } else {
    // Multiple words => take first letters of each word
    return limitedWords.map((w) => w[0].toUpperCase()).join();
  }
}
