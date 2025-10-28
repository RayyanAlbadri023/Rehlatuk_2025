import 'dart:io';
import 'package:flutter/material.dart';
import 'add_destination_page.dart';
import 'update_destination_page.dart';
import 'admin_home_page.dart';
import 'user_data.dart'; // ✅ For language detection

// ==========================
// Destination Model & Service
// ==========================
class Destination {
  final String id;
  final String name;
  final String location;
  final String overview;
  final String imageUrl;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.overview,
    required this.imageUrl,
  });

  static String generateNewId() =>
      DateTime.now().millisecondsSinceEpoch.toString();
}

class DestinationService {
  static final DestinationService _instance = DestinationService._internal();
  factory DestinationService() => _instance;
  DestinationService._internal();

  final List<Destination> _destinations = [
    Destination(
      id: '1',
      name: 'Bern',
      location: 'Switzerland',
      overview: 'Relaxed strolls, sunny terraces, Old City tours.',
      imageUrl: 'https://placehold.co/600x400/004683/ffffff?text=Bern',
    ),
    Destination(
      id: '2',
      name: 'Eiger Electric train',
      location: 'Switzerland',
      overview: 'Breathtaking train journey through the Alps.',
      imageUrl: 'https://placehold.co/600x400/8b0000/ffffff?text=Train+View',
    ),
  ];

  List<Destination> get destinations => _destinations;

  void addDestination(Destination newDestination) =>
      _destinations.add(newDestination);

  void updateDestination(Destination updatedDestination) {
    final index =
    _destinations.indexWhere((d) => d.id == updatedDestination.id);
    if (index != -1) _destinations[index] = updatedDestination;
  }

  void deleteDestination(String id) =>
      _destinations.removeWhere((d) => d.id == id);
}

final destinationService = DestinationService();

// ==========================
// Strings for AR/EN
// ==========================
class AppStrings {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'destinationList': 'Destination List',
      'home': 'Home',
      'addNewPlace': 'Add new place..',
      'deleted': 'deleted.',
    },
    'ar': {
      'destinationList': 'قائمة الوجهات',
      'home': 'الصفحة الرئيسية',
      'addNewPlace': 'أضف مكانًا جديدًا..',
      'deleted': 'تم حذفه.',
    },
  };

  static String get(String key, bool isArabic) {
    return isArabic ? texts['ar']![key]! : texts['en']![key]!;
  }
}

// ==========================
// DestinationListPage
// ==========================
class DestinationListPage extends StatefulWidget {
  const DestinationListPage({super.key});

  @override
  State<DestinationListPage> createState() => _DestinationListPageState();
}

class _DestinationListPageState extends State<DestinationListPage> {
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

  bool get isArabic => currentLanguage == "Arabic";

  void _deleteDestination(Destination destination) {
    destinationService.deleteDestination(destination.id);
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${destination.name} ${AppStrings.get('deleted', isArabic)}',
          ),
        ),
      );
    });
  }

  Future<void> _navigateAndRefresh(Widget page) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => page));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final destinations = destinationService.destinations;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            AppStrings.get('destinationList', isArabic),
            style: const TextStyle(color: Color(0xFF333333)),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(
                Icons.business_center,
                color: Color(0xFF004683),
                size: 18,
              ),
              label: Text(
                AppStrings.get('home', isArabic),
                style: const TextStyle(color: Color(0xFF004683)),
              ),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AdminHomePage()),
                      (route) => false,
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return _DestinationCard(
                    destination: destination,
                    onEdit: () => _navigateAndRefresh(
                      UpdateDestinationPage(destination: destination),
                    ),
                    onDelete: () => _deleteDestination(destination),
                    isArabic: isArabic,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: InkWell(
                onTap: () => _navigateAndRefresh(const AddDestinationPage()),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5A8DBE),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5A8DBE).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        AppStrings.get('addNewPlace', isArabic),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================
// Destination Card Widget
// ==========================
class _DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isArabic;

  const _DestinationCard({
    required this.destination,
    required this.onEdit,
    required this.onDelete,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: destination.imageUrl.startsWith('http')
              ? NetworkImage(destination.imageUrl)
              : FileImage(File(destination.imageUrl)) as ImageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${destination.name}, ${destination.location}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment:
              isArabic ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
