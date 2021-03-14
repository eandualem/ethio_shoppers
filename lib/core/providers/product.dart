import 'package:ethio_shoppers/core/services/products_service.dart';
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  ProductsService productsService = ProductsService();

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

  void toggleIsFavoriteStatus(){
    productsService.setFavorite(id, !isFavorite);
    this.isFavorite = !this.isFavorite;
    notifyListeners();
  }
}