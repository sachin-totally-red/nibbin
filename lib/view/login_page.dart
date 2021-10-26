import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nibbin_app/common/constants.dart';
import 'package:nibbin_app/resource/login_repository.dart';
import 'package:nibbin_app/view/apple_sign_in.dart';
import 'package:nibbin_app/view/custom_widget/progress_indicator.dart';
import 'package:nibbin_app/view/custom_widget/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  final Size screenSize;
  final GlobalKey<ScaffoldState> pageScaffoldKey;

  LoginPage({@required this.screenSize, this.pageScaffoldKey});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showLoader = false;

  @override
  void initState() {
    Constants.rateMyApp.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000),
      child: SafeArea(
        bottom: false,
        child: CustomProgressIndicator(
          inAsyncCall: _showLoader,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              leading: Container(),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/images/close_circle_icon.png',
                    height: 19.81,
                    width: 19.81,
                  ),
                ),
                SizedBox(
                  width: 18,
                ),
              ],
            ),
            body: Container(
              color: Color(0xFF1A101F),
              child: Center(
                child: Container(
                  color: Color(0xFF1A101F),
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Image.asset(
                          'assets/images/nibbin_logo_white.png',
                          height: MediaQuery.of(context).size.height * 77 / 640,
                          width: MediaQuery.of(context).size.width * 209 / 360,
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Image.asset(
                          'assets/images/login_page_icon.png',
                          height:
                              MediaQuery.of(context).size.height * 192 / 640,
                          width: MediaQuery.of(context).size.width * 181 / 360,
                        ),
                        SizedBox(
                          height: 38,
                        ),
                        Text(
                          "Connect your account to Bookmark stories.",
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              letterSpacing: 0.14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "(Or you’d see Emily’s bookmarks too.)",
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 14,
                              letterSpacing: 0.14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 38,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 76 / 360),
                          child: Column(
                            children: [
                              SignInButton(
                                imagePath: 'assets/images/google_icon.png',
                                buttonText: "Continue with Google",
                                onPressed: () async {
                                  setState(() {
                                    _showLoader = true;
                                  });
                                  bool result = await LoginRepository.signIn(
                                      context: context,
                                      screenSize: widget.screenSize,
                                      scaffoldKey: _scaffoldKey);
                                  setState(() {
                                    _showLoader = false;
                                  });
                                  if (result) {
                                    Navigator.pop(context);
                                    if (widget.pageScaffoldKey != null)
                                      widget.pageScaffoldKey.currentState
                                          .showSnackBar(
                                              Constants.showSuccessfulLogin());
                                  }
                                },
                              ),
                              if (Platform.isIOS)
                                SizedBox(
                                  height: 12,
                                ),
                              if (Platform.isIOS)
                                SignInButton(
                                  imagePath: 'assets/images/apple_logo.png',
                                  buttonText: "Continue with Apple",
                                  onPressed: () async {
                                    setState(() {
                                      _showLoader = true;
                                    });

                                    bool response = await appleSignIn(
                                        context: context,
                                        scaffoldKey: _scaffoldKey);
                                    setState(() {
                                      _showLoader = false;
                                    });
                                    if (response == null) {
                                      Navigator.pop(context);
                                      widget.pageScaffoldKey.currentState
                                          .showSnackBar(
                                              Constants.showCustomSnackBar(
                                                  errorText:
                                                      "Your device doesn't support this feature."));
                                      return;
                                    }
                                    if (response) {
                                      Navigator.pop(context);
                                      widget.pageScaffoldKey.currentState
                                          .showSnackBar(
                                              Constants.showSuccessfulLogin());
                                    }
                                  },
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
