import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/child/bottom_page.dart';
import 'package:sos_app/child/bottom_screens/homeSceendemo.dart';
import 'package:sos_app/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_app/child/child_login_screen.dart';
import 'package:sos_app/parents/parentBotom.dart';
import 'package:sos_app/parents/parent_home_screen.dart';
import 'package:sos_app/parents/rootParent.dart';
import 'package:sos_app/utils/color_const.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'db/sharepreferench.dart';

void main() async {
  // This preserves the splash screen until initialization is complete
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize SharedPreferences
  await MySharedPrefference.init();

  // Remove splash screen after initialization is complete
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red), // Changed to red for SOS app
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: MySharedPrefference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // Show loading indicator while waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            }

            // Navigate based on user type
            if (snapshot.data == "") {
              return LoginScreen();
            }
            if (snapshot.data == "child") {
              return BottomPage();
            }
            if (snapshot.data == "parent") {
              return ParentHomeScreen();
            }

            // Fallback loading indicator
            return progressIndicator(context);
          }
      ),
    );
  }
}

// Helper function for showing a progress indicator
Widget progressIndicator(BuildContext context) {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.red,
    ),
  );
}