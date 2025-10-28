import 'package:flutter/material.dart';
import 'comment_page.dart';
import 'map_page.dart';

class AppStrings {
  static Map<String, Map<String, String>> texts = {
    'en': {
      'noInfo': 'No information available for this place.',
      'viewMap': 'View Location Map',
      'placeDetails': 'Place Details',
      'comments': 'Comments',
    },
    'ar': {
      'noInfo': 'لا توجد معلومات متاحة عن هذا المكان.',
      'viewMap': 'عرض الخريطة',
      'placeDetails': 'تفاصيل المكان',
      'comments': 'التعليقات',
    },
  };

  static String get(String key, String locale) {
    return texts[locale]?[key] ?? key;
  }
}

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic>? placeData;
  final String locale;

  const DetailsPage({super.key, required this.placeData, this.locale = 'en'});

  @override
  Widget build(BuildContext context) {
    if (placeData == null) {
      return Scaffold(
        body: Center(
          child: Text('No data available', style: const TextStyle(fontSize: 20)),
        ),
      );
    }

    final isArabic = locale == 'ar';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    final String name = isArabic
        ? (placeData!["name_ar"]?.toString() ?? placeData!["name"]?.toString() ?? 'Unknown')
        : (placeData!["name"]?.toString() ?? 'Unknown');

    final String description = isArabic
        ? (placeData!["description_ar"]?.toString() ?? placeData!["description"]?.toString() ?? 'No info available')
        : (placeData!["description"]?.toString() ?? 'No info available');

    final String? imagePath = placeData!["image"]?.toString();
    final double rating = placeData!["rating"] is num
        ? (placeData!["rating"] as num).toDouble()
        : 0.0;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: containerColor,
        appBar: AppBar(
          backgroundColor: containerColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: buttonTextColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(name, style: TextStyle(color: buttonTextColor)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: imagePath != null
                      ? Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    width: double.infinity,
                    height: 220,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: buttonTextColor, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  style: TextStyle(color: buttonTextColor, fontSize: 16, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Rating & comments
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 28),
                        const SizedBox(width: 5),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                              color: buttonTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.comment, color: buttonTextColor, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommentPage(
                              placeName: name,
                              locale: locale, // ⚡ لا نحتاج initialComments بعد الآن
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // View Map Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonTextColor,
                    foregroundColor: containerColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapPage(
                          items: [
                            {'name': name}
                          ],
                          placeName: name,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_on_outlined),
                  label: Text(
                    AppStrings.get('viewMap', locale),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
