import 'package:ethio_shoppers/core/providers/auth.dart';
import 'package:ethio_shoppers/core/providers/cart.dart';
import 'package:ethio_shoppers/core/providers/orders.dart';
import 'package:ethio_shoppers/core/providers/products.dart';
import 'package:ethio_shoppers/ui/views/auth/auth_screen.dart';
import 'package:ethio_shoppers/ui/views/cart/cart_screen.dart';
import 'package:ethio_shoppers/ui/views/detail/product_detail_screen.dart';
import 'package:ethio_shoppers/ui/views/home/home_page.dart';
import 'package:ethio_shoppers/ui/views/orders/orders_screen.dart';
import 'package:ethio_shoppers/ui/views/products/products_overview_screen.dart';
import 'package:ethio_shoppers/ui/views/user_products/edit_product_screen.dart';
import 'package:ethio_shoppers/ui/views/user_products/user_products_screen.dart';
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
        ChangeNotifierProvider( create: (_) => Auth()),
        ChangeNotifierProvider( create: (_) => Products()),
        ChangeNotifierProvider( create: (_) => Cart()),
        ChangeNotifierProvider( create: (_) => Orders()),
      ],
      child: MaterialApp(
        title: "EthioShoppers",
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
        ),
        routes: {
          '/': (_) => AuthScreen(),
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
          UserProductsScreen.routeName: (_) => UserProductsScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen()
        }

      ),
    );
  }
}

