import 'package:flutter/material.dart';

import 'choosing_screen.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Path to your image
            fit: BoxFit.cover,
            opacity: 0.33, // Fills the background
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 92),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo.png', // Your logo image
                    width: 95.0, // Adjust size as needed
                    height: 95.0,
                  ),
                  const SizedBox(width: 5.0),
                  const Column(
                    children: [
                      // Space between logo and slogan
                      Text(
                        'UniStay',
                        style: TextStyle(
                          fontSize: 49.0, // Adjust size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Private Accommodation',
                        style: TextStyle(
                          fontSize: 12.0, // Adjust size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(children: [
                const SizedBox(height: 220),
                SizedBox(
                    width: 273, // Set the width of the button
                    height: 85, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to SecondScreen when the button is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChoosingScreen()),
                        );
                      },
                      child: Text("Let's Get Started."),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Rounded corners
                        ),
                      ),
                    )),
              ]),
              const Column(
                children: [
                  SizedBox(height: 220),
                  Text(
                    '@ 2024 UniStay All Right Reserved.',
                    style: TextStyle(
                      fontSize: 10.0, // Adjust size as needed
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
