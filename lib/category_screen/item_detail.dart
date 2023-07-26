import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/consts/list.dart';
import 'package:marketplace/controllers/product_controller.dart';
import 'package:marketplace/views/chat_screen/chat_screen.dart';
import 'package:marketplace/widget_common/bag_widget.dart';

import '../widget_common/our_button.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  bool showAllReviews = false;
  void toggleShowAllReviews() {
    showAllReviews = !showAllReviews;
    Get.forceAppUpdate();
  }

  ItemDetails({Key? key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return WillPopScope(
      onWillPop: () async {
        controller.resetValeus();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValeus();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            Obx(() => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWhishlist(data.id, context);
                      controller.isFav(false);
                    } else {
                      controller.addToWhishlist(data.id, context);
                      controller.isFav(true);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outline,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  ),
                )),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                          autoPlay: true,
                          height: 350,
                          aspectRatio: 16 / 9,
                          itemCount: data['p_imgs'].length,
                          itemBuilder: (context, index) {
                            return Image.network(data["p_imgs"][index],
                                width: double.infinity, fit: BoxFit.cover);
                          }),
                      10.heightBox,
                      title!.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(bold)
                          .make(),
                      10.heightBox,
                      Text(
                        'Rp. ${NumberFormat('#,###').format(double.parse(data['p_price']))}',
                        style: TextStyle(
                          color: darkFontGrey,
                          fontFamily: bold,
                          fontSize: 18,
                        ),
                      ),
                      10.heightBox,
                      VxRating(
                        isSelectable: false,
                        value: double.parse(data['p_rating']),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 25,
                        maxRating: 5,
                      ),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Chat Kami"
                                    .text
                                    .white
                                    .fontFamily(semibold)
                                    .make(),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.message_rounded,
                                color: darkFontGrey),
                          ).onTap(() {
                            Get.to(() => const ChatScreen(), arguments: [
                              data['p_seller'],
                              data['vendor_id']
                            ]);
                          })
                        ],
                      )
                          .box
                          .height(60)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),
                      Obx(() => Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Jumlah: "
                                        .text
                                        .color(textfieldGrey)
                                        .make(),
                                  ),
                                  Obx(() => Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  controller.decreaseQuantity();
                                                  controller
                                                      .calculateTotalPrice(
                                                          int.parse(
                                                              data['p_price']));
                                                },
                                                icon: Icon(Icons.remove),
                                              ),
                                              controller.quantity.value.text
                                                  .size(16)
                                                  .color(darkFontGrey)
                                                  .fontFamily(bold)
                                                  .make(),
                                              IconButton(
                                                onPressed: () {
                                                  controller.increaseQuantity(
                                                      int.parse(
                                                          data['p_quantity']));
                                                  controller
                                                      .calculateTotalPrice(
                                                          int.parse(
                                                              data['p_price']));
                                                },
                                                icon: Icon(Icons.add),
                                              ),
                                              10.widthBox,
                                              "(${data['p_quantity']} Stok) "
                                                  .text
                                                  .color(textfieldGrey)
                                                  .make(),
                                            ],
                                          ))
                                      .box
                                      .padding(const EdgeInsets.all(8))
                                      .make(),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: "Total: "
                                        .text
                                        .color(textfieldGrey)
                                        .make(),
                                  ),
                                  "${controller.totalPrice.value}"
                                      .numCurrency
                                      .text
                                      .color(darkFontGrey)
                                      .size(16)
                                      .fontFamily(bold)
                                      .make(),
                                ],
                              ).box.padding(const EdgeInsets.all(8)).make(),
                            ],
                          ).box.white.shadowSm.make()),
                      // Deskripsi
                      10.heightBox,
                      "Deskripsi Produk"
                          .text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data['p_desc']}".text.color(darkFontGrey).make(),
                      20.heightBox,
                      "Ulasan Pembeli"
                          .text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('coment')
                            .where('p_name', isEqualTo: data['p_name'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if (snapshot.data == null ||
                              snapshot.data!.docs.isEmpty) {
                            return Text('Belum ada ulasan untuk produk ini.');
                          }

                          final reviews = snapshot.data!.docs.map((doc) {
                            final comment = doc['comment'];
                            final imageUrl = doc['image_url'];
                            final rating = doc['rating'];
                            final timestamp = doc['timestamp']?.toDate();

                            return {
                              'comment': comment,
                              'imageUrl': imageUrl,
                              'rating': rating,
                              'timestamp': timestamp,
                            };
                          }).toList();

                          final displayedReviews =
                              showAllReviews ? reviews : reviews.sublist(0, 2);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final review in displayedReviews)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['comment'],
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        RatingBarIndicator(
                                          rating: review['rating'].toDouble(),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20,
                                          unratedColor: Colors.grey[300],
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(review['timestamp']!),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    if (review['imageUrl'] != null)
                                      Image.network(
                                        review['imageUrl'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    Divider(),
                                  ],
                                ),
                              if (reviews.length > 1 && !showAllReviews)
                                TextButton(
                                  onPressed: toggleShowAllReviews,
                                  child: Text(
                                    'Lihat Semua Ulasan',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      10.heightBox,
                      "Produk yang mungkin anda suka"
                          .text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              6,
                              (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(imgP1,
                                          width: 150, fit: BoxFit.cover),
                                      10.heightBox,
                                      "Keiki Spike"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      10.heightBox,
                                      "\Rp.50000"
                                          .text
                                          .fontFamily(semibold)
                                          .color(redColor)
                                          .size(16)
                                          .make()
                                    ],
                                  )
                                      .box
                                      .white
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .roundedSM
                                      .rounded
                                      .padding(EdgeInsets.all(8))
                                      .make()),
                        ),
                      ),
                      10.heightBox,
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                  color: greenColor,
                  onPress: () {
                    controller.addToCart(
                        context: context,
                        img: data['p_imgs'],
                        vendorId: data['vendor_id'],
                        qty: controller.quantity.value,
                        sellername: data['p_seller'],
                        title: data['p_name'],
                        tprice: controller.totalPrice.value);
                    VxToast.show(context, msg: "Tambah Ke Keranjang");
                  },
                  textcolor: whiteColor,
                  title: "Tambah ke keranjang"),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
