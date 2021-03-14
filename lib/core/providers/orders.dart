import 'package:ethio_shoppers/core/models/cart_item.dart';
import 'package:ethio_shoppers/core/models/order_item.dart';
import 'package:ethio_shoppers/core/services/order_service.dart';
import 'package:flutter/material.dart';

class Orders with ChangeNotifier {
  final OrderService orderService = OrderService();

  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    String newId = await orderService.addOrder(cartProducts, total, timeStamp);

    _orders.insert(0, OrderItem(
        id: newId,
        amount: total,
        products: cartProducts,
        orderTime: DateTime.now()));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    _orders = await orderService.loadOrders();
    notifyListeners();
    return;
  }
}