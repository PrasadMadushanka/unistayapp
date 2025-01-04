import 'package:flutter/material.dart';
import 'package:unistay/choosing_screen.dart';

class ProviderLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'), // Path to your image
            fit: BoxFit.cover,
            opacity: 0.33, // Fills the background
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Positioned(
                      top: 10, // Adjust 'top' to control vertical position
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back to the previous screen
                        },
                      ),
                    ),
                  ],
                ),
                // Logo and Slogan
                Column(
                  children: [
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
                  ],
                ),
                const SizedBox(height: 50),
                // Sign Up Form Container
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: const Color.fromARGB(0, 20, 25, 172),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 240, 235, 235)
                            .withOpacity(0.8),
                        blurRadius: 16.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30.0, // Adjust size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Username TextField
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Username/Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      // Password TextField
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Sign Up Button
                      ElevatedButton(
                        onPressed: () {
                          // Handle sign-up logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'LogIn',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                const Text("Don't have an account?"),
                GestureDetector(
                  onTap: () {
                    // Navigate to SecondScreen when text is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoosingScreen()),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.blue, // Make the text appear as a link
                      decoration:
                          TextDecoration.underline, // Underline the text
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Footer
                Text(
                  '@ 2024 UniStay All Right Reserved.',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
