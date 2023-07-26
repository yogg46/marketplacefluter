import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  generateToken();
}

void generateToken() async {
  final orderId = await fetchOrderIdFromFirestore();
  final totalAmount = await fetchTotalAmountFromFirestore(orderId);
  final url =
      Uri.parse('https://app.midtrans.com/snap/v1/transactions');

  final headers = <String, String>{
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization':
        'Basic TWlkLXNlcnZlci1Hc1VGOHNTd240WG9iQjZoeTlZQm5vNGU6',
// Basic U0ItTWlkLXNlcnZlci15ZDdGTzk2Z1l4Nl9YRmd3aHRLWGo2Wlc6
    //Basic TWlkLXNlcnZlci1Hc1VGOHNTd240WG9iQjZoeTlZQm5vNGU6
  };

  final body = <String, dynamic>{
    'transaction_details': {'order_id': orderId, 'gross_amount': totalAmount},
    // 'item_details': [
    //   {'id': 'ITEM-123', 'price': 100, 'quantity': 2, 'name': 'Example Item'}
    // ],
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 201) {
    // Request successful, parse the response
    final responseData = jsonDecode(response.body);
    final snapToken = responseData['redirect_url'] as String;
    // Use the snapToken as needed
    print(snapToken);
    print(url);

    // Start the payment UI flow with the Snap Token
    startPaymentUiFlow(snapToken);
  } else {
    // Request failed
    print(response.body);
  }
}

void startPaymentUiFlow(String snapToken) async {
  final paymentUrl =
      snapToken; // Ganti dengan URL yang diperoleh dari response generateToken()

  if (await canLaunch(paymentUrl)) {
    await launch(paymentUrl);
  } else {
    throw 'Tidak dapat membuka halaman pembayaran';
  }
}

List<String> usedOrderCodes = [];

Future<String> fetchOrderIdFromFirestore() async {
  final collection = FirebaseFirestore.instance.collection('orders');
  final querySnapshot = await collection.get();

  if (querySnapshot.docs.isNotEmpty) {
    final doc = querySnapshot.docs.first;
    final orderId = doc.get('order_code') as String;

    if (usedOrderCodes.contains(orderId)) {
      // Jika order_code sudah pernah digunakan sebelumnya, cari order_code yang belum pernah digunakan
      for (final doc in querySnapshot.docs) {
        final code = doc.get('order_code') as String;
        if (!usedOrderCodes.contains(code)) {
          return code;
        }
      }
    } else {
      return orderId;
    }
  }

  throw Exception('Order ID not found in Firestore');
}

Future<double> fetchTotalAmountFromFirestore(String orderId) async {
  final collection = FirebaseFirestore.instance.collection('orders');
  final querySnapshot =
      await collection.where('order_code', isEqualTo: orderId).get();

  if (querySnapshot.docs.isNotEmpty) {
    final doc = querySnapshot.docs.first;
    final totalAmount = doc.get('total_amount') as double;
    return totalAmount;
  }

  throw Exception('Total amount not found in Firestore');
}



// String generateBasicAuth(String apiKey) {
//   final usernameAndPassword = utf8.encode('$apiKey:');
//   final base64Encoded = base64.encode(usernameAndPassword);
//   return 'Basic $base64Encoded';
// }
