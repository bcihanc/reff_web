import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BusyState extends ChangeNotifier {
  bool _isBusy = false;
  get isBusy => this._isBusy;
  busy() {
    _isBusy = true;
    notifyListeners();
  }

  notBusy() {
    _isBusy = false;
    notifyListeners();
  }
}

final busyStateProvider = ChangeNotifierProvider((_) => BusyState());
