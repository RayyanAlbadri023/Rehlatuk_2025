// import 'package:flutter/material.dart';
// import 'destination_list_page.dart'; // Destination model and service
// import 'view_comments_page.dart';
// import 'admin_home_page.dart';
//
// class ManageCommentsPage extends StatefulWidget {
//   const ManageCommentsPage({super.key});
//
//   @override
//   State<ManageCommentsPage> createState() => _ManageCommentsPageState();
// }
//
// class _ManageCommentsPageState extends State<ManageCommentsPage> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Destination> _allDestinations = [];
//   List<Destination> _filteredDestinations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Listen to real-time updates from Firestore
//     destinationService.getDestinations().listen((destinations) {
//       setState(() {
//         _allDestinations = destinations;
//         _filteredDestinations = _filterList(_searchController.text, destinations);
//       });
//     });
//
//     _searchController.addListener(() {
//       setState(() {
//         _filteredDestinations = _filterList(_searchController.text, _allDestinations);
//       });
//     });
//   }
//
//   List<Destination> _filterList(String query, List<Destination> list) {
//     if (query.isEmpty) return list;
//     return list.where((d) => d.name.toLowerCase().contains(query.toLowerCase())).toList();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F5F8),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         actions: [
//           TextButton.icon(
//             icon: const Icon(Icons.home, color: Color(0xFF004683), size: 18),
//             label: const Text('Home', style: TextStyle(color: Color(0xFF004683))),
//             onPressed: () {
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (_) => const AdminHomePage()),
//                     (route) => false,
//               );
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//         title: const Text('Manage Comments', style: TextStyle(color: Color(0xFF333333))),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: const InputDecoration(
//                   hintText: 'Search for destination...',
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                   suffixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
//                 ),
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: _filteredDestinations.length,
//               itemBuilder: (context, index) {
//                 final destination = _filteredDestinations[index];
//                 return DestinationCommentCard(
//                   destination: destination,
//                   onViewComments: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => ViewCommentsPage(destination: destination),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DestinationCommentCard extends StatelessWidget {
//   final Destination destination;
//   final VoidCallback onViewComments;
//
//   const DestinationCommentCard({
//     super.key,
//     required this.destination,
//     required this.onViewComments,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onViewComments,
//       child: Container(
//         height: 80,
//         margin: const EdgeInsets.only(bottom: 12),
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
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 bottomLeft: Radius.circular(12),
//               ),
//               child: Image.network(
//                 destination.imageUrl,
//                 width: 100,
//                 height: 80,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   width: 100,
//                   height: 80,
//                   color: Colors.grey.shade300,
//                   child: const Center(child: Icon(Icons.image)),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 destination.name,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF333333),
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const SizedBox(width: 16),
//             const Padding(
//               padding: EdgeInsets.only(right: 16.0),
//               child: Icon(Icons.arrow_forward_ios, color: Color(0xFF004683), size: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
