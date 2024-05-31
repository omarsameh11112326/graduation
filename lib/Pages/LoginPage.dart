import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:app_project/Wedgits/custom_text_field.dart';
import 'package:app_project/constant.dart';
import 'package:app_project/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                  const Padding(
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
                                    left: 18.0,
                                    right: 18,
                                    bottom: 100,
                                    top: 40),
                                child: Column(
                                  children: [
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    CustomFormTextField(
                                      onchanged: (data) {
                                        password = data;
                                      },
                                      hintText: 'password',
                                      icon: const Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 0,
                                          child: Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    Colors.blue),
                                            child: Checkbox(
                                              checkColor: Colors.black,
                                              activeColor: Colors.white,
                                              value: keepMeLoggedIn,
                                              onChanged: (value) {
                                                setState(() {
                                                  keepMeLoggedIn = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Remember me',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "ForgetPassword");
                                          },
                                          child: const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 90,
                                    ),
                                    CustomButton(
                                      onTap: () async {
                                        if (formKey.currentState!.validate()) {
                                          isLoading = true;
                                          setState(() {});
                                          try {
                                            await loginUser();
                                            showSnackBar(context, 'success');
                                            Navigator.pushNamed(
                                                context, 'HomePage');
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
                                          }
                                          isLoading = false;
                                          setState(() {});
                                        }
                                      },
                                      text: 'SIGN IN',
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
              ))),
    );
  }

  Future<void> loginUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
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

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLoggedIn, keepMeLoggedIn);
  }
}
