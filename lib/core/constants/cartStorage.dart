import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static const String _cartKey = 'cart_items';

  static Future<void> addToCart(String productId, int qty) async {
    final prefs = await SharedPreferences.getInstance();

    final cart = await getCartItems();

    final index = cart.indexWhere((item) => item['id'] == productId);

    if (index >= 0) {
      // Update quantity if item exists
      cart[index]['itemQty'] += qty;
    } else {
      // Add new item
      cart.add({
        'id': productId,
        'itemQty': qty,
      });
    }

    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cartKey);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> removeFromCart(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    final cart = await getCartItems();
    cart.removeWhere((item) => item['id'] == productId);

    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  static Future<bool> isInCart(String productId) async {
    final cart = await getCartItems();
    return cart.any((item) => item['id'] == productId);
  }

  static Future<int> getItemQty(String productId) async {
    final cart = await getCartItems();
    final item = cart.firstWhere(
      (item) => item['id'] == productId,
      orElse: () => {},
    );

    return item['itemQty'] ?? 0;
  }

  static Future<void> updateCartQty(String productId, int newQty) async {
    final prefs = await SharedPreferences.getInstance();

    final cart = await getCartItems();

    final index = cart.indexWhere((item) => item['id'] == productId);

    if (index == -1) return;

    if (newQty <= 0) {
      // Remove item if qty is 0 or less
      cart.removeAt(index);
    } else {
      cart[index]['itemQty'] = newQty;
    }

    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  static Future<void> increaseQty(String productId) async {
    final cart = await getCartItems();

    final index = cart.indexWhere((item) => item['id'] == productId);
    if (index == -1) return;

    cart[index]['itemQty'] += 1;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  static Future<void> decreaseQty(String productId) async {
    final cart = await getCartItems();

    final index = cart.indexWhere((item) => item['id'] == productId);
    if (index == -1) return;

    cart[index]['itemQty'] -= 1;

    if (cart[index]['itemQty'] <= 0) {
      cart.removeAt(index);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode(cart));
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();

    // Set the cart to an empty list
    await prefs.setString(_cartKey, jsonEncode([]));
  }
}
