import 'package:flutter/foundation.dart';

class AuthRefreshService extends ChangeNotifier {

  void logout() {
    notifyListeners();
  }

}