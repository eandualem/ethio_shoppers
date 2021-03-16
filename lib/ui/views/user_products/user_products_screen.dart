import 'package:ethio_shoppers/core/providers/products.dart';
import 'package:ethio_shoppers/ui/views/home/app_drawer.dart';
import 'package:ethio_shoppers/ui/views/user_products/edit_product_screen.dart';
import 'package:ethio_shoppers/ui/views/user_products/user_product_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async =>
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct(filterByUser: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState== ConnectionState.waiting?
        Center(
          child: CircularProgressIndicator(),
        ) :RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<Products>(
            builder:(ctx, productsData, child) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (ctx, index) => Column(
                    children: [
                      UserProductItemWidget(productsData.items[index].id, productsData.items[index].title, productsData.items[index].imageUrl, productsData.deleteProduct),
                      Divider()
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
