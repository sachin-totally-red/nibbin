import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final Function onPressed;
  final Color borderColor;

  SignInButton(
      {@required this.imagePath,
      @required this.buttonText,
      @required this.onPressed,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width * 208 / 360,
      height: MediaQuery.of(context).size.height * 35 / 640,
      buttonColor: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
              color: borderColor != null ? borderColor : Colors.transparent)),
      child: RaisedButton(
        elevation: 0,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imagePath,
                height: 20.02,
                width: 20.02,
              ),
              SizedBox(
                width: 10.94,
              ),
              Text(
                buttonText,
                style: TextStyle(
                    color: Color(0xFF1A101F),
                    fontSize: 14,
                    letterSpacing: 0.14,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
