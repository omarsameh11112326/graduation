import 'package:app_project/Pages/image_picker.dart';
import 'package:app_project/State/MainState.dart';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:app_project/Wedgits/custom_text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart";

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  String selectedValue = 'service center';
  bool isLoading = false;
  String? BusinessName;
  String? NationalID;
  String? Location;
  String? Place;
  // var controller = Get.put(MainStateController());
  var textController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("User");

  final TextEditingController phoneController = TextEditingController();

  LocationForm locationForm = LocationForm();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints:
              BoxConstraints.expand(), // Makes the container full screen
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
                                    NationalID = data;
                                  },
                                  hintText: "National ID",
                                  color: Color.fromARGB(255, 9, 61, 151),
                                  icon: IconButton(
                                    onPressed: () {
                                      showImagePickerOption(context);
                                    },
                                    icon: Icon(Icons.add_a_photo),
                                  ),
                                ),
                                CustomFormTextField(
                                  hintText: "Place",
                                  color: Color.fromARGB(255, 9, 61, 151),
                                  icon: IconButton(
                                    onPressed: () {
                                      showImagePickerOption(context);
                                    },
                                    icon: Icon(Icons.add_a_photo),
                                  ), onchanged: (data) {  }, 
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
                                  onTap: () {
                                    Navigator.pushNamed(context, 'HomePage');
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
