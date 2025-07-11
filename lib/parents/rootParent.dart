import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sos_app/widgets/home_widgets/basic_need/flushlight.dart';
import 'package:sos_app/widgets/home_widgets/custom_appBar.dart';
import 'package:sos_app/utils/quotes.dart';
import 'package:sos_app/widgets/SafeWebView.dart';
import 'package:sos_app/widgets/home_widgets/emergency.dart';
import 'package:sos_app/widgets/home_widgets/games/games.dart';
import 'package:sos_app/widgets/home_widgets/homesafe/SafeHome.dart';
import 'package:sos_app/widgets/livesafe.dart';
import 'package:animate_do/animate_do.dart';

import 'package:sos_app/child/bottom_screens/add_contacts.dart';
import 'package:sos_app/child/bottom_screens/chat_page.dart';
import 'package:sos_app/child/bottom_screens/profile_page.dart';
import 'package:sos_app/parents/parent_home_screen.dart';

import '../../widgets/home_widgets/basic_need/basic_need.dart';

class RootParentHomePage extends StatefulWidget {
  final int initialIndex;
  const RootParentHomePage({super.key, this.initialIndex = 0});

  @override
  State<RootParentHomePage> createState() => _RootParentHomePageState();
}

class _RootParentHomePageState extends State<RootParentHomePage> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _pages = [
    _HomeScreen1(),
    AddContactsPage(),
    ParentHomeScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

//---------------- HOME SCREEN ------------------//

class _HomeScreen1 extends StatefulWidget {
  @override
  State<_HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<_HomeScreen1> {
  int qIndex = 2;

  void getRandomQuote() {
    setState(() {
      qIndex = Random().nextInt(sweetSayings.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getRandomQuote();
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
            FadeInUp(
              duration: const Duration(milliseconds: 800),
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
                    )
                  ],
                ),
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    pageSnapping: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Image.network(
                              imageSliders[index],
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Emergency"),
            Emergency(),
            _buildSectionTitle("Explore Live Safe"),
            LiveSafe(),
            BounceInUp(
              duration: Duration(milliseconds: 800),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SafeHome(),
              ),
            ),
            _buildSectionTitle("Basic Need"),
            basic_need(),
            _buildSectionTitle("Games"),
            Games(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 700),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
