abstract class AppConstants {
  static const String APP_API_VERSION = '1.0.0';

  // Error Messages
  static const String ERROR_MESSAGE =
      'Something went wrong, Please try again later';

  // Contact Details (placeholders)
  static const String CONTACT_EMAIL = 'support@example.com';
  static const String CONTACT_PHONE = '+0000000000';
  static const String CONTACT_PHONE_DISPLAY = '+00 00000 00000';
  static const String CONTACT_WHATSAPP_URL = 'https://wa.me/0000000000';

  // Social Media Links (placeholders)
  static const String FACEBOOK_PROFILE = 'https://www.facebook.com/yourpage';
  static const String TWITTER_PROFILE = 'https://twitter.com/yourprofile';
  static const String INSTAGRAM_PROFILE =
      'https://www.instagram.com/yourprofile';
  static const String YOUTUBE_PROFILE = 'https://www.youtube.com/yourchannel';

  static const String TERMS_AND_CONDITIONS_URL = 'https://example.com/terms';
  static const String PRIVACY_POLICY_URL = 'https://example.com/privacy';

  // Tech Contact Details (placeholders)
  static const String TECH_CONTACT_PHONE_DISPLAY = '+1-000-000-0000';
  static const String TECH_CONTACT_WHATSAPP = 'https://wa.me/10000000000';
  // Apps Page (placeholder)
  static const String APPS_PAGE_URL = 'https://example.com/apps';

  // UI Constants
  static const double MAX_CONTENT_WIDTH = 1024.0;

  // Authentication token and headers
  static String? BEARER_TOKEN;
  static Map<String, String> API_HEADER = {
    'x-app-version': APP_API_VERSION,
    'Content-Type': 'application/json',
  };

  static void updateTokens(String? bearer) {
    BEARER_TOKEN = bearer;
    API_HEADER = {
      'x-app-version': APP_API_VERSION,
      'Content-Type': 'application/json',
      if (BEARER_TOKEN != null) 'Authorization': 'Bearer $BEARER_TOKEN',
    };
  }

  static void clearTokens() {
    BEARER_TOKEN = null;
    API_HEADER.remove('Authorization');
  }

  // Return a fresh copy of API headers including Authorization when present.
  static Map<String, String> getApiHeaders() {
    final headers = <String, String>{
      'x-app-version': APP_API_VERSION,
      'Content-Type': 'application/json',
    };
    if (BEARER_TOKEN != null) headers['Authorization'] = 'Bearer $BEARER_TOKEN';
    return headers;
  }

  // Prevent instantiation and make it a singleton
  AppConstants._();
}

class ApiEndpoints {
  // Default host — change at runtime with [setHost]
  static String _host = 'https://edumart.kragos.com';

  /// Set the whole host/base url at runtime (e.g. for staging/dev)
  static void setHost(String url) => _host = url;

  /// Raw host value (no trailing slash guaranteed)
  static String get HOST =>
      _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;

  /// Base API prefix used by the app. Change this string if your API uses a
  /// different prefix/versioning scheme (for example '/v1' or '/api/v1').
  static String get BASE_URL => '$HOST/api/v1';

  // Authentication endpoints
  static String get AUTH => '$BASE_URL/auth';
  static String get LOGIN => '$AUTH/signin';
  static String get REGISTER => '$AUTH/signup';
  static String get LOGOUT => '$AUTH/logout';
  static String get FORGOT_PASSWORD => '$AUTH/forgotPassword';
  static String get RESET_PASSWORD => '$AUTH/resetPassword';

  // User endpoints
  static String get USER => '$BASE_URL/users/me';

  // Small helper to join an arbitrary relative path to the configured BASE_URL.
  // This helper does NOT append or merge query parameters — service layers
  // should add query params where required.
  static String endpoint(String relativePath) {
    if (relativePath.startsWith('http://') ||
        relativePath.startsWith('https://')) {
      return relativePath;
    }
    final cleanBase = BASE_URL.endsWith('/')
        ? BASE_URL.substring(0, BASE_URL.length - 1)
        : BASE_URL;
    final cleanPath =
        relativePath.startsWith('/') ? relativePath.substring(1) : relativePath;
    return '$cleanBase/$cleanPath';
  }

  ApiEndpoints._();
}

/// Legacy PHP-style endpoints helper. Use this when your backend expects the
/// Joomla/WordPress-style `index.php?option=com_api&task=<task>` pattern.
/// Note: this helper does NOT append query parameters — services should add
/// them when making requests.
class ApiEndpointsPhp {
  static String _host = 'https://edumart.kragos.com';

  /// Set the host at runtime (staging/dev)
  static void setHost(String url) => _host = url;

  /// Raw host value without trailing slash
  static String get HOST =>
      _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;

  /// Build a legacy task URL. Do NOT include query params here.
  static String endpoint(String task) {
    if (task.startsWith('http://') || task.startsWith('https://')) return task;
    final cleanHost =
        HOST.endsWith('/') ? HOST.substring(0, HOST.length - 1) : HOST;
    final cleanTask = task.startsWith('/') ? task.substring(1) : task;
    return '$cleanHost/index.php?option=com_api&task=$cleanTask';
  }

  ApiEndpointsPhp._();
}
