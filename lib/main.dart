import 'package:ethio_shoppers/core/providers/cart.dart';
import 'package:ethio_shoppers/core/providers/products.dart';
import 'package:ethio_shoppers/ui/views/cart/cart_screen.dart';
import 'package:ethio_shoppers/ui/views/detail/product_detail_screen.dart';
import 'package:ethio_shoppers/ui/views/home/home_page.dart';
import 'package:ethio_shoppers/ui/views/products/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(EthioShoppers());
}

class EthioShoppers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => Products()),
        ChangeNotifierProvider( create: (_) => Cart()),
      ],
      child: MaterialApp(
        title: "EthioShoppers",
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
        ),
        routes: {
          '/': (_) => ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
        }

      ),
    );
  }
}

