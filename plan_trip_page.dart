import 'package:flutter/material.dart';

class PlanTripPage extends StatefulWidget {
  const PlanTripPage({super.key});

  @override
  State<PlanTripPage> createState() => _PlanTripPageState();
}

class _PlanTripPageState extends State<PlanTripPage> {
  int _selectedIndex = 2; // trip plan icon index in bottom nav

  // Sample trip plans (newest first)
  List<Map<String, dynamic>> _tripPlans = [
    {
      "name": "Muscat Trip",
      "days": [
        {"day": "Day 1", "place": "Sultan Qaboos Grand Mosque"},
        {"day": "Day 2", "place": "Mutrah Souq"},
        {"day": "Day 3", "place": "Qurum Beach"},
      ],
    },
    {
      "name": "Bangkok Trip",
      "days": [
        {"day": "Day 1", "place": "Grand Palace"},
        {"day": "Day 2", "place": "Chatuchak Market"},
        {"day": "Day 3", "place": "Khao San Road"},
      ],
    },
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/home");
        break;
      case 1:
        Navigator.pushNamed(context, "/chatbot");
        break;
      case 2:
      // already here
        break;
      case 3:
        Navigator.pushNamed(context, "/settings");
        break;
    }
  }

  void _deleteTrip(int index) {
    setState(() {
      _tripPlans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/car.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: const Color(0xFF160948),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Trip Plans",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _tripPlans.length,
                        reverse: false,
                        itemBuilder: (context, index) {
                          final trip = _tripPlans[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.white, // box color changed to white
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip["name"],
                                        style: const TextStyle(
                                          color: Color(0xFF160948), // blue text
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        children: List.generate(trip["days"].length,
                                                (dayIndex) {
                                              final day = trip["days"][dayIndex];
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        day["day"],
                                                        style: const TextStyle(
                                                            color: Color(0xFF160948),
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        day["place"],
                                                        style: const TextStyle(
                                                            color: Color(0xFF160948),
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  if (dayIndex !=
                                                      trip["days"].length - 1)
                                                    const Divider(
                                                      color: Colors.grey, // line between days
                                                      thickness: 1,
                                                    ),
                                                ],
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                // Delete button bottom right
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () => _deleteTrip(index),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[400],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 28,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }
}
