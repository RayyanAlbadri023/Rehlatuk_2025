import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  final String placeName;
  final List<Map<String, String>>? initialComments;

  const CommentPage({super.key, required this.placeName, this.initialComments});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  late List<Map<String, String>> comments;

  @override
  void initState() {
    super.initState();
    comments = widget.initialComments ?? [];
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      comments.add({
        "name": "You", // Replace with real user name if available
        "profile": "assets/images/user.png", // default user image
        "text": _commentController.text.trim(),
      });
      _commentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Your comment has been posted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background car image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/car.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Rounded overlay container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: const BoxDecoration(
                color: Color(0xFF160948),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    Text(
                      "Comments for ${widget.placeName}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // Interaction box for rating message
                    if (_rating > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "You rated ${widget.placeName} ${_rating.toInt()} stars",
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Comments list
                    Expanded(
                      child: comments.isEmpty
                          ? const Center(
                        child: Text(
                          "No comments yet!",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      )
                          : ListView.separated(
                        itemCount: comments.length,
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.white,
                          thickness: 0.5,
                        ),
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  comment["profile"] ?? "assets/images/user.png"),
                            ),
                            title: Text(
                              comment["name"] ?? "Unknown",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              comment["text"] ?? "",
                              style: const TextStyle(color: Colors.white70),
                            ),
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
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _commentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: "Type your comment...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _submitComment,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: const Icon(Icons.arrow_forward, color: Colors.white),
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
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF160948)),
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
