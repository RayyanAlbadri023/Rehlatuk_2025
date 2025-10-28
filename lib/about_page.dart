// lib/about_page.dart
import 'package:flutter/material.dart';
import 'user_data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = userDataNotifier.value.language;

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
          lang == "Arabic" ? "معلومات عنا" : "About us",
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            lang == "Arabic"
                ? "يوفر Rehlatuk طريقة ذكية لتطوير خطط سياحية مخصصة للمستخدمين وتمكينهم من تنظيم جدول رحلاتهم بالكامل من خلال التطبيق."
                : "Rehlatuk provides a smart method for developing customized tourist plans for the users and enables the users to organize their entire trip schedule through the application.",
            style: TextStyle(
              color: Color(0xFF160948),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
