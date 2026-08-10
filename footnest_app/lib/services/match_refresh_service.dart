import 'package:flutter/foundation.dart';

class MatchRefreshService extends ChangeNotifier {

  void refresh() {
    notifyListeners();
  }

}