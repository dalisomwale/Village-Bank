class AppConstants {
  // Server URL - Change this to your computer's IP address
  static const String baseUrl = 'http://10.19.14.201:3000';
  // Alternatives if needed:
  // static const String baseUrl = 'http://192.168.1.100:3000'; // Your WiFi IP
  // static const String baseUrl = 'http://localhost:3000'; // For web
  // static const String baseUrl = 'http://10.0.2.2:3000'; // For Android emulator
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String profileEndpoint = '/api/users/profile';
  static const String healthEndpoint = '/api/health';
}