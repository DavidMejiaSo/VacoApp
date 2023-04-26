class Env {
  static const String _env = 'prod';
  static final Map _dev = {"serverUrl": "https://app.vacofood.com:8080"};
  static final Map _prod = {"serverUrl": "https://app.vacofood.com:8080"};
  static get currentEnv => _env == 'env' ? _dev : _prod;
}
