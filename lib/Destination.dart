import 'package:flutter/material.dart';
import 'package:rehlatuk/places.dart';
import 'cart.dart';
import 'details.dart';
import 'date.dart';
import 'user_data.dart';

class AppStrings {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'noPlaces': 'No places found!',
      'unknownPlace': 'Unknown Place',
      'addedToCart': 'added to cart',
      'cartEmpty': 'Your cart is empty!',
      'createTrip': 'Create Trip Plan',
      'back': 'Back',
    },
    'ar': {
      'noPlaces': 'لم يتم العثور على أماكن!',
      'unknownPlace': 'مكان غير معروف',
      'addedToCart': 'تمت إضافته إلى السلة',
      'cartEmpty': 'السلة فارغة!',
      'createTrip': 'إنشاء خطة الرحلة',
      'back': 'عودة',
    },
  };

  static String get(String key, bool isArabic) {
    return isArabic ? texts['ar']![key]! : texts['en']![key]!;
  }
}

// تحويل المدن والفئات العربية للإنجليزية للفلترة
final Map<String, String> arabicToEnglishCities = {
  "المتراء": "Muttrah",
  "القرم": "Al Qurum",
  "صلالة": "Salalah",
};

final Map<String, String> arabicToEnglishCategories = {
  "تاريخي": "Historical",
  "ترفيهي": "Entertainment",
};

class DestinationPlacesPage extends StatefulWidget {
  final List<String> selectedCities;
  final List<String> selectedCategories;

  const DestinationPlacesPage({
    super.key,
    required this.selectedCities,
    required this.selectedCategories,
  });

  @override
  State<DestinationPlacesPage> createState() => _DestinationPlacesPageState();
}

class _DestinationPlacesPageState extends State<DestinationPlacesPage> {
  late String currentLanguage;

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

  List<String> _convertCitiesToEnglish(List<String> cities) =>
      cities.map((c) => arabicToEnglishCities[c] ?? c).toList();

  List<String> _convertCategoriesToEnglish(List<String> categories) =>
      categories.map((c) => arabicToEnglishCategories[c] ?? c).toList();

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == "Arabic";
    final selectedCitiesEn = _convertCitiesToEnglish(widget.selectedCities);
    final selectedCategoriesEn = _convertCategoriesToEnglish(widget.selectedCategories);

    final List<Map<String, dynamic>> filteredPlaces = [];
    for (var governorate in placesData.keys) {
      final governorateData = placesData[governorate]!;
      for (var city in governorateData.keys) {
        if (selectedCitiesEn.contains(city)) {
          final cityData = governorateData[city]!;
          for (var category in selectedCategoriesEn) {
            if (cityData.containsKey(category)) {
              filteredPlaces.addAll(cityData[category]!);
            }
          }
        }
      }
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/car.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: containerColor,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: buttonTextColor),
                        onPressed: () => Navigator.pop(context),
                        tooltip: AppStrings.get('back', isArabic),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: containerColor,
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart, color: buttonTextColor),
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
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: filteredPlaces.isEmpty
                            ? Center(
                          child: Text(
                            AppStrings.get('noPlaces', isArabic),
                            style: TextStyle(
                              color: buttonTextColor,
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
                            final placeName = isArabic
                                ? (place['name_ar'] ?? place['name'])
                                : (place['name'] ?? 'Unknown');

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsPage(
                                      placeData: place,
                                      locale: isArabic ? 'ar' : 'en',
                                    ),
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
                                        Positioned(
                                          bottom: 10,
                                          left: 15,
                                          child: Text(
                                            placeName,
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
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 16,
                                      child: IconButton(
                                        icon: const Icon(Icons.add, size: 18, color: Colors.black),
                                        onPressed: () {
                                          CartPage.addToCart(place);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("$placeName ${AppStrings.get('addedToCart', isArabic)}"),
                                              duration: const Duration(seconds: 1),
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonTextColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (CartPage.cartItems.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppStrings.get('cartEmpty', isArabic)),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Date(items: CartPage.cartItems),
                              ),
                            );
                          },
                          child: Text(
                            AppStrings.get('createTrip', isArabic),
                            style: TextStyle(
                              color: containerColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
