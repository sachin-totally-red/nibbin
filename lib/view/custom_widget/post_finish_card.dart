import 'package:flutter/material.dart';
import 'package:nibbin_app/view/home_page.dart';

class NoPostLeftCard extends StatefulWidget {
  NoPostLeftCard({
    @required this.widget,
  });

  final HomePage widget;

  @override
  NoPostLeftCardState createState() => NoPostLeftCardState();
}

class NoPostLeftCardState extends State<NoPostLeftCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF1A101F),
      margin: EdgeInsets.only(bottom: 40, top: 20),
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/post_finish_icon.png',
            height: 211,
            width: 131,
          ),
          SizedBox(
            height: 17,
          ),
          Text(
            "Hey! You're all caught up for today!",
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                letterSpacing: 0.14,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Scroll down to look at older stories",
            style: TextStyle(
                color: Color(0xFFFFFFFF), letterSpacing: 0.12, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
