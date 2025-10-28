// lib/language_page.dart
import 'package:flutter/material.dart';
import 'user_data.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = userDataNotifier.value.language;
  }

  Future<void> updateLanguage(String lang) async {
    setState(() {
      selectedLanguage = lang;
    });

    // Save new language
    final updatedData = userDataNotifier.value.copyWith(language: lang);
    userDataNotifier.value = updatedData;
    await saveUserData(updatedData);

    // Optional: show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lang == "Arabic" ? "تم تغيير اللغة إلى العربية" : "Language changed to English"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = selectedLanguage == "Arabic";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          isArabic ? "اللغة" : "Language",
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: isDark ? Colors.grey[850] : Colors.grey[200],
              title: Text(
                "English",
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 18,
                ),
              ),
              trailing: Radio<String>(
                value: "English",
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) updateLanguage(value);
                },
                activeColor: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: isDark ? Colors.grey[850] : Colors.grey[200],
              title: Text(
                "العربية",
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 18,
                ),
              ),
              trailing: Radio<String>(
                value: "Arabic",
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) updateLanguage(value);
                },
                activeColor: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
