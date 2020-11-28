import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class DashboardCard extends StatefulWidget {
  final String name;
  final Map<String, dynamic> dataObject;
  DashboardCard({this.name, this.dataObject});

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      height: 270,
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: SingleCard(widget.dataObject['today'], 'Today')),
              Expanded(
                child: SingleCard(widget.dataObject['week'], "Last 7 Days"),
              ),
              Expanded(
                child: SingleCard(widget.dataObject['month'], "Month"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SingleCard extends StatefulWidget {
  final data;
  final String sub;
  SingleCard(this.data, this.sub);
  @override
  _SingleCardState createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
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
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Theme.of(context).primaryColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _color,
            Colors.orange[100],
            _color,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              widget.data.toString(),
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(widget.sub),
        ],
      ),
    );
  }
}
