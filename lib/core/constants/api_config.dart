class ApiConfig {
  // Base URL
  //static const String baseUrl = 'http://192.168.18.14:3000/api';
  static const String baseUrl = 'http://api.eazysupplies.com/api';

  // Endpoints
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/categories';
  static const String login = '$baseUrl/auth/login';

  // Timeouts
  static const Duration timeout = Duration(seconds: 10);
}
