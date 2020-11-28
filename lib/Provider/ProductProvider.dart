import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Provider/Product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  void delete(dynamic id) async {
    _items.removeWhere((element) => element.id == id);
    FirebaseFirestore.instance.collection('products').doc(id).delete();
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> getAndSetProducts() async {
    try {
      final res = await FirebaseFirestore.instance.collection('products').get();

      List<Product> fetchedItems = res.docs
          .map(
            (e) => Product(
              id: e.id,
              description: e['description'],
              name: e['name'],
              price: e['price'],
              images: e['imageUrl'],
            ),
          )
          .toList();

      _items = fetchedItems;
    } catch (error) {
      throw (error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<Map<String, dynamic>> getUser(String uid) async {
    final res =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return res.data();
  }

  Future<void> updateProduct(String productId, Product updatedProduct) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'name': updatedProduct.name,
      'price': updatedProduct.price,
      'description': updatedProduct.description,
      'imageUrl': updatedProduct.images,
    });
    final oldProductInItems =
        _items.firstWhere((element) => element.id == productId);
    final index = _items.indexOf(oldProductInItems);
    final newProduct = new Product(
      id: productId,
      description: updatedProduct.description,
      name: updatedProduct.name,
      price: updatedProduct.price,
      images: updatedProduct.images,
    );
    _items[index] = newProduct;
    notifyListeners();
  }

  Future<void> addProduct(Product newProd) async {
    final generatedId =
        await FirebaseFirestore.instance.collection('products').add({
      'name': newProd.name,
      'price': newProd.price,
      'description': newProd.description,
      'imageUrl': newProd.images,
    });
    _items.add(Product(
      id: generatedId.toString(),
      description: newProd.description,
      name: newProd.name,
      price: newProd.price,
      images: newProd.images,
    ));
    notifyListeners();
  }
}
