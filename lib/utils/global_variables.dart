import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_lpkl/screens/add_post_screen.dart';
import 'package:instagram_lpkl/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text("search"),
  AddPostScreen(),
  Text("notif"),
  Text("profile"),
];