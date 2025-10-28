// lib/notification_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool notificationsEnabled = true;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
    _listenRatings();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      notificationsEnabled = value;
    });
  }

  void _listenRatings() {
    FirebaseFirestore.instance
        .collection('ratings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (!notificationsEnabled) return;

      final List<Map<String, dynamic>> newNotifications = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "destinationName": data['destinationName'] ?? 'Unknown',
          "userName": data['userName'] ?? 'Someone',
          "rating": data['rating'] ?? 0,
          "timestamp": data['timestamp'] ?? DateTime.now(),
        };
      }).toList();

      setState(() {
        notifications = newNotifications;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = userDataNotifier.value.language;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          lang == "Arabic" ? "الإشعارات" : "Notifications",
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Toggle notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lang == "Arabic" ? "تمكين الإشعارات" : "Enable Notifications",
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    _toggleNotifications(value);
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Notification list
            Expanded(
              child: notificationsEnabled
                  ? (notifications.isEmpty
                  ? Center(
                child: Text(
                  lang == "Arabic"
                      ? "لا توجد إشعارات حتى الآن."
                      : "No notifications yet.",
                  style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => Divider(
                  color: theme.textTheme.bodyMedium?.color,
                ),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return ListTile(
                    leading:
                    const Icon(Icons.star, color: Colors.amber),
                    title: Text(
                      "${notif['userName']} rated ${notif['destinationName']}",
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color),
                    ),
                    subtitle: Text(
                      "⭐ ${notif['rating']}",
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color),
                    ),
                  );
                },
              ))
                  : Center(
                child: Text(
                  lang == "Arabic"
                      ? "الإشعارات معطلة. لن تتلقى تنبيهات جديدة."
                      : "Notifications are disabled. You won't receive new alerts.",
                  style:
                  TextStyle(color: theme.textTheme.bodyMedium?.color),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
