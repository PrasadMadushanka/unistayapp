import 'package:flutter/material.dart';
import 'package:unistaynew/pages/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'), // Path to your image
            fit: BoxFit.cover,
            opacity: 0.33, // Fills the background
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 180,
              ),
              Row(
                //this is logo , name and slogan
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/logo.png', //  logo image
                    width: 150.0,
                    height: 150.0,
                  ),
                  const Column(
                    children: [
                      Text(
                        'UniStay',
                        style: TextStyle(
                          fontSize: 82.0, // Adjust size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Private Accommodation',
                        style: TextStyle(
                          fontSize: 22.0, // Adjust size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 370,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LogIn()));
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        "   Let's Get Started   ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '@ 2024 UniStay All Right Reserved.',
                style: TextStyle(
                  fontSize: 15.0, // Adjust size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}