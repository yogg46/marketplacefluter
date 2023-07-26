import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/controllers/home_controller.dart';
import 'package:uuid/uuid.dart';

class CartController extends GetxController {
  double totalP = 0.0;

  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();
  var trackingcode = TextEditingController();
  var paymentstatus = TextEditingController();
  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];
  var vendors = [];
  var placingOrder = false.obs;

  void calculate(List<dynamic> data) {
    totalP = 0.0;
    for (var item in data) {
      double itemPrice = (item['tprice'] as num).toDouble() * item['qty'];
      totalP += itemPrice;
    }
    update();
  }

  void deleteItem(String itemId) {
    final item = FirebaseFirestore.instance.collection('cart').doc(itemId);
    item.delete();
  }

  void decrementQuantity(String itemId) {
    final item = FirebaseFirestore.instance.collection('cart').doc(itemId);
    item.get().then((snapshot) {
      final data = snapshot.data();
      if (data != null && data.containsKey('qty')) {
        int currentQuantity = data['qty'];
        if (currentQuantity > 1) {
          item.update({'qty': FieldValue.increment(-1)});
        } else {
          item.delete();
        }
      }
    });
  }

  void incrementQuantity(String itemId) {
    final item = FirebaseFirestore.instance.collection('cart').doc(itemId);
    item.get().then((snapshot) {
      final data = snapshot.data();
      if (data != null && data.containsKey('qty')) {
        int currentQuantity = data['qty'];
        item.update({'qty': currentQuantity + 1});
      }
    });
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();

    Timestamp currentTime = Timestamp.now();

    // Mendapatkan jumlah pesanan saat ini
    QuerySnapshot snapshot = await firestore.collection(ordersCollection).get();
    int orderCount = snapshot.docs.length;

    // Membuat kode pesanan dengan format Order-{nomor urut}
    String orderCode = "Order-${orderCount + 1}";

    await firestore.collection(ordersCollection).doc().set({
      'order_code': orderCode,
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      "order_by_postalcode": postalcodeController.text,
      'shipping_method': "Home Delivery",
      'payment_method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'payment_status': paymentstatus.text,
      'total_amount': totalAmount,
      'tracking_code': trackingcode.text,
      'orders': FieldValue.arrayUnion(products),
      'vendors': FieldValue.arrayUnion(vendors),  
    });

    placingOrder(false);
  }

  getProductDetails() {
    products.clear();
    vendors.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tprice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
