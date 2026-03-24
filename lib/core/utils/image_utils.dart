class ImageUtils {
  static const String baseUrl =
      "https://api.eazysupplies.com/api/file?file=";

  static List<String> getImageList(String? images) {
    if (images == null || images.isEmpty) return [];

    return images
        .split(',')
        .map((img) => img.trim())
        .where((img) => img.isNotEmpty)
        .map((img) => baseUrl + img)
        .toList();
  }

  static String getFirstImage(String? images) {
    final list = getImageList(images);
    return list.isNotEmpty ? list.first : "";
  }
}
