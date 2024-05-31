import 'dart:io';
import 'package:app_project/Pages/LoginPage.dart';
import 'package:app_project/Pages/image_picker.dart';
import 'package:app_project/Wedgits/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class profilrUser extends StatefulWidget {
  const profilrUser({Key? key}) : super(key: key);

  @override
  State<profilrUser> createState() => _profilrUserState();
}

class _profilrUserState extends State<profilrUser> {
  late File _image;
  String? email;
  String? phone;
  String? firstName;
  String? LastName;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'My Profile',
                  style: GoogleFonts.andadaPro(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    height: 400,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("images/bg.png"),
                              radius: 80,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 250, left: 240),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'HomePage');
                        // showImagePickerOption(context);
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 300.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 16, 28, 38),
                                Colors.blueAccent,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, top: 20),
                            child: Column(
                              children: [
                                CustomFormTextField(
                                  onchanged: (data) {
                                    firstName = data;
                                  },
                                  hintText: 'First Name',
                                  color: Colors.white,
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    LastName = data;
                                  },
                                  hintText: 'Last Name',
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    email = data;
                                  },
                                  hintText: 'Email',
                                  icon: const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    phone = data;
                                  },
                                  hintText: 'phone',
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "ForgetPassword");
                                  },
                                  child: const Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Change Password ?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'HomePage');
                                  },
                                  child: Container(
                                    height: 53,
                                    width: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
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
