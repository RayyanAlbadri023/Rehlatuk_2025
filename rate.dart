// lib/feedback_page.dart
import 'package:flutter/material.dart';
import 'user_data.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int selectedStars = 0;
  final TextEditingController feedbackController = TextEditingController();
  bool isSubmitted = false;

  bool get isFormValid =>
      selectedStars > 0 && feedbackController.text.trim().isNotEmpty;

  void submitFeedback() {
    if (!isFormValid) return;

    setState(() {
      isSubmitted = true;
    });

    // You can also save feedback somewhere if desired (firebase / api)
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
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Text(
                lang == "Arabic" ? "قيمنا" : "Rate us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.textTheme.bodyMedium?.color,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: feedbackController,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.cardColor,
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
            backgroundColor: isFormValid ? theme.primaryColor : theme.disabledColor,
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
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor,
                ),
                padding: const EdgeInsets.all(20),
                child: const Icon(Icons.thumb_up, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                lang == "Arabic" ? "شكراً لك!" : "Thank you!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                lang == "Arabic"
                    ? "بملاحظاتك تساعدنا في تحسين التطبيق"
                    : "By making your voice heard, you help us improve the app",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
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
