import 'package:admin_app/Widgets/userCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/userProvider.dart';

class Page2 extends StatelessWidget {
  const Page2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<UserProvider>(context).setUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<User> UserList = Provider.of<UserProvider>(context).users;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: UserList.length,
            itemBuilder: (context, index) => UserCard(
              email: UserList[index].email,
              image: UserList[index].userImage,
              uid: UserList[index].uid,
              username: UserList[index].userName,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.78,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        },
      ),
    );
  }
}
