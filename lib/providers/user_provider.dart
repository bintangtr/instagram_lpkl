import 'package:flutter/material.dart';
import 'package:instagram_lpkl/models/user.dart';
import 'package:instagram_lpkl/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

// if (res != 'success') {
//       showSnackBar(res, context);
//     } else {
//       Navigator.of(context).pop();
//     }

// Container(
//                     child: isLoading
//                         ? Center(
//                             child: CircularProgressIndicator(
//                               color: primaryColor,
//                             ),
//                           )
//                         : const Text("Save"),
//                     width: double.infinity,
//                     alignment: Alignment.center,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     decoration: const ShapeDecoration(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(4),
//                         ),
//                       ),
//                       color: blueColor,
//                     ),
//                   ),