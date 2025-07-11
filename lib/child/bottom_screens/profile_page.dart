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
import 'package:uuid/uuid.dart';

import '../bottom_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  String? id;
  String? phone;
  String? profilePic;
  String? downloadUrl;
  String? userType; // 'parent' or 'child'
  bool isSaving = false;
  final key = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  // Color scheme for professional UI
  final Color primaryColor = Color(0xFF3F51B5); // Indigo
  final Color accentColor = Color(0xFF536DFE);  // Light Blue
  final Color backgroundColor = Color(0xFFF5F5F5); // Light Grey
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF212121); // Dark Grey

  // BACKEND FUNCTIONALITY - NOT MODIFIED
  Future<void> getName() async {
    try {
      if (auth.currentUser != null) {
        final snapshot = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            nameC.text = snapshot.data()?['name'] ?? '';
            // profilePic = snapshot.data()?['profilePic'];
            phone = snapshot.data()?['phone'];
            userType = snapshot.data()?['type'];
            id = snapshot.id;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: ${e.toString()}");
    }
  }

  // BACKEND FUNCTIONALITY - NOT MODIFIED
  Future<String> saveImageLocally(String sourcePath) async {
    try {
      // Get local app directory
      final directory = await getApplicationDocumentsDirectory();
      final userId = auth.currentUser!.uid;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final newFileName = '${userId}_$timestamp${path.extension(sourcePath)}';

      // Create destination path
      final destinationPath = path.join(directory.path, newFileName);

      // Copy file to app directory
      final File sourceFile = File(sourcePath);
      final File localFile = await sourceFile.copy(destinationPath);

      // Save path to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profilePicPath', destinationPath);

      return destinationPath;
    } catch (e) {
      debugPrint("Error saving image locally: $e");
      Fluttertoast.showToast(msg: "Failed to save image: $e");
      throw e;
    }
  }

  // BACKEND FUNCTIONALITY - NOT MODIFIED
  Future<void> getLocalProfilePic() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localPath = prefs.getString('profilePicPath');

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
    getName();
    getLocalProfilePic(); // Load local profile pic
  }

  // UPDATED UI: Professional loading indicator
  Widget progressIndicator(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
      strokeWidth: 3.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // Adding a subtle shadow effect to AppBar
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // UPDATED UI: Profile header with avatar
              Container(
                width: double.infinity,
                color: primaryColor,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // UPDATED UI: Profile picture with improved styling
                    GestureDetector(
                      onTap: () async {
                        try {
                          final XFile? pickImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80, // Higher quality image
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
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: profilePic == null
                                ? CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 55,
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[400],
                              ),
                            )
                                : CircleAvatar(
                              radius: 55,
                              backgroundImage: FileImage(File(profilePic!)),
                            ),
                          ),
                          // UPDATED UI: Camera icon for better UX
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
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
                    SizedBox(height: 20),
                  ],
                ),
              ),

              // UPDATED UI: Profile form with card style
              Container(
                transform: Matrix4.translationValues(0, -20, 0),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // UPDATED UI: Section title with professional style
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Divider(height: 30),

                          // UPDATED UI: Form fields with better styling
                          Text(
                            "Full Name",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          // NOTE: Using original CustomTextfield but with different styling
                          CustomTextfield(
                            controller: nameC,
                            hintText: "Enter your name",
                            validate: (v) {
                              if (v!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),

                          // UPDATED UI: Phone number display with cleaner style
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              phone ?? "Not provided",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),

                          // UPDATED UI: Save button with better styling
                          isSaving
                              ? Center(child: progressIndicator(context))
                              : SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              title: "SAVE CHANGES",
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                                  if (profilePic == null) {
                                    Fluttertoast.showToast(
                                      msg: 'Please select a profile picture',
                                    );
                                  } else {
                                    updateProfile();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // UPDATED UI: Sign out card
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Options",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Divider(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.logout, color: Colors.white),
                          label: Text(
                            "SIGN OUT",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE53935), // Red color for signout
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
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
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // UPDATED UI: Related contacts section (parents/children)
              if (userType != null)
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userType == 'child' ? "My Guardians" : "My Children",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Divider(height: 30),
                        Container(
                          height: 200, // Fixed height for the list
                          child: userType == 'child'
                              ? _buildParentsList()
                              : _buildChildrenList(),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // UPDATED UI: Improved parents list
  Widget _buildParentsList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('type', isEqualTo: 'parent')
          .where('childEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
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
                Icon(Icons.people_outline, size: 40, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No guardians found',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // UPDATED UI: Show list of guardians with better styling
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final d = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Card(
                elevation: 0,
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.blue[200]!, width: 1),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    d['name'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Guardian",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // UPDATED UI: Improved children list
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
                Icon(Icons.child_care, size: 40, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No children found',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // UPDATED UI: Show list of children with better styling
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            final d = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Card(
                elevation: 0,
                color: Colors.pink[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.pink[200]!, width: 1),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.pink[400],
                    child: Icon(Icons.child_care, color: Colors.white),
                  ),
                  title: Text(
                    d['name'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    "Child",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // BACKEND FUNCTIONALITY - NOT MODIFIED
  Future<void> updateProfile() async {
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
      };

      // Save image locally instead of uploading to Firebase
      if (profilePic != null) {
        final localPath = await saveImageLocally(profilePic!);
        // We're not adding profilePic to userData as we'll use local storage
      }

      // Update user data in Firestore
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update(userData);

      Fluttertoast.showToast(msg: "Profile updated successfully");

      // Navigate to bottom page
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomPage())
        );
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