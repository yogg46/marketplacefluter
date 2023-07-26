import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/controllers/cart_controller.dart';
import 'package:marketplace/services/firestore_services.dart';
import 'package:marketplace/widget_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Wishlist Saya".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getWishlists(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Belum ada Wishlist!".text.color(darkFontGrey).makeCentered(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                                leading:Image.network("${data[index]['p_imgs'][0]}",
                                width: 80,
                                fit: BoxFit.cover,
                                ),
                                title: "${data[index]['p_name']}".text.fontFamily(semibold).size(16).make(),
                                subtitle: "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(semibold).size(15).make(),
                                trailing: const Icon(
                                  Icons.favorite,
                                  color: redColor,
                                ).onTap(() async { 
                                  await firestore.collection(productsCollection).doc(data[index].id).set({
                                    'p_whishlist': FieldValue.arrayRemove([currentUser!.uid])
                                  }, SetOptions(merge: true));
                                }),
                      );
                    },
                  ),
                ),
              ],
            ); 
          }
        },
      ),
    );
  }
}