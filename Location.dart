import 'package:flutter/material.dart';
import 'destination.dart';

class LocationPage extends StatefulWidget {
  final String governorate;
  final String city;

  const LocationPage({super.key, required this.governorate, required this.city});

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final List<_Category> categories = [
    _Category('Entertainment', Icons.theater_comedy),
    _Category('Historical', Icons.account_balance),
    _Category('Wellness', Icons.spa),
    _Category('Natural', Icons.eco),
  ];

  final List<String> selectedCategories = [];

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void _goToPlaces() {
    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one category")),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/destination',
      arguments: {
        'cities': [widget.city],
        'categories': selectedCategories,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 320,
              height: 470,
              decoration: BoxDecoration(
                color: const Color(0xFF160948),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "Select location classification",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 25,
                      childAspectRatio: 1,
                      physics: const NeverScrollableScrollPhysics(),
                      children: categories.map((category) {
                        final isSelected = selectedCategories.contains(category.name);
                        return GestureDetector(
                          onTap: () => _toggleCategory(category.name),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(category.icon, color: Colors.white, size: 32),
                                const SizedBox(height: 10),
                                Text(
                                  category.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _goToPlaces,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                    ),
                    child: const Text("Next", style: TextStyle(color: Color(0xFF160948), fontWeight: FontWeight.bold, fontSize: 16)),
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

class _Category {
  final String name;
  final IconData icon;
  _Category(this.name, this.icon);
}
