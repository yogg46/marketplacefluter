import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/category_screen/category_detail.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/consts/list.dart';
import 'package:marketplace/controllers/product_controller.dart';
import 'package:marketplace/widget_common/bag_widget.dart';




class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: categories.text.fontFamily(bold).make(),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: GridView.builder(
          shrinkWrap: true,
          itemCount: 9,  
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 200),
           itemBuilder: (context,index){
            return Column(
                 children: [
                  Image.asset(categoriesImage[index], width: 200, height: 120, fit: BoxFit.cover,),
                  10.heightBox,
                  categoriesList[index].text.color(darkFontGrey).align(TextAlign.center).make().onTap(() {
                    controller.getSubCategories(categoriesList[index]);
                    Get.to(()=> CategoryDetails(title: categoriesList[index]));
                  }), 
                  ],
            ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make();
          }),
        ),
      )
    );
  }
}