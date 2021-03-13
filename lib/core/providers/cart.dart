import 'package:ethio_shoppers/core/models/cart_item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String productId, double price, String title) {
     if(_items.containsKey(productId)) {
       _items.update(productId, (existingCartItem) => CartItem(
           id: existingCartItem.id,
           title: existingCartItem.title,
           price: existingCartItem.price,
           quantity: existingCartItem.quantity + 1
       ));
     }
     else {
       _items.putIfAbsent(productId, () => CartItem(
         id: DateTime.now().toString(),
         title: title,
         price: price,
         quantity: 1
       ));
     }
     notifyListeners();
  }

  int get itemCount {
    int count = 0;
    _items.forEach((key, value) => count += value.quantity);
    return count;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) => total += value.price*value.quantity);
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}