import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // For animations
import 'package:sos_app/child/Registerchild.dart';
import 'package:sos_app/child/bottom_page.dart';
import 'package:sos_app/utils/color_const.dart';
import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../components/custom_textfield.dart';
import '../db/sharepreferench.dart';
import '../parents/parent_home_screen.dart';
import '../parents/parents_register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  // Improved error dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Error', style: TextStyle(color: Colors.red[700])),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(color: Color(0xFF5F8E85))),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _formData['email'].toString(),
        password: _formData['password'].toString(),
      );

      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        FirebaseFirestore.instance.collection('users')
            .doc(userCredential.user!.uid)
            .get()
            .then((value) {
          if(value['type'] == 'parent'){
            print(value['type']);
            MySharedPrefference.saveUserType('parent');
            goTo(context, ParentHomeScreen());
          } else{
            MySharedPrefference.saveUserType('child');
            goTo(context, BottomPage());
          }
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          showErrorDialog('Error loading user data. Please try again.');
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email. Please register first.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;

        default:
          errorMessage = 'Authentication error: ${e.message}';
          break;
      }

      // Show the improved error dialog
      showErrorDialog(errorMessage);
      print('Login error: ${e.code} - ${e.message}');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('An unexpected error occurred. Please try again.');
      print('Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE4D25E),
              Color(0xFFFB8580),
              Color(0xFF5F8E85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),

                      // Title with animation
                      FadeInDown(
                        duration: Duration(milliseconds: 800),
                        child: Text(
                          "WELCOME BACK",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Login Image with animation
                      FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/sos_icon.png',
                            height: 130,
                            width: 130,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Form Fields in a Card for better visual separation
                      FadeIn(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Form title
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(height: 20),

                                // Email Field with animation
                                FadeInLeft(
                                  duration: Duration(milliseconds: 1000),
                                  child: CustomTextfield(
                                    hintText: 'Email Address',
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: Icon(Icons.email_rounded, color: Colors.white),
                                    onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          !email.contains("@") ||
                                          !email.contains(".")) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                SizedBox(height: 15),

                                // Password Field with animation
                                FadeInRight(
                                  duration: Duration(milliseconds: 1000),
                                  child: CustomTextfield(
                                    hintText: 'Password',
                                    isPassword: isPasswordShown,
                                    prefix: Icon(Icons.lock_rounded, color: Colors.white),
                                    validate: (password) {
                                      if (password!.isEmpty || password.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                    suffix: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordShown = !isPasswordShown;
                                        });
                                      },
                                      icon: isPasswordShown
                                          ? Icon(Icons.visibility_off, color: Colors.white70)
                                          : Icon(Icons.visibility, color: Colors.white),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),

                                // Forgot Password aligned to the right
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FadeIn(
                                    duration: Duration(milliseconds: 1200),
                                    child: TextButton(
                                      onPressed: () {
                                        // Forgot password action
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(50, 30),
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 25),

                                // Login Button with animation
                                FadeInUp(
                                  duration: Duration(milliseconds: 1000),
                                  child: Opacity(
                                    opacity: isLoading ? 0.5 : 1.0,
                                    child: PrimaryButton(
                                      title: isLoading ? "SIGNING IN..." : "LOGIN",
                                      onPressed: () {
                                        if (!isLoading) {
                                          _onSubmit();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Register options
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Column(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 15),

                            // Register as child button
                            OutlinedButton(
                              onPressed: () {
                                goTo(context, Registerchild());
                              },
                              child: Text(
                                "Register as Child",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                            ),

                            SizedBox(height: 15),

                            // Register as parent button
                            OutlinedButton(
                              onPressed: () {
                                goTo(context, parents_register_screen());
                              },
                              child: Text(
                                "Register as Parent",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Loading overlay
              if (isLoading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5F8E85)),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Signing in...",
                            style: TextStyle(
                              color: Color(0xFF5F8E85),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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