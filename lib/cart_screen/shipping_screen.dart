import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:marketplace/cart_screen/flutrans.dart';
import 'package:marketplace/cart_screen/generatetoken.dart';
import 'package:marketplace/cart_screen/payment_method.dart';
import 'package:marketplace/cart_screen/payment_page.dart';
import 'package:marketplace/consts/consts.dart';
import 'package:marketplace/controllers/cart_controller.dart';
import 'package:marketplace/widget_common/custom_textfield.dart';
import 'package:marketplace/widget_common/our_button.dart';

class ShippingDetails extends StatefulWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  late String selectedAddress = '';
  var controller = Get.find<CartController>();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        print('Layanan lokasi tidak diaktifkan');
        return Future.error('Layanan lokasi tidak diaktifkan');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print('Izin lokasi ditolak secara permanen');
      return Future.error('Izin lokasi ditolak secara permanen');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print('Izin lokasi ditolak');
        return Future.error('Izin lokasi ditolak');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String address =
          '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}';
      return address;
    }
    return '';
  }

  void _updateFormFields(
      String address, String city, String state, String postalCode) {
    setState(() {
      controller.addressController.text = address;
      controller.cityController.text = city;
      controller.stateController.text = state;
      controller.postalcodeController.text = postalCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Isi Data Pengiriman",
          style: TextStyle(
            fontFamily: semibold,
            color: darkFontGrey,
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (selectedAddress.isNotEmpty) {
              Get.to(() => const PaymentMethods());
            } else {
              Get.snackbar(
                'Peringatan',
                'Mohon isi data alamat terlebih dahulu',
              );
            }
          },
          color: greenColor,
          textcolor: whiteColor,
          title: "Selanjutnya",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alamat Tersimpan",
                style: TextStyle(
                  fontFamily: semibold,
                  fontSize: 18,
                  color: darkFontGrey,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('shipping_details')
                      .where('userId', isEqualTo: currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          Map<String, dynamic> data =
                              doc.data() as Map<String, dynamic>;
                          String address = data['address'];
                          bool isSelected = (address == selectedAddress);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddress = address;
                                controller.addressController.text =
                                    data['address'];
                                controller.cityController.text = data['city'];
                                controller.stateController.text = data['state'];
                                controller.postalcodeController.text =
                                    data['postal_code'];
                                controller.phoneController.text = data['phone'];
                              });
                            },
                            child: Container(
                              width: 200,
                              margin: EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.green[200]
                                    : Colors.green[500],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text(
                                  address,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['city']),
                                    Text(data['state']),
                                    Text(data['postal_code']),
                                  ],
                                ),
                                trailing: Icon(Icons.edit),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Tambah Alamat Baru",
                style: TextStyle(
                  fontFamily: semibold,
                  fontSize: 18,
                  color: darkFontGrey,
                ),
              ),
              SizedBox(height: 12),
              Form(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Alamat Lengkap',
                        hintText: 'Masukkan alamat',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      controller: controller.addressController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Kota',
                        hintText: 'Masukkan kota',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      controller: controller.cityController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Provinsi',
                        hintText: 'Masukkan provinsi',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      controller: controller.stateController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Kode Pos',
                        hintText: 'Masukkan kode pos',
                        prefixIcon: Icon(Icons.local_post_office),
                      ),
                      controller: controller.postalcodeController,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Telepon',
                        hintText: 'Masukkan nomor telepon',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: controller.phoneController,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.addressController.text.isNotEmpty &&
                            controller.cityController.text.isNotEmpty &&
                            controller.stateController.text.isNotEmpty &&
                            controller.postalcodeController.text.isNotEmpty &&
                            controller.phoneController.text.isNotEmpty) {
                          Map<String, dynamic> newAddress = {
                            'address': controller.addressController.text,
                            'city': controller.cityController.text,
                            'state': controller.stateController.text,
                            'postal_code': controller.postalcodeController.text,
                            'phone': controller.phoneController.text,
                            'userId': currentUser!.uid,
                          };

                          try {
                            await FirebaseFirestore.instance
                                .collection('shipping_details')
                                .add(newAddress);

                            controller.addressController.clear();
                            controller.cityController.clear();
                            controller.stateController.clear();
                            controller.postalcodeController.clear();
                            controller.phoneController.clear();

                            Get.snackbar(
                              'Sukses',
                              'Alamat berhasil ditambahkan',
                            );
                          } catch (error) {
                            Get.snackbar(
                              'Error',
                              'Terjadi kesalahan saat menambahkan alamat',
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Peringatan',
                            'Mohon lengkapi semua field',
                          );
                        }
                      },
                      child: Text('Tambah Alamat Baru'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Position? currentPosition = await getCurrentLocation();
                        if (currentPosition != null) {
                          String currentAddress =
                              await getAddressFromCoordinates(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          );
                          if (currentAddress.isNotEmpty) {
                            List<String> addressComponents =
                                currentAddress.split(', ');
                            if (addressComponents.length >= 5) {
                              String address = addressComponents[0];
                              String city = addressComponents[1];
                              String state = addressComponents[2];
                              String postalCode = addressComponents[3];
                              _updateFormFields(
                                  address, city, state, postalCode);
                              Get.snackbar('Sukses',
                                  'Alamat saat ini berhasil didapatkan');
                            } else {
                              Get.snackbar('Error',
                                  'Tidak dapat mendapatkan alamat saat ini');
                            }
                          } else {
                            Get.snackbar('Error',
                                'Tidak dapat mendapatkan alamat saat ini');
                          }
                        } else {
                          Get.snackbar('Error',
                              'Tidak dapat mendapatkan lokasi saat ini');
                        }
                      },
                      child: Text('Gunakan Lokasi Saat Ini'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 