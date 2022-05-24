import 'package:flutter/material.dart';

/*
  Designed for fixing the varying endpoint problem,
  caused by varying ip of the host computer.
*/

class EndPoint with ChangeNotifier {
  String endpoint = 'http://192.168.94.84:3000/event_planner/api/';

  // * sets new enpoint
  void setEndpoint(String target) {
    endpoint = 'http://' + target + ':3000/event_planner/api/';
    notifyListeners();
  }
}
