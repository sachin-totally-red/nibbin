import 'package:flutter/material.dart';
import 'package:nibbin_app/view/custom_widget/custom_radio.dart';
import 'package:nibbin_app/view/custom_widget/report_news.dart';

class MoreInfoReportingTile extends StatefulWidget {
  final String title;
  final String subTitle;
  final String radioValue;
  MoreInfoReportingTile({
    this.title,
    this.subTitle,
    this.radioValue,
  });

  @override
  _MoreInfoReportingTileState createState() => _MoreInfoReportingTileState();
}

class _MoreInfoReportingTileState extends State<MoreInfoReportingTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomRadio(
                toggleable: true,
                value: widget.radioValue,
                groupValue: groupID,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  selectedSubTypeID = int.parse(value);
                  detailedReportNewsPageState.setState(() {
                    groupID = value;
                  });
                },
                activeColor: Color(0xFFF35F5F),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A101F),
                          letterSpacing: 0.14,
                          height: 1.5,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
              ),
              Flexible(
                child: Text(
                  widget.subTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF636976),
                      letterSpacing: 0.4,
                      height: 1.3,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
