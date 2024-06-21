import 'package:app_project/Pages/googleMaps/googleMaps.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class WaitingScreen2 extends StatelessWidget {
  WaitingScreen2();

  Future<String> getLatestDocumentId() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('serviceProviderRequest')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
        
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      throw Exception('No documents found');
    }
  }

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
      body: FutureBuilder<String>(
        future: getLatestDocumentId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No document found'));
          }

          String documentId = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Load a Lottie file from a remote url
              Lottie.network('https://lottie.host/4e69d648-b7a5-4c27-98c0-17cb984e0d24/rE5skB0OHu.json'),
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
                    .doc(documentId)
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
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('googleMapsNavigation')
                          .orderBy('createdAt', descending: true)
                          .limit(1)
                          .get(),
                      builder: (context, querySnapshot) {
                        if (querySnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (querySnapshot.hasError) {
                          return Center(child: Text('An error occurred'));
                        }

                        if (!querySnapshot.hasData || querySnapshot.data!.docs.isEmpty) {
                          return Center(child: Text('Document does not exist'));
                        }

                        DocumentSnapshot document = querySnapshot.data!.docs.first;

                        double userLat = document.get('userLat');
                        double userLong = document.get('userLong');
                        double serviceProviderLat = document.get('serviceProviderLat');
                        double serviceProviderLong = document.get('serviceProviderLong');

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
                                    builder: (context) => Live(
                                      latitude: userLat,
                                      longitude: userLong,
                                      latitude2: serviceProviderLat,
                                      longitude2: serviceProviderLong,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
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
          );
        },
      ),
    );
  }
}