import 'package:flutter/services.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/widget_common/our_button.dart';

Widget exitDialog (context){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        "Konfirmasi".text.fontFamily(semibold).size(16).color(darkFontGrey).make(),
        const Divider(),
        5.heightBox,
        "Keluar".text.size(16).fontFamily(semibold).color(darkFontGrey).make(),
        10.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ourButton(color: greenColor,onPress: (){SystemNavigator.pop();},textcolor: whiteColor, title: "Iya"),
            ourButton(color: greenColor,onPress: (){Navigator.pop(context);},textcolor: whiteColor, title: "Tidak"),
          ],
        )
      ],
    ).box.color(lightGrey).padding(EdgeInsets.all(12)).roundedSM.make()


  );

}