import 'package:flutter/material.dart';

/*
  Designed for fixing the varying endpoint problem,
  caused by varying ip of the host computer.
*/

class EndPoint with ChangeNotifier {
  String endpoint = 'http://192.168.1.39:3000/event_planner/api/category';

  // sets new enpoint
  void setEndpoint(String endpoint) {
    this.endpoint = 'http://' + endpoint + ':3000/event_planner/api/category';
    notifyListeners();
  }
}
