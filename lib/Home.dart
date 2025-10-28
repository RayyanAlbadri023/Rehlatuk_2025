import 'package:flutter/material.dart';
import 'country.dart';
import 'settings_page.dart';
import 'previous_plans_page.dart'; // ✅ Added import
import 'user_data.dart'; // Tracks language changes

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String currentLanguage = "English"; // ✅ Default to avoid LateInitializationError

  @override
  void initState() {
    super.initState();

    // ✅ Safe initialization with fallback
    currentLanguage = userDataNotifier.value.language ?? "English";

    // ✅ Listen for language changes
    userDataNotifier.addListener(_updateLanguage);
  }

  @override
  void dispose() {
    // ✅ Prevent memory leaks
    userDataNotifier.removeListener(_updateLanguage);
    super.dispose();
  }

  void _updateLanguage() {
    setState(() {
      currentLanguage = userDataNotifier.value.language ?? "English";
    });
  }

  // ✅ Updated navigation
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 2) {
      // 📄 Open Previous Plans page when list_alt icon is clicked
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PreviousPlansPage()),
      );
    } else if (index == 3) {
      // ⚙️ Settings page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    } else if (index == 1) {
      // 🤖 For future AI or trip suggestion features
    } else if (index == 0) {
      // 🏠 Stay on home
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ✅ Define colors based on theme
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF160948);
    final buttonBackground = isDark ? Colors.white : const Color(0xFF160948);
    final buttonTextColor = isDark ? const Color(0xFF160948) : Colors.white;
    final bottomBarColor = isDark ? Colors.grey[400] : const Color(0xFF160948);
    const bottomBarSelected = Colors.white;
    const bottomBarUnselected = Colors.white70;

    // ✅ Text translations
    final discoverText = currentLanguage == "Arabic"
        ? "اكتشف وجهات جديدة"
        : "Discover New Destination";
    final startTripText = currentLanguage == "Arabic"
        ? "ابدأ رحلتك الجديدة"
        : "Start your new trip";
    final hotTripText = currentLanguage == "Arabic"
        ? "خطط رحلات شائعة"
        : "Hot top trip plans";

    // ✅ Support RTL (Right-To-Left) layout when Arabic
    final isArabic = currentLanguage == "Arabic";

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // 🔹 Background image
            Positioned.fill(
              child: Image.asset(
                "assets/car.jpg",
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 Foreground content
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: containerColor,
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
                      Text(
                        discoverText,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 🔹 "Start Trip" Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CountryPage()),
                            );
                          },
                          child: Text(
                            startTripText,
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Text(
                        hotTripText,
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                      const SizedBox(height: 15),

                      // 🔹 Trip list
                      Expanded(
                        child: ListView(
                          children: [
                            _tripCard(
                              {
                                "English": "Muscat - Oman",
                                "Arabic": "مسقط - عمان",
                              },
                              "assets/Muscat.jpg",
                            ),
                            const SizedBox(height: 15),
                            _tripCard(
                              {
                                "English": "Bangkok - Thailand",
                                "Arabic": "بانكوك - تايلاند",
                              },
                              "assets/bangkok.jpg",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // 🔹 Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: bottomBarColor,
          selectedItemColor: bottomBarSelected,
          unselectedItemColor: bottomBarUnselected,
          iconSize: 28,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ""), // ✅ Opens Previous Plans
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          ],
        ),
      ),
    );
  }

  // 🔹 Trip Card Widget (multi-language support)
  Widget _tripCard(Map<String, String> names, String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: Text(
              names[currentLanguage] ?? names["English"]!,
              textAlign:
              currentLanguage == "Arabic" ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black54,
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
