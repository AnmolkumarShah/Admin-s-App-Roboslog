import 'package:admin_app/Screens/ControlScreen.dart';
import 'package:flutter/material.dart';

import './manageScreen.dart';
import './page2.dart';
import './page3.dart';
import '../Widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Colors.white54,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(Icons.settings),
                text: "Controls",
              ),
              Tab(
                icon: Icon(Icons.storefront),
                text: "All Products",
              ),
              Tab(
                icon: Icon(Icons.supervisor_account_outlined),
                text: "All Orders",
              ),
              Tab(
                icon: Icon(Icons.star_border_purple500_sharp),
                text: "All Customers",
              ),
            ],
          ),
          title: Text("Admin's App"),
        ),
        body: TabBarView(
          children: [
            ControlScreen(),
            ManageScreen(),
            Page3(),
            Page2(),
          ],
        ),
      ),
    );
  }
}
