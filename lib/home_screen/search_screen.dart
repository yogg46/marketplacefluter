import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marketplace/category_screen/item_detail.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/services/firestore_services.dart';
import 'package:marketplace/widget_common/loading_indicator.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
        future: FirestoreServices.searchProducts(title),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty){
            return "Produk Tidak Ditemukan".text.makeCentered();
          } else {
            var data = snapshot.data!.docs;
            // print(data[0]['p_name']);
            var filtered = data.where(
              (element) => element['p_name'].toString().toLowerCase().contains(title!.toLowerCase()),
            ).toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 300),
               children: filtered
               .mapIndexed((currentValue, index) => Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  filtered[index]['p_imgs'][0], 
                                                  width: 200, 
                                                  height: 200,
                                                  fit: BoxFit.cover
                                                  ),
                                                10.heightBox, 
                                                "${filtered[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                                10.heightBox,
                                                "${filtered[index]['p_price']}".numCurrency.text.fontFamily(semibold).color(darkFontGrey).size(16).make(),
                                              ],
                                    ).box.green500.margin(const EdgeInsets.symmetric(horizontal: 4)).roundedSM.rounded.padding(EdgeInsets.all(8)).make().
                                    onTap(() {Get.to(()=>ItemDetails(
                                      title: "${filtered[index]['p_name']}",
                                      data: filtered[index], 
                                      ));
                                    }))
                                    .toList(),
              ),
            );
          }
        }
      ),
    );
  }
}