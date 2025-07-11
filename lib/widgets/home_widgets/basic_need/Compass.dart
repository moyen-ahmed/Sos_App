// Compass Screen
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double? _direction;
  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _direction = event.heading;
        });
      }
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Compass Background
                  Image.asset('assets/Compass-1.png'),
                  // Rotating Needle
                  if (_direction != null)
                    Transform.rotate(
                      angle: (_direction ?? 0) * (math.pi / 180) * -1,
                      child: Image.asset(
                        'assets/Compass-1.png',
                        width: 190,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _direction != null
                  ? '${_direction!.toStringAsFixed(1)}°'
                  : 'Initializing...',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}