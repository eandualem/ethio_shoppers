import 'package:flutter/material.dart';
import 'package:ethio_shoppers/core/models/order_item.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {

  final OrderItem _orderItem;
  OrderItemWidget(this._orderItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${_orderItem.amount} Birr"),
            subtitle: Text(DateFormat("dd MM yyyy hh:mm").format(_orderItem.orderTime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: (){},
            ),
          )
        ],
      ),
    );
  }
}
