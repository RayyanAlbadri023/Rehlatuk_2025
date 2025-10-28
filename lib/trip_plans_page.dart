import 'package:flutter/material.dart';

// Mock model for a Trip Plan
class TripPlan {
  final String id;
  final String userName;
  final String userAvatarUrl;

  TripPlan({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
  });
}

// Mock data
final List<TripPlan> mockTripPlans = [
  TripPlan(id: '1', userName: 'Sara', userAvatarUrl: 'https://placehold.co/100x100/A0C0E0/ffffff?text=S'),
  TripPlan(id: '2', userName: 'User', userAvatarUrl: 'https://placehold.co/100x100/808080/ffffff?text=U'),
  TripPlan(id: '3', userName: 'Marwa', userAvatarUrl: 'https://placehold.co/100x100/F0A0B0/ffffff?text=M'),
  TripPlan(id: '4', userName: 'Ahmed', userAvatarUrl: 'https://placehold.co/100x100/60C0A0/ffffff?text=A'),
  TripPlan(id: '5', userName: 'Ali', userAvatarUrl: 'https://placehold.co/100x100/C0A060/ffffff?text=A'),
];

class TripPlansPage extends StatelessWidget {
  const TripPlansPage({super.key});

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
        title: const Text('View trip plan pag1', style: TextStyle(color: Color(0xFF333333))),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24.0, bottom: 20.0),
            child: Text(
              'View trip plans',
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
              itemCount: mockTripPlans.length + 1, // +1 for the More button
              itemBuilder: (context, index) {
                if (index < mockTripPlans.length) {
                  final plan = mockTripPlans[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TripPlanCard(plan: plan),
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

class TripPlanCard extends StatelessWidget {
  final TripPlan plan;

  const TripPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(plan.userAvatarUrl),
              radius: 20,
              onBackgroundImageError: (exception, stackTrace) => {}, // Handle error
            ),
            const SizedBox(width: 16),
            Text(
              plan.userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const Spacer(),
            // Mock action button (e.g., to view details)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
