import 'constants.dart';

/// A centralized class for managing image asset PATHS in your Flutter app.
/// Follow DRY principle by defining all image paths here.
/// This class only provides STRING PATHS - no widget creation.
///
/// Usage:
/// - Image.asset(MyImages.logo)
/// - AssetImage(MyImages.placeholder)
/// - SmartImageWidget(imageUrl: MyImages.networkImage('user-avatar.jpg'))
class MyImages {
  // Private constructor to prevent instantiation
  MyImages._();

  // Base paths for different asset categories
  static const String _basePath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _illustrationsPath = 'assets/illustrations';
  static const String _backgroundsPath = 'assets/backgrounds';

  // App branding assets
  static const String logo = '$_basePath/logo.png';
  static const String logoWhite = '$_basePath/logo_white.png';
  static const String logoIcon = '$_basePath/logo_icon.png';
  static const String splashLogo = '$_basePath/splash_logo.png';

  // Common UI assets
  static const String placeholder = '$_basePath/placeholder.png';
  static const String avatarPlaceholder = '$_basePath/avatar_placeholder.png';
  static const String imagePlaceholder = '$_basePath/image_placeholder.png';
  static const String noData = '$_basePath/no_data.png';
  static const String error = '$_basePath/error.png';

  // Onboarding/Welcome screens
  static const String onboarding1 = '$_illustrationsPath/onboarding_1.png';
  static const String onboarding2 = '$_illustrationsPath/onboarding_2.png';
  static const String onboarding3 = '$_illustrationsPath/onboarding_3.png';
  static const String welcome = '$_illustrationsPath/welcome.png';

  // Authentication screens
  static const String loginIllustration = '$_illustrationsPath/login.png';
  static const String signupIllustration = '$_illustrationsPath/signup.png';
  static const String forgotPassword =
      '$_illustrationsPath/forgot_password.png';

  // Empty states
  static const String emptyCart = '$_illustrationsPath/empty_cart.png';
  static const String emptySearch = '$_illustrationsPath/empty_search.png';
  static const String emptyNotifications =
      '$_illustrationsPath/empty_notifications.png';
  static const String emptyFavorites =
      '$_illustrationsPath/empty_favorites.png';

  // Background images
  static const String authBackground = '$_backgroundsPath/auth_bg.png';
  static const String homeBackground = '$_backgroundsPath/home_bg.png';
  static const String patternBackground = '$_backgroundsPath/pattern_bg.png';

  // Category/Feature specific images (customize based on your app)
  static const String category1 = '$_basePath/categories/category_1.png';
  static const String category2 = '$_basePath/categories/category_2.png';
  static const String category3 = '$_basePath/categories/category_3.png';

  // Profile/User related
  static const String defaultProfile = '$_basePath/default_profile.png';
  static const String camera = '$_iconsPath/camera.png';
  static const String gallery = '$_iconsPath/gallery.png';

  // Helper methods for dynamic image paths
  /// Build network image URL using the base URL from constants
  static String networkImage(String imageName) {
    // You can customize this based on your API structure
    return '${_getBaseImageUrl()}/$imageName';
  }

  /// Build category image path dynamically
  static String categoryImage(String categoryId) {
    return '$_basePath/categories/category_$categoryId.png';
  }

  /// Build user avatar URL (useful for user profiles)
  static String userAvatar(String userId) {
    return networkImage('avatars/$userId.jpg');
  }

  /// Build product image URL
  static String productImage(String productId, {int variant = 1}) {
    return networkImage('products/${productId}_$variant.jpg');
  }

  // Private helper to get base image URL from constants
  static String _getBaseImageUrl() {
    // Use the HOST from ApiEndpoints for images
    return ApiEndpoints.HOST;
  }

  // Helper method to check if an asset exists (useful for debugging)
  static bool assetExists(String assetPath) {
    // This is a simple check - in production you might want more robust validation
    return assetPath.isNotEmpty && assetPath.startsWith('assets/');
  }

  // Get all logo variants as a list (useful for testing different logos)
  static List<String> get logoVariants => [
        logo,
        logoWhite,
        logoIcon,
        splashLogo,
      ];

  // Get all placeholder images
  static List<String> get placeholders => [
        placeholder,
        avatarPlaceholder,
        imagePlaceholder,
        noData,
        error,
      ];

  // Get all onboarding images in order
  static List<String> get onboardingImages => [
        onboarding1,
        onboarding2,
        onboarding3,
      ];
}
