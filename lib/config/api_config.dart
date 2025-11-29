/// API Configuration
/// Contains all API-related configuration and endpoints
class ApiConfig {
  /// Base URL for the FinAI backend API
  /// Local development server - use PC's IP for real phone
  static const String baseUrl = 'http://10.133.60.119:8000';

  /// API endpoints
  static const String generateEndpoint = '/generate';

  /// Full URL for the generate endpoint
  static String get generateUrl => '$baseUrl$generateEndpoint';

  /// API timeout duration - increased for Gemini Pro model
  static const Duration timeout = Duration(seconds: 90);

  /// Request headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
