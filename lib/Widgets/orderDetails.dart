import 'package:admin_app/Provider/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  final String id;
  final String name;
  final String email;
  final String addr1;
  final String addr2;
  final String state;
  final String pincode;
  final String uid;
  final String thisId;
  OrderDetails(
    this.id,
    this.name,
    this.email,
    this.addr1,
    this.addr2,
    this.state,
    this.pincode,
    this.uid,
    this.thisId,
  );
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<DateTime> datePicker(BuildContext ctx) async {
    return showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, 1),
      lastDate: DateTime.now().add(Duration(days: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrderItem OrderData =
        Provider.of<Order>(context).getOrderById(widget.id);
    print(OrderData.dispatched);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.horizontal_rule_rounded,
                size: 40,
              ),
            ],
          ),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            widget.email,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          Divider(thickness: 3),
          Text(widget.addr1),
          Text(widget.addr2),
          Text(widget.state),
          Text(widget.pincode),
          Divider(thickness: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Accept Order"),
              RaisedButton(
                onPressed: () async {
                  await Provider.of<Order>(context, listen: false).accepedOrder(
                    widget.uid,
                    widget.id,
                    DateTime.now(),
                    widget.thisId,
                  );
                  Navigator.of(context).pop();
                },
                color: OrderData.accepted == true
                    ? Colors.blueAccent
                    : Colors.grey,
                child: OrderData.accepted != null && OrderData.accepted == true
                    ? Text("Order Accepted")
                    : Text("Accept Order ?"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reject Order"),
              RaisedButton(
                onPressed: () async {
                  await Provider.of<Order>(context, listen: false).rejectOrder(
                    widget.uid,
                    widget.id,
                    widget.thisId,
                  );
                  Navigator.of(context).pop();
                },
                color:
                    OrderData.rejected == true ? Colors.redAccent : Colors.grey,
                child: OrderData.rejected != null && OrderData.rejected == true
                    ? Text("Order Rejected")
                    : Text("Reject  Order ?"),
              ),
            ],
          ),
          Divider(thickness: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (OrderData.expectedDateofDelivery == null)
                Text("Expected Date of Delivery"),
              OrderData.expectedDateofDelivery != null
                  ? Text(
                      "Delivery set to ${DateFormat('dd MMMM yyyy').format(OrderData.expectedDateofDelivery)}")
                  : Text("Not Set"),
              IconButton(
                icon: Icon(Icons.calendar_today_outlined),
                onPressed: () async {
                  var data = await datePicker(context);
                  await Provider.of<Order>(context, listen: false)
                      .setExpectedDate(
                    widget.uid,
                    widget.id,
                    data,
                    widget.thisId,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Divider(thickness: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Dispatched"),
                color: OrderData.dispatched == true
                    ? Colors.blueAccent
                    : Colors.grey,
                onPressed: () async {
                  await Provider.of<Order>(context, listen: false)
                      .setDispatched(
                    widget.uid,
                    widget.id,
                    widget.thisId,
                    true,
                  );
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                width: 20,
              ),
              RaisedButton(
                child: Text("Delete Dispatched"),
                color: OrderData.dispatched == false
                    ? Colors.blueAccent
                    : Colors.grey,
                onPressed: () async {
                  await Provider.of<Order>(context, listen: false)
                      .setDispatched(
                    widget.uid,
                    widget.id,
                    widget.thisId,
                    false,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Divider(thickness: 3),
          Text(
            "Items",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
            height: OrderData.products.length * 100.0,
            child: ListView.builder(
              itemCount: OrderData.products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  subtitle: Text(
                      "Each Item for ${OrderData.products[index].price.toString()}"),
                  title: Text(OrderData.products[index].title),
                  trailing: Text(
                      " X ${OrderData.products[index].quantity.toString()}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
