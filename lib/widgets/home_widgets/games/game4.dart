import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MathMatchGame extends StatefulWidget {
  @override
  _MathMatchGameState createState() => _MathMatchGameState();
}

class _MathMatchGameState extends State<MathMatchGame> {
  late Timer _timer;
  int _timeLeft = 10;
  int _score = 0;
  late int _correctAnswer;
  String _question = '';
  List<int> _options = [];
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _score = 0;
    _gameOver = false;
    _startTimer();
    _generateQuestion();
  }

  void _startTimer() {
    _timeLeft = 10;
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

  void _generateQuestion() {
    Random random = Random();
    int a = random.nextInt(20) + 1;
    int b = random.nextInt(20) + 1;
    int op = random.nextInt(3); // 0=+, 1=-, 2=*

    switch (op) {
      case 0:
        _correctAnswer = a + b;
        _question = '$a + $b = ?';
        break;
      case 1:
        _correctAnswer = a - b;
        _question = '$a - $b = ?';
        break;
      case 2:
        _correctAnswer = a * b;
        _question = '$a × $b = ?';
        break;
    }

    _options = [_correctAnswer];
    while (_options.length < 4) {
      int wrongAnswer = _correctAnswer + random.nextInt(10) - 5;
      if (!_options.contains(wrongAnswer)) {
        _options.add(wrongAnswer);
      }
    }
    _options.shuffle();
  }

  void _checkAnswer(int selected) {
    if (_gameOver) return;
    if (selected == _correctAnswer) {
      setState(() {
        _score++;
        _timeLeft = 10;
        _generateQuestion();
      });
    } else {
      setState(() {
        _gameOver = true;
        _timer.cancel();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text("Math Match Game"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: _gameOver ? _buildGameOver() : _buildGameUI(),
      ),
    );
  }

  Widget _buildGameUI() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _question,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(
            value: _timeLeft / 10,
            minHeight: 10,
            color: Colors.indigo,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 20),
          ..._options.map((opt) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => _checkAnswer(opt),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                backgroundColor: Colors.indigo,
              ),
              child: Text(
                '$opt',
                style: TextStyle(fontSize: 24),
              ),
            ),
          )),
          SizedBox(height: 30),
          Text(
            "Score: $_score",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOver() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Game Over!",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        SizedBox(height: 20),
        Text(
          "Final Score: $_score",
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _startNewGame();
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          child: Text("Play Again", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
