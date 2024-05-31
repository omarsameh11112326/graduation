import 'package:app_project/Pages/serviceProviderPages/ServiceProviderUpdate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ProfileServiceProvider extends StatefulWidget {
  const ProfileServiceProvider({Key? key})
      : super(key: key);

  @override
  State<ProfileServiceProvider> createState() => _ProfileServiceProviderState();
}

class _ProfileServiceProviderState extends State<ProfileServiceProvider> {
  bool isLoading = false;
  late String businessName = '';
  late String location = '';
  late String nationalId = '';
  late String placePhoto = '';
  late String serviceType = '';
  late String phone = '';
  late String userId;

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
  Future<void> fetchDataFromFirestore() async {
    setState(() {
      isLoading = true;
    });

    try {
      
      getUserId();
      // Fetch documents from Firestore based on "userid" field
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('form')
          .where('userId', isEqualTo: userId) // Filter by user ID
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Assume there's only one document per user, use the first one
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Safely access and handle potential null data
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Update local variables with fetched data
          setState(() {
            businessName = data['businessName'] ?? '';
            location = data['location'] ?? '';
            nationalId = data['nationalID'] ?? '';
            placePhoto = data['place'] ?? '';
            serviceType = data['selectedValue'] ?? '';
            phone = data['phone'] ?? '';
          });
        } else {
          // Handle case where data is null (should not normally happen if document exists)
          print('Document data is null for user ID: ${userId}');
        }
      } else {
        // No document found for the specified user ID
        print('No document found for user ID: ${userId}');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching data: $e');
    }

    setState(() {
      isLoading = false;
    });
  
  }
  @override
  void initState() {
    super.initState();
    // Call the function to fetch data when the widget initializes
    fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 22),
                child: Text(
                  'Profile \nService Provider',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 16, 28, 38),
                                Colors.blueAccent,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, top: 40),
                            child: Column(
                              children: [
                                // Display fetched data
                                buildDataRow(Icons.check, 'Business Name ',
                                    businessName),
                                buildDataRow(Icons.email, 'Location', location),
                                if (nationalId.isNotEmpty)
                                  buildTappableImageRow(
                                      Icons.image, 'National ID', nationalId),
                                if (placePhoto.isNotEmpty)
                                  buildTappableImageRow(
                                      Icons.image, 'Place Photo', placePhoto),
                                buildDataRow(Icons.settings, 'Service Type',
                                    serviceType),
                                buildDataRow(
                                    Icons.check, 'Phone Number ', phone),


                               
                                const SizedBox(height: 160),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: 
                                    (context) {
                                      return ServiceProviderUpdate();
                                    },
                                    ));
                                  },
                                  child: Container(
                                    height: 53,
                                    width: 320,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
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

  // Helper function to build each row of data
  Widget buildDataRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  // Helper function to build tappable image row
  Widget buildTappableImageRow(IconData icon, String label, String imageUrl) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          _showImageFullScreenDialog(imageUrl);
        },
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}


  // Function to show image in full screen dialog
 void _showImageFullScreenDialog(String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close dialog on tap
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    },
  );
}

}