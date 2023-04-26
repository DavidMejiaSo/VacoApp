import 'package:flutter/material.dart';

class NotificationListenProvider with ChangeNotifier {
  bool _notificationNew = false;

  bool get notificationNew => _notificationNew;

  set notificationNew(bool valor) {
    _notificationNew = valor;
    notifyListeners();
  }
}
