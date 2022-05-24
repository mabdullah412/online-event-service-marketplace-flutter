import 'package:flutter/material.dart';

/*
  User modes are Buyer, Seller
  used to check, if buyer or seller widgets are to be shown
*/

class UserMode with ChangeNotifier {
  bool sellerMode = false;

  void toggleUserMode() {
    sellerMode = !sellerMode;
    notifyListeners();
  }
}
