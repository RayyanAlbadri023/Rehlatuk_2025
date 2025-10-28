import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'destination_service.dart';
import 'destination_model.dart';

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
  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedFile != null) {
      setState(() {
        _selectedPhotoFile = File(pickedFile.path);
      });
    }
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false && _selectedPhotoFile != null) {
      final newDestination = Destination(
        id: Destination.generateNewId(),
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        overview: _overviewController.text.trim(),
        imageUrl: '', // temporary, will upload
      );
      await destinationService.addDestination(newDestination, _selectedPhotoFile);
      if (mounted) Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select a photo")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Destination")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _overviewController,
                decoration: const InputDecoration(labelText: "Overview"),
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: _selectedPhotoFile != null
                      ? Image.file(_selectedPhotoFile!, fit: BoxFit.cover)
                      : const Icon(Icons.add_a_photo),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _handleSave, child: const Text("Save")),
            ],
          ),
        ),
      ),
    );
  }
}
