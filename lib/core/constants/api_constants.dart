class ApiConstants {
  // Base URL - Change for production
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator
  // static const String baseUrl = 'http://localhost:3000'; // iOS simulator
  // static const String baseUrl = 'https://api.justfind.com'; // Production
  
  static const String apiVersion = '/api';
  
  // Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String me = '$auth/me';
  
  static const String businesses = '/businesses';
  static const String myBusinesses = '$businesses/my/businesses';
  static const String categories = '/categories';
  static const String reviews = '$businesses/reviews';
  static const String favorites = '$businesses/favorites';
  
  static const String admin = '/admin';
  static const String adminBusinesses = '$admin/businesses';
  static const String adminReviews = '$admin/reviews';
  static const String adminStats = '$admin/stats';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
