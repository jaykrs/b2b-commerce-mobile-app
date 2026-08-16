import '../constants/app.config.dart';

String buildProductImageUrl(String fileName, {String? version}) {
  final trimmedFileName = fileName.trim();
  if (trimmedFileName.isEmpty) return '';

  final source = trimmedFileName.startsWith('http://') ||
          trimmedFileName.startsWith('https://')
      ? Uri.parse(trimmedFileName)
      : Uri.parse(Config.ImagebaseUrl).replace(
          queryParameters: {
            ...Uri.parse(Config.ImagebaseUrl).queryParameters,
            'file': trimmedFileName,
          },
        );

  if (version == null || version.isEmpty) return source.toString();

  return source.replace(
    queryParameters: {
      ...source.queryParameters,
      'v': version,
    },
  ).toString();
}

List<String> buildProductImageUrls(String? images, {String? version}) {
  if (images == null || images.trim().isEmpty) return const [];

  return images
      .split(',')
      .map((image) => buildProductImageUrl(image, version: version))
      .where((url) => url.isNotEmpty)
      .toList();
}
