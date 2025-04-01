import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Secure Your Banking Apps",
          body: "Protect your financial transactions from unauthorized access.",
          image: const Center(child: Icon(Icons.security, size: 100, color: Colors.blueAccent)),
        ),
        PageViewModel(
          title: "Prevent Screen Recording",
          body: "Ensure your transactions remain private and safe.",
          image: const Center(child: Icon(Icons.visibility_off, size: 100, color: Colors.blueAccent)),
        ),
        PageViewModel(
          title: "Block Unauthorized Apps",
          body: "Restrict unwanted apps from accessing your banking information.",
          image: const Center(child: Icon(Icons.block, size: 100, color: Colors.blueAccent)),
        ),
        PageViewModel(
          title: "Stay Secure and Protected",
          body: "Use SecureBank Hub to keep your financial data safe.",
          image: const Center(child: Icon(Icons.shield, size: 100, color: Colors.blueAccent)),
        ),
      ],
      onDone: () => Navigator.pushReplacementNamed(context, '/login'),
      onSkip: () => Navigator.pushReplacementNamed(context, '/login'),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}