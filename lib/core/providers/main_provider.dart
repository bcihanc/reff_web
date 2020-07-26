import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  bool isBusy;

  MainProvider() {
    isBusy = false;
  }

  busy() {
    isBusy = true;
    notifyListeners();
  }

  notBusy() {
    isBusy = false;
    notifyListeners();
  }
}
