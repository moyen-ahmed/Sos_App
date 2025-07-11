import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class flashlight extends StatelessWidget {
  const flashlight({Key? key}) : super(key: key);

  // Function to toggle flashlight
  Future<void> _toggleFlashlight(BuildContext context) async {
    try {
      // Check if device supports torch
      bool isSupported = await TorchLight.isTorchAvailable();

      if (isSupported) {
        try {
          // Try to turn on the torch
          await TorchLight.enableTorch();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashlight turned ON')),
          );
        } catch (e) {
          // If the torch is already on, turn it off
          await TorchLight.disableTorch();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Flashlight turned OFF')),
          );
        }
      } else {
        // Show an error message if flashlight is not available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No flashlight available on this device')),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleFlashlight(context),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 50,
                width: 50,
                child: Center(
                  child: Image.asset('assets/flashlight.png',
                    height: 60,
                  ),
                ),
              ),
            ),
          ),
          Text('Flashlight')  // Changed the text to reflect new functionality
        ],
      ),
    );
  }
}