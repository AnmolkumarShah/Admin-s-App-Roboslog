import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

import '../Provider/ProductProvider.dart';

class OrderCard extends StatefulWidget {
  final String uid;
  final double amount;
  final DateTime date;
  final int orderLength;
  final String orderId;
  final bool accepted;
  final bool rejected;
  final bool dispatched;

  OrderCard({
    this.uid,
    this.amount,
    this.date,
    this.orderId,
    this.orderLength,
    this.accepted,
    this.rejected,
    this.dispatched,
  });

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String _name = "Loading";
  Color _color;

  setData(BuildContext context, String uid) async {
    final data = await Provider.of<ProductProvider>(context).getUser(uid);
    setState(() {
      _name = data['username'];
    });
  }

  @override
  void initState() {
    RandomColor _randomColor = RandomColor();
    Color color = _randomColor.randomColor(
      colorHue: ColorHue.orange,
    );
    setState(() {
      _color = color;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setData(context, widget.uid);

    return Card(
      elevation: 0.0,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white70,
                _color,
                Colors.blue,
              ]),
        ),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    _name,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      size: 14,
                      color: Colors.white70,
                    ),
                    FittedBox(
                      child: Text(
                        "  Total Amount : ${widget.amount.toString()}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 14,
                      color: Colors.white70,
                    ),
                    FittedBox(
                      child: Text(
                        "  Placed on : ${DateFormat('dd MMMM yyyy').format(widget.date)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                Container(
                  width: 220,
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        size: 14,
                        color: Colors.white70,
                      ),
                      Text(
                        "    ${widget.orderId}",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.accepted == null && widget.rejected == null)
                  Text(
                    widget.orderLength.toString(),
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                if (widget.accepted == true)
                  Icon(
                    Icons.check_circle,
                    size: 60,
                  ),
                if (widget.rejected == true)
                  Icon(
                    Icons.phonelink_erase_rounded,
                    size: 60,
                  ),
                if (widget.dispatched == true)
                  Icon(
                    Icons.delivery_dining,
                    size: 60,
                  ),
                if (widget.accepted == null && widget.rejected == null)
                  widget.orderLength > 1 ? Text("items") : Text("item"),
                if (widget.accepted == true) Text("Accepted"),
                if (widget.dispatched == true) Text("& dispatched"),
                if (widget.rejected == true) Text("Rejected"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
