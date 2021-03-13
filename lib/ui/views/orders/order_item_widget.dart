import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ethio_shoppers/core/models/order_item.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {

  final OrderItem _orderItem;
  OrderItemWidget(this._orderItem);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${widget._orderItem.amount} Birr"),
            subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(widget._orderItem.orderTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less: Icons.expand_more),
              onPressed: (){
                 setState(() {
                   _expanded = !_expanded;
                 });
              },
            ),
          ),
          if (_expanded) Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: min((widget._orderItem.products.length *20.0) + 10, 100),
            child: ListView(
              children: widget._orderItem.products.map((prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(prod.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("${prod.quantity} x ${prod.price} Birr",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                    ),
                  )
                ],
              )).toList(),
            ),
          )
        ],
      ),
    );
  }
}
