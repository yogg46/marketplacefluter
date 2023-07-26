import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/auth_screen/login_screen.dart';
import 'package:marketplace/cart_screen/shipping_screen.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/controllers/cart_controller.dart';
import 'package:marketplace/services/firestore_services.dart';
import 'package:marketplace/widget_common/loading_indicator.dart';
import 'package:marketplace/widget_common/our_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: currentUser != null
            ? ourButton(
                color: greenColor,
                onPress: () {
                  Get.to(() => const ShippingDetails());
                },
                textcolor: whiteColor,
                title: "Pilih Pengiriman",
              )
            : InkWell(
                onTap: () {
                  Get.to(() => LoginScreen());
                },
                child: Container(
                  color: greenColor,
                  child: Center(
                    child: Text(
                      "Login untuk Melanjutkan",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Keranjang",
          style: TextStyle(color: darkFontGrey),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreServices.getCart(currentUser?.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Beli dulu yuk",
                style: TextStyle(color: darkFontGrey),
              ),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: SizedBox(
                            child: Image.network("${data[index]['img']}"),
                            width: 80,
                          ),
                          title: Text(
                            "${data[index]['title']} (x${data[index]['qty']})",
                            style: TextStyle(
                              fontFamily: semibold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Rp ${NumberFormat('#,###').format((data[index]['tprice']))}',
                            style: TextStyle(
                              fontFamily: semibold,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.incrementQuantity(data[index].id);
                                },
                                child: Icon(
                                  Icons.add,
                                  color: greenColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  controller.decrementQuantity(data[index].id);
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: redColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  controller.deleteItem(data[index].id);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Harga",
                        style: TextStyle(
                          fontFamily: semibold,
                          color: darkFontGrey,
                        ),
                      ),
                      Text(
                        'Rp. ${NumberFormat('#,###').format((controller.totalP))}',
                        style: TextStyle(
                          color: darkFontGrey,
                          fontFamily: semibold,
                        ),
                      ),
                    ],
                  )
                      .box
                      .padding(EdgeInsets.all(12))
                      .color(lightGreen)
                      .width(context.screenWidth - 60)
                      .roundedSM
                      .make(),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
