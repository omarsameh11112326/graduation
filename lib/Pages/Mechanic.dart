import 'package:app_project/Pages/Services.dart';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class Mechanic extends StatefulWidget {
   Mechanic({Key? key}) : super(key: key);

  @override
  State<Mechanic> createState() => _FuelDeliveryState();
}

class _FuelDeliveryState extends State<Mechanic> {
  bool isLoading = false;
  String? Address;
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: FlutterLocationPicker(
                  initZoom: 11,
                  minZoomLevel: 5,
                  maxZoomLevel: 16,
                  trackMyPosition: true,
                  onPicked: (pickedData) {
                    Address = pickedData.address;
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 0,
                          bottom: 0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 300,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 16, 28, 38),
                                    Colors.blueAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child:  Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Image.asset(
                                    "images/mechanic_8598957.png",
                                    color: Colors.white,
                                    height: 50,
                                    width: 50,
                                  ),
                                  
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    "Mechanic",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.message),
                                hintText:
                                    "Please Write Your Problem description",
                                hintStyle: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 300,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.credit_card,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Text(
                                      "Visa",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Icon(Icons.arrow_right),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 45,
                            ),
                            CustomButton(
                              onTap: () {
                                // Save user request to Firestore
                                _saveUserRequest();
                              },
                              text: "Get your help",
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUserRequest() async {
    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      // Access Firestore instance
      final firestoreInstance = FirebaseFirestore.instance;

      // Get the description and location
      String description = _descriptionController.text;
      String location =
          "$Address"; // You need to update this with actual location

      // Add document to 'userRequest' collection
      await firestoreInstance.collection('userRequest').add({
        'description': description,
        'location': location,
        'serviceType': 'Mechanic',
      });

      // Request saved successfully
      setState(() {
        isLoading = false; // Hide loading indicator
      });

      // Optionally, you can show a success message or navigate to a new screen here
    } catch (error) {
      // Handle errors
      print('Error saving user request: $error');
      setState(() {
        isLoading = false; // Hide loading indicator in case of error
      });
    }
  }
}