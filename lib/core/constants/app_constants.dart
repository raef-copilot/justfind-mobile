class AppConstants {
  static const String appName = 'JustFind';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String storageToken = 'auth_token';
  static const String storageUser = 'user_data';
  static const String storageLanguage = 'app_language';
  static const String storageTheme = 'app_theme';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxImageUpload = 5;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  
  // Image
  static const double maxImageSizeMB = 5.0;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Map
  static const double defaultZoom = 14.0;
  static const double defaultLatitude = 24.7136; // Riyadh
  static const double defaultLongitude = 46.6753;
  
  // Roles
  static const String roleAdmin = 'admin';
  static const String roleBusinessOwner = 'business_owner';
  static const String roleCustomer = 'customer';
}
