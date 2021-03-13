import 'package:ethio_shoppers/core/providers/orders.dart';
import 'package:ethio_shoppers/ui/views/orders/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context, index) => OrderItemWidget(ordersData.orders[index])),
    );
  }
}
