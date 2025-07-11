import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class AsteroidBlasterGame extends StatefulWidget {
  const AsteroidBlasterGame({Key? key}) : super(key: key);

  @override
  State<AsteroidBlasterGame> createState() => _AsteroidBlasterGameState();
}

class _AsteroidBlasterGameState extends State<AsteroidBlasterGame>
    with TickerProviderStateMixin {
  late AnimationController _gameController;
  late AnimationController _shootController;
  double _playerX = 0.5;
  double _playerSpeed = 0.0;
  final List<Offset> _asteroids = [];
  final List<Offset> _bullets = [];
  int _score = 0;
  int _lives = 3;
  bool _gameOver = false;
  final Random _random = Random();
  double _gameWidth = 300.0;

  @override
  void initState() {
    super.initState();
    _gameController = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..addListener(_updateGame);
    _shootController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startGame();
  }

  void _startGame() {
    _gameController.repeat();
    // Spawn asteroids periodically
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_gameOver) {
        setState(() {
          _asteroids.add(Offset(
            _random.nextDouble() * _gameWidth,
            -30.0,
          ));
        });
      }
    });
  }

  void _updateGame() {
    if (_gameOver) return;

    // Update player position
    setState(() {
      _playerX = (_playerX + _playerSpeed).clamp(0.15, 0.85);
    });

    // Update asteroids
    setState(() {
      _asteroids.removeWhere((asteroid) {
        // Check if asteroid reached bottom
        if (asteroid.dy > MediaQuery.of(context).size.height) {
          _lives--;
          if (_lives <= 0) _endGame();
          return true;
        }
        return false;
      });

      _asteroids.forEach((asteroid) {
        final index = _asteroids.indexOf(asteroid);
        _asteroids[index] = Offset(asteroid.dx, asteroid.dy + 2);
      });
    });

    // Update bullets
    setState(() {
      _bullets.removeWhere((bullet) => bullet.dy < 0);
      _bullets.forEach((bullet) {
        final index = _bullets.indexOf(bullet);
        _bullets[index] = Offset(bullet.dx, bullet.dy - 5);
      });
    });

    // Check collisions
    _checkCollisions();
  }

  void _checkCollisions() {
    _bullets.forEach((bullet) {
      _asteroids.removeWhere((asteroid) {
        final distance = (bullet - asteroid).distance;
        if (distance < 20) {
          setState(() => _score += 10);
          return true;
        }
        return false;
      });
    });
  }

  void _endGame() {
    setState(() => _gameOver = true);
    _gameController.stop();
  }

  void _moveLeft() => setState(() => _playerSpeed = -0.02);
  void _moveRight() => setState(() => _playerSpeed = 0.02);
  void _stopMoving() => setState(() => _playerSpeed = 0.0);

  void _shoot() {
    if (_shootController.isAnimating) return;
    _shootController.forward().then((_) => _shootController.reset());

    setState(() {
      _bullets.add(Offset(
        _playerX * _gameWidth,
        MediaQuery.of(context).size.height - 100,
      ));
    });
  }

  @override
  void dispose() {
    _gameController.dispose();
    _shootController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _gameWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildGameHeader(),
            Expanded(child: _buildGameArea()),
            _buildControlPanel(),
            if (_gameOver) _buildGameOverScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Score: $_score',
              style: const TextStyle(color: Colors.white, fontSize: 20)),
          Row(
            children: List.generate(3, (index) => Icon(
              Icons.favorite,
              color: index < _lives ? Colors.red : Colors.grey,
            )),
          )
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _playerX = (details.globalPosition.dx / _gameWidth).clamp(0.15, 0.85);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: CustomPaint(
          painter: AsteroidPainter(
            playerX: _playerX,
            asteroids: _asteroids,
            bullets: _bullets,
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(Icons.arrow_left, _moveLeft),
          _buildControlButton(Icons.radio_button_checked, _shoot),
          _buildControlButton(Icons.arrow_right, _moveRight),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
      iconSize: 40,
    );
  }

  Widget _buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Game Over!',
              style: TextStyle(color: Colors.white, fontSize: 40)),
          Text('Final Score: $_score',
              style: const TextStyle(color: Colors.white, fontSize: 24)),
          ElevatedButton(
            child: const Text('Play Again'),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const AsteroidBlasterGame())),
          ),
        ],
      ),
    );
  }
}

class AsteroidPainter extends CustomPainter {
  final double playerX;
  final List<Offset> asteroids;
  final List<Offset> bullets;

  AsteroidPainter({
    required this.playerX,
    required this.asteroids,
    required this.bullets,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw player
    final playerPaint = Paint()..color = Colors.blue;
    final playerPos = Offset(size.width * playerX, size.height - 30);
    canvas.drawCircle(playerPos, 20, playerPaint);

    // Draw asteroids
    final asteroidPaint = Paint()..color = Colors.grey;
    for (final asteroid in asteroids) {
      canvas.drawCircle(asteroid, 15, asteroidPaint);
    }

    // Draw bullets
    final bulletPaint = Paint()..color = Colors.red;
    for (final bullet in bullets) {
      canvas.drawRect(
        Rect.fromCenter(center: bullet, width: 4, height: 20),
        bulletPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AsteroidPainter oldDelegate) => true;
}