import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Product.dart';
import '../Provider/ProductProvider.dart';
import '../Widgets/image_picker.dart';

class EditForm extends StatefulWidget {
  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  var _initialValue = {
    'description': "",
    'name': "",
    'price': "",
  };

  var _editedProduct = Product(
    id: null,
    description: "",
    name: "",
    price: null,
    images: "",
  );

  String _productName = '';
  String _productPrice = '';
  String _productDescription = '';
  File _userImages;
  var _isLoading = false;
  var _isInit = true;

  void _pickImage(File image) {
    _userImages = image;
    // print(_userImages.length);
  }

  final _prodPriceNode = FocusNode();
  final _prodDescNode = FocusNode();

  @override
  void dispose() {
    _prodPriceNode.dispose();
    _prodDescNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      print(productId);
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProvider>(context).findById(productId);
        _initialValue = {
          'description': _editedProduct.description,
          'name': _editedProduct.name,
          'price': _editedProduct.price.toString(),
          'imageUrl': "",
        };
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  void _trySubmitForm() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImages == null && _editedProduct.id == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick Some product Images!!"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();

      if (_editedProduct.id == null || _userImages != null) {
        var ref = FirebaseStorage.instance
            .ref()
            .child('product_images')
            .child(DateTime.now().toString() + '.jpg');
        await ref.putFile(_userImages).onComplete;
        final String url = await ref.getDownloadURL();

        _editedProduct = new Product(
          id: _editedProduct.id,
          description: _editedProduct.description,
          name: _editedProduct.name,
          price: _editedProduct.price,
          images: url,
        );
      }

      if (_editedProduct.id != null) {
        Provider.of<ProductProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        Provider.of<ProductProvider>(context, listen: false).addProduct(
          // Product(
          //   description: _productDescription,
          //   name: _productName,
          //   price: double.parse(_productPrice),
          //   images: url,
          //   id: DateTime.now().toString(),
          // ),
          _editedProduct,
        );
      }

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: 300,
              height: 100,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Please wait for the upload ...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: Card(
              elevation: 0,
              margin: EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty || value.length < 3) {
                              return "Please enter a valid Product Name.";
                            }
                            return null;
                          },
                          initialValue: _initialValue['name'],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_prodPriceNode);
                          },
                          onSaved: (newValue) {
                            _editedProduct = new Product(
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              name: newValue,
                              price: _editedProduct.price,
                              images: _editedProduct.images,
                            );
                          },
                          decoration: InputDecoration(
                            labelText: "Product Name",
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some product price.";
                            }
                            return null;
                          },
                          initialValue: _initialValue['price'],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_prodDescNode);
                          },
                          focusNode: _prodPriceNode,
                          onSaved: (newValue) {
                            _editedProduct = new Product(
                              id: _editedProduct.id,
                              description: _editedProduct.description,
                              name: _editedProduct.name,
                              price: double.parse(newValue),
                              images: _editedProduct.images,
                            );
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Product Price",
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return "Please enter long and good enough product description";
                            }
                            return null;
                          },
                          initialValue: _initialValue['description'],
                          onSaved: (newValue) {
                            _editedProduct = new Product(
                              id: _editedProduct.id,
                              description: newValue,
                              name: _editedProduct.name,
                              price: _editedProduct.price,
                              images: _editedProduct.images,
                            );
                          },
                          focusNode: _prodDescNode,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Product Description",
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ImgPicker(_pickImage),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: _trySubmitForm,
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
