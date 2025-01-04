import 'package:flutter/material.dart';
import 'package:unistay/provider_welcome_screen.dart';
import 'package:unistay/seeker_welcome_screen.dart';

class ChoosingScreen extends StatelessWidget {
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
                const SizedBox(height: 60),
                const Text(
                  "You?",
                  style: TextStyle(
                    fontSize: 42.0, // Adjust size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 95),
                SizedBox(
                    width: 273, // Set the width of the button
                    height: 85, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeekerWelcome()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Rounded corners
                        ),
                      ),
                      child: const Text("Seeker"),
                    )),
              ]),
              Column(children: [
                const SizedBox(height: 20),
                SizedBox(
                    width: 273, // Set the width of the button
                    height: 85, // Set the height of the button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProviderWelcome()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        backgroundColor: const Color.fromARGB(
                            255, 255, 255, 255), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Rounded corners
                        ),
                      ),
                      child: const Text("Provider"),
                    )),
              ]),
              const Column(
                children: [
                  SizedBox(height: 120),
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
