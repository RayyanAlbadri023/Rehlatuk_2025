import 'package:flutter/material.dart';
import 'comment_page.dart';
import 'map_page.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> place;

  const DetailsPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF160948),
      appBar: AppBar(
        backgroundColor: const Color(0xFF160948),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          place["name"] ?? "Place Details",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image of the place
            if (place["image"] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  place["image"],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Description text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                place["description"] ?? "No information available for this place.",
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // Rating and comment row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Fixed rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 28),
                      const SizedBox(width: 5),
                      Text(
                        place["rating"]?.toStringAsFixed(1) ?? "0.0",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Comment icon
                  IconButton(
                    icon: const Icon(Icons.comment, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommentPage(
                            placeName: place["name"],
                            initialComments: place["comments"] ?? [],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // View Location Map Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF160948),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MapPage(placeName: place["name"]),
                    ),
                  );
                },
                icon: const Icon(Icons.location_on_outlined),
                label: const Text(
                  "View Location Map",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
