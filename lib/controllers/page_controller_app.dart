import 'package:flutter/cupertino.dart';

class PageControllerApp extends ChangeNotifier {
  double _index = 0.0;

  setIndex(value) {
    this._index = value;
    notifyListeners();
  }

  get index => this._index;
}
