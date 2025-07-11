import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:sos_app/child/child_login_screen.dart';
import 'package:sos_app/components/PrimaryButton.dart';
import 'package:sos_app/components/custom_textfield.dart';
import 'package:sos_app/utils/color_const.dart';

import '../parents/parentBotom.dart'; // Update with correct parent navigation path

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({super.key});

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController(); // Added email controller
  String? id;
  String? phone;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;
  final key = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> getParentData() async {
    try {
      if (auth.currentUser != null) {
        final snapshot = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            nameC.text = snapshot.data()?['name'] ?? '';
            emailC.text = auth.currentUser!.email ?? '';
            phone = snapshot.data()?['phone'];
            id = snapshot.id;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching parent data: ${e.toString()}");
    }
  }

  // Method to save image locally
  Future<String> saveImageLocally(String sourcePath) async {
    try {
      // Get local app directory
      final directory = await getApplicationDocumentsDirectory();
      final userId = auth.currentUser!.uid;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final newFileName = 'parent_${userId}_$timestamp${path.extension(sourcePath)}';

      // Create destination path
      final destinationPath = path.join(directory.path, newFileName);

      // Copy file to app directory
      final File sourceFile = File(sourcePath);
      final File localFile = await sourceFile.copy(destinationPath);

      // Save path to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('parentProfilePicPath', destinationPath);

      return destinationPath;
    } catch (e) {
      debugPrint("Error saving image locally: $e");
      Fluttertoast.showToast(msg: "Failed to save image: $e");
      throw e;
    }
  }

  // Method to get local profile picture path
  Future<void> getLocalProfilePic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localPath = prefs.getString('parentProfilePicPath');

      if (localPath != null) {
        final file = File(localPath);
        if (await file.exists()) {
          setState(() {
            profilePic = localPath;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading local profile: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getParentData();
    getLocalProfilePic();
  }

  Widget progressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parent Profile"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Personal profile section
                Form(
                  key: key,
                  child: Column(
                    children: [
                      Text(
                          "Parent Profile Settings",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink[800]
                          )
                      ),
                      SizedBox(height: 30),

                      // Profile Picture
                      GestureDetector(
                        onTap: () async {
                          try {
                            final XFile? pickImage = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 50,
                            );
                            if (pickImage != null) {
                              setState(() {
                                profilePic = pickImage.path;
                              });
                            }
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Image selection failed: ${e.toString()}");
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.pink, width: 2),
                              ),
                              child: profilePic == null
                                  ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 65,
                                child: Image.asset('assets/profile.png'),
                              )
                                  : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 65,
                                backgroundImage: FileImage(File(profilePic!)),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Name Field
                      CustomTextfield(
                        controller: nameC,
                        hintText: "Your Name",
                        validate: (v) {
                          if (v!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Email Field (read-only)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Address",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              emailC.text.isEmpty ? "Not provided" : emailC.text,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Phone Number
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              phone ?? "Not provided",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Update Button
                      isSaving
                          ? Center(child: CircularProgressIndicator(color: Colors.pink))
                          : PrimaryButton(
                        title: "UPDATE PROFILE",
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            SystemChannels.textInput.invokeMethod('TextInput.hide');

                            if (profilePic == null) {
                              Fluttertoast.showToast(
                                msg: 'Please select a profile picture',
                              );
                            } else {
                              updateParentProfile();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
                Divider(thickness: 1.5, color: Colors.grey[300]),
                SizedBox(height: 20),

                // Connected Children Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Connected Children",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[800]
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 200, // Fixed height for the list
                      child: _buildChildrenList(),
                    ),
                  ],
                ),

                SizedBox(height: 30),
                Divider(thickness: 1.5, color: Colors.grey[300]),
                SizedBox(height: 20),

                // Sign Out Button
                PrimaryButton(
                  title: "SIGN OUT",
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (route) => false,
                        );
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: "Sign out failed: ${e.toString()}");
                    }
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildrenList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'child')
          .where('parentemail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        // Show loading indicator when waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: progressIndicator(context));
        }

        // Handle error state
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Handle empty data
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.child_care, size: 50, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'No children connected yet',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // Show list of children when data is available
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final d = snapshot.data!.docs[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: Colors.pink[100],
                  child: Icon(Icons.child_care, color: Colors.pink),
                ),
                title: Text(
                  d['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              ),
            );
          },
        );
      },
    );
  }

  // Update parent profile
  Future<void> updateParentProfile() async {
    if (auth.currentUser == null) {
      Fluttertoast.showToast(msg: "User not authenticated");
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final userData = <String, dynamic>{
        'name': nameC.text,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Save image locally
      if (profilePic != null) {
        await saveImageLocally(profilePic!);
      }

      // Update user data in Firestore
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update(userData);

      Fluttertoast.showToast(msg: "Profile updated successfully");

      // Navigate back to parent home screen
      if (mounted) {
        Navigator.pop(context); // This will return to the previous screen
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Update failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }
}