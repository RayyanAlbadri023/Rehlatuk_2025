import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_data.dart';

class CommentPage extends StatefulWidget {
  final String placeName;
  final String locale;

  const CommentPage({super.key, required this.placeName, required this.locale});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  // للحصول على التعليقات من Firestore
  late CollectionReference commentsCollection;

  @override
  void initState() {
    super.initState();
    // كل مكان له مجموعة خاصة باسمه داخل collection "destinations"
    commentsCollection = FirebaseFirestore.instance
        .collection('destinations')
        .doc(widget.placeName)
        .collection('comments');
  }

  Future<void> _submitComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final user = userDataNotifier.value;

    final commentData = {
      'name': user.name.isNotEmpty ? user.name : "Anonymous",
      'profile': user.profileImagePath ?? "",
      'text': commentText,
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await commentsCollection.add(commentData);

      _commentController.clear();
      setState(() {
        _rating = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your comment has been posted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to post comment")),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Comments for ${widget.placeName}",
                      style: TextStyle(
                          color: buttonTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    // StreamBuilder لجلب التعليقات مباشرة من Firestore
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: commentsCollection
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                "No comments yet!",
                                style: TextStyle(color: buttonTextColor, fontSize: 16),
                              ),
                            );
                          }
                          final docs = snapshot.data!.docs;
                          return ListView.separated(
                            itemCount: docs.length,
                            separatorBuilder: (_, __) => Divider(
                              color: buttonTextColor,
                              thickness: 0.5,
                            ),
                            itemBuilder: (context, index) {
                              final data = docs[index].data() as Map<String, dynamic>;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: data['profile'] != ""
                                      ? NetworkImage(data['profile'])
                                      : const AssetImage("assets/user.png")
                                  as ImageProvider,
                                ),
                                title: Text(
                                  data['name'] ?? "Unknown",
                                  style: TextStyle(
                                      color: buttonTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['text'] ?? "",
                                      style: TextStyle(color: buttonTextColor),
                                    ),
                                    if (data['rating'] != null)
                                      Row(
                                        children: List.generate(5, (i) {
                                          return Icon(
                                            i < data['rating'] ? Icons.star : Icons.star_border,
                                            size: 16,
                                            color: Colors.amber,
                                          );
                                        }),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Rating stars row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: starIndex <= _rating ? Colors.amber : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = starIndex.toDouble();
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    // Comment input
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: buttonTextColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _commentController,
                              style: TextStyle(color: buttonTextColor),
                              decoration: const InputDecoration(
                                hintText: "Type your comment...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _submitComment,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.arrow_forward, color: buttonTextColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: buttonTextColor,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: containerColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
