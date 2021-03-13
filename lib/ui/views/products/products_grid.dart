import 'package:ethio_shoppers/core/providers/products.dart';
import 'package:ethio_shoppers/ui/views/products/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductsGrid extends StatelessWidget {

  final bool _showOnlyFavorites;
  ProductsGrid(this._showOnlyFavorites);

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<Products>(context);
    final products = _showOnlyFavorites ? productsData.favoriteItems :productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2/3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10
        ),
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              // id: products[index].id,
              // title: products[index].title,
              // imageUrl: products[index].imageUrl
          ),
        ));
  }
}
