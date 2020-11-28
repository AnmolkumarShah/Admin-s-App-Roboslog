import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/order.dart';

class AdminProvider with ChangeNotifier {
  List<Map<String, dynamic>> getAllOrderData(BuildContext context) {
    final allOrderData = Provider.of<Order>(context).item();
    var Order_today = 0;
    double earning_today = 0;
    var Order_week = 0;
    double earning_week = 0;
    var Order_month = 0;
    double earning_month = 0;
    allOrderData.forEach(
      (element) {
        if (element.dateTime.day == DateTime.now().day) {
          Order_today++;
          earning_today += element.amount;
        }
      },
    );
    final prevSevenDay = DateTime.now().subtract(Duration(days: 7));
    allOrderData.forEach(
      (element) {
        if (element.dateTime.isAfter(prevSevenDay) &&
            element.dateTime.isBefore(DateTime.now())) {
          Order_week++;
          earning_week += element.amount;
        }
      },
    );
    allOrderData.forEach(
      (element) {
        if (element.dateTime.month == DateTime.now().month) {
          Order_month++;
          earning_month += element.amount;
        }
      },
    );
    final dataObject = [
      {
        'name': 'Orders',
        'data': {
          'today': Order_today,
          'week': Order_week,
          'month': Order_month,
        },
      },
      {
        'name': 'Earnings',
        'data': {
          'today': earning_today,
          'week': earning_week,
          'month': earning_month
        },
      },
    ];

    return dataObject;
  }

  Future<Map<String, dynamic>> maxItemCount() async {
    final res = await FirebaseFirestore.instance
        .collection('adminData')
        .doc("TSB06dHQbdvE2swBISrQ")
        .get();
    final Map<String, dynamic> data = res.data();
    return data;
    notifyListeners();
  }

  incrementCount(int prevCount) async {
    final res = await FirebaseFirestore.instance
        .collection('adminData')
        .doc("TSB06dHQbdvE2swBISrQ")
        .update({
      'maxItemCount': prevCount + 1,
    });
    notifyListeners();
  }

  decrementCount(int prevCount) async {
    final res = await FirebaseFirestore.instance
        .collection('adminData')
        .doc("TSB06dHQbdvE2swBISrQ")
        .update({
      'maxItemCount': prevCount - 1,
    });
    notifyListeners();
  }
}
