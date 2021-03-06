import 'package:ethio_shoppers/ui/views/user_products/edit_product_screen.dart';
import 'package:flutter/material.dart';

class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteHandler;
  UserProductItemWidget(this.id, this.title, this.imageUrl, this.deleteHandler);

  @override
  Widget build(BuildContext context) {

    var messanger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await deleteHandler(id);
                }
                catch (err) {
                  messanger.showSnackBar(
                    SnackBar(
                      content: Text(err),
                      duration: const Duration(seconds: 1),));
                }
              },
              color: Theme.of(context).errorColor,)
          ],
        ),
      ),

    );
  }
}
