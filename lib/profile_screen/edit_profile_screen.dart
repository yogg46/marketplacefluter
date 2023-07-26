import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/auth_screen/login_screen.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/consts/list.dart';
import 'package:marketplace/controllers/auth_controller.dart';
import 'package:marketplace/controllers/profile_controller.dart';
import 'package:marketplace/profile_screen/detail_card.dart';
import 'package:marketplace/widget_common/bag_widget.dart';
import 'package:marketplace/widget_common/custom_textfield.dart';
import 'package:marketplace/widget_common/our_button.dart';



class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    // controller.nameController.text = data ['name'];
    // controller.passController.text = data ['password'];


    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Obx(
          () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            data['imageUrl'] == '' &&  
           controller.profileImgPath.isEmpty ? Image.asset(imgProfile2, width: 100, fit: BoxFit.cover).box.roundedFull.clip(Clip.antiAlias).make():
           data ['imageUrl'] != ''&& controller.profileImgPath.isEmpty ?
            Image.network(data ['imageUrl'], width: 100,
            fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make():
            Image.file(File(controller.profileImgPath.value),
              width: 70,
              fit: BoxFit.cover,
           ).box.roundedFull.clip(Clip.antiAlias).make(), 
            5.heightBox,
            ourButton(color: greenColor, onPress: (){
              controller.changeImage(context);
            }, textcolor: whiteColor, title: "Rubah"),
            const Divider(),
            10.heightBox,
            customTextField(
              controller: controller.nameController,
              hint: nameHint,title: name, isPass: false),
            10.heightBox,
            customTextField(
              controller: controller.oldpassController,
              hint: password,title: oldpass, isPass: true),
            10.heightBox,  
            customTextField(
              controller: controller.newpassController,
              hint: password,title: newpass, isPass: true),
            20.heightBox,
            controller.isloading.value ?  const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(greenColor),
            ): SizedBox(
              width: context.screenWidth - 60,
              child: ourButton(color: greenColor, onPress: () async {
                controller.isloading(true);

                if(controller.profileImgPath.value.isNotEmpty) {
                    await controller.uploadProfileImage();
                } else {
                  controller.profileImageLink = data['imageUrl'];
                }
                if (data['password'] == controller.oldpassController.text) {
                   await controller.changeAuthPassword(
                    email: data ['email'],
                    password: controller.oldpassController.text,
                    newpassword: controller.newpassController.text,
                   );
                   await controller.updateProfile(
                    imgUrl: controller.profileImageLink,
                    name: controller.nameController.text,
                    password: controller.newpassController.text
                );
                VxToast.show(context, msg: "Sukses");
                } else {
                  VxToast.show(context, msg: "Password Salah");
                  controller.isloading(false);
                }
              }, textcolor: whiteColor, title: "Simpan")),
          ],
          ).box.white.shadowSm.padding(EdgeInsets.all(16)).margin(EdgeInsets.only(top: 10, left: 12, right: 12 )).rounded.make(),
        ),
      )
    );
  }
}