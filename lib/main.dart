import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ✅ Localization

// 🔹 Auth & Data
import 'package:firebase_auth/firebase_auth.dart';
import 'user_data.dart';

// 🔹 Screens
import 'login_screen.dart';
import 'Home.dart';
import 'admin_login_screen.dart';
import 'feedback_page.dart';
import 'feedback_app.dart';

// 🔹 Travel Planner Pages
import 'Country.dart';
import 'City.dart';
import 'Location.dart';
import 'Destination.dart';
import 'Governorate.dart';
import 'plan_trip_page.dart';
import 'create_plan.dart';
import 'date.dart';

// 🔹 Settings & Profile
import 'settings_page.dart';
import 'profile_page.dart';
import 'language_page.dart';
import 'notification_page.dart';
import 'theme_mode_page.dart';
import 'about_page.dart';

// 🔹 Ads and Wallpaper
import 'ad1.dart';
import 'ad2.dart';
import 'ad3.dart';
import 'ad4.dart';
import 'welpaper.dart'; // WallpaperPage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load saved user data
  await loadUserData();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen for theme changes
    userDataNotifier.addListener(() {
      themeNotifier.value = userDataNotifier.value.themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rehlatuk',
          themeMode: mode,

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],

          // 🔹 Force LTR for all pages even عند اختيار العربية
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: child!,
            );
          },

          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.grey, brightness: Brightness.dark),
            scaffoldBackgroundColor: const Color(0xFF1C0B5C),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1C0B5C),
              foregroundColor: Colors.white,
            ),
          ),

          home: const WallpaperPage(),

          // 🔹 Named Routes
          routes: {
            '/ad1': (context) => const Ad1Screen(),
            '/ad2': (context) => const Ad2Screen(),
            '/ad3': (context) => const Ad3Screen(),
            '/ad4': (context) => const Ad4Screen(),
            '/login_screen': (context) => const LoginScreen(),
          },

          // 🔹 Dynamic Routes
          onGenerateRoute: (settings) {
            switch (settings.name) {
            // ------------------- Travel Planner -------------------
              case '/HomePage':
                return MaterialPageRoute(builder: (_) => const HomePage());
              case '/searchCountry':
                return MaterialPageRoute(builder: (_) => CountryPage());
              case '/governorate':
                final country = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (_) =>
                      GovernoratePage(selectedCountry: country),
                );
              case '/city':
                final governorate = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (_) => CityPage(governorate: governorate),
                );
              case '/location':
                final args = settings.arguments as Map<String, String>;
                return MaterialPageRoute(
                  builder: (_) => LocationPage(
                    governorate: args['governorate']!,
                    city: args['city']!,
                  ),
                );
              case '/destination':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => DestinationPlacesPage(
                    selectedCities: args['cities'],
                    selectedCategories: args['categories'],
                  ),
                );
              case '/tripplan':
                return MaterialPageRoute(builder: (_) => const PlanTripPage());

            // ------------------- Settings & Profile -------------------
              case '/settings':
                return MaterialPageRoute(builder: (_) => const SettingsPage());
              case '/profile':
                return MaterialPageRoute(builder: (_) => const ProfilePage());
              case '/language':
                return MaterialPageRoute(builder: (_) => const LanguagePage());
              case '/notification':
                return MaterialPageRoute(
                    builder: (_) => const NotificationPage());
              case '/theme':
                return MaterialPageRoute(builder: (_) => const ThemeModePage());
              case '/about':
                return MaterialPageRoute(builder: (_) => const AboutPage());
              case '/feedback':
                return MaterialPageRoute(
                    builder: (_) => const FeedbackPageApp());
              case '/login':
                return MaterialPageRoute(builder: (_) => const LoginScreen());

            // ------------------- Select Destination & Trip Dates -------------------
              case '/selectDestination':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => SelectDis(
                    cartItems: args['cartItems'],
                    tripStart: args['tripStart'],
                    tripEnd: args['tripEnd'],
                  ),
                );

            // ------------------- Admin & Dashboard -------------------
              case '/admin-dashboard':
                return MaterialPageRoute(builder: (_) => const HomePage());
            }

            // Fallback if route not found
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Page not found: ${settings.name}')),
              ),
            );
          },
        );
      },
    );
  }
}

// 🔹 Custom AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1A4B),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Image.asset(
            'assets/logo.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
