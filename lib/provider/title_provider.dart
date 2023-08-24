import 'package:flutter/foundation.dart';

class TitleProvider extends ChangeNotifier {
  String _title = '';

  String get title => _title;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}