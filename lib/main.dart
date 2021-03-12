import 'package:ethio_shoppers/core/providers/products.dart';
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
    return ChangeNotifierProvider(
      create: (_) => Products(),
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
        }

      ),
    );
  }
}

