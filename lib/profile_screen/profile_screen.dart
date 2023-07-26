import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/auth_screen/login_screen.dart';
import 'package:marketplace/auth_screen/signup_screen.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/consts/list.dart';
import 'package:marketplace/controllers/profile_controller.dart';
import 'package:marketplace/profile_screen/detail_card.dart';
import 'package:marketplace/profile_screen/edit_profile_screen.dart';
import 'package:marketplace/services/firestore_services.dart';
import 'package:marketplace/views/chat_screen/messaging_screen.dart';
import 'package:marketplace/views/orders_screen/orders_screen.dart';
import 'package:marketplace/views/whislist_screen/wishlist_screen.dart';
import 'package:marketplace/widget_common/bag_widget.dart';
import 'package:marketplace/widget_common/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var controller = Get.put(ProfileController());
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        isLoggedIn = (user != null);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        body: isLoggedIn
            ? StreamBuilder<QuerySnapshot>(
                stream: FirestoreServices.getUser(currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(redColor),
                      ),
                    );
                  } else {
                    var data = snapshot.data!.docs[0];
                    return SafeArea(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  controller.nameController.text = data['name'];
                                  Get.to(() => EditProfileScreen(data: data));
                                },
                                child: Icon(Icons.edit, color: whiteColor),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                data['imageUrl'] == ''
                                    ? Image.asset(
                                        imgProfile2,
                                        width: 90,
                                        fit: BoxFit.cover,
                                      )
                                        .box
                                        .roundedFull
                                        .clip(Clip.antiAlias)
                                        .make()
                                    : Image.network(
                                        data['imageUrl'],
                                        width: 90,
                                        fit: BoxFit.cover,
                                      )
                                        .box
                                        .roundedFull
                                        .clip(Clip.antiAlias)
                                        .make(),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                          fontFamily: semibold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        data['email'],
                                        style: TextStyle(
                                          fontFamily: semibold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: whiteColor),
                                  ),
                                  onPressed: () async {
                                    if (FirebaseAuth.instance.currentUser ==
                                        null) {
                                      Get.to(() => const LoginScreen());
                                    } else {
                                      await FirebaseAuth.instance.signOut();
                                      Get.offAll(() => const LoginScreen());
                                    }
                                  },
                                  child: Text(
                                    FirebaseAuth.instance.currentUser == null
                                        ? 'Login'
                                        : 'Logout',
                                    style: TextStyle(
                                      fontFamily: semibold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (FirebaseAuth.instance.currentUser == null)
                                  const SizedBox(width: 8),
                                if (FirebaseAuth.instance.currentUser == null)
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: whiteColor),
                                    ),
                                    onPressed: () {
                                      Get.to(() => const SignUpScreen());
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                        fontFamily: semibold,
                                        color: Color.fromARGB(255, 255, 8, 8),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder(
                            future: FirestoreServices.getCounts(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(child: loadingIndicator());
                              } else {
                                var countData = snapshot.data;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: detailsCard(
                                        count: countData[0].toString(),
                                        title: "Keranjang",
                                        width: context.screenWidth / 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: detailsCard(
                                        count: countData[1].toString(),
                                        title: "Wishlist",
                                        width: context.screenWidth / 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: detailsCard(
                                        count: countData[2].toString(),
                                        title: "Pesanan Anda",
                                        width: context.screenWidth / 2,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return const Divider(color: lightGrey);
                              },
                              itemCount: profileButtonsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    switch (index) {
                                      case 0:
                                        Get.to(() => const OrdersScreen());
                                        break;
                                      case 1:
                                        Get.to(() => const WishlistScreen());
                                        break;
                                      case 2:
                                        Get.to(() => const MessageScreen());
                                        break;
                                    }
                                  },
                                  leading: Image.asset(
                                    profileButtonsIcon[index],
                                    width: 22,
                                  ),
                                  title: Text(
                                    profileButtonsList[index],
                                    style: TextStyle(
                                        fontFamily: semibold,
                                        color: darkFontGrey),
                                  ),
                                );
                              },
                            )
                                .box
                                .white
                                .rounded
                                .margin(const EdgeInsets.all(12))
                                .shadowSm
                                .make()
                                .box
                                .color(greenColor)
                                .make(),
                          ),
                        ],
                      ),
                    );
                  }
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Anda belum login',
                      style: TextStyle(
                        fontFamily: semibold,
                        color: const Color.fromARGB(255, 54, 149, 244),
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const SignUpScreen());
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
