import 'package:ethio_shoppers/core/models/cart_item.dart';
import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderTime});
}