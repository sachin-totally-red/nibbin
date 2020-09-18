import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerOption extends StatelessWidget {
  final Size screenSize;
  final String imagePath;
  final String optionName;
  final Function onTap;
  final Widget trailingWidget;
  final double imageHeight;
  final double imageWidth;
  final double space;

  DrawerOption(
      {@required this.screenSize,
      @required this.imagePath,
      @required this.optionName,
      @required this.onTap,
      this.trailingWidget,
      @required this.imageHeight,
      @required this.imageWidth,
      @required this.space});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
          top: 0,
          left: 16,
          right: 10,
          bottom: (screenSize.height > 700.0) ? 6 : 0),
      trailing: trailingWidget,
      title: Row(
        children: [
          Image.asset(
            imagePath,
            height: screenSize.height * imageHeight / 640,
            width: screenSize.width * imageWidth / 360,
          ),
          SizedBox(
            width: space,
          ),
          Text(
            optionName,
            //ToDo: Update this styling
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12, allowFontScalingSelf: true),
              color: Color(0xFF111111),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.14,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
