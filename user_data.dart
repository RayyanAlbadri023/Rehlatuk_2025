import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final String name;
  final String email;
  final String phone;
  final String language;
  final ThemeMode themeMode;
  final String? profileImagePath; // Local only

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    this.language = "English",
    this.themeMode = ThemeMode.system,
    this.profileImagePath,
  });

  factory UserData.initial() {
    return UserData(
      name: '',
      email: '',
      phone: '',
      language: 'English',
      themeMode: ThemeMode.system,
    );
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  File? get profileImage =>
      profileImagePath != null &&
          profileImagePath!.isNotEmpty &&
          File(profileImagePath!).existsSync()
          ? File(profileImagePath!)
          : null;

  UserData copyWith({
    String? name,
    String? email,
    String? phone,
    String? language,
    ThemeMode? themeMode,
    String? profileImagePath,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'phone': phone,
    'language': language,
    'themeMode': themeMode.index,
    'profileImagePath': profileImagePath,
  };

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      language: map['language'] ?? 'English',
      themeMode: ThemeMode.values[map['themeMode'] ?? ThemeMode.system.index],
      profileImagePath: map['profileImagePath'],
    );
  }

  String toJson() => json.encode(toMap());
  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));
}

// 🔹 Global notifiers
final ValueNotifier<UserData> userDataNotifier =
ValueNotifier<UserData>(UserData.initial());
final ValueNotifier<ThemeMode> themeNotifier =
ValueNotifier<ThemeMode>(ThemeMode.system);

// 🔹 Local Storage (save locally)
Future<void> saveUserData(UserData data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userData', data.toJson());
}

Future<UserData> loadUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonData = prefs.getString('userData');

  if (jsonData != null && jsonData.isNotEmpty) {
    try {
      final data = UserData.fromJson(jsonData);
      userDataNotifier.value = data;
      themeNotifier.value = data.themeMode;
      return data;
    } catch (_) {}
  }

  final initial = UserData.initial();
  userDataNotifier.value = initial;
  themeNotifier.value = initial.themeMode;
  return initial;
}

// ✅ Sync Firestore but exclude image
Future<void> syncUserFromFirestore(User user) async {
  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final doc = await docRef.get();

  if (!doc.exists) {
    await docRef.set({
      'fullName': user.displayName ?? '',
      'email': user.email ?? '',
      'phone': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  final data = (await docRef.get()).data() ?? {};
  final loaded = UserData(
    name: data['fullName'] ?? '',
    email: data['email'] ?? user.email ?? '',
    phone: data['phone'] ?? '',
    language: 'English',
    themeMode: ThemeMode.system,
    profileImagePath: userDataNotifier.value.profileImagePath, // keep local image
  );

  userDataNotifier.value = loaded;
  themeNotifier.value = loaded.themeMode;
  await saveUserData(loaded);
}

// ✅ Update Firestore (only text fields)
Future<void> updateUserInFirestore(User user, UserData data) async {
  final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  await docRef.set({
    'fullName': data.name,
    'email': data.email,
    'phone': data.phone,
  }, SetOptions(merge: true));
}

// ✅ Clear local data
Future<void> clearLocalUserData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userData');
  userDataNotifier.value = UserData.initial();
}
