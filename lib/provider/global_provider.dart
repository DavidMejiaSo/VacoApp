import 'package:flutter/material.dart';

class GlobalProvider with ChangeNotifier {
  bool _esPublicidad = true;

  bool get esPublicidad => _esPublicidad;

  set esPublicidad(bool valor) {
    _esPublicidad = valor;
    notifyListeners();
  }
}