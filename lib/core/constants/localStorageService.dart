import 'dart:convert';
import 'package:grocery/core/models/dummy_bundle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyBundles = 'bundles';

  static Future<void> saveBundles(List<BundleModel> bundles) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(bundles.map((e) => e.toJson()).toList());
    await prefs.setString(_keyBundles, jsonString);
  }

  static Future<List<BundleModel>> loadBundles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyBundles);
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((e) => BundleModel.fromJson(e)).toList();
  }

  static Future<bool> hasBundles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyBundles);
  }

  // categories

  static const _keyCategories = 'categories';

  static Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(categories.map((e) => e.toJson()).toList());
    await prefs.setString(_keyCategories, jsonString);
  }

  static Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyCategories);
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((e) => Category.fromJson(e)).toList();
  }

  static Future<bool> hasCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyCategories);
  }

  static Future<void> addToCart(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    final ids = prefs.getStringList('cart_product_ids') ?? [];

    if (!ids.contains(productId)) {
      ids.add(productId);
      await prefs.setStringList('cart_product_ids', ids);
    }
  }

  static Future<List<String>> getCartProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('cart_product_ids') ?? [];
  }

  static Future<void> removeFromCart(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    final ids = prefs.getStringList('cart_product_ids') ?? [];
    ids.remove(productId);

    await prefs.setStringList('cart_product_ids', ids);
  }

  static Future<bool> isInCart(String productId) async {
  final prefs = await SharedPreferences.getInstance();
  final ids = prefs.getStringList('cart_product_ids') ?? [];
  return ids.contains(productId);
}

}
