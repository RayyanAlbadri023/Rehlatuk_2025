class Destination {
  final String id;
  final String name;
  final String location;
  final String overview;
  final String imageUrl;

  Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.overview,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'overview': overview,
      'imageUrl': imageUrl,
    };
  }

  factory Destination.fromMap(Map<String, dynamic> map) {
    return Destination(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      overview: map['overview'],
      imageUrl: map['imageUrl'],
    );
  }

  static String generateNewId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
