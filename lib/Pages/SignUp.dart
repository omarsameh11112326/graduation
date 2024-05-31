import 'package:app_project/Pages/serviceProviderPages/FormPage.dart';
import 'package:app_project/Pages/home.dart';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:app_project/Wedgits/custom_text_field.dart';
import 'package:app_project/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

String? firstName;
String? lastName;
  String? documentId;


class _SignUpScreenState extends State<SignUpScreen> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController _FirstName = TextEditingController();
  TextEditingController _LastName = TextEditingController();

  @override
  void dispose() { // Corrected method name
    _FirstName.dispose();
    _LastName.dispose();
    super.dispose();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
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
              const Padding(
                padding: EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Create Your\nAccount',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, bottom: 90, top: 20),
                            child: Column(
                              children: [
                                CustomFormTextField(
                                  onchanged: (data) {
                                    firstName = data;
                                  },
                                  controller: _FirstName,
                                  hintText: 'First Name',
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    lastName = data;
                                  },
                                  controller: _LastName,
                                  hintText: 'Last Name',
                                  icon: const Icon(Icons.check),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    email = data;
                                  },
                                  hintText: 'Email',
                                  icon: const Icon(Icons.email),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                CustomFormTextField(
                                  onchanged: (data) {
                                    password = data;
                                  },
                                  hintText: 'Password',
                                  icon: const Icon(Icons.visibility_off),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                CustomButton(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      isLoading = true;
                                      setState(() {});
                                      try {
                                        await registerUser();
                                        showSnackBar(context, 'success');
                                        Navigator.pushNamed(
                                            context, 'PhonePage');
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          showSnackBar(context,
                                              'The password provided is too weak.');
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          showSnackBar(context,
                                              'The account already exists for that email.');
                                        }
                                      } catch (e) {
                                        showSnackBar(
                                            context, 'there was an error');
                                        print(e);
                                      }
                                      isLoading = false;
                                      setState(() {});
                                    }
                                  },
                                  text: 'GET STARTED',
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Or Login with",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 20),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              signInWithGoogle();
                                              Navigator.pushNamed(
                                                  context, "LoginPage");
                                            },
                                            child: Tab(
                                                icon: Image.asset(
                                                    "images/facebook.png"))),
                                        InkWell(
                                            onTap: () {
                                              signInWithGoogle();
                                              Navigator.pushNamed(
                                                  context, "LoginPage");
                                            },
                                            child: Tab(
                                                icon: Image.asset(
                                                    "images/google.png"))),
                                      ],
                                    )
                                  ],
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

  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);


          
    String userId = userCredential.user!.uid;
              String userType='Normal user';



      // Add user information to Firestore
      await users.doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'userType': userType,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(), 
        

        // Add more fields as needed
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Home(userId: userId);
      },));

    } catch (e) {
      print("Error registering user: $e");
      throw e; // Rethrow the error to handle it in the UI
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
