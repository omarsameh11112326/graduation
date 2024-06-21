import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class userWaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.network(
              'https://lottie.host/4e69d648-b7a5-4c27-98c0-17cb984e0d24/rE5skB0OHu.json', 
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20),
            Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
