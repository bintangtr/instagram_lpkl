import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:instagram_lpkl/resources/auth_methods.dart';
import 'package:instagram_lpkl/resources/firestore_methods.dart';
import 'package:instagram_lpkl/resources/storage_methods.dart';
import 'package:instagram_lpkl/screens/profile_screen.dart';
import 'package:instagram_lpkl/utils/colors.dart';
import 'package:instagram_lpkl/utils/utils.dart';
import 'package:instagram_lpkl/widgets/follow_button.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  const EditProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var userData = {};
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  Uint8List? newProfilePhotoUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void selectImage() async {
    Uint8List newIm = await pickImage(ImageSource.gallery);
    if (newIm != null) {
      setState(() {
        newProfilePhotoUrl = newIm;
      });
    }
  }

  getUserData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      setState(() {
        userData = userSnap.data()!;
        usernameController.text = userSnap['username'];
        bioController.text = userSnap['bio'];
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  saveProfileChanges() async {
    setState(() {
      isLoading = true;
    });

    String newProfileImageUrl = '';
    if (newProfilePhotoUrl != null) {
      newProfileImageUrl = await StorageMethods()
          .updateProfileImage('profilePics', newProfilePhotoUrl!, true);
    }

    // Update profile image, username, and bio
    await FirestoreMethods().updateProfile(
      widget.uid,
      newProfileImageUrl,
      usernameController.text,
      bioController.text,
    );

    setState(() {
      isLoading = false;
    });

    // Navigate back to the profile page
    Navigator.of(context).pop(
      MaterialPageRoute(
        builder: (context) => ProfileScreen(uid: widget.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Edit Profile'),
        centerTitle: false,
      ),
      body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          newProfilePhotoUrl != null
                              ? CircleAvatar(
                                  radius: 80,
                                  backgroundImage:
                                      MemoryImage(newProfilePhotoUrl!),
                                )
                              : CircleAvatar(
                                  radius: 80,
                                  backgroundImage: NetworkImage(
                                    userData['photoUrl'],
                                  ),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 110,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Textfield untuk username
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                        keyboardType: TextInputType
                            .text, // Ini memaksa keyboard menjadi keyboard teks
                        onChanged: (text) {
                          // Menghapus spasi dan mengubah teks menjadi huruf kecil
                          final formattedText =
                              text.replaceAll(RegExp(r' '), '').toLowerCase();

                          usernameController.value =
                              usernameController.value.copyWith(
                            text: formattedText,
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: formattedText.length),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10),

                      // Textfield untuk bio
                      TextFormField(
                        controller: bioController,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                        ),
                      ),
                      SizedBox(height: 20),

                      InkWell(
                        onTap: saveProfileChanges,
                        child: Container(
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Text("Save"),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
