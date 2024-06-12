import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_project/Pages/RequestToServiceProvider.dart';
import 'package:lottie/lottie.dart';

class WaitingScreen extends StatelessWidget {
  final String formId;

  WaitingScreen({required this.formId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safe Road',
          style: TextStyle(
            fontSize: 32,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 16, 28, 38),
                  Colors.blueAccent
                ],
              ).createShader(const Rect.fromLTWH(0.0, 70.0, 200.0, 0.0)),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Load a Lottie file from a remote url
          Lottie.network(
              'https://lottie.host/4e69d648-b7a5-4c27-98c0-17cb984e0d24/rE5skB0OHu.json'),
          Center(
            child: Text(
              'Waiting for Admin Response',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('form')
                .doc(formId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('An error occurred'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('Document does not exist'));
              }

              var formStatus = snapshot.data!.get('status');

              return Center(
                child: Text(
                  'Form Status: $formStatus',
                  style: TextStyle(fontSize: 24),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('form')
                .doc(formId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(); // Return an empty SizedBox while waiting
              }

              var formStatus = snapshot.data!.get('status');

              if (formStatus == 'accepted') {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_circle_right,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => requestToService(),
                      ),
                    );
                  },
                );
              } else {
                return SizedBox(); // Return an empty SizedBox if status is not 'accepted'
              }
            },
          ),
        ],
      ),
    );
  }
}
