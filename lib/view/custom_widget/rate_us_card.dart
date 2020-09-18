import 'package:flutter/material.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/resource/app_rating.dart';
import 'package:nibbin_app/view/home_page.dart';

int tappedStar = 0;
RateUsCardState _rateUsCardState;

class RateUsCard extends StatefulWidget {
  RateUsCard({
    @required this.widget,
  });

  final HomePage widget;

  @override
  RateUsCardState createState() => RateUsCardState();
}

class RateUsCardState extends State<RateUsCard> {
  @override
  Widget build(BuildContext context) {
    _rateUsCardState = this;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 35,
          ),
          Image.asset(
            'assets/images/rate_us_icon.png',
            height: 199,
            width: 135,
          ),
          SizedBox(
            height: 28,
          ),
          Text(
            "Rate Your Experience",
            style: TextStyle(
                color: Color(0xFF111111),
                letterSpacing: 0.16,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Let us know how we can improve",
            style: TextStyle(
              color: Color(0xFF707070),
              letterSpacing: 0.14,
            ),
          ),
          SizedBox(
            height: 28,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getStarRatingCardRow(star: tappedStar)),
          SizedBox(
            height: 44,
          ),
        ],
      ),
    );
  }
}

getStarRatingCardRow({int star = 0}) {
  List<Widget> starList = List<Widget>();
  for (int i = 0; i < 5; i++) {
    starList.add(InkWell(
      onTap: () async {
        _rateUsCardState.setState(() {
          tappedStar = i + 1;
        });

        Future.delayed(Duration(seconds: 1), () {
          AppRatingRepository.rateApp(
              Constants.rateMyApp, _rateUsCardState.context,
              rating: (i + 1).toDouble());
        });
      },
      child: Image.asset(
        'assets/images/${star <= i ? "star_white" : "star_colored"}.png',
        height: 25,
        width: 24,
      ),
    ));
    starList.add(SizedBox(
      width: 10,
    ));
  }
  return starList;
}
