import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sos_app/widgets/home_widgets/basic_need/translator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Compass.dart';
import 'ServicesPage.dart';
import 'firstaidguide.dart';  // This should import the full FirstAidGuide page
import 'flushlight.dart';

class basic_need extends StatelessWidget {
  const basic_need({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          // First Aid Guide Icon Button
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // Navigate to the FirstAidGuide page when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstAidGuide()),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Icon(
                          Icons.medical_services_outlined,  // First aid icon
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Text('First Aid')
              ],
            ),
          ),
          // Add your other items like flashlight, compass, etc.
          flashlight(),
          // Compass(),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CompassScreen()),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Image.asset(
                          'assets/Compass-1.png',  // Replace with your emergency services icon
                          height: 70,
                        ),
                        // If you don't have an image asset, you can use an icon instead:
                        // child: Icon(
                        //   Icons.emergency,  // Emergency icon
                        //   color: Colors.orange,
                        //   size: 30,
                        // ),
                      ),
                    ),
                  ),
                ),
                Text('Compass')
              ],
            ),
          ),

          // Emergency Services Page Icon Button
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServicesPage()),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Image.asset(
                          'assets/service.png',  // Replace with your emergency services icon
                          height: 70,
                        ),
                        // If you don't have an image asset, you can use an icon instead:
                        // child: Icon(
                        //   Icons.emergency,  // Emergency icon
                        //   color: Colors.orange,
                        //   size: 30,
                        // ),
                      ),
                    ),
                  ),
                ),
                Text('Services')
              ],
            ),
          ),

          // Proper formatting for the translator button to match others
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EnglishToBanglaTranslator()),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Icon(
                          Icons.translate,  // Translate icon
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Text('Translator')
              ],
            ),
          ),
        ],
      ),
    );
  }
}