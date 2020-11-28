import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class UserCard extends StatelessWidget {
  final String email;
  final String uid;
  final String username;
  final String image;

  UserCard({
    this.uid,
    this.email,
    this.image,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
      colorHue: ColorHue.blue,
    );
    return GridTile(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 70,
          ),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          username,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
