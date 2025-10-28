import 'package:flutter/material.dart';
import 'destination.dart';
import 'user_data.dart'; // ✅ For language detection

class LocationPage extends StatefulWidget {
  final String governorate;
  final String city;

  const LocationPage({
    super.key,
    required this.governorate,
    required this.city,
  });

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late String currentLanguage;

  final List<_Category> categories = [
    _Category('Entertainment', Icons.theater_comedy),
    _Category('Historical', Icons.account_balance),
    _Category('Wellness', Icons.spa),
    _Category('Natural', Icons.eco),
  ];

  final List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    // ✅ Listen for language changes from userDataNotifier
    currentLanguage = userDataNotifier.value.language.isNotEmpty
        ? userDataNotifier.value.language
        : "English";

    userDataNotifier.addListener(() {
      setState(() {
        currentLanguage = userDataNotifier.value.language;
      });
    });
  }

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
        SnackBar(
          content: Text(
            currentLanguage == "Arabic"
                ? "الرجاء اختيار تصنيف واحد على الأقل"
                : "Please select at least one category",
          ),
        ),
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
    final isArabic = currentLanguage == "Arabic";
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    // ✅ Localized text
    final titleText = isArabic
        ? "اختر تصنيف الموقع"
        : "Select Location Classification";
    final nextText = isArabic ? "التالي" : "Next";
    final backTooltip = isArabic ? "رجوع" : "Back";

    // ✅ Localized category names
    final categoryTranslations = {
      "Entertainment": isArabic ? "ترفيهي" : "Entertainment",
      "Historical": isArabic ? "تاريخي" : "Historical",
      "Wellness": isArabic ? "صحي" : "Wellness",
      "Natural": isArabic ? "طبيعي" : "Natural",
    };

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: buttonTextColor),
            onPressed: () => Navigator.pop(context),
            tooltip: backTooltip,
          ),
          actions: [
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
        body: Stack(
          children: [
            // 🔹 Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/car.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔹 Main content card
            Center(
              child: Container(
                width: 320,
                height: 470,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  children: [
                    Text(
                      titleText,
                      style: TextStyle(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Category grid
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 25,
                        crossAxisSpacing: 25,
                        childAspectRatio: 1,
                        physics: const NeverScrollableScrollPhysics(),
                        children: categories.map((category) {
                          final isSelected =
                          selectedCategories.contains(category.name);
                          return GestureDetector(
                            onTap: () => _toggleCategory(category.name),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? buttonTextColor.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category.icon,
                                    color: buttonTextColor,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    categoryTranslations[category.name] ??
                                        category.name,
                                    style: TextStyle(
                                      color: buttonTextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // 🔹 Next button
                    ElevatedButton(
                      onPressed: _goToPlaces,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 40,
                        ),
                      ),
                      child: Text(
                        nextText,
                        style: TextStyle(
                          color: containerColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

class _Category {
  final String name;
  final IconData icon;
  _Category(this.name, this.icon);
}
