import 'package:flutter/foundation.dart';

class ProfileRefreshService extends ChangeNotifier {

  void refresh() {
    notifyListeners();
  }

}