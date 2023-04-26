class EnvPayU {
  static const String _dev =
      'https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi';

  static get dev => _dev;

  static const String _prod =
      'https://api.payulatam.com/payments-api/4.0/service.cgi';

  static get prod => _prod;
}
