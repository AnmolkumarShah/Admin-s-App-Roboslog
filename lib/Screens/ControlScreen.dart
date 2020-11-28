import 'package:admin_app/Provider/order.dart';
import 'package:admin_app/Widgets/dashboardCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

import '../Provider/adminProvider.dart';

class ControlScreen extends StatefulWidget {
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  Color _color;
  @override
  void initState() {
    RandomColor _randomColor = RandomColor();
    Color color = _randomColor.randomColor(
      colorHue: ColorHue.blue,
    );
    setState(() {
      _color = color;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: Provider.of<Order>(context).getAndSetOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final adminData =
            Provider.of<AdminProvider>(context).getAllOrderData(context);
        return InkWell(
          splashColor: Colors.redAccent[300],
          radius: 20,
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                InkWell(
                  splashColor: Colors.blue[100],
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    height: 80,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.orange[100], _color],
                      ),
                      // color: _color,
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 200,
                        child: Text(
                          "Max. number of item customers can order",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      trailing: Container(
                        width: 210,
                        child: FutureBuilder(
                          future: Provider.of<AdminProvider>(context)
                              .maxItemCount(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: Colors.blue, // button color
                                    child: InkWell(
                                      splashColor: Colors.red, // inkwell color
                                      child: SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: new Icon(
                                          Icons.arrow_left,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                      onTap: () {
                                        Provider.of<AdminProvider>(context,
                                                listen: false)
                                            .decrementCount(
                                                snapshot.data['maxItemCount']);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: new Text(
                                      snapshot.data['maxItemCount'].toString(),
                                      style: new TextStyle(fontSize: 20.0)),
                                ),
                                ClipOval(
                                  child: Material(
                                    color: Colors.blue, // button color
                                    child: InkWell(
                                      splashColor: Colors.red, // inkwell color
                                      child: SizedBox(
                                        width: 36,
                                        height: 36,
                                        child: new Icon(
                                          Icons.arrow_right,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                      onTap: () {
                                        Provider.of<AdminProvider>(context,
                                                listen: false)
                                            .incrementCount(
                                                snapshot.data['maxItemCount']);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: adminData.length,
                    itemBuilder: (context, index) => DashboardCard(
                      name: adminData[index]['name'],
                      dataObject: adminData[index]['data'],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ));
  }
}
