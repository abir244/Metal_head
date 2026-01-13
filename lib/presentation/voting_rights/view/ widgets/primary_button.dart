// import 'package:flutter/material.dart';
//
// import '../../../../core/constants/app_colors.dart';
//
//
// class PrimaryButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onPressed;
//   const PrimaryButton({super.key, required this.label, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primaryYellow,
//           foregroundColor: Colors.black,
//           shape: RoundedRectangleActionBorder(borderRadius: BorderRadius.circular(28)),
//           textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         child: Text(label),
//       ),
//     );
//   }
// }