import 'package:ethio_shoppers/ui/views/products/products_grid.dart';
import 'package:flutter/material.dart';

class ProductsOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EthioShoppers"),
      ),
      body: ProductsGrid(),
    );
  }
}

