  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/services.dart';
  import 'package:get/get.dart';
  import 'package:marketplace/consts/consts.dart';
  import 'package:marketplace/models/category_model.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var totalPrice = 0.obs; 
  var subcat = [];

  var isFav = false.obs;
  

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s = decoded.categories.where((element) => element.name == title).toList();


    for (var e in s[0].subcategory){
      subcat.add(e);

    }

    
  }
   increaseQuantity(totalQuantity){
    if (quantity.value < totalQuantity){
      quantity.value++;
    }
      
    }
    
    decreaseQuantity(){
      if (quantity.value > 0 ){
        quantity.value--;
      }
    }

    calculateTotalPrice(price) {
      totalPrice.value = price * quantity.value;
    }

    addToCart ({title, img, sellername, qty, tprice, context, vendorId}) async {
      await firestore.collection(cartCollection).doc().set({
        'title': title,
        'img': img[0],
        'sellername': sellername,
        'qty': qty,
        'vendor_id': vendorId,
        'tprice': tprice,
        'added_by': currentUser!.uid
      }).catchError((error){
        VxToast.show(context, msg: error.toString());
      }); 
    } 

    resetValeus(){
      totalPrice.value = 0;
      quantity.value = 0;

    }

    addToWhishlist(docId, context) async {
      await firestore.collection(productsCollection).doc(docId).set({
        'p_whishlist': FieldValue.arrayUnion([currentUser!.uid])
      }, SetOptions(merge: true));
      isFav(true);
      VxToast.show(context, msg: "Ditambahkan ke wishlist");
    }

     removeFromWhishlist(docId, context) async {
      await firestore.collection(productsCollection).doc(docId).set({
        'p_whishlist': FieldValue.arrayRemove([currentUser!.uid])
      }, SetOptions(merge: true));
      isFav(false);
      VxToast.show(context, msg: "Hapus wishlist");
    }

    checkIfFav(data) async{
      if(data['p_whishlist'].contains(currentUser!.uid)){
        isFav(true);
      } else {
        isFav(false);
      }
    }
}