import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class OrderItem {
  final String orderId;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String userId;
  final String thisId;
  final bool accepted;
  final bool rejected;
  final bool dispatched;
  final DateTime expectedDateofDelivery;

  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.orderId,
    @required this.products,
    @required this.userId,
    @required this.thisId,
    @required this.accepted,
    @required this.rejected,
    @required this.dispatched,
    @required this.expectedDateofDelivery,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _item = [];

  // List<User> userData

  List<OrderItem> item() {
    return [..._item];
  }

  OrderItem getOrderById(String id) {
    return _item.firstWhere((element) => element.orderId == id);
  }

  Future<void> setExpectedDate(
    String uid,
    String oid,
    DateTime expedtedDate,
    String thisId,
  ) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(uid)
        .collection('user_orders')
        .doc(oid)
        .update({
      "expectedDelivery": expedtedDate.toIso8601String(),
    });

    await FirebaseFirestore.instance
        .collection('orders_all')
        .doc(thisId)
        .update({
      "expectedDelivery": expedtedDate.toIso8601String(),
    });

    notifyListeners();
  }

  Future<void> setDispatched(
    String uid,
    String oid,
    String thisId,
    bool value,
  ) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(uid)
        .collection('user_orders')
        .doc(oid)
        .update({
      "dispatched": value,
    });

    await FirebaseFirestore.instance
        .collection('orders_all')
        .doc(thisId)
        .update({
      "dispatched": value,
    });

    notifyListeners();
  }

  Future<void> accepedOrder(
    String uid,
    String oid,
    DateTime expedtedDate,
    String thisId,
  ) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(uid)
        .collection('user_orders')
        .doc(oid)
        .update({
      "accepted": true,
      "rejected": false,
    });

    await FirebaseFirestore.instance
        .collection('orders_all')
        .doc(thisId)
        .update({
      "accepted": true,
      "rejected": false,
    });

    notifyListeners();
  }

  Future<void> rejectOrder(
    String uid,
    String oid,
    String thisId,
  ) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(uid)
        .collection('user_orders')
        .doc(oid)
        .update({
      "accepted": false,
      "rejected": true,
      "dispatched": null,
      "expectedDelivery": null,
    });

    await FirebaseFirestore.instance
        .collection('orders_all')
        .doc(thisId)
        .update({
      "accepted": false,
      "rejected": true,
      "dispatched": null,
      "expectedDelivery": null,
    });
    notifyListeners();
  }

  Future<void> getAndSetOrders() async {
    try {
      final res =
          await FirebaseFirestore.instance.collection('orders_all').get();

      List<OrderItem> fetchedItems = res.docs
          .map(
            (e) => OrderItem(
              amount: e['amount'],
              dateTime: DateTime.parse(e['dateTime']),
              orderId: e['order_id'],
              userId: e['user_id'],
              thisId: e.id,
              accepted: e['accepted'],
              rejected: e['rejected'],
              dispatched: e['dispatched'],
              expectedDateofDelivery: e['expectedDelivery'] != null
                  ? DateTime.parse(e['expectedDelivery'])
                  : null,
              products: (e['products'] as List<dynamic>)
                  .map(
                    (data) => CartItem(
                      id: data['id'],
                      price: data['price'],
                      quantity: data['quantity'],
                      title: data['title'],
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      _item = fetchedItems;
    } catch (error) {
      throw (error);
    }
    return;
  }
}
