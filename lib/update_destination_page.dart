import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'destination_service.dart';
import 'destination_model.dart';

class UpdateDestinationPage extends StatefulWidget {
  final Destination destination;
  const UpdateDestinationPage({super.key, required this.destination});

  @override
  State<UpdateDestinationPage> createState() => _UpdateDestinationPageState();
}

class _UpdateDestinationPageState extends State<UpdateDestinationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _overviewController;

  File? _selectedPhotoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.destination.name);
    _locationController = TextEditingController(text: widget.destination.location);
    _overviewController = TextEditingController(text: widget.destination.overview);
  }

  void _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedFile != null) {
      setState(() {
        _selectedPhotoFile = File(pickedFile.path);
      });
    }
  }

  void _handleUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = widget.destination.copyWith(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        overview: _overviewController.text.trim(),
      );
      await destinationService.updateDestination(updated, _selectedPhotoFile);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Destination")),
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
                      : Image.network(widget.destination.imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _handleUpdate, child: const Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
