import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'destination_model.dart';

class DestinationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = "destinations";

  // Get all destinations as stream
  Stream<List<Destination>> getDestinations() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Destination.fromMap(doc.data())).toList();
    });
  }

  // Upload image and get URL
  Future<String> uploadImage(File imageFile, String id) async {
    Reference ref = _storage.ref().child('destination_images/$id.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // Add new destination
  Future<void> addDestination(Destination destination, File? imageFile) async {
    String imageUrl = destination.imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile, destination.id);
    }
    await _firestore.collection(collectionName).doc(destination.id).set(
      destination.copyWith(imageUrl: imageUrl).toMap(),
    );
  }

  // Update destination
  Future<void> updateDestination(Destination destination, File? imageFile) async {
    String imageUrl = destination.imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile, destination.id);
    }
    await _firestore.collection(collectionName).doc(destination.id).update(
      destination.copyWith(imageUrl: imageUrl).toMap(),
    );
  }

  // Delete a destination
  Future<void> deleteDestination(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }
}

extension CopyWith on Destination {
  Destination copyWith({
    String? id,
    String? name,
    String? location,
    String? overview,
    String? imageUrl,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      overview: overview ?? this.overview,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

final destinationService = DestinationService();
