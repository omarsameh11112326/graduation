import 'dart:async';
import 'package:app_project/Pages/userOffers.dart';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FuelDelivery extends StatefulWidget {
  FuelDelivery({Key? key}) : super(key: key);

  @override
  State<FuelDelivery> createState() => _FuelDeliveryState();
}

class _FuelDeliveryState extends State<FuelDelivery> {
  String address = '';
  String userId = '';

  final Completer<GoogleMapController> _controller = Completer();

  Future<Position> _getUserCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition();
    }

    // Handle case where permissions are denied, but not permanently.
    return Future.error('Location permissions are denied.');
  }

  final List<Marker> _markers = <Marker>[];

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(title: 'some Info ')),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.addAll(list);
    //loadData();
  }

  loadData() {
    _getUserCurrentLocation().then((value) async {
      _markers.add(Marker(
          markerId: const MarkerId('SomeId'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: address)));

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {});
    });
  }

  bool isLoading = false;

  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(),
          child: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(_markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 0,
                          bottom: 0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 300,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 16, 28, 38),
                                    Colors.blueAccent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.local_gas_station,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Text(
                                    "Fuel Delivery",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              //height: MediaQuery.of(context).size.height * .2,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _getUserCurrentLocation()
                                          .then((value) async {
                                        _markers.add(Marker(
                                            markerId: const MarkerId('SomeId'),
                                            position: LatLng(value.latitude,
                                                value.longitude),
                                            infoWindow:
                                                InfoWindow(title: address)));
                                        final GoogleMapController controller =
                                            await _controller.future;

                                        CameraPosition _kGooglePlex =
                                            CameraPosition(
                                          target: LatLng(
                                              value.latitude, value.longitude),
                                          zoom: 14,
                                        );
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                _kGooglePlex));

                                        List<Placemark> placemarks =
                                            await placemarkFromCoordinates(
                                                value.latitude,
                                                value.longitude);

                                        final add = placemarks.first;

                                        address += add.subThoroughfare != null
                                            ? '${add.subThoroughfare}'
                                            : '';
                                        address += add.thoroughfare != null
                                            ? ', ${add.thoroughfare}'
                                            : '';
                                        address += add.subLocality != null
                                            ? ', ${add.subLocality}'
                                            : '';
                                        address += add.locality != null
                                            ? ', ${add.locality}'
                                            : '';
                                        address += add.subAdministrativeArea !=
                                                null
                                            ? ', ${add.subAdministrativeArea}'
                                            : '';
                                        address +=
                                            add.administrativeArea != null
                                                ? ', ${add.administrativeArea}'
                                                : '';
                                        address += add.country != null
                                            ? ', ${add.country}'
                                            : '';
                                        address += add.postalCode != null
                                            ? ', ${add.postalCode}'
                                            : '';

                                        setState(() {});
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Center(
                                            child: Text(
                                          'get your Current Location',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(address),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.message),
                                hintText:
                                    "Please Write Your Problem description",
                                hintStyle: TextStyle(fontSize: 13),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 300,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.credit_card,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Text(
                                      "Visa",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Icon(Icons.arrow_right),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            CustomButton(
                              onTap: () {
                                // Save user request to Firestore

                                _saveUserRequest();
                                 Navigator.of(context).push(MaterialPageRoute(builder: 
                                (context) {
                                  return UserOffers(
      latitude: _markers.last.position.latitude,
      longitude: _markers.last.position.longitude,
    );
                                },
                                ));
                              },
                              text: "Get your help",
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<String?> getUserId() async {
  // Get the current user ID from Firebase Authentication
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  }
  return null; // Return null if user is not authenticated
}
void _saveUserRequest() async {
  try {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    String? userId = await getUserId();

    // Access Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Get the description and location
    String description = _descriptionController.text;
    String location = "$address"; // You need to update this with actual location
    LatLng lastMarkerPosition = _markers.last.position;
    double latitude = lastMarkerPosition.latitude;
    double longitude = lastMarkerPosition.longitude;

    // Add document to 'userRequest' collection
    await firestoreInstance.collection('userRequest').add({
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'serviceType': 'Fuel Delivery',
      'userId': userId,
        'createdAt': FieldValue.serverTimestamp(), 
    });

    // Request saved successfully
    setState(() {
      isLoading = false; // Hide loading indicator
    });

    // Optionally, you can show a success message or navigate to a new screen here
  } catch (error) {
    // Handle errors
    print('Error saving user request: $error');
    setState(() {
      isLoading = false; // Hide loading indicator in case of error
    });
  }
}

}