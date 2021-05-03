import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentPage = 0;
  bool _showMore = false;

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    showMore = false;
    notifyListeners();
  }

  bool get showMore => _showMore;

  set showMore(bool value) {
    _showMore = value;
    notifyListeners();
  }
}
