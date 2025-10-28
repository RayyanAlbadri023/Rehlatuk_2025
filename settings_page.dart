import 'dart:io';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'notification_page.dart';
import 'theme_mode_page.dart';
import 'language_page.dart';
import 'about_page.dart';
import 'feedback_app.dart';
import 'reset_password_screen.dart';
import 'login_screen.dart' ;
import 'user_data.dart';
import 'Home.dart';
import 'previous_plans_page.dart';
import 'forget_password_screen.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3; // ✅ Settings icon is active (index 3)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // ✅ Handle navigation
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
      // Smart toy / AI feature
        Navigator.pushReplacementNamed(context, '/smart');
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  PreviousPlansPage()),
        );
        break;
      case 3:
      // Settings - stay here
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomBarColor =
    isDark ? Colors.grey[400] : const Color(0xFF160948);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ValueListenableBuilder<UserData>(
        valueListenable: userDataNotifier,
        builder: (context, userData, _) {
          final lang = userData.language;

          return Column(
            children: [
              // Header
              Container(
                color: bottomBarColor,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark ? Colors.white : Colors.grey[300],
                      backgroundImage: userData.profileImage != null
                          ? FileImage(userData.profileImage!)
                          : null,
                      child: userData.profileImage == null
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.name.isNotEmpty
                              ? userData.name
                              : (lang == "Arabic" ? "مرحباً" : "Welcome"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),
                        Text(
                          userData.email.isNotEmpty
                              ? userData.email
                              : (lang == "Arabic"
                              ? "أدخل بريدك"
                              : "Add email"),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Menu
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    MenuItem(
                      icon: Icons.person,
                      title: lang == "Arabic"
                          ? "الملف الشخصي"
                          : "Profile Settings",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.notifications_off,
                      title: lang == "Arabic" ? "الإشعارات" : "Notifications",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationPage()),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.thumb_up,
                      title: lang == "Arabic" ? "التقييم" : "Feedback",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FeedbackPageApp()),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.info,
                      title:
                      lang == "Arabic" ? "معلومات عنا" : "About Us",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.language,
                      title: lang == "Arabic" ? "اللغة" : "Language",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LanguagePage()),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.color_lens,
                      title: lang == "Arabic" ? "وضع العرض" : "Theme Mode",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ThemeModePage()),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.lock,
                      title: lang == "Arabic" ? "إعادة تعيين كلمة مرور" : "Reset Password",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForgetPasswordScreen(
                            email: userData.email, // تمرير الإيميل من UserData
                          ),
                        ),
                      ),
                    ),
                    MenuItem(
                      icon: Icons.logout,
                      title:
                      lang == "Arabic" ? "تسجيل الخروج" : "Log Out",
                      onTap: () =>
                          _showLogoutDialog(context, lang, isDark),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // ✅ Bottom Navigation Bar Added
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:bottomBarColor,
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
    );
  }
}

// 🔹 Custom MenuItem
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}

// 🔹 Logout Dialog
void _showLogoutDialog(BuildContext context, String lang, bool isDark) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close,
                      color: isDark ? Colors.white : Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lang == "Arabic"
                    ? "هل أنت متأكد من تسجيل الخروج؟"
                    : "Are you sure you want to Logout?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isDark ? const Color(0xFF1e0b45) : Colors.grey[300],
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  lang == "Arabic" ? "نعم بالتأكيد" : "Yes sure",
                  style:
                  TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
