import 'package:flutter/material.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final TextEditingController _controller = TextEditingController();

  final List<String> countries = [
    "Oman",
    "Qatar",
    "Kuwait",
    "Bahrain",
    "Saudi Arabia",
    "United Arab Emirates",
    "Egypt",
    "Jordan",
    "Lebanon",
    "Iraq",
    "Syria",
    "Yemen",
    "India",
    "Pakistan",
    "Japan",
    "China",
    "South Korea",
    "Malaysia",
    "Indonesia",
    "France",
    "Germany",
    "Spain",
    "Italy",
    "United Kingdom",
    "United States",
    "Canada",
    "Brazil",
    "Argentina",
    "Australia"
  ];

  List<String> filteredCountries = [];

  @override
  void initState() {
    super.initState();

    // Sort countries alphabetically
    countries.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    // Show all countries initially
    filteredCountries = List.from(countries);
  }

  void _filterCountries(String query) {
    final results = countries
        .where((country) =>
        country.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    setState(() {
      filteredCountries = query.isEmpty ? List.from(countries) : results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Top bar with back button and home icon button
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.home, color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  },
                ),
              ],
            ),
          ),

          /// Search box and country list
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF160948).withOpacity(0.85), // same as city.dart
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Search and select the country ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Search input
                  TextField(
                    controller: _controller,
                    onChanged: _filterCountries,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search country...",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Country list
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            filteredCountries[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/governorate",
                              arguments: filteredCountries[index],
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
