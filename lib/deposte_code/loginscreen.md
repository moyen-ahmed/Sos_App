import 'package:flutter/material.dart';
import 'components/PrimaryButton.dart';

import 'components/SecondaryButton.dart';
import 'components/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//const LoginScreen({super.key});
bool isPasswordShown = true;
final _formKey=GlobalKey<FormState>();
final _formData=Map<String,Object>();
_onSubmit() {
_formKey.currentState!.save();
print(_formData['email']);
print(_formData['password']);
}
@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Padding(
padding: const EdgeInsets.all(8.0),
child: SingleChildScrollView(
child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                // Title
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "USER LOGIN",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      Image.asset(
                        'assets/login.png',
                        height: 150,
                        width: 160,
                      ),
                  
                    ],
                  ),
                ),
            
                // Image
            
                // Username Field
                Container(
                  height: MediaQuery.of(context).size.height*0.4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomTextfield(
                          hintText: 'Enter email',
                          textInputAction: TextInputAction.next,
                          keyboardtype: TextInputType.emailAddress,
                          prefix: Icon(Icons.person),
                          onsave: (email) {
                            _formData['email'] = email ?? "";
                          },
                          validate: (email) {
                            if (email!.isEmpty ||
                                email.length < 3 ||
                                !email.contains("@")) {
                              return 'enter correct email';
                            }
                            return null;
                          },
                        ),
                    
                        // Password Field
                        CustomTextfield(
                          hintText: 'Enter password',
                          isPassword: isPasswordShown,
                          prefix: Icon(Icons.vpn_key_rounded),
                          validate: (password) {
                            if (password!.isEmpty ||
                                password.length < 4) {
                              return 'enter correct password';
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
                                  : Icon(Icons.visibility)),
                        ),
                    
                      ],
                    ),
                  ),
                ),
            
            
                // Login Button (Fixed)
                PrimaryButton(
                  title: "Login",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onSubmit();
                    }
                    print("Login Button Pressed");
                  },
            
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 18,
                        color: Colors.black),
                      ),
                        SecondaryButton(title: "Click here !",
                        onPressed: () {}
                      ),
                    ],
                  ),
                ),
                SecondaryButton(title: "Resgister new user",
                    onPressed: () {}
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
}
