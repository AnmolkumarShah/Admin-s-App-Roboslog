import 'package:admin_app/Provider/ProductProvider.dart';
import 'package:admin_app/Provider/order.dart';
import 'package:admin_app/Widgets/orderCard.dart';
import 'package:admin_app/Widgets/orderDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/userProvider.dart';

class Page3 extends StatefulWidget {
  const Page3({Key key}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

void openModal(
  BuildContext ctx,
  String oid,
  String name,
  String email,
  String addr1,
  String addr2,
  String state,
  String pincode,
  String uid,
  String thisId,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    context: ctx,
    builder: (context) {
      return Container(
        height: 600,
        padding: EdgeInsets.all(20),
        child: OrderDetails(
            oid, name, email, addr1, addr2, state, pincode, uid, thisId),
      );
    },
  );
}

class _Page3State extends State<Page3> {
  void openModal(
    BuildContext ctx,
    String oid,
    String name,
    String email,
    String addr1,
    String addr2,
    String state,
    String pincode,
    String uid,
    String thisId,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: ctx,
      builder: (context) {
        return Container(
          height: 600,
          padding: EdgeInsets.all(20),
          child: OrderDetails(
              oid, name, email, addr1, addr2, state, pincode, uid, thisId),
        );
      },
    );
  }

  int tabIndex = 0;
  List<Widget> listScreens;
  @override
  void initState() {
    super.initState();
    listScreens = [
      All(),
      Accepted(),
      Rejected(),
      Dispatched(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: tabIndex, children: listScreens),
      bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle:
              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          currentIndex: tabIndex,
          onTap: (int index) {
            setState(() {
              tabIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.store_mall_directory_sharp,
                color: Colors.black,
              ),
              label: 'All Orders',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle,
                color: Colors.black,
              ),
              label: 'Accepted',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.phonelink_erase_rounded,
                color: Colors.black,
              ),
              label: 'Rejected',
              backgroundColor: Theme.of(context).primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.delivery_dining,
                color: Colors.black,
              ),
              label: 'Dispatched',
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ]),
    );
    // );
    //
    //   FutureBuilder(
    //   future: Provider.of<Order>(context).getAndSetOrders(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //
    //     final userData =
    //         Provider.of<UserProvider>(context, listen: false).users;
    //     List<OrderItem> orders = Provider.of<Order>(context).item();
    //     // userData
    //     return ListView.builder(
    //       itemCount: orders.length,
    //       itemBuilder: (context, index) {
    //         return GestureDetector(
    //           onTap: () async {
    //             final data =
    //                 await Provider.of<ProductProvider>(context, listen: false)
    //                     .getUser(orders[index].userId);
    //             return openModal(
    //               context,
    //               orders[index].orderId,
    //               data['username'],
    //               data['email'],
    //               data['addr1'],
    //               data['addr2'],
    //               data['state'],
    //               data['pincode'],
    //               orders[index].userId,
    //               orders[index].thisId,
    //             );
    //           },
    //           child: OrderCard(
    //             orderId: orders[index].orderId,
    //             amount: orders[index].amount,
    //             date: orders[index].dateTime,
    //             orderLength: orders[index].products.length,
    //             uid: orders[index].userId,
    //             accepted: orders[index].accepted,
    //             rejected: orders[index].rejected,
    //             dispatched: orders[index].dispatched,
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }
}

class All extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Order>(context).getAndSetOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData =
            Provider.of<UserProvider>(context, listen: false).users;
        List<OrderItem> orders = Provider.of<Order>(context).item();
        // userData
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                final data =
                    await Provider.of<ProductProvider>(context, listen: false)
                        .getUser(orders[index].userId);
                return openModal(
                  context,
                  orders[index].orderId,
                  data['username'],
                  data['email'],
                  data['addr1'],
                  data['addr2'],
                  data['state'],
                  data['pincode'],
                  orders[index].userId,
                  orders[index].thisId,
                );
              },
              child: OrderCard(
                orderId: orders[index].orderId,
                amount: orders[index].amount,
                date: orders[index].dateTime,
                orderLength: orders[index].products.length,
                uid: orders[index].userId,
                accepted: orders[index].accepted,
                rejected: orders[index].rejected,
                dispatched: orders[index].dispatched,
              ),
            );
          },
        );
      },
    );
  }
}

class Accepted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Order>(context).getAndSetOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData =
            Provider.of<UserProvider>(context, listen: false).users;
        List<OrderItem> orders = Provider.of<Order>(context)
            .item()
            .where((element) => element.accepted == true)
            .toList();
        // userData
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                final data =
                    await Provider.of<ProductProvider>(context, listen: false)
                        .getUser(orders[index].userId);
                return openModal(
                  context,
                  orders[index].orderId,
                  data['username'],
                  data['email'],
                  data['addr1'],
                  data['addr2'],
                  data['state'],
                  data['pincode'],
                  orders[index].userId,
                  orders[index].thisId,
                );
              },
              child: OrderCard(
                orderId: orders[index].orderId,
                amount: orders[index].amount,
                date: orders[index].dateTime,
                orderLength: orders[index].products.length,
                uid: orders[index].userId,
                accepted: orders[index].accepted,
                rejected: orders[index].rejected,
                dispatched: orders[index].dispatched,
              ),
            );
          },
        );
      },
    );
  }
}

class Rejected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Order>(context).getAndSetOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData =
            Provider.of<UserProvider>(context, listen: false).users;
        List<OrderItem> orders = Provider.of<Order>(context)
            .item()
            .where((element) => element.rejected == true)
            .toList();
        // userData
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                final data =
                    await Provider.of<ProductProvider>(context, listen: false)
                        .getUser(orders[index].userId);
                return openModal(
                  context,
                  orders[index].orderId,
                  data['username'],
                  data['email'],
                  data['addr1'],
                  data['addr2'],
                  data['state'],
                  data['pincode'],
                  orders[index].userId,
                  orders[index].thisId,
                );
              },
              child: OrderCard(
                orderId: orders[index].orderId,
                amount: orders[index].amount,
                date: orders[index].dateTime,
                orderLength: orders[index].products.length,
                uid: orders[index].userId,
                accepted: orders[index].accepted,
                rejected: orders[index].rejected,
                dispatched: orders[index].dispatched,
              ),
            );
          },
        );
      },
    );
  }
}

class Dispatched extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Order>(context).getAndSetOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData =
            Provider.of<UserProvider>(context, listen: false).users;
        List<OrderItem> orders = Provider.of<Order>(context)
            .item()
            .where((element) => element.dispatched == true)
            .toList();
        // userData
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                final data =
                    await Provider.of<ProductProvider>(context, listen: false)
                        .getUser(orders[index].userId);
                return openModal(
                  context,
                  orders[index].orderId,
                  data['username'],
                  data['email'],
                  data['addr1'],
                  data['addr2'],
                  data['state'],
                  data['pincode'],
                  orders[index].userId,
                  orders[index].thisId,
                );
              },
              child: OrderCard(
                orderId: orders[index].orderId,
                amount: orders[index].amount,
                date: orders[index].dateTime,
                orderLength: orders[index].products.length,
                uid: orders[index].userId,
                accepted: orders[index].accepted,
                rejected: orders[index].rejected,
                dispatched: orders[index].dispatched,
              ),
            );
          },
        );
      },
    );
  }
}
