import 'package:ethio_shoppers/core/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsService {
  final url = Uri.parse('https://ethio-shoppers-default-rtdb.firebaseio.com/products.json');

  Future<String> addProduct(Product product) async {
    try {
      final response = await http.post(url, body: json.encode({
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
      final response = await http.get(url);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

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
    final _url = Uri.parse('https://ethio-shoppers-default-rtdb.firebaseio.com/products/${product.id}.json');
    await http.patch(_url, body: json.encode({
      "title": product.title,
      "description":product.description,
      "price":product.price,
      "imageUrl":product.imageUrl,
    }));
  }

  Future<void> setFavorite(String id, bool isFavorite) async {
    final _url = Uri.parse('https://ethio-shoppers-default-rtdb.firebaseio.com/products/$id.json');
    await http.patch(_url, body: json.encode({
      "isFavorite": isFavorite
    }));
  }

  Future<void> deleteProduct(String id) async {
    final _url = Uri.parse('https://ethio-shoppers-default-rtdb.firebaseio.com/products/$id.json');
    await http.delete(_url).then((response) {
      if(response.statusCode >= 400)
        throw("Delete failed");
    });
  }
}