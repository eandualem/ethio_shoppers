import 'package:ethio_shoppers/core/services/products_service.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false});

  void toggleIsFavoriteStatus(String authToken, String userId){
    ProductsService productsService = ProductsService(authToken, userId);
    productsService.setFavorite(id, !isFavorite);
    this.isFavorite = !this.isFavorite;
    notifyListeners();
  }
}