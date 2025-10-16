import 'package:flutter/material.dart';

class GovernoratePage extends StatefulWidget {
  final String selectedCountry;
  const GovernoratePage({super.key, required this.selectedCountry});

  @override
  _GovernoratePageState createState() => _GovernoratePageState();
}

class _GovernoratePageState extends State<GovernoratePage> {
  // Full list of Oman governorates
  final Map<String, List<String>> governoratesByCountry = {
    "Oman": [
      "Muscat",
      "Dhofar",
      "Al Batinah North",
      "Al Batinah South",
      "Al Dhahirah",
      "Al Dakhiliyah",
      "Ash Sharqiyah North",
      "Ash Sharqiyah South",
      "Al Wusta",
      "Musandam",
    ],
    // You can add more countries with governorates here
  };

  @override
  Widget build(BuildContext context) {
    final governorates = governoratesByCountry[widget.selectedCountry] ?? [];

    return Scaffold(
      body: Stack(
        children: [
          // Background image (same as country page)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Top bar with back button and home icon
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.pop(context); // back to country page
                  },
                ),
                // Empty space for center alignment
                const SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/home",
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          // Main content (scrollable governorate list) with styled container
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF160948).withOpacity(0.7), // same color as city.dart box
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "Select a Governorate in ${widget.selectedCountry}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Governorates List with white buttons
                  Expanded(
                    child: ListView.builder(
                      itemCount: governorates.length,
                      itemBuilder: (context, index) {
                        final governorate = governorates[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // button color white now
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/city',
                                arguments: governorate,
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                governorate,
                                style: const TextStyle(
                                  color: Color(0xFF160948), // dark purple text
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
