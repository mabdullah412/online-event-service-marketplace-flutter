import 'package:flutter/material.dart';

/*
  Designed for fixing the varying endpoint problem,
  caused by varying ip of the host computer.
*/

class EndPoint with ChangeNotifier {
  String endpoint = 'http://{target}:3000/event_planner/';
  String imageEndpoint = 'http://{target}:3000/images/';

  // * sets new enpoint
  void setEndpoint(String target) {
    endpoint = 'http://' + target + ':3000/event_planner/';
    imageEndpoint = 'http://' + target + ':3000/images/';
    notifyListeners();
  }
}
