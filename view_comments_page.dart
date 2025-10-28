// import 'package:flutter/material.dart';
// import 'destination_list_page.dart';
//
// class Comment {
//   final String id;
//   final String userName;
//   final String userAvatarUrl;
//   final int rating;
//   final String text;
//   final String language;
//
//   Comment({
//     required this.id,
//     required this.userName,
//     required this.userAvatarUrl,
//     required this.rating,
//     required this.text,
//     required this.language,
//   });
// }
//
// // Example comments (replace with Firestore fetch later)
// final List<Comment> mockComments = [
//   Comment(
//     id: 'c1',
//     userName: 'Saidah',
//     userAvatarUrl: 'https://placehold.co/100x100/F0A0B0/ffffff?text=S',
//     rating: 5,
//     text: 'Highly recommended place!',
//     language: 'English',
//   ),
//   Comment(
//     id: 'c2',
//     userName: 'Salim',
//     userAvatarUrl: 'https://placehold.co/100x100/A0C0E0/ffffff?text=S',
//     rating: 5,
//     text: 'Stunning experience!',
//     language: 'English',
//   ),
//   Comment(
//     id: 'c3',
//     userName: 'Saleh M. Omar',
//     userAvatarUrl: 'https://placehold.co/100x100/60C0A0/ffffff?text=S',
//     rating: 4,
//     text: 'جميل جداً ومريح. أنصح به لمن يبحث عن الهدوء.',
//     language: 'Arabic',
//   ),
// ];
//
// class ViewCommentsPage extends StatelessWidget {
//   final Destination destination;
//
//   const ViewCommentsPage({super.key, required this.destination});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F5F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         title: const Text('View Comments', style: TextStyle(color: Color(0xFF333333))),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Destination Card
//             Container(
//               height: 150,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 image: DecorationImage(
//                   image: NetworkImage(destination.imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               alignment: Alignment.bottomLeft,
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(16),
//                     bottomRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Text(
//                   destination.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               'Comments:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004683)),
//             ),
//             const SizedBox(height: 15),
//             ...mockComments.map((comment) => CommentCard(comment: comment)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CommentCard extends StatelessWidget {
//   final Comment comment;
//
//   const CommentCard({super.key, required this.comment});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Container(
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(comment.userAvatarUrl),
//                   radius: 18,
//                 ),
//                 const SizedBox(width: 10),
//                 Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333))),
//                 const Spacer(),
//                 Row(
//                   children: List.generate(5, (index) => Icon(
//                     index < comment.rating ? Icons.star : Icons.star_border,
//                     color: Colors.amber,
//                     size: 16,
//                   )),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: Text('Simulated delete comment ${comment.id}'),
//                     ));
//                   },
//                   child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(comment.text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }
