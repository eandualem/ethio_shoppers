import 'package:ethio_shoppers/ui/views/home/home_page.dart';
import 'package:ethio_shoppers/ui/views/products/products_overview_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EthioShoppers());
}

class EthioShoppers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EthioShoppers",
      theme: ThemeData(

      ),
      routes: {
        '/': (_) => ProductsOverviewScreen(),
      }

    );
  }
}

