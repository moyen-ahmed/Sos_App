import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MeteorDodgeGame extends StatefulWidget {
  const MeteorDodgeGame({Key? key}) : super(key: key);

  @override
  State<MeteorDodgeGame> createState() => _MeteorDodgeGameState();
}

class _MeteorDodgeGameState extends State<MeteorDodgeGame> {
  final int rowCount = 10;
  final int colCount = 6;
  final Duration tickRate = const Duration(milliseconds: 500);

  int playerPos = 2;
  List<Point<int>> meteors = [];
  late Timer _timer;
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    isGameOver = false;
    meteors.clear();
    playerPos = 2;

    _timer = Timer.periodic(tickRate, (timer) {
      setState(() {
        _updateGame();
      });
    });
  }

  void _updateGame() {
    if (isGameOver) return;

    // Move meteors down
    for (int i = 0; i < meteors.length; i++) {
      meteors[i] = Point(meteors[i].x, meteors[i].y + 1);
    }

    // Remove meteors that have left the grid
    meteors.removeWhere((m) => m.y >= rowCount);

    // Add new meteor at top
    int newMeteorCol = Random().nextInt(colCount);
    meteors.add(Point(newMeteorCol, 0));

    // Check for collision
    for (final meteor in meteors) {
      if (meteor.y == rowCount - 1 && meteor.x == playerPos) {
        isGameOver = true;
        _timer.cancel();
        break;
      }
    }
  }

  void _moveLeft() {
    if (playerPos > 0) {
      setState(() => playerPos--);
    }
  }

  void _moveRight() {
    if (playerPos < colCount - 1) {
      setState(() => playerPos++);
    }
  }

  Widget _buildCell(int x, int y) {
    bool isPlayer = y == rowCount - 1 && x == playerPos;
    bool isMeteor = meteors.any((m) => m.x == x && m.y == y);

    Color color;
    if (isPlayer) {
      color = Colors.greenAccent;
    } else if (isMeteor) {
      color = Colors.redAccent;
    } else {
      color = Colors.transparent;
    }

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Meteor Dodge"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: rowCount * colCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colCount,
              ),
              itemBuilder: (context, index) {
                int x = index % colCount;
                int y = index ~/ colCount;
                return _buildCell(x, y);
              },
            ),
          ),
          if (isGameOver)
            Text(
              'Game Over!',
              style: TextStyle(color: Colors.redAccent, fontSize: 24),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left, color: Colors.white),
                onPressed: _moveLeft,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right, color: Colors.white),
                onPressed: _moveRight,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
