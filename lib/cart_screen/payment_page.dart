// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   Future<String> fetchSnapToken() async {
//     // Replace 'YOUR_SERVER_ENDPOINT' with the actual server endpoint URL
//     final url =
//         Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');
//     final headers = <String, String>{
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       'Authorization' : 'Basic U0ItTWlkLXNlcnZlci15ZDdGTzk2Z1l4Nl9YRmd3aHRLWGo2Wlc6',
//       // 'auth'  : 'SB-Mid-server-yd7FO96gYx6_XFgwhtKXj6ZW',
//       // Replace with your Midtrans API key
//     };

//     // final auth = 'SB-Mid-server-yd7FO96gYx6_XFgwhtKXj6ZW';

//     final body = <String, dynamic>{
//       'transaction_details': {
//         'order_id': 'ORDER-12345',
//         'gross_amount': 200000
//       },
//       'item_details': [
//         {
//           'id': 'ITEM-001',
//           'price': 100000,
//           'quantity': 2,
//           'name': 'Example Item'
//         }
//       ],
//       // Add any other required data for the transaction
//     };

//     // try {
//     final response = await http.post(url,
//         headers: headers, body: jsonEncode(body));

//     // if (response.statusCode == 200) {
//     //   // Token fetched successfully
//     //   final responseData = jsonDecode(response.body);
//     //   print(responseData);
//     //   return response.body;
//     // } else {
//     //   // Error occurred while fetching token
//     //   throw Exception('Failed to fetch SNAP Token');
//     // }
//     if (response.statusCode == 201) {
//       // Request successful, parse the response
//       final responseData = jsonDecode(response.body);
//       final snapToken = responseData['redirect_url'] as String;
//       throw Exception(snapToken);
//     } else {
//       // Request failed
//       throw Exception('Request failed with status: ${response.statusCode}');
//     }
//     // } catch (e) {
//     //   // Error occurred during the request
//     //   throw Exception('Failed to fetch SNAP Token: $e');
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Fetch SNAP Token'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               try {
//                 final snapToken = await fetchSnapToken();
//                 // Use the snapToken for further processing
//                 print('SNAP Token: $snapToken');
//               } catch (e) {
//                 print('Error fetching SNAP Token: $e');
//               }
//             },
//             child: const Text('Fetch SNAP Token'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MyApp());
// }
