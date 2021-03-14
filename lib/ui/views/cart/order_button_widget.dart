import 'package:ethio_shoppers/core/providers/cart.dart';
import 'package:ethio_shoppers/core/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderButtonWidget extends StatefulWidget {
  const OrderButtonWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null :() async {
        setState(() => _isLoading=true);
        await Provider.of<Orders>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
        setState(() => _isLoading=false);
        widget.cart.clear();
      },
      child: _isLoading ? Center(
        child: CircularProgressIndicator(),)
        :Text("ORDER NOW",
          style: TextStyle(
              color: Theme.of(context).primaryColor
          )
      ),
    );
  }
}
