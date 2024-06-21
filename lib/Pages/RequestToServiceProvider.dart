import 'package:app_project/AdminPannel/waitingScreen.dart';
import 'package:app_project/Pages/Services.dart';
import 'package:app_project/Pages/home.dart';
import 'package:app_project/Pages/serviceProviderPages/profileServiceProvider.dart';
import 'package:app_project/Pages/serviceProviderPages/waitingScreenServiceProvider.dart';
import 'package:app_project/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class requestToService extends StatefulWidget {
  requestToService({Key? key});

  @override
  State<requestToService> createState() => _requestToServiceState();
}

class _requestToServiceState extends State<requestToService> {
  String? price;
  String? TypeOfService;
  late String phone = '';
  late String userId;
  String? serverTimestamp;
  bool isLoading = false;
  bool IsAccepted = false;
  String? googleMapsNavigationDocumentIdawait;
  int _selectedIndex = 0; // Current tab index
  

  Future<void> fetchLatestDocumentId() async {
    String? documentId = await getLastCreatedDocumentId();
    setState(() {
      googleMapsNavigationDocumentIdawait = documentId!;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLatestDocumentId();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      userId: '',
                    )));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileServiceProvider()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Services()));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      userId: '',
                    )));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('userRequest').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var requestData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String location =
                    requestData['location'] ?? 'Location not available';
                String serviceType =
                    requestData['serviceType'] ?? 'Service type not available';
                String description =
                    requestData['description'] ?? 'Description not available';

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
                              const Icon(Icons.location_on),
                              Expanded(
                                child: Text(
                                  'Location : $location',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey, thickness: 2),
                          Row(
                            children: [
                              const Icon(Icons.design_services),
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
                              Text(
                                'Description : $description',
                                maxLines: 3,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey, thickness: 2),
                          Padding(
                            padding: const EdgeInsets.only(left: 50.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 35,
                                  child: TextField(
                                    onChanged: (data) {
                                      price = data;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Set Price",
                                      fillColor: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 70),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await fetchLatestDocumentId();
                                    await getUserId();

                                    if (googleMapsNavigationDocumentIdawait !=
                                        null) {
                                      await GoogleNavigateUser(
                                          googleMapsNavigationDocumentIdawait!,
                                          userId);
                                    }

                                    try {
                                      await ServiceProviderResponse(
                                          price!, serviceType);
                                      showSnackBar(context, 'success');
                                    } catch (e) {
                                      print(e);
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 16, 28, 38),
                                          Colors.blueAccent,
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Send",
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
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_right_rounded),
              label: 'User Mode',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue.shade900,
          unselectedItemColor: Colors.grey, // Set unselected icon color
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<void> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<String?> getPhoneNumber() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('form')
            .where('userId', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          Map<String, dynamic>? userData =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            return userData['phone'];
          } else {
            print('Document data is null for user ID: ${user.uid}');
          }
        } else {
          print('No document found for user ID: ${user.uid}');
        }
      } else {
        print('User is not authenticated.');
      }
    } catch (error) {
      print('Error fetching phone number: $error');
    }
    return null;
  }

  Future<void> ServiceProviderResponse(
      String price, String TypeOfService) async {
    try {
      final firestore = FirebaseFirestore.instance;
      String? phoneNumber = await getPhoneNumber();
      await getUserId();

      DocumentReference docRef =
          await firestore.collection('serviceProviderRequest').add({
        'price': price,
        'typeOfServide': TypeOfService,
        'phoneNumper': phoneNumber,
        'IsAccepted': IsAccepted,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WaitingScreen2();
      }));

      print('Document added with ID: ${docRef.id}');
    } catch (error) {
      print('Error saving user request: $error');
    }
  }

  Future<void> DeleteDoc(String documentId) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      DocumentReference docRef =
          firestoreInstance.collection('userRequest').doc(documentId);
      await docRef.delete();
    } catch (error) {
      print('Error deleting user request: $error');
    }
  }

  Future<String?> getLastCreatedDocumentId() async {
  try {
      final firestoreInstance = FirebaseFirestore.instance;

    // Query Firestore for the most recent document based on 'createdAt' field
    QuerySnapshot querySnapshot = await firestoreInstance
        .collection('googleMapsNavigation')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    // Check if there are any documents returned
    if (querySnapshot.docs.isNotEmpty) {
      // Return the ID of the first document (most recent one)
      return querySnapshot.docs.first.id;
    } else {
      // If no documents found, return null
      return null;
    }
  } catch (e) {
    // Print and handle any errors that occur during fetching
    print('Error fetching document: $e');
    return null; // Return null in case of error
  }
}

  Future<void> GoogleNavigateUser(
      String googleMapsDocumentId, String userId) async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      QuerySnapshot formQuerySnapshot = await firestoreInstance
          .collection('form')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (formQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot formDocumentSnapshot = formQuerySnapshot.docs.first;
        double latitude = formDocumentSnapshot.get('lat');
        double longitude = formDocumentSnapshot.get('long');

        await firestoreInstance
            .collection('googleMapsNavigation')
            .doc(googleMapsDocumentId)
            .update({
          'serviceProviderLat': latitude,
          'serviceProviderId': userId,
          'serviceProviderLong': longitude,
        });
      } else {
        print('Form document with the specified userId does not exist');
      }
    } catch (error) {
      print('Error fetching form data or updating user request: $error');
    }
  }
  
}