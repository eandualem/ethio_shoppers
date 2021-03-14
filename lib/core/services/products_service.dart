import 'package:ethio_shoppers/core/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsService {
  final URL = Uri.parse('https://ethio-shoppers-default-rtdb.firebaseio.com/products.json');

  Future<String> addProduct(Product product) async {
    dynamic response = await http.post(URL, body: json.encode({
      "title": product.title,
      "description":product.description,
      "price":product.price,
      "imageUrl":product.imageUrl,
      "isFavorite": product.isFavorite,
    }));
    return json.decode(response.body)["name"].toString();
  }
}