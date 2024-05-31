import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  State<Services> createState() => _ServicesState();
}

String? addressOfUser;

class _ServicesState extends State<Services> {
  bool isLoading = false;

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
                child: FlutterLocationPicker(
                  initZoom: 11,
                  minZoomLevel: 5,
                  maxZoomLevel: 16,
                  trackMyPosition: true,
                  onPicked: (pickedData) {
                    addressOfUser = pickedData.address;
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
                            topRight: Radius.circular(40)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(
                                  flex: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'Tire Change');
                                  },
                                  child: Card(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(
                                                255, 16, 28, 38),
                                            Colors.blueAccent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "images/tires_2422813.png",
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Tire change',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'Mechanic');
                                  },
                                  child: Card(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(
                                                255, 16, 28, 38),
                                            Colors.blueAccent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "images/automobile-with-wrench_81836.png",
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Mechanic',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Spacer(
                                  flex: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'Jump Start');
                                  },
                                  child: Card(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(
                                                255, 16, 28, 38),
                                            Colors.blueAccent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "images/battery_9734403.png",
                                            color: Colors.white,
                                            height: 50,
                                            width: 50,
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Jump Start',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'Fuel Delivery');
                                  },
                                  child: Card(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(
                                                255, 16, 28, 38),
                                            Colors.blueAccent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_gas_station,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'Fuel Delivery',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
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
}
