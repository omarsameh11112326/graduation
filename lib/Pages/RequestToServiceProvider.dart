import 'package:app_project/Pages/Services.dart';
import 'package:app_project/Pages/home.dart';
import 'package:app_project/Pages/serviceProviderPages/profileServiceProvider.dart';
import 'package:app_project/helper/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool isLoading = false;



int _selectedIndex = 0; // Current tab index


 

  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  switch (index) {
    case 0:
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userId: '',)));
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileServiceProvider()));
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Services()));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(userId: '',)));
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
                  String location =
                      requestData['location'] ?? 'Location not available';
                  String serviceType = requestData['serviceType'] ??
                      'Service type not available';
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
                                      onChanged: (data){
                                        price=data;

                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Set Price",
                                        fillColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 70),
                                  GestureDetector(
                                    onTap: () async{
                                     String documentId = snapshot.data!.docs[index].id;

                                  
                                      try {
                                        await ServiceProviderResponse(price!,serviceType);
                                        await DeleteDoc(documentId);
                                        showSnackBar(context, 'success');
                                        }catch(e){
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
              ),
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
    // Get the current user ID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  // Function to fetch data from Firestore
  Future<String?> getPhoneNumber() async {
  try {
    // Get the current user ID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch documents from Firestore based on "userId" field
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('form')
          .where('userId', isEqualTo: user.uid) // Filter by user ID
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Assume there's only one document per user, use the first one
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Safely access and handle potential null data
        Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Return the phone number
          return userData['phone'];
        } else {
          // Handle case where data is null (should not normally happen if document exists)
          print('Document data is null for user ID: ${user.uid}');
        }
      } else {
        // No document found for the specified user ID
        print('No document found for user ID: ${user.uid}');
      }
    } else {
      print('User is not authenticated.');
    }
  } catch (error) {
    // Handle errors
    print('Error fetching phone number: $error');
  }
  return null; // Return null if there's an error or no phone number found
}
  Future<void> ServiceProviderResponse(String price, String TypeOfService) async {
  try {
    // Access Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Fetch phone number from Firestore 'form' collection
    String? phoneNumber = await getPhoneNumber();

    DocumentReference docRef = await firestore.collection('serviceProviderRequest').add({
      'price': price,
      'typeOfServide': TypeOfService,
      'phoneNumper': phoneNumber, // Add phone number to the document
    });

    print('Document added with ID: ${docRef.id}');
  } catch (error) {
    // Handle errors
    print('Error saving user request: $error');
  }
}

Future<void> DeleteDoc(String documentId) async {
  try {
    // Access Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Add document to 'userRequest' collection
    DocumentReference docRef = firestoreInstance.collection('userRequest').doc(documentId);

    await docRef.delete();

    // Optionally, you can show a success message or navigate to a new screen here
  } catch (error) {
    // Handle errors
    print('Error deleting user request: $error');
  }
}


}