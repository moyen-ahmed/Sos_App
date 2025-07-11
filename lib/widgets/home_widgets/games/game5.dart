import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class WordBuilderGame extends StatefulWidget {
  const WordBuilderGame({Key? key}) : super(key: key);

  @override
  State<WordBuilderGame> createState() => _WordBuilderGameState();
}

class _WordBuilderGameState extends State<WordBuilderGame> {
  late String currentWord;
  late List<String> shuffledLetters;
  String userWord = '';
  String message = '';
  int score = 0;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _generateNewWord();
  }

  void _generateNewWord() {
    setState(() {
      // Get random word with length between 4 and 6
      final word = nouns.where((w) => w.length >= 4 && w.length <= 6).toList()..shuffle();
      currentWord = word.first.toUpperCase();
      shuffledLetters = currentWord.split('')..shuffle(random);
      userWord = '';
      message = '';
    });
  }

  void _onLetterTap(String letter) {
    if (userWord.length >= currentWord.length) return;
    setState(() {
      userWord += letter;
    });
  }

  void _onBackspace() {
    if (userWord.isNotEmpty) {
      setState(() {
        userWord = userWord.substring(0, userWord.length - 1);
      });
    }
  }

  void _checkWord() {
    if (userWord == currentWord) {
      setState(() {
        message = 'Correct!';
        score += 10;
      });
    } else {
      setState(() {
        message = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Builder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Score: $score', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: shuffledLetters
                  .map((letter) => ElevatedButton(
                onPressed: () => _onLetterTap(letter),
                child: Text(letter, style: const TextStyle(fontSize: 22)),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(userWord, style: const TextStyle(fontSize: 28, letterSpacing: 4)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _checkWord,
                  child: const Text('Check'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _onBackspace,
                  child: const Icon(Icons.backspace),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 22,
                color: message == 'Correct!' ? Colors.green : Colors.red,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _generateNewWord,
              child: const Text('Next Word'),
            ),
          ],
        ),
      ),
    );
  }
}
