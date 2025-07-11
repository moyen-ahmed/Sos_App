import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';  // UI animation package
import 'package:sos_app/home_screen.dart';
import 'package:sos_app/child/child_login_screen.dart';
import 'package:sos_app/utils/color_const.dart';

import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../components/custom_textfield.dart';
import '../model/user_model.dart';

class parents_register_screen extends StatefulWidget {
  @override
  State<parents_register_screen> createState() => _parents_register_screenState();
}

class _parents_register_screenState extends State<parents_register_screen> {
  bool isPasswordShown = true;
  bool isRePasswordShown = true;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading=false;

  _onSubmit() async {
    _formKey.currentState!.save();
    if(_formData['password']!=_formData['rpassword']!) {
      alertbox(context, 'password and retype password should be equal');
    } else{
      progressIndicator(context);

      try {
        setState(() {
          isLoading=true;
        });
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email:_formData['gemail'].toString(),
            password:_formData['password'].toString()
        );
        if (userCredential.user!=null){
          final v=userCredential.user!.uid;
          DocumentReference<Map<String,dynamic>> db=

          FirebaseFirestore.instance.collection('users').doc(v);
          final user=UserModel(
            name:_formData['name'].toString(),
            phone:_formData['phone'].toString(),
            childEmail:_formData['cemail'].toString(),
            parentemail:_formData['gemail'].toString(),
            id:v,
            type: 'parent',
          );
          final jsonData=user.toJson();

          await db.set(jsonData).whenComplete(() {
            goTo(context, LoginScreen());
            setState(() {
              isLoading=false;
            });
          });
        }
      } on FirebaseAuthException catch (e) {

        setState(() {
          isLoading=false;
        });

        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          alertbox(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          alertbox(context, 'email-already-in-use');
        }
      } catch (e) {

        print(e);
        setState(() {
          isLoading=false;
        });
        alertbox(context, e.toString());
      }



    }
    print(_formData['gemail']);
    print(_formData['password']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE34141),
              Color(0xFFFB8580),
              Color(0xFF80F7FB),], // UI Updated: Background Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              isLoading?
              progressIndicator(context):
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // Animated Title and Image
                      FadeInDown( // UI Updated: Added Animation
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Are U Parents Then Register",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // UI Updated: White Text
                                ),
                              ),
                              BounceInDown( // UI Updated: Added Animation to Image
                                child: Image.asset(
                                  'assets/img_2.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Form Fields
                      Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              FadeInLeft( // UI Updated: Animation for Text Fields
                                child: CustomTextfield(
                                  hintText: 'Enter Name',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.name,
                                  prefix: Icon(Icons.person),
                                  onsave: (name) {
                                    _formData['name'] = name ?? "";
                                  },
                                  validate: (email) {
                                    if (email!.isEmpty || email.length < 3) {
                                      return 'Enter a Correct Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              FadeInLeft(
                                child: CustomTextfield(
                                  hintText: 'Enter Mobile Number',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.phone,
                                  prefix: Icon(Icons.phone),
                                  onsave: (phone) {
                                    _formData['phone'] = phone ?? "";
                                  },
                                  validate: (phone) {
                                    if (phone!.isEmpty || phone.length < 11) {
                                      return 'Enter a Correct phone Number';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              FadeInLeft(
                                child: CustomTextfield(
                                  hintText: 'Enter Child Email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  prefix: Icon(Icons.email),
                                  onsave: (cemail) {
                                    _formData['cemail'] = cemail ?? "";
                                  },
                                  validate: (cemail) {
                                    if (cemail!.isEmpty || cemail.length < 3 || !cemail.contains("@")) {
                                      return 'Enter a valid email';
                                    }
                                  },
                                ),
                              ),

                              FadeInLeft(
                                child: CustomTextfield(
                                  hintText: 'Enter email',
                                  textInputAction: TextInputAction.next,
                                  keyboardtype: TextInputType.emailAddress,
                                  prefix: Icon(Icons.email),
                                  onsave: (email) {
                                    _formData['gemail'] = email ?? "";
                                  },
                                  validate: (email) {
                                    if (email!.isEmpty || email.length < 3 || !email.contains("@")) {
                                      return 'Enter a valid email';
                                    }
                                  },
                                ),
                              ),

                              FadeInLeft(
                                child: CustomTextfield(
                                  hintText: 'Enter password',
                                  isPassword: isPasswordShown,
                                  prefix: Icon(Icons.vpn_key_rounded),
                                  validate: (password) {
                                    if (password!.isEmpty || password.length < 4) {
                                      // return 'Enter a valid password';
                                      alertbox(context,'Enter a strong  password');
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
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                              ),

                              FadeInLeft(
                                child: CustomTextfield(
                                  hintText: 'Retype password',
                                  isPassword: isRePasswordShown,
                                  prefix: Icon(Icons.vpn_key_rounded),
                                  validate: (password) {
                                    if (password!.isEmpty || password.length < 4) {
                                      return 'Enter a valid password';
                                    }
                                    return null;
                                  },
                                  onsave: (password) {
                                    _formData['rpassword'] = password ?? "";
                                  },
                                  suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                       isRePasswordShown= !isRePasswordShown;
                                      });
                                    },
                                    icon: isRePasswordShown
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20), // UI Updated: Space Added

                      // Buttons
                      FadeInUp( // UI Updated: Animation for Buttons
                        child: PrimaryButton(
                          title: "Register",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _onSubmit();
                            }
                            print("Register Button Pressed");
                          },
                        ),
                      ),

                      FadeInUp(
                        child: SecondaryButton(
                          title: "Login your account",
                          onPressed: () {
                            goTo(context, LoginScreen());
                          },
                        ),
                      ),
                    ],
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
