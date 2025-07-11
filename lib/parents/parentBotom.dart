import 'package:flutter/material.dart';
import 'package:sos_app/child/bottom_screens/add_contacts.dart';
import 'package:sos_app/child/bottom_screens/chat_page.dart';
import 'package:sos_app/child/bottom_screens/profile_page.dart';
import 'package:sos_app/parents/parent_home_screen.dart';
import '../child/bottom_screens/homeSceendemo.dart';

class ParentBottomPage extends StatefulWidget {
  final int initialIndex;
  const ParentBottomPage({super.key, this.initialIndex = 0});

  @override
  State<ParentBottomPage> createState() => _ParentBottomPageState();
}

class _ParentBottomPageState extends State<ParentBottomPage> {
  late int _currentIndex;

  final List<Widget> _pages = [
    HomeScreen1(),
    AddContactsPage(),
    ParentHomeScreen(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
