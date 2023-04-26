import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoLocationProvider with ChangeNotifier {
  Map _infoUbicacion = {};

  Map get infoUbicacion => _infoUbicacion;

  set infoUbicacion(valor) {
    _infoUbicacion = valor;
    notifyListeners();
  }
}
