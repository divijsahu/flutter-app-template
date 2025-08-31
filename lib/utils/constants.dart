/// Application-wide constants and configuration
///
/// TODO: Customize these values for your specific project:
/// 1. Update API_VERSION and host URLs
/// 2. Replace contact details with your actual information
/// 3. Add your social media links
/// 4. Configure API endpoints based on your backend
/// 5. Add project-specific constants as needed
abstract class AppConstants {
  // ===== APP CONFIGURATION =====

  /// API version for your application
  static const String APP_API_VERSION = '1.0.0';

  /// App version (sync with pubspec.yaml)
  static const String APP_VERSION = '1.0.0';

  /// App name (used in various places like notifications, titles)
  static const String APP_NAME = 'Your App Name';

  /// Environment flags
  static const bool IS_DEBUG = true; // Set to false for production
  static const bool IS_PRODUCTION = false; // Set to true for production

  // ===== FEATURE FLAGS =====

  /// Toggle features on/off
  static bool IS_SUBSCRIPTION_ACTIVE = true;
  static bool IS_ANALYTICS_ENABLED = true;
  static bool IS_CRASH_REPORTING_ENABLED = true;
  static bool IS_PUSH_NOTIFICATIONS_ENABLED = true;

  // ===== ERROR MESSAGES =====

  /// Generic error message
  static const String ERROR_MESSAGE =
      'Something went wrong, Please try again later';
  static const String NETWORK_ERROR =
      'Network connection failed. Please check your internet.';
  static const String SERVER_ERROR =
      'Server error occurred. Please try again later.';
  static const String TIMEOUT_ERROR = 'Request timeout. Please try again.';
  static const String UNAUTHORIZED_ERROR =
      'Session expired. Please login again.';

  // ===== CONTACT INFORMATION =====
  // TODO: Replace with your actual contact details

  static const String CONTACT_EMAIL = 'support@yourapp.com';
  static const String CONTACT_PHONE = '+1234567890';
  static const String CONTACT_PHONE_DISPLAY = '+1 (234) 567-890';
  static const String CONTACT_WHATSAPP_URL = 'https://wa.me/1234567890';
  static const String CONTACT_ADDRESS = 'Your Company Address';
  static const String COMPANY_NAME = 'Your Company Name';

  // ===== SOCIAL MEDIA LINKS =====
  // TODO: Replace with your actual social media profiles

  static const String FACEBOOK_PROFILE = 'https://www.facebook.com/yourpage';
  static const String TWITTER_PROFILE = 'https://twitter.com/yourprofile';
  static const String INSTAGRAM_PROFILE =
      'https://www.instagram.com/yourprofile';
  static const String LINKEDIN_PROFILE =
      'https://www.linkedin.com/company/yourcompany';
  static const String YOUTUBE_PROFILE = 'https://www.youtube.com/c/yourchannel';
  static const String TIKTOK_PROFILE = 'https://www.tiktok.com/@yourprofile';

  // ===== LEGAL & POLICY LINKS =====
  // TODO: Replace with your actual policy pages

  static const String TERMS_AND_CONDITIONS_URL = 'https://yourapp.com/terms';
  static const String PRIVACY_POLICY_URL = 'https://yourapp.com/privacy';
  static const String REFUND_POLICY_URL = 'https://yourapp.com/refund-policy';
  static const String SUPPORT_URL = 'https://yourapp.com/support';
  static const String FAQ_URL = 'https://yourapp.com/faq';

  // ===== TECHNICAL CONTACT =====
  // TODO: Replace with your technical support details

  static const String TECH_CONTACT_EMAIL = 'tech@yourapp.com';
  static const String TECH_CONTACT_PHONE_DISPLAY = '+1-234-567-8900';
  static const String TECH_CONTACT_WHATSAPP = 'https://wa.me/12345678900';

  // ===== EXTERNAL LINKS =====

  static const String APPS_PAGE_URL = 'https://yourapp.com/apps';
  static const String WEBSITE_URL = 'https://yourapp.com';
  static const String BLOG_URL = 'https://yourapp.com/blog';

  // ===== UI CONSTANTS =====

  /// Maximum content width for responsive layouts
  static const double MAX_CONTENT_WIDTH = 1024.0;

  /// Standard padding and margins
  static const double PADDING_SMALL = 8.0;
  static const double PADDING_MEDIUM = 16.0;
  static const double PADDING_LARGE = 24.0;
  static const double PADDING_EXTRA_LARGE = 32.0;

  /// Animation durations
  static const int ANIMATION_DURATION_FAST = 200;
  static const int ANIMATION_DURATION_NORMAL = 300;
  static const int ANIMATION_DURATION_SLOW = 500;

  /// Common radius values
  static const double BORDER_RADIUS_SMALL = 4.0;
  static const double BORDER_RADIUS_MEDIUM = 8.0;
  static const double BORDER_RADIUS_LARGE = 12.0;
  static const double BORDER_RADIUS_EXTRA_LARGE = 16.0;

  // ===== AUTHENTICATION & API =====
  // ===== AUTHENTICATION & API =====

  /// Bearer token for API authentication (set at runtime)
  static String? BEARER_TOKEN;

  /// Default API headers
  static Map<String, String> API_HEADER = {
    'x-app-version': APP_API_VERSION,
    'Content-Type': 'application/json',
  };

  /// Update authentication tokens and headers
  static void updateTokens(String? bearer) {
    BEARER_TOKEN = bearer;
    API_HEADER = {
      'x-app-version': APP_API_VERSION,
      'Content-Type': 'application/json',
      if (BEARER_TOKEN != null) 'Authorization': 'Bearer $BEARER_TOKEN',
    };
  }

  /// Clear authentication tokens
  static void clearTokens() {
    BEARER_TOKEN = null;
    API_HEADER.remove('Authorization');
  }

  /// Return a fresh copy of API headers including Authorization when present
  static Map<String, String> getApiHeaders() {
    final headers = <String, String>{
      'x-app-version': APP_API_VERSION,
      'Content-Type': 'application/json',
    };
    if (BEARER_TOKEN != null) headers['Authorization'] = 'Bearer $BEARER_TOKEN';
    return headers;
  }

  // ===== CACHE & STORAGE =====

  /// Cache durations (in seconds)
  static const int CACHE_DURATION_SHORT = 300; // 5 minutes
  static const int CACHE_DURATION_MEDIUM = 1800; // 30 minutes
  static const int CACHE_DURATION_LONG = 3600; // 1 hour
  static const int CACHE_DURATION_EXTRA_LONG = 86400; // 24 hours

  /// Local storage keys
  static const String STORAGE_KEY_USER_TOKEN = 'user_token';
  static const String STORAGE_KEY_USER_DATA = 'user_data';
  static const String STORAGE_KEY_SETTINGS = 'app_settings';
  static const String STORAGE_KEY_ONBOARDING = 'onboarding_completed';
  static const String STORAGE_KEY_FIRST_LAUNCH = 'first_launch';

  // ===== PAGINATION & LIMITS =====

  /// Default pagination settings
  static const int DEFAULT_PAGE_SIZE = 20;
  static const int MAX_PAGE_SIZE = 100;
  static const int MIN_PAGE_SIZE = 5;

  /// File upload limits (in bytes)
  static const int MAX_IMAGE_SIZE = 5 * 1024 * 1024; // 5MB
  static const int MAX_VIDEO_SIZE = 100 * 1024 * 1024; // 100MB
  static const int MAX_DOCUMENT_SIZE = 10 * 1024 * 1024; // 10MB

  // ===== VALIDATION CONSTANTS =====

  /// Text field limits
  static const int MIN_PASSWORD_LENGTH = 8;
  static const int MAX_PASSWORD_LENGTH = 128;
  static const int MAX_NAME_LENGTH = 50;
  static const int MAX_EMAIL_LENGTH = 254;
  static const int MAX_PHONE_LENGTH = 20;
  static const int MAX_MESSAGE_LENGTH = 1000;

  /// Regex patterns
  static const String EMAIL_REGEX =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String PHONE_REGEX = r'^\+?[1-9]\d{1,14}$';
  static const String PASSWORD_REGEX =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // Prevent instantiation and make it a singleton
  AppConstants._();
}

/// REST API endpoints for modern backends
///
/// TODO: Customize the host URL and endpoint structure for your API
/// Example usage:
/// - ApiEndpoints.setHost('https://staging.yourapi.com') // For staging
/// - ApiEndpoints.LOGIN // Returns full URL
/// - ApiEndpoints.endpoint('custom/path') // Build custom endpoints
class ApiEndpoints {
  // TODO: Replace with your actual API host
  static String _host = 'https://api.yourapp.com';

  /// Set the whole host/base url at runtime (e.g. for staging/dev)
  static void setHost(String url) => _host = url;

  /// Raw host value (no trailing slash guaranteed)
  static String get HOST =>
      _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;

  /// Base API prefix used by the app. Change this string if your API uses a
  /// different prefix/versioning scheme (for example '/v1' or '/api/v2').
  static String get BASE_URL => '$HOST/api/v1';

  // ===== AUTHENTICATION ENDPOINTS =====
  static String get AUTH => '$BASE_URL/auth';
  static String get LOGIN => '$AUTH/signin';
  static String get REGISTER => '$AUTH/signup';
  static String get LOGOUT => '$AUTH/logout';
  static String get FORGOT_PASSWORD => '$AUTH/forgot-password';
  static String get RESET_PASSWORD => '$AUTH/reset-password';
  static String get REFRESH_TOKEN => '$AUTH/refresh';
  static String get VERIFY_EMAIL => '$AUTH/verify-email';
  static String get RESEND_VERIFICATION => '$AUTH/resend-verification';

  // ===== USER ENDPOINTS =====
  static String get USER => '$BASE_URL/user';
  static String get USER_PROFILE => '$USER/profile';
  static String get USER_SETTINGS => '$USER/settings';
  static String get USER_AVATAR => '$USER/avatar';
  static String get CHANGE_PASSWORD => '$USER/change-password';
  static String get DELETE_ACCOUNT => '$USER/delete';

  // ===== COMMON ENDPOINTS =====
  // TODO: Add your app-specific endpoints here

  /// Example endpoints - replace with your actual endpoints
  static String get DASHBOARD => '$BASE_URL/dashboard';
  static String get NOTIFICATIONS => '$BASE_URL/notifications';
  static String get SEARCH => '$BASE_URL/search';
  static String get UPLOAD => '$BASE_URL/upload';

  // Helper methods for dynamic endpoints
  static String userById(String userId) => '$USER/$userId';
  static String notificationById(String notificationId) =>
      '$NOTIFICATIONS/$notificationId';

  /// General helper to join an arbitrary relative path to the configured BASE_URL.
  /// This helper does NOT append or merge query parameters — service layers
  /// should add query params where required.
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
///
/// TODO: Only use this class if you have a PHP backend that follows this pattern
class ApiEndpointsPhp {
  // TODO: Replace with your actual PHP backend host
  static String _host = 'https://yourapp.com';

  /// Set the host at runtime (staging/dev)
  static void setHost(String url) => _host = url;

  /// Raw host value without trailing slash
  static String get HOST =>
      _host.endsWith('/') ? _host.substring(0, _host.length - 1) : _host;

  /// Build a legacy PHP task URL. Do NOT include query params here.
  /// Example: endpoint('login') -> 'https://yourapp.com/index.php?option=com_api&task=login'
  static String endpoint(String task) {
    if (task.startsWith('http://') || task.startsWith('https://')) return task;
    final cleanHost =
        HOST.endsWith('/') ? HOST.substring(0, HOST.length - 1) : HOST;
    final cleanTask = task.startsWith('/') ? task.substring(1) : task;
    return '$cleanHost/index.php?option=com_api&task=$cleanTask';
  }

  /// Alternative method for Joomla-style endpoints with different component
  static String joomlaEndpoint(String component, String task) {
    return '$HOST/index.php?option=$component&task=$task';
  }

  ApiEndpointsPhp._();
}
