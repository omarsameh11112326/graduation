import 'package:app_project/AdminPannel/homeAdmin.dart';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:app_project/Wedgits/custom_text_field.dart';
import 'package:app_project/constant.dart';
import 'package:app_project/helper/showSnackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

String? email;

String? password;

GlobalKey<FormState> formKey = GlobalKey();

class _loginScreenState extends State<loginScreen> {
  bool isLoading = false;
  bool keepMeLoggedIn = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
          body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 16, 28, 38),
                  Colors.blueAccent,
                ]),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 60.0, left: 22),
                    child: Text(
                      'Hello\nSign in!',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SingleChildScrollView(
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
                                  left: 18.0,
                                  right: 18,
                                  bottom: 100,
                                  top: 40),
                              child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: fetchLottieAnimation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading animation');
                } else {
                  return Lottie.network(
                   "https://lottie.host/4e69d648-b7a5-4c27-98c0-17cb984e0d24/rE5skB0OHu.json",
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate or perform action for "Start Service"
                serviecProgress('Service Provider Arrived');
              },
              child: Text('Service Provider Arrived'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate or perform action for "Service in Progress"
                serviceProgressUpdate1('Service in Progress');
 },
              child: Text('Service in Progress'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate or perform action for "Service Ended"
                serviceProgressUpdate2('Service Ended');
              },
              child: Text('Service Ended'),
            ),
            
          ],
        ),
      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
Future<String> fetchLottieAnimation() async {
    // Replace with your actual Lottie animation URL
    String animationUrl = 'https://example.com/your-lottie-animation.json';
    // Simulate network delay (you can remove this in real usage)
    await Future.delayed(Duration(seconds: 2));
    return animationUrl;
  }
  Future<void> serviecProgress(String TextButton) async {
 

  try {
   

    DocumentReference docRef = await FirebaseFirestore.instance.collection('serviceProgress').add({
      
      'serviceStrated':TextButton,
        'createdAt': FieldValue.serverTimestamp(), 
    });

    

    
  } catch (e) {
    
    print('Error saving form data: $e');
  }
}
  Future<void> serviceProgressUpdate1(String textButton) async {
  try {
    // Query the Firestore collection to get the last document created
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('serviceProgress')
        .orderBy('createdAt', descending: true) // Order by createdAt field to get the latest document first
        .limit(1) // Limit to only one document (the latest one)
        .get();

    // Check if there's any document returned
    if (querySnapshot.docs.isNotEmpty) {
      // Get the reference to the document
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('serviceProgress')
          .doc(docSnapshot.id); // Use the ID of the latest document

      // Update the document with the new data
      await docRef.update({
        'serviceInprogress': textButton,
      });

      print('Document updated successfully.');
    } else {
      print('No documents found in the collection.');
    }
  } catch (e) {
    print('Error updating document: $e');
  }
}
  Future<void> serviceProgressUpdate2(String textButton) async {
  try {
    // Query the Firestore collection to get the last document created
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('serviceProgress')
        .orderBy('createdAt', descending: true) // Order by createdAt field to get the latest document first
        .limit(1) // Limit to only one document (the latest one)
        .get();

    // Check if there's any document returned
    if (querySnapshot.docs.isNotEmpty) {
      // Get the reference to the document
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('serviceProgress')
          .doc(docSnapshot.id); // Use the ID of the latest document

      // Update the document with the new data
      await docRef.update({
        'serviceEnded': textButton,
      });

      print('Document updated successfully.');
    } else {
      print('No documents found in the collection.');
    }
  } catch (e) {
    print('Error updating document: $e');
  }
}
  

  
}