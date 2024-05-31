
import 'package:app_project/hold/hold4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class hold extends StatefulWidget {
  const hold({super.key});

  @override
  State<hold> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<hold> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  ElevatedButton(
                onPressed: () {
                   _saveUserRequest();
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                     return hold4();
                   },));
                },
                child: Text('hi'),

                ),
    );
  }

}
void _saveUserRequest() async {
  try {
    String message = 'Service was accepted55555555555555555555555555555555555555555555555555555555555';
    String messageCraft = 'User request';
    
    // Access Firestore instance
    final firestoreInstance = FirebaseFirestore.instance;

    // Create a new document with a timestamp field
    await firestoreInstance.collection('notif-message').add({
      'message': message,
      'message-craft': messageCraft,
      'createdAt': FieldValue.serverTimestamp(), // Add a server timestamp
    });

    // Optionally, you can show a success message or navigate to a new screen here
  } catch (error) {
    // Handle errors
    print('Error saving user request: $error');
  }
}

