import 'package:flutter/foundation.dart';

class TeamRefreshService extends ChangeNotifier {

  void refresh() {
    notifyListeners();
  }

}