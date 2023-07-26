import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/controllers/auth_controller.dart';
import 'package:marketplace/home_screen/home.dart';
import '../consts/list.dart';
import '../widget_common/applogo.widget.dart';
import '../widget_common/bag_widget.dart';
import '../widget_common/custom_textfield.dart';
import '../widget_common/our_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  bool isPasswordVisible = false;
  bool isPasswordValid = true;
  bool isPasswordMatch = true;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Buat Akun  $appname".text.fontFamily(bold).white.size(18).make(),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      hint: nameHint,
                      title: name,
                      controller: nameController,
                      isPass: false,
                    ),
                    customTextField(
                      hint: emailHint,
                      title: email,
                      controller: emailController,
                      isPass: false,
                    ),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        customTextField(
                          hint: passwordHint,
                          title: password,
                          isPass: !isPasswordVisible,
                          controller: passwordController,
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isPasswordValid)
                      'Password harus 8-12 karakter'
                          .text
                          .color(Colors.red)
                          .make(),
                    customTextField(
                      hint: passwordHint,
                      title: retypePassword,
                      controller: passwordRetypeController,
                      isPass: !isPasswordVisible,
                    ),
                    if (!isPasswordMatch)
                      'Password harus sama'.text.color(Colors.red).make(),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue;
                            });
                          },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "Saya setuju dengan ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: termAndCond,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  ),
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  ),
                                ),
                                TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    5.heightBox,
                    //tombol
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : ourButton(
                            color: isCheck == true ? redColor : lightGrey,
                            title: signup,
                            textcolor: whiteColor,
                            onPress: () async {
                              if (passwordController.text.length >= 8 &&
                                  passwordController.text.length <= 12) {
                                isPasswordValid = true;
                                if (passwordController.text ==
                                    passwordRetypeController.text) {
                                  isPasswordMatch = true;
                                  controller.isloading(true);
                                  await controller
                                      .signupMethod(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  )
                                      .then((value) {
                                    return controller.storeUserData(
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text,
                                    );
                                  }).then((value) {
                                    VxToast.show(context, msg: loggindin);
                                    Get.offAll(() => const Home());
                                  });
                                } else {
                                  isPasswordMatch = false;
                                }
                              } else {
                                isPasswordValid = false;
                              }
                              setState(() {});
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        alredyHaveAccount.text.color(fontGrey).make(),
                        login.text.color(redColor).make().onTap(() {
                          Get.back();
                        })
                      ],
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(const EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
