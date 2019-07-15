import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF11a085),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Stack(
            children: <Widget>[
              Center(
                child: Image.asset(
                  "assets/images/splash_logo.png",
                  width: 250,
                  height: 150,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "© 2018 Crafted by PDFfiller Inc. All rights reserved.",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                    color: Colors.white,
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
