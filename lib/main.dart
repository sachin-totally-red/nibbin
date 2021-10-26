import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nibbin_app/view/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nibbin App',
      theme: ThemeData(
          fontFamily: GoogleFonts.roboto().fontFamily,
          appBarTheme: AppBarTheme(
            color: Color(0xFF1A101F),
          )),
      home: SplashScreen(),
    );
  }
}
