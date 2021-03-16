import 'package:ethio_shoppers/core/providers/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsService {
  final String authToken;
  final String userId;
  ProductsService(this.authToken, this.userId);

  String getUrl(String obj, {String filterBy = ""}) => 'https://ethio-shoppers-default-rtdb.firebaseio.com/$obj.json?auth=$authToken&$filterBy';

  Future<String> addProduct(Product product) async {
    try {
      final response = await http.post(Uri.parse(getUrl("products")), body: json.encode({
        "title": product.title,
        "description":product.description,
        "price":product.price,
        "imageUrl":product.imageUrl,
        "creatorId": userId
      }));
      return json.decode(response.body)["name"].toString();
    }
    catch (error) {
      throw error.toString();
    }
  }

  Future<List<Product>> loadProduct(bool filterByUser) async {
    Uri url = !filterByUser ? Uri.parse(getUrl("products")) :Uri.parse(getUrl("products", filterBy: 'orderBy="creatorId"&equalTo="$userId"'));

    try {
      final response = await http.get(url);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if(loadedData == null) return null;

      final favoriteResponse = await http.get(Uri.parse(getUrl("userFavorites/$userId")));
      final favoriteData = json.decode(favoriteResponse.body);

      loadedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value["title"],
          description: value["description"],
          price: value["price"],
          imageUrl: value["imageUrl"],
          isFavorite: favoriteData == null ? false : favoriteData[key] == null ? false : favoriteData[key]["fav"] ?? false
        ));
      });
      return loadedProducts;
    }
    catch (error) {
      throw error.toString();
    }
  }

  Future<void> editProduct(Product product) async {
    await http.patch(Uri.parse(getUrl("products/${product.id}")), body: json.encode({
      "title": product.title,
      "description":product.description,
      "price":product.price,
      "imageUrl":product.imageUrl,
    }));
  }

  Future<void> setFavorite(String id, bool isFavorite) async {
    await http.put(Uri.parse(getUrl("userFavorites/$userId/$id")),
      body: json.encode({
        "fav": isFavorite, }));
  }

  Future<void> deleteProduct(String id) async {
    await http.delete(Uri.parse(getUrl("/$id"))).then((response) {
      if(response.statusCode >= 400)
        throw("Delete failed");
    });
  }
}