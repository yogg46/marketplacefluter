import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/services/firestore_services.dart';
import 'package:marketplace/views/chat_screen/chat_screen.dart';
import 'package:marketplace/widget_common/loading_indicator.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Pesanan Saya".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData){
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Belum ada pesanan!".text.color(darkFontGrey).makeCentered(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index){
                      return Card(
                        child: ListTile(
                          onTap: (){
                            Get.to(()=> const ChatScreen(),
                            arguments: [
                              data[index]['friend_name'].toString(), 
                              data[index]['toId'].toString()],
                            );
                          },
                          leading: const CircleAvatar(
                            backgroundColor: greenColor,
                            child: Icon(
                              Icons.person,
                              color: whiteColor,
                            ),
                          ),
                          title: "${data[index]['friend_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                          subtitle: "${data[index]['last_msg']}".text.make(),
                        ),
                      );
                    },
                    )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}