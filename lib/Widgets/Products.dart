import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsOverview extends StatelessWidget {
  const ProductsOverview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final productDocs = snapshot.data.docs;
        return ProductItemView(productDocs: productDocs);
      },
    );
  }
}

class ProductItemView extends StatelessWidget {
  const ProductItemView({
    Key key,
    @required this.productDocs,
  }) : super(key: key);

  final productDocs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productDocs.length,
      itemBuilder: (ctx, i) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(productDocs[i]['imageUrl']),
        ),
        title: Text(productDocs[i]['name']),
        subtitle: Text(productDocs[i]['price'].toString()),
        trailing: Container(
          width: 100,
          child: IconButton(
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
                        print(productDocs[i].documentID);
                        FirebaseFirestore.instance
                            .collection('products')
                            .doc(productDocs[i].documentID)
                            .delete();

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
      ),
    );
  }
}
