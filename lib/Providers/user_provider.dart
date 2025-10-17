import 'package:eventlyapp/model/myUser.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Myuser? currentUser;


  void updateUser(Myuser user) {
    currentUser = user;
    notifyListeners();

  }
}