import 'package:flutter/material.dart';
import 'cart.dart';
import 'places.dart';
import 'details.dart';

class DestinationPlacesPage extends StatelessWidget {
  final List<String> selectedCities;
  final List<String> selectedCategories;

  const DestinationPlacesPage({
    super.key,
    required this.selectedCities,
    required this.selectedCategories,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredPlaces = [];

    // Filter places based on selected cities and categories
    for (var governorate in placesData.keys) {
      final governorateData = placesData[governorate]!;
      for (var city in governorateData.keys) {
        if (selectedCities.contains(city)) {
          final cityData = governorateData[city]!;
          for (var category in selectedCategories) {
            if (cityData.containsKey(category)) {
              filteredPlaces.addAll(cityData[category]!);
            }
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF160948)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cart button
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Color(0xFF160948)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom container with filtered places
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Color(0xFF160948),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: filteredPlaces.isEmpty
                    ? const Center(
                  child: Text(
                    "No places found!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : ListView.separated(
                  itemCount: filteredPlaces.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final place = filteredPlaces[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsPage(place: place),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                Image.asset(
                                  place["image"] ?? "",
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                // Place name text WITHOUT background
                                Positioned(
                                  bottom: 10,
                                  left: 15,
                                  child: Text(
                                    place["name"] ?? "Unknown Place",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Add to cart button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 16,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 18,
                                  color: Color(0xFF160948),
                                ),
                                onPressed: () {
                                  CartPage.addToCart(place);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${place['name']} added to cart"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
