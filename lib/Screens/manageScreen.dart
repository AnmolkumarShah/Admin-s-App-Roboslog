import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Screens/EditScreen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/product_grid.dart';

class ManageScreen extends StatelessWidget {
  static const RouteName = "/manage-screen";

  @override
  Widget build(BuildContext context) {
    // final prodData = Provider.of<ProductProvider>(context).items;
    return Scaffold(
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditScreen.RouteName);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context).getAndSetProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ProductsGrid();
        },
      ),
    );
  }
}
