import 'package:flutter/material.dart';
import 'user_data.dart';

class ThemeModePage extends StatefulWidget {
  const ThemeModePage({super.key});

  @override
  State<ThemeModePage> createState() => _ThemeModePageState();
}

class _ThemeModePageState extends State<ThemeModePage> {
  late String selectedMode;

  @override
  void initState() {
    super.initState();
    final mode = userDataNotifier.value.themeMode;
    selectedMode = mode == ThemeMode.dark ? "Dark" : "Light";
  }

  void changeTheme(String mode) async {
    setState(() => selectedMode = mode);

    ThemeMode newTheme = mode == "Dark" ? ThemeMode.dark : ThemeMode.light;
    themeNotifier.value = newTheme;

    // Save user preference
    final updatedData = userDataNotifier.value.copyWith(themeMode: newTheme);
    userDataNotifier.value = updatedData;
    await saveUserData(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = userDataNotifier.value.language;

    final bool isDark = selectedMode == "Dark";
    final Color backgroundColor = isDark ? const Color(0xFF1C0B5C) : theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          lang == "Arabic" ? "وضع العرض" : "Theme Mode",
          style: TextStyle(
            color: isDark ? Colors.white : theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            activeColor: Colors.orange,
            title: Text(lang == "Arabic" ? "فاتح" : "Light",
                style: TextStyle(color: isDark ? Colors.white : theme.textTheme.bodyMedium?.color)),
            value: "Light",
            groupValue: selectedMode,
            onChanged: (v) => v != null ? changeTheme(v) : null,
          ),
          RadioListTile<String>(
            activeColor: Colors.orange,
            title: Text(lang == "Arabic" ? "داكن" : "Dark",
                style: TextStyle(color: isDark ? Colors.white : theme.textTheme.bodyMedium?.color)),
            value: "Dark",
            groupValue: selectedMode,
            onChanged: (v) => v != null ? changeTheme(v) : null,
          ),
        ],
      ),
    );
  }
}
