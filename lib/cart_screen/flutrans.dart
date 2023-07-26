// import 'package:flutter/material.dart';
// import 'package:flutter_midtrans/flutter_midtrans.dart';

// void main() {
//   runApp(MaterialApp(
//     home: MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             generateToken(context);
//           },
//           child: Text('Start Payment'),
//         ),
//       ),
//     );
//   }
// }

// void generateToken(BuildContext context) async {
//   // Lakukan pemanggilan API untuk mendapatkan Snap Token
//   final snapToken = await callYourApiToGetSnapToken();

//   // Cek apakah Snap Token berhasil didapatkan
//   if (snapToken != null) {
//     // Konfigurasi Midtrans
//     MidtransConfig config = MidtransConfig(
//       clientKey: 'YOUR_CLIENT_KEY', // Ganti dengan client key Midtrans Anda
//       snapToken: snapToken,
//       environment: MidtransEnvironment.sandbox, // Ganti dengan environment yang sesuai
//     );

//     // Inisialisasi Midtrans
//     await MidtransFlutter.init(config);

//     // Mulai alur pembayaran dengan Snap Token
//     await MidtransFlutter.startPaymentUiFlow();

//     // Tampilkan halaman pembayaran Midtrans
//     // Pada tahap ini, aplikasi akan beralih ke halaman pembayaran Midtrans
//   } else {
//     // Jika Snap Token tidak berhasil didapatkan
//     print('Failed to generate Snap Token');
//   }
// }
