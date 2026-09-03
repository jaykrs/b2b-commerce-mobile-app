import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/app_defaults.dart';
import '../constants/app_colors.dart';
import 'skeleton.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final BoxFit fit;
  final String src;
  final double radius;
  final BorderRadius? borderRadius;

  const NetworkImageWithLoader(
    this.src, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = AppDefaults.radius,
    this.borderRadius,
  });

  /// ✅ Fallback fetch
  Future<Uint8List?> fetchImageBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      debugPrint("Image fetch error: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = src.trim().isEmpty ? '' : Uri.encodeFull(src);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      child: imageUrl.isEmpty
          ? Container(
              color: AppColors.scaffoldWithBoxBackground,
              alignment: Alignment.center,
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.placeholder,
                size: 42,
              ),
            )
          : CachedNetworkImage(
              key: ValueKey(imageUrl),
              fit: fit,
              imageUrl: imageUrl,
              httpHeaders: const {
                "Accept": "image/*",
              },
              // Avoid the card fade while ensuring a reused grid cell never
              // keeps the previous product image after its URL changes.
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,

              // ✅ Normal case (fast + cached)
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  ),
                ),
              ),

              // ✅ Loading skeleton
              placeholder: (context, url) => const Skeleton(),

              // 🔥 FIX: Fallback when API fails
              errorWidget: (context, url, error) {
                return FutureBuilder<Uint8List?>(
                  future: fetchImageBytes(url),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Skeleton();
                    }

                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        fit: fit,
                      );
                    }

                    return Container(
                      color: AppColors.scaffoldWithBoxBackground,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.placeholder,
                        size: 42,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
