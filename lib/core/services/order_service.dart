import 'dart:convert';
import 'package:ethio_shoppers/core/models/cart_item.dart';
import 'package:ethio_shoppers/core/models/order_item.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String authToken;
  final String userId;
  OrderService(this.authToken, this.userId);

  String get url => 'https://ethio-shoppers-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

  Future<String> addOrder(List<CartItem> cartProducts, double total, DateTime timeStamp) async {
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        "amount": total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts.map((cp) => {
          "id": cp.id,
          "title": cp.title,
          "quantity": cp.quantity,
          "price": cp.price
        }).toList()
      }));
      return json.decode(response.body)["name"].toString();
    }
    catch (error) {
      throw error.toString();
    }
  }

  Future<List<OrderItem>> loadOrders() async {
    try {
      final response = await http.get(Uri.parse(url));
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];

      if(loadedData == null) return null;

      loadedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            id: key,
            amount: value["amount"],
            orderTime: DateTime.parse(value["dateTime"]),
            products: (value["products"] as List<dynamic>).map((item) =>
                CartItem(id: item["id"], title: item["title"], quantity: item["quantity"], price: item["price"])).toList(),
        ));
      });
      return loadedOrders.reversed.toList();
    }
    catch (error) {
      throw error.toString();
    }
  }


}