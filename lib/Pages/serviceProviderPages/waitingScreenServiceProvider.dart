import 'package:app_project/Pages/googleMaps/googleMaps.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_project/Pages/RequestToServiceProvider.dart';
import 'package:lottie/lottie.dart';

class WaitingScreen2 extends StatelessWidget {
  final String userId;

  WaitingScreen2({required this.userId});

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
                  Colors.blueAccent,
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
              'Waiting for User Response',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('serviceProviderRequest')
                .doc(userId)
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

              bool isAccepted = false;
              try {
                isAccepted = snapshot.data!.get('IsAccepted');
              } catch (e) {
                return Center(child: Text('Error fetching request status'));
              }

              if (isAccepted) {
                return Column(
                  children: [
                    Center(
                      child: Text(
                        'Request Status: Accepted',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 20),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_circle_right,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Live(latitude: 0, longitude: 0),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    'Request Status: Pending',
                    style: TextStyle(fontSize: 24),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
