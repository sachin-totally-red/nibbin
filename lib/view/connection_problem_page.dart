import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nibbin_app/view/splash_screen.dart';

class ConnectionProblemPage extends StatefulWidget {
  @override
  _ConnectionProblemPageState createState() => _ConnectionProblemPageState();
}

class _ConnectionProblemPageState extends State<ConnectionProblemPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.35,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/images/nibbin_logo.png',
                  height: MediaQuery.of(context).size.height * 77 / 640,
                  width: MediaQuery.of(context).size.width * 209 / 360,
                ),
                Text(
                  "Connection Problem!!\nPlease check your internet and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    height: 1.4,
                    fontSize:
                        ScreenUtil().setSp(16, allowFontScalingSelf: true),
                  ),
                ),
                ButtonTheme(
                  minWidth: 150,
                  height: 60,
                  child: FlatButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontSize:
                            ScreenUtil().setSp(16, allowFontScalingSelf: true),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
