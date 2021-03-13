import 'package:ethio_shoppers/core/providers/cart.dart';
import 'package:ethio_shoppers/core/providers/products.dart';
import 'package:ethio_shoppers/ui/views/cart/cart_screen.dart';
import 'package:ethio_shoppers/ui/views/products/badge.dart';
import 'package:ethio_shoppers/ui/views/products/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions{
  All,
  Favorites
}

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EthioShoppers"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                switch(selectedValue) {
                  case (FilterOptions.All):
                    _showOnlyFavorites = false;
                    break;
                  case (FilterOptions.Favorites):
                    _showOnlyFavorites = true;
                    break;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show all"),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text("Only Favorites"),
                value: FilterOptions.Favorites,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, _child) => Badge(
              child: _child,
              value: cart.itemCount.toString() ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

