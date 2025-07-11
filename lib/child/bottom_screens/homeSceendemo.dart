import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sos_app/widgets/home_widgets/basic_need/flushlight.dart';
import 'dart:math';
import 'package:sos_app/widgets/home_widgets/custom_appBar.dart';
import 'package:sos_app/utils/quotes.dart';
import 'package:sos_app/widgets/SafeWebView.dart';
import 'package:sos_app/widgets/home_widgets/emergency.dart';
import 'package:sos_app/widgets/home_widgets/games/games.dart';
import 'package:sos_app/widgets/home_widgets/homesafe/SafeHome.dart';
import 'package:sos_app/widgets/livesafe.dart';
import 'package:animate_do/animate_do.dart';

import '../../widgets/home_widgets/basic_need/basic_need.dart';

class HomeScreen1 extends StatefulWidget {
  @override
  State<HomeScreen1> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {
  int qIndex = 2;
  // Initialize controllers in initState instead of using late
  ScrollController? _scrollController;
  bool _isScrolled = false;

  void getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(sweetSayings.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getRandomQuote();

    // Initialize the scroll controller properly
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController!.offset > 20 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController!.offset <= 20 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    // Always dispose controllers
    _scrollController?.dispose();
    super.dispose();
  }

  // Custom section header widget for consistent styling
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
          children: [
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              child: _sectionHeader("Quotes"),
            ),
            // Custom app bar with animation effect - FIXED by passing required parameters
            // SlideInDown(
            //   duration: const Duration(milliseconds: 600),
            //   child: CustomAppbar(
            //     quoteIndex: qIndex,
            //     onTap: getRandomQuote,
            //   ),
            // ),

            // Improved motivational quote section with beautiful styling
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: GestureDetector(
                  onTap: getRandomQuote,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.7),
                          Theme.of(context).primaryColor.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Today's Inspiration",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          sweetSayings[qIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Tap for new quote",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Carousel with optimized loading
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      autoPlayCurve: Curves.easeInOutCubic,
                      autoPlayAnimationDuration: const Duration(seconds: 1),
                    ),
                    itemCount: imageSliders.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      SafeWebView(url: webLinks[index]),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Using regular Image.network (no need for additional packages)
                              Image.asset(
                                imageSliders[index],
                                fit: BoxFit.cover,
                              ),
                              // Gradient overlay for better text visibility
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      stops: const [0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                              // Text overlay with better positioning
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Text(
                                  imageTexts[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 3.0,
                                        color: Colors.black45,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Emergency section with improved animation
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              child: _sectionHeader("Emergency"),
            ),
            SlideInRight(
              duration: const Duration(milliseconds: 800),
              child: const Emergency(),
            ),

            // Live Safe section
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 100),
              child: _sectionHeader("Explore Live Safe"),
            ),
            SlideInRight(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 100),
              child: const LiveSafe(),
            ),

            // Safe Home section with staggered animation
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SafeHome(),
              ),
            ),

            // Basic Need section with slide animation
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 200),
              child: _sectionHeader("Basic Need"),
            ),
            SlideInRight(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: const basic_need(),
            ),

            // Games section with bounce animation
            FadeInLeft(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: _sectionHeader("Games"),
            ),
            BounceInUp(
              duration: const Duration(milliseconds: 900),
              delay: const Duration(milliseconds: 300),
              child: const Games(),
            ),
          ],
        ),
      ),
      // Simple FAB for scrolling to top
      floatingActionButton:
          _isScrolled
              ? FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController?.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              )
              : null,
    );
  }
}
