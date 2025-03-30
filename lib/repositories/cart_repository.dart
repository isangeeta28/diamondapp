
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/diamond.dart';

class CartRepository {
  static const String _cartKey = 'diamond_cart';

  Future<List<Diamond>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList(_cartKey) ?? [];

    return cartData.map((item) => Diamond.fromJson(jsonDecode(item))).toList();
  }

  Future<void> addToCart(Diamond diamond) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList(_cartKey) ?? [];

    // Check if diamond already exists in cart
    final exists = cartData.any((item) {
      final decodedItem = jsonDecode(item);
      return decodedItem['lotId'] == diamond.lotId;
    });

    if (!exists) {
      cartData.add(jsonEncode(diamond.toJson()));
      await prefs.setStringList(_cartKey, cartData);
    }
  }

  Future<void> removeFromCart(String lotId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList(_cartKey) ?? [];

    cartData.removeWhere((item) {
      final decodedItem = jsonDecode(item);
      return decodedItem['lotId'] == lotId;
    });

    await prefs.setStringList(_cartKey, cartData);
  }

  Future<bool> isInCart(String lotId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList(_cartKey) ?? [];

    return cartData.any((item) {
      final decodedItem = jsonDecode(item);
      return decodedItem['lotId'] == lotId;
    });
  }
}