import 'package:flutter/material.dart';
import 'user_data.dart'; // ✅ To detect language change

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final TextEditingController _controller = TextEditingController();

  // 🔹 Country names in both languages
  final Map<String, Map<String, String>> countryNames = {
    "Oman": {"English": "Oman", "Arabic": "عُمان"},
    "Qatar": {"English": "Qatar", "Arabic": "قطر"},
    "Kuwait": {"English": "Kuwait", "Arabic": "الكويت"},
    "Bahrain": {"English": "Bahrain", "Arabic": "البحرين"},
    "Saudi Arabia": {
      "English": "Saudi Arabia",
      "Arabic": "المملكة العربية السعودية"
    },
    "United Arab Emirates": {
      "English": "United Arab Emirates",
      "Arabic": "الإمارات العربية المتحدة"
    },
    "Egypt": {"English": "Egypt", "Arabic": "مصر"},
    "Jordan": {"English": "Jordan", "Arabic": "الأردن"},
    "Lebanon": {"English": "Lebanon", "Arabic": "لبنان"},
    "Iraq": {"English": "Iraq", "Arabic": "العراق"},
    "Syria": {"English": "Syria", "Arabic": "سوريا"},
    "Yemen": {"English": "Yemen", "Arabic": "اليمن"},
    "India": {"English": "India", "Arabic": "الهند"},
    "Pakistan": {"English": "Pakistan", "Arabic": "باكستان"},
    "Japan": {"English": "Japan", "Arabic": "اليابان"},
    "China": {"English": "China", "Arabic": "الصين"},
    "South Korea": {"English": "South Korea", "Arabic": "كوريا الجنوبية"},
    "Malaysia": {"English": "Malaysia", "Arabic": "ماليزيا"},
    "Indonesia": {"English": "Indonesia", "Arabic": "إندونيسيا"},
    "France": {"English": "France", "Arabic": "فرنسا"},
    "Germany": {"English": "Germany", "Arabic": "ألمانيا"},
    "Spain": {"English": "Spain", "Arabic": "إسبانيا"},
    "Italy": {"English": "Italy", "Arabic": "إيطاليا"},
    "United Kingdom": {
      "English": "United Kingdom",
      "Arabic": "المملكة المتحدة"
    },
    "United States": {
      "English": "United States",
      "Arabic": "الولايات المتحدة"
    },
    "Canada": {"English": "Canada", "Arabic": "كندا"},
    "Brazil": {"English": "Brazil", "Arabic": "البرازيل"},
    "Argentina": {"English": "Argentina", "Arabic": "الأرجنتين"},
    "Australia": {"English": "Australia", "Arabic": "أستراليا"},
  };

  List<String> filteredCountries = [];
  String? currentLanguage; // ✅ nullable to avoid LateInitializationError

  @override
  void initState() {
    super.initState();

    // ✅ Initialize safely with fallback to English
    currentLanguage = userDataNotifier.value.language.isNotEmpty
        ? userDataNotifier.value.language
        : "English";

    // ✅ Listen for language changes
    userDataNotifier.addListener(() {
      setState(() {
        currentLanguage = userDataNotifier.value.language.isNotEmpty
            ? userDataNotifier.value.language
            : "English";
      });
    });

    // ✅ Initialize filtered list alphabetically
    filteredCountries = countryNames.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  void _filterCountries(String query) {
    final results = countryNames.keys
        .where((country) => countryNames[country]![currentLanguage ?? "English"]!
        .toLowerCase()
        .startsWith(query.toLowerCase()))
        .toList();

    setState(() {
      filteredCountries =
      query.isEmpty ? countryNames.keys.toList() : results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = currentLanguage ?? "English";
    final isArabic = lang == "Arabic";

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // 🔹 Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/car.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🔹 Top bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:  Icon(Icons.arrow_back, color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/HomePage");
                      },
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

            // 🔹 Main content
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      isArabic
                          ? "ابحث واختر الدولة"
                          : "Search and select the country",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Search box
                    TextField(
                      controller: _controller,
                      onChanged: _filterCountries,
                      style: TextStyle(color: containerColor),
                      decoration: InputDecoration(
                        hintText:
                        isArabic ? "ابحث عن الدولة..." : "Search country...",
                        hintStyle: TextStyle(color: containerColor),
                        filled: true,
                        fillColor: buttonTextColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search, color: containerColor),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Country list
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = filteredCountries[index];
                          final translated =
                              countryNames[country]![lang] ?? country;
                          return ListTile(
                            title: Text(
                              translated,
                              style: TextStyle(color: buttonTextColor),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/governorate",
                                arguments: translated,
                              );
                            },
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
