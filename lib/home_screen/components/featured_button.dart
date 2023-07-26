import 'package:get/get.dart';
import 'package:marketplace/category_screen/category_detail.dart';
import 'package:marketplace/consts/consts.dart';

Widget featuredButton({String? title, icon}){
  return Row(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill),
      10.heightBox,
      title!.text.fontFamily(semibold).color(darkFontGrey).make(),
    ],
  )
  
  .box
  .width(200)
  .margin(EdgeInsets.symmetric(horizontal: 4))
  .white.padding(const EdgeInsets.all(4))
  .roundedSM
  .outerShadowSm
  .make()
  .onTap(() { 
    Get.to(()=> CategoryDetails(title: title));
  });

}