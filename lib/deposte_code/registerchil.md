import 'package:flutter/material.dart';
import 'package:sos_app/home_screen.dart';
import 'package:sos_app/login_screen.dart';
import 'package:sos_app/utils/color_const.dart';

import 'components/PrimaryButton.dart';
import 'components/SecondaryButton.dart';
import 'components/custom_textfield.dart';

class Registerchild extends StatefulWidget {
@override
State<Registerchild> createState() => _RegisterchildState();
}

class _RegisterchildState extends State<Registerchild> {
bool isPasswordShown = true;

final _formKey = GlobalKey<FormState>();
final _formData = Map<String, Object>();

_onSubmit() {
_formKey.currentState!.save();
print(_formData['email']);
print(_formData['password']);
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: SingleChildScrollView(
// FIXED: Wrapped in SingleChildScrollView
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 10),
child: SingleChildScrollView(
child: Column(
children: [
Container(
height: MediaQuery.of(context).size.height * 0.3,
child: Column(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
Text(
"Are U Child Then Register",
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 25,
fontWeight: FontWeight.bold,
color: Colors.deepPurpleAccent,
),
),
Image.asset('assets/registration.png', height: 100, width: 100),
],
),
),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                           // take name
                          CustomTextfield(
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
                           // take phone number
                          CustomTextfield(
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
                          // take Gurdian email
                          CustomTextfield(
                            hintText: 'Enter Gurdain Email',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.email),
                            onsave: (gemail) {
                              _formData['gemail'] = gemail ?? "";
                            },
                            validate: (gemail) {
                              if (gemail!.isEmpty ||
                                  gemail.length < 3 ||
                                  !gemail.contains("@")) {
                                return 'Enter a valid email';
                              }
                            },
                          ),
                          // take email
                          CustomTextfield(
                            hintText: 'Enter email',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.email),
                            onsave: (email) {
                              _formData['email'] = email ?? "";
                            },
                            validate: (email) {
                              if (email!.isEmpty ||
                                  email.length < 3 ||
                                  !email.contains("@")) {
                                return 'Enter a valid email';
                              }
                            },
                          ),
              //take password
                          CustomTextfield(
                            hintText: 'Enter password',
                            isPassword: isPasswordShown,
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty || password.length < 4) {
                                return 'Enter a valid password';
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
                              icon:
                                  isPasswordShown
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                            ),
                          ),
              // retype password
                          CustomTextfield(
                            hintText: 'Retype password',
                            isPassword: isPasswordShown,
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty || password.length < 4) {
                                return 'Enter a valid password';
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
                              icon:
                              isPasswordShown
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20), // Added space

                  PrimaryButton(
                    title: "Regiter",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onSubmit();
                      }
                      print("Login Button Pressed");
                    },
                  ),

                  SecondaryButton(
                    title: "Login your account",
                    onPressed: () {
                      goTo(context,LoginScreen());
                    },
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
