import 'dart:io';
import 'dart:typed_data';

import 'package:app_project/Pages/RequestToServiceProvider.dart';
import 'package:app_project/Pages/image_picker.dart';
import 'package:app_project/Pages/serviceProviderPages/profileServiceProvider.dart';
import 'package:app_project/State/MainState.dart';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:app_project/Wedgits/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import "package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart";
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ServiceProviderUpdate extends StatefulWidget {

  ServiceProviderUpdate({Key? key}) : super(key: key);

  @override
  State<ServiceProviderUpdate> createState() => _FormScreenState();
}


Uint8List? _image;
File? selectedIMage;

class _FormScreenState extends State<ServiceProviderUpdate> {
  String selectedValue = 'service center';
  bool isLoading = false;
  String? BusinessName;
  File? _imageFile;
  File? _imageid;
  String? documentId;
  String? phone;
  String? userId;

  final TextEditingController phoneController = TextEditingController();

  LocationForm locationForm = LocationForm();
  void initState() {
    super.initState();
    // Call a function to fetch user ID when the widget is initialized
    getUserId();
  }
  

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 16, 28, 38),
                Colors.blueAccent,
              ],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Welcome to\nService Provider Mode',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, bottom: 90, top: 40),
                            child: Column(
                              children: [
                                CustomFormTextField(
                                  onchanged: (data) {
                                    BusinessName = data;
                                  },
                                  hintText: 'Business Name',
                                  color: Color.fromARGB(255, 9, 61, 151),
                                  icon: Icon(Icons.check),
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    phone = data;
                                  },
                                  hintText: 'phone number',
                                  color: Color.fromARGB(255, 9, 61, 151),
                                  icon: Icon(Icons.phone_android),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Text(
                                                _imageid != null
                                                    ? "${_imageid!.path}"
                                                    : 'please upload the Image of National Id',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 9, 61, 151),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                showImagePickerOption(
                                                    context, true);
                                              },
                                              icon: Icon(Icons.add_a_photo))
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0),
                                              child: Text(
                                                _imageFile != null
                                                    ? "${_imageFile!.path}"
                                                    : 'please upload the Image of your place',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 9, 61, 151),
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                showImagePickerOption(
                                                    context, false);
                                              },
                                              icon: Icon(Icons.add_a_photo))
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: DropdownButton<String>(
                                    value: selectedValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'service center',
                                      'tow truck'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 9, 61, 151),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                locationForm,
                                SizedBox(
                                  height: 70,
                                ),
                                CustomButton(
                                  onTap: (){
                                    updateServiceProviderData();

                                  },
                                  text: 'SUBMIT',
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context, bool isNationalID) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blueAccent,
                Color.fromARGB(255, 16, 28, 38),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        print('${file?.path}');

                        if (file == null) return;

                        setState(() {
                          if (isNationalID) {
                            _imageid = File(file.path);
                          } else {
                            _imageFile = File(file.path);
                          }
                        });
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                              color: Colors.white,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.camera);
                        print('${file?.path}');

                        if (file == null) return;

                        setState(() {
                          if (isNationalID) {
                            _imageid = File(file.path);
                          } else {
                            _imageFile = File(file.path);
                          }
                        });
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                              color: Colors.white,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> getUserId() async {
    // Get the current user ID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }


  Future<void> updateServiceProviderData() async {
    setState(() {
      isLoading = true;
    });

    try {
      getUserId();
      Position position = await _determinePosition();
    String address = await _getAddressFromLatLng(position.latitude, position.longitude);

    String? imageUrl1;
    String? imageUrl2;
     
      
          

    // Upload images to Firebase Storage and get download URLs
    if (_imageid != null) {
      imageUrl1 = await _uploadImageToStorage(_imageid!);
    }

    if (_imageFile != null) {
      imageUrl2 = await _uploadImageToStorage(_imageFile!);
    }
      // Reference to the Firestore collection 'form'
      CollectionReference users = FirebaseFirestore.instance.collection('form');

      // Query to find the document where "userId" field matches the provided userId
      QuerySnapshot querySnapshot = await users.where('userId', isEqualTo: userId).get();

      // Check if a document was found
      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the first document (assuming there's only one match)
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String documentId = documentSnapshot.id;

        // Update the document with new data
        await users.doc(documentId).update({
          'businessName': BusinessName,
      'nationalID': imageUrl1,
      'location': address,
      'place': imageUrl2,
      'selectedValue': selectedValue,
      'phone': phone,
          // Add other fields you want to update
        });

        // Show success message or perform other actions upon successful update
        print('Document updated successfully');
      } else {
        // Handle case where no document was found with matching userId
        print('No document found with userId: $userId');
      }
    } catch (e) {
      // Handle errors
      print('Error updating document: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image to storage: $e');
      return null;
    }
  }

  
 

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> _getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    } catch (e) {
      print("Error getting address: $e");
      return "";
    }
  }
}

class LocationForm extends StatelessWidget {
  const LocationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      init: LocationController(),
      builder: (controller) {
        return Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        controller.currentLocation == null
                            ? 'No Address Found'
                            : controller.currentLocation!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 9, 61, 151),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await controller.getCurrentLocation();
                      },
                      icon: Icon(Icons.add_location_alt))
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}