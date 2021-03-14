import 'package:ethio_shoppers/core/providers/product.dart';
import 'package:ethio_shoppers/core/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct;
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    "title":"",
    "description":"",
    "price":"",
    "imageUrl":""
  };


  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  void _updateImageUrl() {
    if( !_imageUrlFocusNode.hasFocus) setState(() {});
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          "title":_editedProduct.title,
          "description":_editedProduct.description,
          "price":_editedProduct.price.toString(),
          "imageUrl":_editedProduct.imageUrl
        };
        _imageUrlController.text = _initValues["imageUrl"]; // if there is controller we can't set init value.
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) return;
    _form.currentState.save();
    setState(() => _isLoading = true);

    if(_editedProduct != null) {
      _editedProduct = Product(
          id: _editedProduct.id,
          title: _initValues["title"],
          description: _initValues["description"],
          price: double.parse(_initValues["price"]),
          imageUrl: _initValues["imageUrl"],
          isFavorite: _editedProduct.isFavorite
      );
      await Provider.of<Products>(context, listen: false).editProduct(_editedProduct);
    }
    else{
      _editedProduct = Product(
          id: null,
          title: _initValues["title"],
          description: _initValues["description"],
          price: double.parse(_initValues["price"]),
          imageUrl: _initValues["imageUrl"]);

      await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
                onPressed: _saveForm)
          ],
      ),
      body: _isLoading? Center(
        child: CircularProgressIndicator(),
      ) :Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
              initialValue: _initValues["title"],
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_priceFocusNode),
              validator: (value) {
                if( value.isEmpty ) return "Please provide a value.";
                return null;
              },
              onSaved: (value)=> _initValues["title"] = value,
            ),
            TextFormField(
              initialValue: _initValues["price"],
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
              validator: (value) {
                if( value.isEmpty ) return "Please enter price.";
                if( double.tryParse(value) == null) return "Please enter valid number";
                if( double.parse(value) <= 0) return "Please enter number greater than 0";
                return null;
              },
              onSaved: (value)=> _initValues["price"] = value,
            ),
            TextFormField(
              initialValue: _initValues["description"],
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if( value.isEmpty ) return "Please enter a description.";
                return null;
              },
              onSaved: (value)=> _initValues["description"] = value,
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8, right: 10),
                decoration: BoxDecoration(border: Border.all(
                  width: 1,
                  color: Colors.grey
                )),
                child: _imageUrlController.text.isEmpty ? Text("Enter a URL"): FittedBox(
                  child: Image.network(_imageUrlController.text, fit: BoxFit.cover,),),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  validator: (value) {
                    if( value.isEmpty ) return "Please enter an image url.";
                    if( !value.startsWith("http") || !value.startsWith("https") ) return "Please enter valid url.";
                    if( !value.endsWith(".png") && !value.endsWith(".jpg") && !value.endsWith(".jpeg") ) return "Please enter valid image url.";
                    return null;
                  },
                  onSaved: (value)=> _initValues["imageUrl"] = value,
                  onFieldSubmitted: (value){_saveForm();},

                ),
              ),
            ],
            )
          ],),
        ),
      ),
    );
  }
}
