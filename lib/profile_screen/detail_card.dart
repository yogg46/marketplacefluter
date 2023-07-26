import 'package:flutter/material.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/widget_common/bag_widget.dart';

Widget detailsCard({width,String? count, String? title} ){
  return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                count!.text.fontFamily(bold).color(darkFontGrey).size(12).make(),
                5.heightBox,
                title!.text.fontFamily(bold).color(darkFontGrey).make(),
              ],
            ).box.white.rounded.width(130).height(80).padding(EdgeInsets.all(4)).make();
}