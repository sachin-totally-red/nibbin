import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SharingRepository {
  static Future shareOnTap(BuildContext context, {String content}) async {
    final RenderBox box = context.findRenderObject();
    Share.share(content,
        subject: "Nibbin",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
