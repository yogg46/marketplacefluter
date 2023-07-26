import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/models/category_model.dart';


class FirestoreServices {
  static getUser(uid){
    return firestore.collection(usersCollection).where('id', isEqualTo: uid).snapshots();
  }
  static getProducts(category){
    return firestore.collection(productsCollection).where('p_category', isEqualTo: category).snapshots();
  }
  static getSubCategoryProducts(title){
    return firestore.collection(productsCollection).where('p_subcategory', isEqualTo: title).snapshots();
  }
  static getCart(uid){
    return firestore.collection(cartCollection).where('added_by',isEqualTo: uid).snapshots();
  }
  static deleteDocument(docId){
    return firestore.collection(cartCollection).doc(docId).delete();
  }
 
  static getChatMessages(docId){
    return firestore.collection(chatsCollection).doc(docId).collection( messagesCollection).orderBy('created_on', descending: false).snapshots();
  }

  static getAllOrders(){
    return firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).snapshots();
  }
   static getWishlists(){
    return firestore.collection(productsCollection).where('p_whishlist', arrayContains: currentUser!.uid).snapshots();
  }
  
   static getAllMessages(){
    return firestore.collection(chatsCollection).where('fromId', isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value){
      return value.docs.length;
      }),
       firestore.collection(productsCollection).where('p_whishlist', arrayContains: currentUser!.uid).get().then((value){
      return value.docs.length;
      }),
       firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).get().then((value){
      return value.docs.length;
      }),
    ]);
    return res;
  }

  static allproducts(){
    return firestore.collection(productsCollection).snapshots();
  }

  static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('p_featured',isEqualTo: true).get();
  }

  static searchProducts(title){
    return firestore.collection(productsCollection).get();
  }

  static getUsers(String uid) {}
  
}