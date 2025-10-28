import 'package:flutter/material.dart';
import 'user_data.dart'; // ✅ To detect language change

class GovernoratePage extends StatefulWidget {
  final String selectedCountry;
  const GovernoratePage({super.key, required this.selectedCountry});

  @override
  _GovernoratePageState createState() => _GovernoratePageState();
}

class _GovernoratePageState extends State<GovernoratePage> {
  late String currentLanguage;

  // ✅ Governorates in both languages (English is the internal key)
  final Map<String, Map<String, List<String>>> governoratesByCountry = {
    "Oman": {
      "English": [
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
      "Arabic": [
        "مسقط",
        "ظفار",
        "الباطنة شمال",
        "الباطنة جنوب",
        "الظاهرة",
        "الداخلية",
        "الشرقية شمال",
        "الشرقية جنوب",
        "الوسطى",
        "مسندم",
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    currentLanguage = userDataNotifier.value.language.isNotEmpty
        ? userDataNotifier.value.language
        : "English";

    userDataNotifier.addListener(() {
      setState(() {
        currentLanguage = userDataNotifier.value.language;
      });
    });
  }

  /// ✅ Helper: Get the English key even if Arabic name is tapped
  String _getEnglishGovernorate(String name) {
    final englishList = governoratesByCountry["Oman"]?["English"] ?? [];
    final arabicList = governoratesByCountry["Oman"]?["Arabic"] ?? [];
    final index = arabicList.indexOf(name);
    return index != -1 ? englishList[index] : name;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == "Arabic";

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    final governorates =
        governoratesByCountry["Oman"]?[currentLanguage] ?? [];

    final titleText = isArabic
        ? "اختر المحافظة في ${widget.selectedCountry}"
        : "Select a Governorate in ${widget.selectedCountry}";

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

            // Main content
            Center(
              child: Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      titleText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: governorates.length,
                        itemBuilder: (context, index) {
                          final displayName = governorates[index];
                          final englishGovernorate =
                          _getEnglishGovernorate(displayName);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonTextColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/city',
                                  arguments: englishGovernorate,
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  displayName,
                                  style: TextStyle(
                                    color: containerColor,
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
      ),
    );
  }
}
