import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  LatLng _ubicacionDot = const LatLng(0, 0);

  LatLng get ubicacionDot => _ubicacionDot;

  set ubicacionDot(LatLng valor) {
    _ubicacionDot = valor;
    notifyListeners();
  }
}
