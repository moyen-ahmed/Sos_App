import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PoliceEmergency extends StatelessWidget {
  _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  const PoliceEmergency({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the available height for the card from the container constraints
    final availableHeight = 180.0; // This should match your container height

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => _callNumber('999'),
          child: Container(
            height: availableHeight,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFD8080),
                  Color(0xFFFB8580),
                  Color(0xFFFBD079),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Important: Use minimum space
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar at the top
                  CircleAvatar(
                    radius: 22, // Slightly smaller
                    backgroundColor: Colors.white.withOpacity(.8),
                    child: Image.asset('assets/alert.png'),
                  ),

                  const Spacer(flex: 1), // Flexible space

                  // Main text
                  Text(
                    'Active Emergency',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05, // Smaller font
                    ),
                  ),

                  const SizedBox(height: 4), // Smaller fixed space

                  // Subtitle
                  Text(
                    'Call 999 for emergency',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.025, // Smaller font
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(flex: 1), // Flexible space

                  // Bottom container with emergency number
                  Container(
                    height: 28, // Slightly smaller
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '999',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.03, // Smaller font
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}