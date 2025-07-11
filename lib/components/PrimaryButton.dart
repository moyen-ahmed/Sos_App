import 'package:sos_app/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/utils/color_const.dart';
import 'package:sos_app/utils/color_const.dart';
import '../utils/color_const.dart';




class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;  // Loading state

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,  // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,  // Disable button when loading
        style: ElevatedButton.styleFrom(
          backgroundColor:Color(0xFFAB40CA), // Button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: loading
            ? const CircularProgressIndicator(color: Colors.redAccent) // Show spinner when loading
            : Text(
          title,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
