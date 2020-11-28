import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';
import '../Screens/EditScreen.dart';
import '../Screens/ProductDetailsScreen.dart';

class ProductItem extends StatelessWidget {
  final imageUrl;
  final String title;
  final double price;
  final String id;
  ProductItem({
    this.id,
    this.imageUrl,
    this.price,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetail.RouteName,
            arguments: id,
          );
        },
        child: GridTile(
          child: Hero(
            tag: id,
            child: FadeInImage(
              placeholder: AssetImage('Asset/Images/placeholder.png'),
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              color: Theme.of(context).accentColor,
              icon: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("Are you sure?"),
                      title: Text("Do you want to delete this Product!"),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Provider.of<ProductProvider>(context, listen: false)
                                .delete(id);
                            Navigator.of(context).pop();
                          },
                          child: Text("Yes!"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("No"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditScreen.RouteName, arguments: id);
              },
            ),
          ),
        ),
      ),
    );
  }
}
