import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService with ChangeNotifier {
  bool isConnectedToInternet = false;

  bool get getInternetConnectionStatus {
    return isConnectedToInternet;
  }

  StreamSubscription? _internetConnectionStreamSubscription;

  ConnectivityService() {
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((status) {
      isConnectedToInternet = (status == InternetStatus.connected);
      notifyListeners();
    });
  }

  @override
  void dispose() {
   _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }
}
