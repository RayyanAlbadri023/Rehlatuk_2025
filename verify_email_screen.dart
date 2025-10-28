// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class VerifyEmailScreen extends StatefulWidget {
//   const VerifyEmailScreen({Key? key}) : super(key: key);
//
//   @override
//   State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
// }
//
// class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   bool _isLoading = false;
//   bool _isResending = false;
//   bool _isVerified = false;
//   bool _emailSent = false;
//   late final User? _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentUser = FirebaseAuth.instance.currentUser;
//     _emailController.text = _currentUser?.email ?? '';
//     _startAutoCheckVerification();
//   }
//
//   void _startAutoCheckVerification() async {
//     while (mounted && !_isVerified) {
//       await Future.delayed(const Duration(seconds: 5));
//       await _checkVerificationStatus(silent: true);
//     }
//   }
//
//   Future<void> _sendVerificationEmail() async {
//     final email = _emailController.text.trim();
//
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter your email')),
//       );
//       return;
//     }
//
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(email)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid email format.')),
//       );
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       await _currentUser?.sendEmailVerification();
//       setState(() {
//         _emailSent = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Verification email sent! Please check your inbox.'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send verification email: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _checkVerificationStatus({bool silent = false}) async {
//     setState(() => _isLoading = !silent);
//
//     try {
//       await _currentUser?.reload();
//       final user = FirebaseAuth.instance.currentUser;
//
//       if (user != null && user.emailVerified) {
//         setState(() {
//           _isVerified = true;
//         });
//         if (!silent) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('✅ Email verified successfully!')),
//           );
//         }
//         Navigator.pushReplacementNamed(context, '/home');
//       } else if (!silent) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Email not verified yet.')),
//         );
//       }
//     } catch (e) {
//       if (!silent) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error checking verification: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _resendVerificationEmail() async {
//     setState(() => _isResending = true);
//     try {
//       await _currentUser?.sendEmailVerification();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Verification email resent successfully!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error resending email: $e')),
//       );
//     } finally {
//       setState(() => _isResending = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool hasEmail = _currentUser?.email != null;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[400],
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     'Verify Email',
//                     style: TextStyle(
//                       color: Color(0xFF1A1A4B),
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     _emailSent
//                         ? 'A verification link has been sent to your email. Please verify your account to continue.'
//                         : 'Please confirm or update your email to receive a verification link.',
//                     style: const TextStyle(
//                       color: Color(0xFF1A1A4B),
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   const Text(
//                     'Email Address',
//                     style: TextStyle(
//                       color: Color(0xFF1A1A4B),
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     enabled: !hasEmail,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                       hintText: 'example@gmail.com',
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 15,
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   if (!_emailSent) ...[
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed:
//                         _isLoading ? null : _sendVerificationEmail,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1A1A4B),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding:
//                           const EdgeInsets.symmetric(vertical: 15),
//                         ),
//                         child: _isLoading
//                             ? const CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                             : const Text(
//                           'Send',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ] else ...[
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed:
//                         _isLoading ? null : () => _checkVerificationStatus(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF1A1A4B),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding:
//                           const EdgeInsets.symmetric(vertical: 15),
//                         ),
//                         child: _isLoading
//                             ? const CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                             : const Text(
//                           'Continue',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isResending
//                             ? null
//                             : _resendVerificationEmail,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: const Color(0xFF1A1A4B),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             side: const BorderSide(
//                                 color: Color(0xFF1A1A4B)),
//                           ),
//                           padding:
//                           const EdgeInsets.symmetric(vertical: 15),
//                         ),
//                         child: _isResending
//                             ? const CircularProgressIndicator(
//                           color: Color(0xFF1A1A4B),
//                         )
//                             : const Text(
//                           'Resend Email',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF1A1A4B),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding:
//                         const EdgeInsets.symmetric(vertical: 15),
//                       ),
//                       child: const Text(
//                         'Back',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 16,
//               right: 16,
//               child: Image.asset(
//                 'assets/logo.png',
//                 height: 50,
//                 width: 50,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
