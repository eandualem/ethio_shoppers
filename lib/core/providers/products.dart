import 'package:ethio_shoppers/core/providers/product.dart';
import 'package:ethio_shoppers/core/services/products_service.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  ProductsService productsService;
  List<Product> _items;

  Products(String authToken, String userId, this._items) {
    productsService = ProductsService(authToken, userId);
  }

  List<Product> get favoriteItems {
    return items.where((prod) => prod.isFavorite).toList();
  }
  List<Product> get items {
    return [..._items];
  }

  Product findById(String id){
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct({bool filterByUser=false}) async {
    _items = await productsService.loadProduct(filterByUser);
    notifyListeners();
    return;
  }

  Future<void> addProduct(Product product){
    return productsService.addProduct(product).then((newId) {
      print(newId);
      final newProduct = Product(id: newId, title: product.title, description: product.description, price: product.price, imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    });
  }

  Future<void> editProduct(Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == newProduct.id);
    if(prodIndex >= 0) {
      await productsService.editProduct(newProduct);
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    else throw("Product not found");
  }

  Future<void> deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    var product = _items[index];

    _items.removeAt(index);
    notifyListeners();

    return productsService.deleteProduct(id)
      .then((_) => product = null)     // clean from memory
      .catchError((err) {
        _items.insert(index, product);    // if error occurred roll back
        notifyListeners();
        throw(err);
    });
  }
}