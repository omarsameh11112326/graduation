import 'dart:convert';

import 'package:app_project/Nearst/nearby_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  String apiKey =
      "AIzaSyCzG2PxSPsIeiSrfbxN4zrYvmFVUhmRwZM"; // Replace with your API key
  String radius = "2500";

  late Position _currentPosition;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// List of Tab Bar Item
  List<String> items = [
    "All",
    "Gas station",
    "Car wash",
    "Car repair",
    "Parking",
    "car rental",
    "Rest",
  ];

  /// List of body icon
  List<IconData> icons = [
    Icons.home,
    Icons.gas_meter,
    Icons.water_drop,
    Icons.car_repair,
    Icons.local_parking,
    Icons.car_rental,
    Icons.local_cafe,
  ];
  int current = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            Text(
              'Nearst Services',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 16, 28, 38),
                      Colors.blueAccent
                    ],
                  ).createShader(const Rect.fromLTWH(0.0, 70.0, 200.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              current = index;
                            });
                            if (items[index] == "All") {
                              getNearbyPlaces([
                                "car_wash",
                                "gas_station",
                                "car_repair",
                                "parking",
                                "car_rental",
                                "cafe"
                              ]);
                            } else if (items[index] == "Car wash") {
                              getNearbyPlaces(["car_wash"]);
                            } else if (items[index] == "Gas station") {
                              getNearbyPlaces(["gas_station"]);
                            } else if (items[index] == "Car repair") {
                              getNearbyPlaces(["car_repair"]);
                            } else if (items[index] == "Parking") {
                              getNearbyPlaces(["parking"]);
                            } else if (items[index] == "car rental") {
                              getNearbyPlaces(["car_rental"]);
                            } else if (items[index] == "Rest") {
                              getNearbyPlaces(["cafe"]);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.all(5),
                            width: 100,
                            height: 55,
                            decoration: BoxDecoration(
                              color: current == index
                                  ? Colors.white70
                                  : Colors.white54,
                              borderRadius: current == index
                                  ? BorderRadius.circular(12)
                                  : BorderRadius.circular(7),
                              border: current == index
                                  ? Border.all(
                                      color: const Color.fromARGB(
                                          255, 20, 91, 150),
                                      width: 2.5)
                                  : null,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icons[index],
                                    size: current == index ? 23 : 20,
                                    color: current == index
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                  ),
                                  Text(
                                    items[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: current == index
                                          ? Colors.black
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: current == index,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 5, 42, 72),
                                shape: BoxShape.circle),
                          ),
                        )
                      ],
                    );
                  }),
            ),

            /// MAIN BODY
            Container(
              margin: const EdgeInsets.only(top: 30),
              width: double.infinity,
              height: 550,
              child: nearbyPlacesResponse.results != null
                  ? ListView.builder(
                      itemCount: nearbyPlacesResponse.results!.length,
                      itemBuilder: (context, index) {
                        return nearbyPlacesWidget(
                            context, nearbyPlacesResponse.results![index]);
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  void getNearbyPlaces(List<String> types) async {
    if (_currentPosition == null) {
      // Handle case when location is not available
      return;
    }

    var typesString = types.join('|');
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            _currentPosition.latitude.toString() +
            ',' +
            _currentPosition.longitude.toString() +
            '&radius=' +
            radius +
            "&types=$typesString" + // Specify the types of places here
            '&key=' +
            apiKey);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        nearbyPlacesResponse =
            NearbyPlacesResponse.fromJson(jsonDecode(response.body));
      });
    } else {
      // Handle errors
      print('Failed to load nearby places');
    }
  }

  Widget nearbyPlacesWidget(BuildContext context, Results results) {
    return FutureBuilder(
      future: getAddress(results),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return GestureDetector(
            onTap: () {
              _launchGoogleMaps(results.geometry!.location!.lat!,
                  results.geometry!.location!.lng!);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: " + results.name!),
                  Text("Address: " + snapshot.data.toString()),
                  Text(results.openingHours != null ? "Open" : "Closed"),
                  Text("Type: " + results.types!.join(", ")),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> getAddress(Results result) async {
    var detailsUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
            result.placeId.toString() +
            '&fields=formatted_address' +
            '&key=' +
            apiKey);

    var detailsResponse = await http.get(detailsUrl);

    if (detailsResponse.statusCode == 200) {
      var detailsJson = jsonDecode(detailsResponse.body);
      return detailsJson['result']['formatted_address'];
    } else {
      return "Address not available";
    }
  }

  void _launchGoogleMaps(double latitude, double longitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }
}
