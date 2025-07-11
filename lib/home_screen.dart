import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';
import 'package:sos_app/widgets/home_widgets/custom_appBar.dart';
import 'package:sos_app/utils/quotes.dart';
import 'package:sos_app/widgets/SafeWebView.dart';
import 'package:sos_app/widgets/home_widgets/emergency.dart';
import 'package:sos_app/widgets/home_widgets/homesafe/SafeHome.dart';
import 'package:sos_app/widgets/livesafe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qIndex = 2;

  void getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(sweetSayings.length);
    });
  }

  @override
  void initState() {
    getRandomQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            CustomAppbar(
              quoteIndex: qIndex,
              onTap: getRandomQuote,
            ),
            const SizedBox(height: 20),
            // Carousel wrapped in a Container with fixed height
            Container(
              height: 200,
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                itemCount: imageSliders.length,
                itemBuilder: (context, index, realIndex) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SafeWebView(url: webLinks[index]),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            imageSliders[index],
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Positioned(
                          top: 130,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.black54,
                            child: Text(
                              imageTexts[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Emergency",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Emergency(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Explore Live Safe",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            LiveSafe(),
            // Wrap SafeHome widgets in Containers if they need fixed height
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SafeHome(),
            ),

            // Add additional widgets as needed
          ],
        ),
      ),
    );
  }
}
