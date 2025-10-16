import 'package:flutter/material.dart';
import 'details.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  // Static cart list to store added places
  static final List<Map<String, dynamic>> _cartItems = [];

  // Method to add to cart
  static void addToCart(Map<String, dynamic> place) {
    _cartItems.add(place);
  }

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
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

          // Safe area for back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF160948)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Rounded box like HomePage
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF160948), // same as HomePage
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.75,
              child: CartPage._cartItems.isEmpty
                  ? const Center(
                child: Text(
                  "Your cart is empty!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.separated(
                itemCount: CartPage._cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final place = CartPage._cartItems[index];
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
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 180,
                                    color: Colors.grey,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Image not found",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                child: Text(
                                  place["name"] ?? "Unknown Place",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 2,
                                        color: Colors.black45,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Remove icon top-right
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: IconButton(
                              icon: const Icon(Icons.delete, size: 18, color: Color(0xFF160948)),
                              onPressed: () {
                                setState(() {
                                  CartPage._cartItems.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${place['name']} removed from cart")),
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
        ],
      ),
    );
  }
}
