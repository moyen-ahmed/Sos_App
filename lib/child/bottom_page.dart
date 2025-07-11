import 'package:flutter/material.dart';
import 'package:sos_app/child/bottom_screens/add_contacts.dart';
import 'package:sos_app/child/bottom_screens/chat_page.dart';
import 'package:sos_app/child/bottom_screens/profile_page.dart';
import 'bottom_screens/homeSceendemo.dart';

class BottomPage extends StatefulWidget {
  const BottomPage({super.key});

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen1(),
    AddContactsPage(),
    ChatPage(),
    ProfilePage(),
  ];

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Color.fromRGBO(227, 196, 196, 1.0),
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Color.fromRGBO(
                74, 37, 37, 0.9882352941176471),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),
            elevation: 15,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: const Icon(Icons.home_rounded),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Contacts',
                icon: const Icon(Icons.contacts_rounded),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.contacts_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Chats',
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Profile',
                icon: const Icon(Icons.person_rounded),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}