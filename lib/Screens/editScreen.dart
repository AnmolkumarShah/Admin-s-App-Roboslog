import 'package:flutter/material.dart';

// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

import '../Widgets/editForm.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key key}) : super(key: key);
  static const RouteName = '/edit-screen';
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  //final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final prod = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: prod != null ? Text("Edit Product") : Text("Add Product"),
      ),
      body: EditForm(),
    );
  }
}
