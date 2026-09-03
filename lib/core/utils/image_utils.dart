import 'product_image_url.dart';

class ImageUtils {
  ImageUtils(String imageUrl);

  static List<String> getImageList(String? images) {
    if (images == null || images.isEmpty) return [];

    return images
        .split(',')
        .map((img) => img.trim())
        .where((img) => img.isNotEmpty)
        .map(buildProductImageUrl)
        .toList();
  }

  static String getFirstImage(String? images) {
    final list = getImageList(images);
    return list.isNotEmpty ? list.first : "";
  }
}
