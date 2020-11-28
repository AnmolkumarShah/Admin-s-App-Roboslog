import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  String uid;
  String email;
  String userImage;
  String userName;

  User({
    @required this.userName,
    @required this.userImage,
    @required this.uid,
    @required this.email,
  });
}

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users {
    return [..._users];
  }

  Future<void> setUsers() async {
    try {
      final res = await FirebaseFirestore.instance.collection('users').get();

      List<User> userList = res.docs
          .map(
            (e) => User(
              userName: e.data()['username'],
              userImage: e.data()['image_url'],
              uid: e.data()['userId'],
              email: e.data()['email'],
            ),
          )
          .toList();

      _users = userList;
      print(_users.length);
    } catch (error) {
      throw (error);
    }
  }
}
