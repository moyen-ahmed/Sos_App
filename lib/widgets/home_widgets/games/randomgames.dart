import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({Key? key}) : super(key: key);

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

enum Direction { up, down, left, right }

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int rowCount = 20;
  static const int columnCount = 20;
  static const Duration tickRate = Duration(milliseconds: 200);

  late Timer _timer;
  Direction _direction = Direction.right;
  List<Point<int>> _snake = [const Point(10, 10)];
  Point<int> _food = const Point(5, 5);
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _snake = [const Point(10, 10)];
    _direction = Direction.right;
    _isGameOver = false;
    _placeFood();

    _timer = Timer.periodic(tickRate, (Timer timer) {
      setState(() {
        _updateGame(timer); // or just call the method if it doesn't need arguments
      });
    });
  }

  void _updateGame(_) {
    final head = _snake.last;
    Point<int> newHead;

    switch (_direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    if (_snake.contains(newHead) ||
        newHead.x < 0 ||
        newHead.y < 0 ||
        newHead.x >= columnCount ||
        newHead.y >= rowCount) {
      _gameOver();
      return;
    }

    _snake.add(newHead);

    if (newHead == _food) {
      _placeFood();
    } else {
      _snake.removeAt(0);
    }
  }

  void _gameOver() {
    _timer.cancel();
    setState(() {
      _isGameOver = true;
    });
  }

  void _placeFood() {
    final random = Random();
    while (true) {
      final food = Point(random.nextInt(columnCount), random.nextInt(rowCount));
      if (!_snake.contains(food)) {
        _food = food;
        break;
      }
    }
  }

  void _onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity!;
    if (details.velocity.pixelsPerSecond.dx.abs() >
        details.velocity.pixelsPerSecond.dy.abs()) {
      if (velocity < 0 && _direction != Direction.right) {
        _direction = Direction.left;
      } else if (velocity > 0 && _direction != Direction.left) {
        _direction = Direction.right;
      }
    } else {
      if (velocity < 0 && _direction != Direction.down) {
        _direction = Direction.up;
      } else if (velocity > 0 && _direction != Direction.up) {
        _direction = Direction.down;
      }
    }
  }

  Widget _buildCell(int x, int y) {
    final point = Point(x, y);
    Color color;

    if (_snake.contains(point)) {
      color = Colors.greenAccent;
    } else if (_food == point) {
      color = Colors.redAccent;
    } else {
      color = Colors.black;
    }

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: _onSwipe,
      onHorizontalDragEnd: _onSwipe,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Snake Game'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowCount * columnCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                ),
                itemBuilder: (context, index) {
                  final x = index % columnCount;
                  final y = index ~/ columnCount;
                  return _buildCell(x, y);
                },
              ),
            ),
            if (_isGameOver)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Game Over!',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                      ),
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
