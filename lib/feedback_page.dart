import 'package:flutter/material.dart';

// Mock model for Feedback
class AppFeedback {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final int rating;
  final String text;

  AppFeedback({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.text,
  });
}

// Mock data
final List<AppFeedback> mockFeedbacks = [
  AppFeedback(
    id: 'f1',
    userName: 'Sara',
    userAvatarUrl: 'https://placehold.co/100x100/F0A0B0/ffffff?text=S',
    rating: 5,
    text: 'Great system, it helped me a lot. Thank u rehtank',
  ),
  AppFeedback(
    id: 'f2',
    userName: 'User',
    userAvatarUrl: 'https://placehold.co/100x100/808080/ffffff?text=U',
    rating: 4,
    text: 'I like this app, it is so useful!',
  ),
  AppFeedback(
    id: 'f3',
    userName: 'Ahmed',
    userAvatarUrl: 'https://placehold.co/100x100/60C0A0/ffffff?text=A',
    rating: 5,
    text: 'wow, good!!',
  ),
];

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Home Button
          TextButton.icon(
            icon: const Icon(Icons.luggage, color: Color(0xFF004683), size: 18),
            label: const Text('Home', style: TextStyle(color: Color(0xFF004683))),
            onPressed: () {
              // Navigate back to the main Admin Home Page
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          const SizedBox(width: 8),
        ],
        title: const Text('Show feedback page', style: TextStyle(color: Color(0xFF333333))),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24.0, left: 24.0, bottom: 20.0),
            child: Text(
              'Feedback',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004683),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: mockFeedbacks.length + 1, // +1 for the More button
              itemBuilder: (context, index) {
                if (index < mockFeedbacks.length) {
                  final feedback = mockFeedbacks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: FeedbackCard(feedback: feedback),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 40.0),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 40,
                        color: Color(0xFF004683),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final AppFeedback feedback;

  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(feedback.userAvatarUrl),
            radius: 20,
            onBackgroundImageError: (exception, stackTrace) => {},
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      feedback.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    // Displaying stars based on rating
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < feedback.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  feedback.text,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
