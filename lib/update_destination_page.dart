import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'destination_list_page.dart';
import 'admin_home_page.dart';

class UpdateDestinationPage extends StatefulWidget {
  final Destination destination;
  const UpdateDestinationPage({super.key, required this.destination});

  @override
  State<UpdateDestinationPage> createState() => _UpdateDestinationPageState();
}

class _UpdateDestinationPageState extends State<UpdateDestinationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _overviewController;

  File? _selectedPhotoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.destination.name);
    _locationController = TextEditingController(text: widget.destination.location);
    _overviewController = TextEditingController(text: widget.destination.overview);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _overviewController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (pickedFile != null) {
      setState(() => _selectedPhotoFile = File(pickedFile.path));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('New image selected.')));
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      String updatedImageUrl = _selectedPhotoFile?.path ?? widget.destination.imageUrl;

      final updatedDestination = Destination(
        id: widget.destination.id,
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        overview: _overviewController.text.trim(),
        imageUrl: updatedImageUrl,
      );

      destinationService.updateDestination(updatedDestination);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${updatedDestination.name} updated successfully!'), backgroundColor: Colors.green),
      );

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the validation errors.'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _imagePreviewWidget() {
    if (_selectedPhotoFile != null) return Image.file(_selectedPhotoFile!, width: 100, height: 100, fit: BoxFit.cover);
    return Image.network(widget.destination.imageUrl, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 100, height: 100, color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported, color: Colors.grey)));
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
            icon: const Icon(Icons.business_center, color: Color(0xFF004683), size: 18),
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
        title: const Text('Update Destination', style: TextStyle(color: Color(0xFF333333))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            const Text('Update Destination', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF004683))),
            const SizedBox(height: 30),

            // Name
            const Text('Destination name:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
            const SizedBox(height: 8),
            TextFormField(controller: _nameController, decoration: InputDecoration(fillColor: Colors.grey.shade200, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), validator: (v) => (v == null || v.isEmpty) ? 'Destination name is required.' : null),
            const SizedBox(height: 20),

            // Location
            const Text('Location:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
            const SizedBox(height: 8),
            TextFormField(controller: _locationController, decoration: InputDecoration(fillColor: Colors.grey.shade200, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), validator: (v) => (v == null || v.isEmpty) ? 'Location is required.' : null),
            const SizedBox(height: 20),

            // Overview
            const Text('Destination overview:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
            const SizedBox(height: 8),
            TextFormField(controller: _overviewController, maxLines: 5, decoration: InputDecoration(fillColor: Colors.grey.shade200, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)), validator: (v) => (v == null || v.isEmpty) ? 'Overview is required.' : null),
            const SizedBox(height: 20),

            // Image
            const Text('Photo:', style: TextStyle(fontSize: 16, color: Color(0xFF004683))),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(10),
              child: Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF5A8DBE), width: 2)), child: ClipRRect(borderRadius: BorderRadius.circular(10), child: _imagePreviewWidget())),
            ),

            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: _handleUpdate, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5A8DBE), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Update', style: TextStyle(color: Colors.white, fontSize: 18))),
            ),
          ]),
        ),
      ),
    );
  }
}
