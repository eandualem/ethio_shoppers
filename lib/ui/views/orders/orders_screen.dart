import 'package:ethio_shoppers/core/providers/orders.dart';
import 'package:ethio_shoppers/ui/views/home/app_drawer.dart';
import 'package:ethio_shoppers/ui/views/orders/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot){
          switch(snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            case ConnectionState.done:
              return ordersWidget(snapshot);
            default:
              throw ("error");
          }
        }
      ),
    );
  }

  Consumer ordersWidget(AsyncSnapshot snapshot) {
    if(snapshot.error != null) {
      throw (snapshot.error);
    }
    return Consumer<Orders>(
      builder: (ctx, orderData, child) =>
        ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) => OrderItemWidget(orderData.orders[index])
        ),
    );
  }
}
