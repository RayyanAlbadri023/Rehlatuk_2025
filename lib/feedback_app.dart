import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_data.dart';

class FeedbackPageApp extends StatefulWidget {
  const FeedbackPageApp({super.key});

  @override
  State<FeedbackPageApp> createState() => _FeedbackPageAppState();
}

class _FeedbackPageAppState extends State<FeedbackPageApp> {
  int selectedStars = 0;
  final TextEditingController feedbackController = TextEditingController();
  bool isSubmitted = false;

  bool get isFormValid =>
      selectedStars > 0 && feedbackController.text.trim().isNotEmpty;

  Future<void> submitFeedback() async {
    if (!isFormValid) return;

    final user = userDataNotifier.value;

    final feedbackData = {
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'language': user.language,
      'stars': selectedStars,
      'feedback': feedbackController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('feedbacks')
          .add(feedbackData);

      setState(() {
        isSubmitted = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting feedback')),
      );
    }
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = userDataNotifier.value.language;

    Widget buildRateUs() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Text(
                lang == "Arabic" ? "قيمنا" : "Rate us",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF160948),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selectedStars ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() => selectedStars = index + 1);
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              Text(
                lang == "Arabic"
                    ? "اكتب لنا عن تجربتك مع التطبيق"
                    : "Write to us about your experience with our application",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF160948),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(color: Color(0xFF160948)),
                controller: feedbackController,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: lang == "Arabic"
                      ? "اكتب ملاحظاتك هنا..."
                      : "Write your feedback here...",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isFormValid ? submitFeedback : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isFormValid ? Colors.grey : theme.disabledColor,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            lang == "Arabic" ? "إرسال" : "Submit",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );

    Widget buildThankYou() => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.thumb_up, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                lang == "Arabic" ? "شكراً لك!" : "Thank you!",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF160948),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lang == "Arabic"
                    ? "بملاحظاتك تساعدنا في تحسين التطبيق"
                    : "By making your voice heard, you help us improve the app",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF160948),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            lang == "Arabic" ? "تم" : "Done",
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: isSubmitted
          ? null
          : AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Center(
        child: isSubmitted ? buildThankYou() : buildRateUs(),
      ),
    );
  }
}
