import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/core/constants/api_config.dart';
import 'package:grocery/core/constants/localStorageService.dart';
import 'package:grocery/core/models/dummy_bundle_model.dart';
import 'package:http/http.dart' as http;

Future<List<BundleModel>> getBundles() async {
  // ✅ STEP 1: Load from local storage first
  final localBundles = await LocalStorageService.loadBundles();
  if (localBundles.isNotEmpty) {
    debugPrint('Loaded bundles from local storage');
    return localBundles;
  }

  // ✅ STEP 2: If no local data → call API
  try {
    final response = await http
        .get(
          Uri.parse(ApiConfig.products),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      final bundles = data.map((e) => BundleModel.fromJson(e)).toList();

      // ✅ STEP 3: Save API data locally
      await LocalStorageService.saveBundles(bundles);

      debugPrint('Loaded bundles from API');
      return bundles;
    } else {
      return [];
    }
  } catch (e) {
    debugPrint('API error: $e');
    return [];
  }
}

Future<List<Category>> getCategories() async {
  // 1️⃣ Load local first
  final localCategories = await LocalStorageService.loadCategories();
  if (localCategories.isNotEmpty) {
    debugPrint('Loaded categories from local storage');
    return localCategories;
  }

  // 2️⃣ API fallback
  try {
    final response = await http
        .get(Uri.parse(ApiConfig.categories))
        .timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final categories = data.map((e) => Category.fromJson(e)).toList();

      // 3️⃣ Save locally
      await LocalStorageService.saveCategories(categories);

      return categories;
    }
  } catch (e) {
    debugPrint('Category API error: $e');
  }

  return [];
}
