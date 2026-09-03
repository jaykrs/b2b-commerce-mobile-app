const _brandAssetOrigin = 'https://api.eazysupplies.com';

String buildBrandImageUrl(String? image) {
  final value = image?.trim() ?? '';
  if (value.isEmpty) return '';

  final uri = Uri.tryParse(value);
  if (uri != null && uri.hasScheme) return uri.toString();

  final normalizedPath = value.startsWith('/') ? value : '/$value';
  return Uri.parse(_brandAssetOrigin).resolve(normalizedPath).toString();
}
