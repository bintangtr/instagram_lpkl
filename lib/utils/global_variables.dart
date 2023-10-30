import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_lpkl/screens/add_post_screen.dart';
import 'package:instagram_lpkl/screens/feed_screen.dart';
import 'package:instagram_lpkl/screens/profile_screen.dart';
import 'package:instagram_lpkl/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text("notif"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];