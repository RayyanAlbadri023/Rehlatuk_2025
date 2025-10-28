import 'package:flutter/material.dart';
import 'ad4.dart';
import 'login_screen.dart';

class Ad3Screen extends StatelessWidget {
  const Ad3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0140), // Dark blue background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Skip button at top-right
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Main white card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image
                    Image.asset(
                      'assets/image3.jpg',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),

                    // Dots indicator (third active)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 2 ? 14 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: index == 2
                                ? const Color(0xFF0D0140)
                                : const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      "Start your adventure",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0140),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    const Text(
                      "Enjoy! Relax and create unforgettable memories.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0D0140),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Next button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Ad4Screen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D0140),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
