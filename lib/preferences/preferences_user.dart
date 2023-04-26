import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario.internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario.internal();

  late SharedPreferences _prefs;

  iniciarPreferencias() async {
    _prefs = await SharedPreferences.getInstance();
  }

  limpiar() async {
    _prefs.clear();
  }

  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String valor) {
    _prefs.setString('token', valor);
  }

  String get usuario {
    return _prefs.getString('usuario') ?? '';
  }

  set usuario(String valor) {
    _prefs.setString('usuario', valor);
  }

  String get tipoLogin {
    return _prefs.getString('tipoLogin') ?? '';
  }

  set tipoLogin(String valor) {
    _prefs.setString('tipoLogin', valor);
  }

  String get defaultLocation {
    return _prefs.getString('defaultLocation') ?? '';
  }

  set defaultLocation(String valor) {
    _prefs.setString('defaultLocation', valor);
  }

  double get latitud {
    return _prefs.getDouble('latitud') ?? 0.0;
  }

  set latitud(double valor) {
    _prefs.setDouble('latitud', valor);
  }

  double get longitud {
    return _prefs.getDouble('longitud') ?? 0.0;
  }

  set longitud(double valor) {
    _prefs.setDouble('longitud', valor);
  }

  String get password {
    return _prefs.getString('password') ?? '';
  }

  set password(String valor) {
    _prefs.setString('password', valor);
  }

  String get email {
    return _prefs.getString('email') ?? '';
  }

  set email(String valor) {
    _prefs.setString('email', valor);
  }

  bool get check {
    return _prefs.getBool('check') ?? false;
  }

  set check(bool valor) {
    _prefs.setBool('check', valor);
  }

  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario(String valor) {
    _prefs.setString('nombreUsuario', valor);
  }

  List<String> get restaurantFavorite {
    return _prefs.getStringList('restaurantFavorite') ?? [];
  }

  set restaurantFavorite(List<String> valor) {
    _prefs.setStringList('restaurantFavorite', valor);
  }

  String get idOrden {
    return _prefs.getString('idOrden') ?? '0';
  }

  set idOrden(String valor) {
    _prefs.setString('idOrden', valor);
  }
}
