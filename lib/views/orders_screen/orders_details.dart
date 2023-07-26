import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/views/orders_screen/components/order_place_detail.dart';
import 'package:marketplace/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrdersDetails extends StatefulWidget {
  final dynamic data;

  const OrdersDetails({Key? key, this.data}) : super(key: key);

  @override
  _OrdersDetailsState createState() => _OrdersDetailsState();
}

class _OrdersDetailsState extends State<OrdersDetails> {
  String? _comment;
  File? _image;
  double _rating = 0.0;

  void _copyTrackingCode(BuildContext context, String trackingCode) {
    Clipboard.setData(ClipboardData(text: trackingCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kode resi disalin ke clipboard')),
    );
  }

  Future<void> _addReview(BuildContext context, String productName) async {
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ulas produk kami !'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Produk: $productName'),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Komentar',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Komentar harus diisi';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _comment = value;
                    },
                  ),
                  SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 30,
                    unratedColor: Colors.grey[300],
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage();
                    },
                    child: Text('Unggah Foto Produk'),
                  ),
                  SizedBox(height: 16),
                  if (_image != null)
                    Image.file(
                      _image!,
                      height: 100,
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.data['order_delivered']) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(' anda sudah melakukan review ')),
                  );
                } else {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    _uploadReview(productName);
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadReview(String productName) async {
    try {
      final firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child('coment');
      final imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final uploadTask = ref.child(imageFileName).putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('coment').add({
        'order_by_name': widget.data['order_by_name'],
        'p_name': productName, // Nama produk yang direview
        'comment': _comment,
        'rating': _rating,
        'image_url': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      var store = firestore.collection('orders').doc(widget.data.id);
      await store.set({'order_delivered': true}, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review berhasil ditambahkan')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan. Gagal menambahkan review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Detail Pesanan",
          style: TextStyle(color: darkFontGrey, fontFamily: semibold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              orderStatus(
                color: greenColor,
                icon: Icons.done,
                title: "Pesanan Diproses",
                showDone: widget.data['order_placed'],
              ),
              orderStatus(
                color: Colors.blue,
                icon: Icons.thumb_up,
                title: "Pesanan Dikonfirmasi",
                showDone: widget.data['order_confirmed'],
              ),
              orderStatus(
                color: redColor,
                icon: Icons.car_crash,
                title: "Pesanan Dalam Perjalanan",
                showDone: widget.data['order_on_delivery'],
              ),
              orderStatus(
                color: redColor,
                icon: Icons.done_all_sharp,
                title: "Pesanan Selesai",
                showDone: widget.data['order_delivered'],
              ),
              const Divider(),
              SizedBox(height: 10),
              Column(
                children: [
                  OrderPalceDetail(
                    d1: "${widget.data['order_code']}",
                    d2: widget.data['shipping_method'],
                    title1: "Kode Pesanan",
                    title2: "Metode Pengiriman",
                  ),
                  OrderPalceDetail(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format((widget.data['order_date'].toDate())),
                    d2: widget.data['payment_method'],
                    title1: "Tanggal Pesanan",
                    title2: "Kurir Pengiriman",
                  ),
                  OrderPalceDetail(
                      d1: "${widget.data['payment_status']}",
                      d2: "${widget.data['order_delivered']}",
                      title1: "Status Pembayaran",
                      title2: "Status Pengiriman"),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Alamat Pengiriman"
                                .text
                                .fontFamily(semibold)
                                .make(),
                            "${widget.data['order_by_name']}".text.make(),
                            "${widget.data['order_by_email']}".text.make(),
                            "${widget.data['order_by_address']}".text.make(),
                            "${widget.data['order_by_city']}".text.make(),
                            "${widget.data['order_by_state']}".text.make(),
                            "${widget.data['order_by_phone']}".text.make(),
                            "${widget.data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Pembayaran"
                                  .text
                                  .fontFamily(semibold)
                                  .make(),
                              "${widget.data['total_amount']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(semibold)
                                  .make(),
                              "Kode Resi".text.fontFamily(semibold).make(),
                              "${widget.data['tracking_code']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(semibold)
                                  .make(),
                              IconButton(
                                onPressed: () {
                                  _copyTrackingCode(
                                      context, widget.data['tracking_code']);
                                },
                                icon: Icon(Icons.content_copy),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).box.outerShadow.white.make(),
              const Divider(),
              SizedBox(height: 10),
              "Produk"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              SizedBox(height: 10),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(widget.data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderPalceDetail(
                        title1: widget.data['orders'][index]['title'],
                        title2: widget.data['orders'][index]['tprice'],
                        d1: "${widget.data['orders'][index]['qty']}x",
                        d2: "Refundable",
                      ),
                    ],
                  );
                }).toList(),
              )
                  .box
                  .outerShadow
                  .white
                  .margin(const EdgeInsets.only(bottom: 4))
                  .make(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.data['order_delivered']) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pesanan belum terkonfirmasi')),
                    );
                  } else {
                    _addReview(context, widget.data['orders'][0]['title']);
                  }
                },
                child: Text('Selesaikan Pesanan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
