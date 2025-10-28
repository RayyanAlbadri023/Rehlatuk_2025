// lib/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  File? profileImage;
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    final data = userDataNotifier.value;
    nameController = TextEditingController(text: data.name);
    emailController = TextEditingController(text: data.email);
    phoneController = TextEditingController(text: data.phone);
    profileImage = data.profileImage;
    selectedLanguage = data.language;
  }

  Future<void> saveChanges() async {
    final updatedData = userDataNotifier.value.copyWith(
      name: nameController.text,
      phone: phoneController.text,
      profileImagePath: profileImage?.path,
      language: selectedLanguage,
    );

    userDataNotifier.value = updatedData;
    await saveUserData(updatedData);
  }

  Future<void> changeProfilePicture() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
                if (picked != null) {
                  setState(() => profileImage = File(picked.path));
                  await saveChanges();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? picked = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (picked != null) {
                  setState(() => profileImage = File(picked.path));
                  await saveChanges();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Photo'),
              onTap: () async {
                Navigator.pop(context);
                setState(() => profileImage = null);
                await saveChanges();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = selectedLanguage;
    String t(String en, String ar) => lang == "Arabic" ? ar : en;

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
        title: Text(t("Profile", "الملف الشخصي"),
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: changeProfilePicture,
              borderRadius: BorderRadius.circular(50),
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                profileImage != null ? FileImage(profileImage!) : null,
                backgroundColor: Colors.grey[300],
                child: profileImage == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            buildTextField(t("Name", "الاسم"), nameController, theme),
            buildTextField(
                t("Email Address", "البريد الإلكتروني"), emailController, theme,
                readOnly: true), // ✅ Email is read-only
            buildTextField(
                t("Phone Number", "رقم الهاتف"), phoneController, theme),
            const SizedBox(height: 16),



            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveChanges();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Text(t("Save", "حفظ "),
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      ThemeData theme,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onChanged: (_) => saveChanges(),
        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
