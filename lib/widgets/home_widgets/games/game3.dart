import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AstroTapperGame extends StatefulWidget {
  const AstroTapperGame({Key? key}) : super(key: key);

  @override
  State<AstroTapperGame> createState() => _AstroTapperGameState();
}

class _AstroTapperGameState extends State<AstroTapperGame> {
  final Random _random = Random();
  int _score = 0;
  Offset _orbPosition = const Offset(100, 100);
  bool _gameStarted = false;
  int _timeLeft = 30;
  Timer? _gameTimer;

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 30;
      _gameStarted = true;
    });

    _randomizeOrb();

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft <= 1) {
        timer.cancel();
        setState(() {
          _gameStarted = false;
        });
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void _randomizeOrb() {
    final width = MediaQuery.of(context).size.width - 80;
    final height = MediaQuery.of(context).size.height - 200;
    setState(() {
      _orbPosition = Offset(
        _random.nextDouble() * width,
        _random.nextDouble() * height,
      );
    });
  }

  void _tapOrb() {
    if (!_gameStarted) return;
    setState(() {
      _score++;
    });
    _randomizeOrb();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Astro Tapper'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          if (!_gameStarted)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tap the orb as fast as you can!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startGame,
                    child: const Text('Start Game'),
                  ),
                ],
              ),
            ),
          if (_gameStarted)
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score: $_score',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time: $_timeLeft',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          if (_gameStarted)
            Positioned(
              top: _orbPosition.dy,
              left: _orbPosition.dx,
              child: GestureDetector(
                onTap: _tapOrb,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.cyanAccent.shade200,
                        Colors.blueAccent.shade700,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!_gameStarted && _score > 0)
            Center(
              child: Text(
                'Game Over!\nYour Score: $_score',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
