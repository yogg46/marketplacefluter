import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:marketplace/auth_screen/signup_screen.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/controllers/auth_controller.dart';
import 'package:marketplace/home_screen/home.dart';
import '../consts/list.dart';
import '../widget_common/applogo.widget.dart';
import '../widget_common/bag_widget.dart';
import '../widget_common/custom_textfield.dart';
import '../widget_common/our_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isPasswordValid = true;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogoWidget(),
                10.heightBox,
                "Log in to $appname"
                    .text
                    .fontFamily(bold)
                    .white
                    .size(18)
                    .make(),
                15.heightBox,
                Obx(
                  () => Column(
                    children: [
                      customTextField(
                        hint: emailHint,
                        title: email,
                        isPass: false,
                        controller: controller.emailController,
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          customTextField(
                            hint: passwordHint,
                            title: password,
                            isPass: !isPasswordVisible,
                            controller: controller.passwordController,
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
                        'Password must be 8-12 characters long'
                            .text
                            .color(Colors.red)
                            .make(),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {},
                      //     child: forgetPass.text.make(),
                      //   ),
                      // ),
                      5.heightBox,
                      controller.isloading.value
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            )
                          : ourButton(
                              color: redColor,
                              title: login,
                              textcolor: whiteColor,
                              onPress: () async {
                                if (controller.passwordController.text.length >=
                                        8 &&
                                    controller.passwordController.text.length <=
                                        12) {
                                  isPasswordValid = true;
                                  setState(() {});
                                  controller.isloading(true);
                                  await controller
                                      .loginMethod(
                                    context: context,
                                  )
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: loggindin);
                                      Get.to(() => const Home());
                                    } else {
                                      controller.isloading(false);
                                    }
                                  });
                                } else {
                                  isPasswordValid = false;
                                  setState(() {});
                                }
                              },
                            ).box.width(context.screenWidth - 50).make(),
                      5.heightBox,
                      createNewAccount.text.color(fontGrey).make(),
                      5.heightBox,
                      ourButton(
                        color: lightGolden,
                        title: signup,
                        textcolor: whiteColor,
                        onPress: () {
                          Get.to(() => const SignUpScreen());
                        },
                      ).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      loginWith.text.color(fontGrey).make(),
                      5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          2,
                          (index) => CircleAvatar(
                            backgroundColor: lightGrey,
                            radius: 25,
                            child: Image.asset(
                              socialIconList[index],
                              width: 30,
                            ),
                          ),
                        ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
