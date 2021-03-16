import 'package:ethio_shoppers/core/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsService {
  final String authToken;
  ProductsService(this.authToken);
  String getUrl(String obj) => 'https://ethio-shoppers-default-rtdb.firebaseio.com/products$obj.json?auth=$authToken';

  Future<String> addProduct(Product product) async {
    try {
      final response = await http.post(Uri.parse(getUrl("")), body: json.encode({
        "title": product.title,
        "description":product.description,
        "price":product.price,
        "imageUrl":product.imageUrl,
        "isFavorite": product.isFavorite,
      }));
      return json.decode(response.body)["name"].toString();
    }
    catch (error) {
      throw error.toString();
    }
  }

  Future<List<Product>> loadProduct() async {
    try {
      final response = await http.get(Uri.parse(getUrl("")));
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if(loadedData == null) return null;

      loadedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value["title"],
          description: value["description"],
          price: value["price"],
          imageUrl: value["imageUrl"],
          isFavorite: value["isFavorite"]
        ));
      });
      return loadedProducts;
    }
    catch (error) {
      throw error.toString();
    }
  }

  Future<void> editProduct(Product product) async {
    await http.patch(Uri.parse(getUrl("/${product.id}")), body: json.encode({
      "title": product.title,
      "description":product.description,
      "price":product.price,
      "imageUrl":product.imageUrl,
    }));
  }

  Future<void> setFavorite(String id, bool isFavorite) async {
    await http.patch(Uri.parse(getUrl("/$id")), body: json.encode({
      "isFavorite": isFavorite
    }));
  }

  Future<void> deleteProduct(String id) async {
    await http.delete(Uri.parse(getUrl("/$id"))).then((response) {
      if(response.statusCode >= 400)
        throw("Delete failed");
    });
  }
}