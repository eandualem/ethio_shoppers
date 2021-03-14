import 'package:ethio_shoppers/core/providers/cart.dart' show Cart;
import 'package:ethio_shoppers/core/providers/orders.dart';
import 'package:ethio_shoppers/ui/views/cart/cart_item_widget.dart';
import 'package:ethio_shoppers/ui/views/cart/order_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text("${cart.totalAmount.toStringAsFixed(2)} Birr",
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButtonWidget(cart: cart),

                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) => CartItemWidget(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],  // key
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title)))
        ],
      ),
    );
  }
}