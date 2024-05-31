import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class hold4 extends StatefulWidget {
  hold4({Key? key});

  @override
  State<hold4> createState() => _hold4State();
}

class _hold4State extends State<hold4> {
  late Stream<QuerySnapshot> _notificationsStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen for changes in the 'notif-message' collection
    _notificationsStream = FirebaseFirestore.instance
    .collection('notif-message')
    .orderBy('createdAt',descending: true)
    .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 37,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 0.02,
            letterSpacing: -0.41,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data available.'),
            );
          }

          var lastNotification =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          String message = lastNotification['message'] ?? "No notification yet";

          return NotificationCard(title: message);
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;

  const NotificationCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.blueAccent; // Default color

    if (title.toLowerCase().contains('urgent')) {
      cardColor = Colors.red; // Set color to red for urgent messages
    } else if (title.toLowerCase().contains('normal')) {
      cardColor = Colors.blue; // Set color to blue for normal messages
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('images/female.png'),
                radius: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
