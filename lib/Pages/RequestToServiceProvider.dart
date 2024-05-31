import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class requestToService extends StatelessWidget {
  requestToService({Key? key});

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
                                  'Type Of Service : $serviceType',
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey, thickness: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 80,
                                    height: 35,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Set Price",
                                        fillColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 70),
                                  GestureDetector(
                                    onTap: () {},
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
      ),
    );
  }
}