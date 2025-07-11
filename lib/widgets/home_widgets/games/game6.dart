import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MathMemoryGame extends StatefulWidget {
  @override
  _MathMemoryGameState createState() => _MathMemoryGameState();
}

class _MathMemoryGameState extends State<MathMemoryGame> {
  late Timer _timer;
  int _timeLeft = 60;
  int _score = 0;
  List<MemoryCard> _cards = [];
  List<int> _flippedIndices = [];
  bool _gameOver = false;
  final int _gridSize = 4; // 4x4 grid

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _score = 0;
    _gameOver = false;
    _flippedIndices.clear();
    _generateCards();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _gameOver = true;
          _timer.cancel();
        }
      });
    });
  }

  void _generateCards() {
    final Random random = Random();
    final List<EquationPair> pairs = [];

    // Generate 8 unique equation-answer pairs
    while (pairs.length < (_gridSize * _gridSize) ~/ 2) {
      final a = random.nextInt(15) + 1;
      final b = random.nextInt(15) + 1;
      final op = random.nextInt(3);
      String equation;
      int answer;

      switch (op) {
        case 0:
          equation = '$a + $b';
          answer = a + b;
          break;
        case 1:
          equation = '$a - $b';
          answer = a - b;
          break;
        default:
          equation = '$a × $b';
          answer = a * b;
          break;
      }

      if (!pairs.any((p) => p.equation == equation)) {
        pairs.add(EquationPair(equation, answer));
      }
    }

    // Duplicate pairs and shuffle
    _cards = (pairs.map((p) => [p, p]).expand((i) => i).toList()
      ..shuffle())
        .map((pair) => MemoryCard(
      value: pair.equation,
      answer: pair.answer,
      isFlipped: false,
      isMatched: false,
    ))
        .toList();
  }

  void _flipCard(int index) async {
    if (_gameOver ||
        _flippedIndices.length == 2 ||
        _cards[index].isFlipped ||
        _cards[index].isMatched) return;

    setState(() {
      _cards[index].isFlipped = true;
      _flippedIndices.add(index);
    });

    if (_flippedIndices.length == 2) {
      final first = _cards[_flippedIndices[0]];
      final second = _cards[_flippedIndices[1]];

      if (first.answer == second.answer) {
        setState(() {
          first.isMatched = true;
          second.isMatched = true;
          _score += 10;
          _flippedIndices.clear();
        });
        // Check for game completion
        if (_cards.every((card) => card.isMatched)) {
          _gameOver = true;
          _timer.cancel();
        }
      } else {
        await Future.delayed(Duration(milliseconds: 800));
        setState(() {
          _cards[_flippedIndices[0]].isFlipped = false;
          _cards[_flippedIndices[1]].isFlipped = false;
          _flippedIndices.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardSize = (size.width - 40) / _gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text("Math Memory Match"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(child: Text("Time: $_timeLeft")),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Score: $_score",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridSize,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) => _buildCard(index, cardSize),
              ),
            ),
          ),
          if (_gameOver) _buildGameOver(),
        ],
      ),
    );
  }

  Widget _buildCard(int index, double size) {
    return GestureDetector(
      onTap: () => _flipCard(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _cards[index].isMatched
              ? Colors.green.shade200
              : _cards[index].isFlipped
              ? Colors.white
              : Colors.teal.shade400,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _cards[index].isFlipped || _cards[index].isMatched
                ? Text(
              _cards[index].isMatched
                  ? _cards[index].answer.toString()
                  : _cards[index].value,
              style: TextStyle(
                fontSize: size * 0.3,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            )
                : Icon(Icons.question_mark,
                size: size * 0.3,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Game Over!",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
          SizedBox(height: 10),
          Text(
            "Final Score: $_score",
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text("Play Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            onPressed: () => setState(_startNewGame),
          ),
        ],
      ),
    );
  }
}

class MemoryCard {
  final String value;
  final int answer;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.value,
    required this.answer,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class EquationPair {
  final String equation;
  final int answer;

  EquationPair(this.equation, this.answer);
}