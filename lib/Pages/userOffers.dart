import 'package:app_project/Pages/googleMaps/googleMaps.dart';
import 'package:app_project/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/get_navigation.dart';

class UserOffers extends StatefulWidget {
  final double latitude;
  final double longitude;

  UserOffers({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<UserOffers> createState() => _requestToServiceState();
}

class _requestToServiceState extends State<UserOffers> {
  String? price;
  String? TypeOfService;
  String? userId;
  bool isAccepted = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('serviceProviderRequest').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No data available.'),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var requestData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  
                  String serviceType = requestData['typeOfServide'] ??
                      'Service type not available';
                  String price =
                      requestData['price'] ?? 'price not available';
                  String phone =
                      requestData['phoneNumper'] ?? 'phone not available';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           
                            Row(
                              children: [
                                const Icon(Icons.design_services),
                                SizedBox(width: 5,),
                                Text(
                                  'Type Of Service : $serviceType ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey, thickness: 2),
                            Row(
                              children: [
                                const Icon(Icons.chat),
                                SizedBox(width: 5,),
                                Text(
                                  'Price : $price',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey, thickness: 2),
                            Row(
                              children: [
                                const Icon(Icons.chat),
                                SizedBox(width: 5,),
                                Text(
                                  'Phone : $phone',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey, thickness: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      String documentId = snapshot.data!.docs[index].id;
                                      try {
                                        await deleteDoc(documentId);
                                        showSnackBar(context, 'success');
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 16, 28, 38),
                                            Colors.red,
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 65),
                                  GestureDetector(
                                    onTap: () async {
                                      String documentId = snapshot.data!.docs[index].id;
                                      try {
                                        await updateIsAccepted(documentId);
                                        List<Map<String, dynamic>> userRequests = await fetchUserRequests();

                                        if (userRequests.isNotEmpty ) {
                                          double latitude = userRequests.first['latitude'];
                                          double longitude = userRequests.first['longitude'];
                                         
                                         
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return Live(latitude: latitude, longitude: longitude, latitude2: 0.0, longitude2: 0.0,);
                                          }));
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 16, 28, 38),
                                            Colors.green,
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteDoc(String documentId) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference docRef = firestoreInstance.collection('serviceProviderRequest').doc(documentId);
      await docRef.delete();
    } catch (error) {
      print('Error deleting document: $error');
    }
  }

  Future<void> updateIsAccepted(String documentId) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference docRef = firestoreInstance.collection('serviceProviderRequest').doc(documentId);
      await docRef.update({'IsAccepted': true});
    } catch (error) {
      print('Error updating document: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserRequests() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('userRequest')
          .orderBy('createdAt', descending: true)
          .get();
      List<Map<String, dynamic>> userRequests = [];
      querySnapshot.docs.forEach((doc) {
        double latitude = doc['latitude'] ?? 0.0;
        double longitude = doc['longitude'] ?? 0.0;
        Map<String, dynamic> userData = {
          'latitude': latitude,
          'longitude': longitude,
        };
        userRequests.add(userData);
      });
      return userRequests;
    } catch (error) {
      print('Error fetching user requests: $error');
      return [];
    }
  }
  Future<List<Map<String, dynamic>>> fetchSreviceProviderLatLong() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('form')
          .orderBy('createdAt', descending: true)
          .get();
      List<Map<String, dynamic>> ServiceProviderLat = [];
      querySnapshot.docs.forEach((doc) {
        double latitude = doc['lat'] ?? 0.0;
        double longitude = doc['long'] ?? 0.0;
        Map<String, dynamic> userData = {
          'latitude2': latitude,
          'longitude2': longitude,
        };
        ServiceProviderLat.add(userData);
      });
      return ServiceProviderLat;
    } catch (error) {
      print('Error fetching user requests: $error');
      return [];
    }
  }

  Future<void> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }
}