import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Color(0xFF1A101F),
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            title: Text(
              "Privacy",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            leading: IconButton(
              icon: ImageIcon(
                AssetImage(
                  "assets/images/back_arrow.png",
                ),
                size: ScreenUtil().setSp(14, allowFontScalingSelf: true),
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Card(
            margin: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(16),
              child: Stack(
                children: [
                  WebView(
                    initialUrl: Constants.privacyPolicyUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Stack(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
