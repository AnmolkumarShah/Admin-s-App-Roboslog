import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  String images;

  Product({
    @required this.id,
    @required this.description,
    @required this.name,
    @required this.price,
    @required this.images,
  });
}
