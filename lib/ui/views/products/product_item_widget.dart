import 'package:ethio_shoppers/core/providers/auth.dart';
import 'package:ethio_shoppers/core/providers/cart.dart';
import 'package:ethio_shoppers/core/providers/product.dart';
import 'package:ethio_shoppers/ui/views/detail/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItemWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context, listen: false);
    Cart cart = Provider.of<Cart>(context, listen: false);
    var authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage("assets/images/product-placeholder.png"),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          )
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product> ( // The whole app will not rebuild.
            builder: (context, _product, child) => IconButton(
              icon: Icon( _product.isFavorite ? Icons.favorite: Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: (){_product.toggleIsFavoriteStatus(authData.token, authData.userId);},
            ),
          ),
          title: Text(product.title,
            textAlign: TextAlign.center,),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: (){
              Scaffold.of(context).hideCurrentSnackBar();
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Hello"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: (){
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
