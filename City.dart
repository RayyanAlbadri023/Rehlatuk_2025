import 'package:flutter/material.dart';
import 'user_data.dart';
import 'location.dart';

class CityPage extends StatelessWidget {
  final String governorate;

  const CityPage({super.key, required this.governorate});

  final Map<String, List<String>> citiesByGovernorate = const {
    "Muscat": ["Muttrah", "Seeb", "Bausher", "Al Qurum", "Al Amerat"],
    "Dhofar": ["Salalah", "Taqah", "Mirbat", "Rakhyut"],
  };

  final Map<String, List<String>> citiesByGovernorateArabic = const {
    "Muscat": ["مطرح", "السيب", "بوشر", "القرم", "العامرات"],
    "Dhofar": ["صلالة", "طاقة", "مرباط", "رخيوت"],
  };

  @override
  Widget build(BuildContext context) {
    final isArabic = userDataNotifier.value.language == "Arabic";

    final cities = isArabic
        ? citiesByGovernorateArabic[governorate] ?? []
        : citiesByGovernorate[governorate] ?? [];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/car.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Top bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.black, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/HomePage', (route) => false);
                      },
                      child: Image.asset(
                        'assets/logo.png',
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main content
            Center(
              child: Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      isArabic ? "اختر المدينة" : "Select a City",
                      style: TextStyle(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (cities.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            isArabic
                                ? "لا توجد مدن متاحة"
                                : "No cities available",
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            final city = cities[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: buttonTextColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  city,
                                  style: TextStyle(
                                    color: containerColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/location',
                                    arguments: {
                                      'governorate': governorate,
                                      'city': city,
                                    },
                                  );
                                },
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
      ),
    );
  }
}
