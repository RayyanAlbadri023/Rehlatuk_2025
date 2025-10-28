// lib/previous_plans_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rehlatuk/user_data.dart';
import 'country.dart';
import 'settings_page.dart';
import 'Home.dart'; // Import HomePage if needed

class PreviousPlansPage extends StatefulWidget {
  const PreviousPlansPage({Key? key}) : super(key: key);

  @override
  State<PreviousPlansPage> createState() => _PreviousPlansPageState();
}

class _PreviousPlansPageState extends State<PreviousPlansPage> {
  List<File> pdfFiles = [];
  String currentLanguage = 'English';
  int _selectedIndex = 2; // List icon is selected by default

  @override
  void initState() {
    super.initState();
    _loadSavedPdfs();
    currentLanguage = userDataNotifier.value.language ?? 'English';
    userDataNotifier.addListener(_updateLanguage);
  }

  @override
  void dispose() {
    userDataNotifier.removeListener(_updateLanguage);
    super.dispose();
  }

  void _updateLanguage() {
    setState(() {
      currentLanguage = userDataNotifier.value.language ?? 'English';
    });
  }

  Future<void> _loadSavedPdfs() async {
    final dir = await getApplicationDocumentsDirectory();
    final savedDir = Directory('${dir.path}/saved_trips');

    if (await savedDir.exists()) {
      final files = savedDir
          .listSync()
          .where((f) => f.path.endsWith('.pdf'))
          .map((f) => File(f.path))
          .toList();
      setState(() => pdfFiles = files);
    } else {
      await savedDir.create(recursive: true);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    } // index 1 can be for future features
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == 'Arabic';
    final theme = Theme.of(context);
    final textColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black87;

    final title = isArabic ? 'الخطط السابقة' : 'Previous Plans';
    final noFilesText =
    isArabic ? 'لا توجد خطط محفوظة حتى الآن' : 'No saved trip plans yet';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor:
          theme.brightness == Brightness.dark ?  Colors.white : const Color(0xFF160948),
          foregroundColor: Colors.white,
        ),
        body: pdfFiles.isEmpty
            ? Center(
          child: Text(
            noFilesText,
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pdfFiles.length,
          itemBuilder: (context, index) {
            final file = pdfFiles[index];
            final fileName = file.path.split('/').last;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf,
                    color: Colors.redAccent, size: 36),
                title: Text(
                  fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new,
                      color: const Color(0xFF160948)),
                  onPressed: () => OpenFilex.open(file.path),
                ),
                onTap: () => OpenFilex.open(file.path),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor:
          theme.brightness == Brightness.dark ?  Colors.white : const Color(0xFF160948),
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
      ),
    );
  }
}
