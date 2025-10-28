// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'login_screen.dart';
// import 'app_validators.dart'; // ✅ استدعاء AppValidators
//
// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }
//
// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//
//   bool _obscureNewPassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;
//   final _formKey = GlobalKey<FormState>(); // ✅ نموذج التحقق
//
//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _resetPassword() async {
//     if (!_formKey.currentState!.validate()) return; // ✅ تحقق
//
//     setState(() => _isLoading = true);
//
//     final newPassword = _newPasswordController.text.trim();
//
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         _showMessage('No user logged in. Please log in again.');
//         return;
//       }
//
//       await user.updatePassword(newPassword);
//       await FirebaseAuth.instance.signOut();
//
//       _showMessage('Password updated successfully. Please log in again.');
//
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//             (route) => false,
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'requires-recent-login') {
//         _showMessage('Please re-login before changing your password.');
//       } else {
//         _showMessage('Error: ${e.message}');
//       }
//     } catch (e) {
//       _showMessage('Unexpected error: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _showMessage(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[400],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey, // ✅ نموذج التحقق
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 40),
//                 const Text(
//                   'Reset Password',
//                   style: TextStyle(
//                     color: Color(0xFF1A1A4B),
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Enter a new password that meets the security requirements.',
//                   style: TextStyle(color: Color(0xFF1A1A4B), fontSize: 14),
//                 ),
//                 const SizedBox(height: 40),
//
//                 _buildPasswordField(
//                   label: 'New password',
//                   controller: _newPasswordController,
//                   obscureText: _obscureNewPassword,
//                   validator: AppValidators.validatePassword,
//                   toggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildPasswordField(
//                   label: 'Confirm password',
//                   controller: _confirmPasswordController,
//                   obscureText: _obscureConfirmPassword,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) return 'Please confirm your password';
//                     if (value != _newPasswordController.text) return 'Passwords do not match';
//                     return null;
//                   },
//                   toggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
//                 ),
//
//                 const Spacer(),
//
//                 // ✅ Save Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _resetPassword,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1A1A4B),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                       'Save',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // ✅ Back Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1A1A4B),
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                     ),
//                     child: const Text(
//                       'Back',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPasswordField({
//     required String label,
//     required TextEditingController controller,
//     required bool obscureText,
//     required String? Function(String?) validator,
//     required VoidCallback toggle,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             color: Color(0xFF1A1A4B),
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           validator: validator,
//           style: const TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             hintText: '••••••••',
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                 color: Colors.grey,
//               ),
//               onPressed: toggle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
