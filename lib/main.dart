import 'package:app_project/AdminPannel/homeAdmin.dart';
import 'package:app_project/ChatProgress.dart';
import 'package:app_project/Pages/RequestToServiceProvider.dart';
import 'package:app_project/Pages/googleMaps/googleMaps.dart';
import 'package:app_project/Pages/serviceProviderPages/FormPage.dart';
import 'package:app_project/Pages/services/FuelDelivery.dart';
import 'package:app_project/Pages/LoginPage.dart';

import 'package:app_project/Pages/SignUp.dart';
import 'package:app_project/Pages/forgot.dart';
import 'package:app_project/Pages/home.dart';
import 'package:app_project/Pages/phonePage.dart';
import 'package:app_project/Pages/services/TireChange.dart';

import 'package:app_project/Pages/verfiy.dart';
import 'package:app_project/Pages/welcomeScreen.dart';
import 'package:app_project/constant.dart';
import 'package:app_project/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
  );
  runApp(SafeRoad());
}

class SafeRoad extends StatelessWidget {
  SafeRoad({Key? key});
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
                body: Center(
              child: Text("is Loading...."),
            )),
          );
        } else {
          isUserLoggedIn = snapshot.data?.getBool(kKeepMeLoggedIn) ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: {
              'LoginPage': (context) => loginScreen(),
              'SignUpScreen': (context) => SignUpScreen(),
              'HomePage': (context) =>  Home(userId:'' ,),
              'FormPage': (context) => FormScreen(),
              'PhonePage': (context) => const MyPhone(),
              'verify': (context) => const MyVerify(),
              'ForgetPassword': (context) => const ForgotPassword(),
              'WelcomePage': (context) => const WelcomeScreen(),
            },
            home: WelcomeScreen(),
          );
        }
      },
    );
  }
}
