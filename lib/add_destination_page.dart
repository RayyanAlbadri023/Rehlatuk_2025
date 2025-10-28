import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'destination_list_page.dart';
import 'admin_home_page.dart';

class AddDestinationPage extends StatefulWidget {
  const AddDestinationPage({super.key});

  @override
  State<AddDestinationPage> createState() => _AddDestinationPageState();
}

class _AddDestinationPageState extends State<AddDestinationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _overviewController = TextEditingController();

  File? _selectedPhotoFile;
  bool _isPhotoMissing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _overviewController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedPhotoFile = File(pickedFile.path);
        _isPhotoMissing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image selected successfully!')),
      );
    }
  }

  void _handleSave() {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    bool isPhotoSelected = _selectedPhotoFile != null;

    setState(() {
      _isPhotoMissing = !isPhotoSelected;
    });

    if (isFormValid && isPhotoSelected) {
      final newDestination = Destination(
        id: Destination.generateNewId(),
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        overview: _overviewController.text.trim(),
        imageUrl: _selectedPhotoFile!.path,
      );

      destinationService.addDestination(newDestination);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newDestination.name} saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop(); // Return to list page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields and add a photo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.luggage, color: Color(0xFF004683), size: 18),
            label: const Text('Home', style: TextStyle(color: Color(0xFF004683))),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AdminHomePage()),
                    (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        title: const Text('Add Destination', style: TextStyle(color: Color(0xFF333333))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Destination',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF004683)),
              ),
              const SizedBox(height: 30),

              // Name
              const Text('Destination name:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'Enter destination name',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Destination name is required.' : null,
              ),
              const SizedBox(height: 20),

              // Location
              const Text('Location:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'Enter location',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Location is required.' : null,
              ),
              const SizedBox(height: 20),

              // Overview
              const Text('Destination overview:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
              const SizedBox(height: 8),
              TextFormField(
                controller: _overviewController,
                maxLines: 5,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintText: 'Provide a brief overview...',
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Overview is required.' : null,
              ),
              const SizedBox(height: 20),

              // Photo
              const Text('Photo:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isPhotoMissing ? Colors.red : const Color(0xFF5A8DBE),
                      width: _isPhotoMissing ? 3 : 2,
                    ),
                  ),
                  child: _selectedPhotoFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_selectedPhotoFile!, width: 100, height: 100, fit: BoxFit.cover),
                  )
                      : const Center(child: Icon(Icons.add_a_photo, size: 40, color: Color(0xFF5A8DBE))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _isPhotoMissing ? 'Photo is mandatory.' : 'Tap to add photo',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isPhotoMissing ? Colors.red : Colors.grey,
                    fontWeight: _isPhotoMissing ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A8DBE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
