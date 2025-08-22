import 'package:flutter/material.dart';

/// A centralized class for managing icon assets and Material Design icons.
/// Follow DRY principle by defining all icons here.
///
/// Usage:
/// - Icon(MyIcons.home)
/// - Image.asset(MyIcons.customIcon)
/// - IconButton(icon: Icon(MyIcons.settings), onPressed: () {})
class MyIcons {
  // Private constructor to prevent instantiation
  MyIcons._();

  // Base path for custom icon assets
  static const String _iconsPath = 'assets/icons';
  static const String _svgIconsPath = 'assets/icons/svg';

  // ===== MATERIAL DESIGN ICONS =====
  // Navigation icons
  static const IconData home = Icons.home;
  static const IconData search = Icons.search;
  static const IconData profile = Icons.person;
  static const IconData settings = Icons.settings;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData close = Icons.close;
  static const IconData menu = Icons.menu;

  // Action icons
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.save;
  static const IconData share = Icons.share;
  static const IconData download = Icons.download;
  static const IconData upload = Icons.upload;
  static const IconData refresh = Icons.refresh;

  // Communication icons
  static const IconData call = Icons.call;
  static const IconData email = Icons.email;
  static const IconData message = Icons.message;
  static const IconData chat = Icons.chat;
  static const IconData videocam = Icons.videocam;
  static const IconData mic = Icons.mic;
  static const IconData micOff = Icons.mic_off;

  // Status icons
  static const IconData check = Icons.check;
  static const IconData error = Icons.error;
  static const IconData warning = Icons.warning;
  static const IconData info = Icons.info;
  static const IconData loading = Icons.hourglass_bottom;
  static const IconData success = Icons.check_circle;

  // Media icons
  static const IconData play = Icons.play_arrow;
  static const IconData pause = Icons.pause;
  static const IconData stop = Icons.stop;
  static const IconData skip = Icons.skip_next;
  static const IconData previous = Icons.skip_previous;
  static const IconData volume = Icons.volume_up;
  static const IconData volumeOff = Icons.volume_off;

  // Shopping/E-commerce icons
  static const IconData cart = Icons.shopping_cart;
  static const IconData cartAdd = Icons.add_shopping_cart;
  static const IconData favorite = Icons.favorite;
  static const IconData favoriteOutline = Icons.favorite_border;
  static const IconData payment = Icons.payment;
  static const IconData creditCard = Icons.credit_card;
  static const IconData wallet = Icons.account_balance_wallet;

  // File/Document icons
  static const IconData file = Icons.insert_drive_file;
  static const IconData folder = Icons.folder;
  static const IconData image = Icons.image;
  static const IconData video = Icons.video_file;
  static const IconData audio = Icons.audio_file;
  static const IconData pdf = Icons.picture_as_pdf;

  // Location icons
  static const IconData location = Icons.location_on;
  static const IconData locationOff = Icons.location_off;
  static const IconData map = Icons.map;
  static const IconData directions = Icons.directions;
  static const IconData navigation = Icons.navigation;

  // Security icons
  static const IconData lock = Icons.lock;
  static const IconData unlock = Icons.lock_open;
  static const IconData security = Icons.security;
  static const IconData visibility = Icons.visibility;
  static const IconData visibilityOff = Icons.visibility_off;

  // Time icons
  static const IconData clock = Icons.access_time;
  static const IconData calendar = Icons.calendar_today;
  static const IconData date = Icons.date_range;
  static const IconData schedule = Icons.schedule;

  // ===== CUSTOM ASSET ICONS =====
  // Brand/Social Media icons (SVG recommended for scalability)
  static const String facebook = '$_svgIconsPath/facebook.svg';
  static const String twitter = '$_svgIconsPath/twitter.svg';
  static const String instagram = '$_svgIconsPath/instagram.svg';
  static const String linkedin = '$_svgIconsPath/linkedin.svg';
  static const String youtube = '$_svgIconsPath/youtube.svg';
  static const String whatsapp = '$_svgIconsPath/whatsapp.svg';
  static const String telegram = '$_svgIconsPath/telegram.svg';

  // App-specific custom icons
  static const String appLogo = '$_iconsPath/app_logo.png';
  static const String customHome = '$_svgIconsPath/custom_home.svg';
  static const String customProfile = '$_svgIconsPath/custom_profile.svg';
  static const String customSettings = '$_svgIconsPath/custom_settings.svg';

  // Category icons (customize based on your app)
  static const String category1 = '$_svgIconsPath/category_1.svg';
  static const String category2 = '$_svgIconsPath/category_2.svg';
  static const String category3 = '$_svgIconsPath/category_3.svg';

  // Feature-specific icons
  static const String notification = '$_svgIconsPath/notification.svg';
  static const String filter = '$_svgIconsPath/filter.svg';
  static const String sort = '$_svgIconsPath/sort.svg';

  // ===== HELPER METHODS =====

  /// Get Material Design icon with default size and color
  static Widget materialIcon(
    IconData icon, {
    double size = 24.0,
    Color? color,
  }) {
    return Icon(icon, size: size, color: color);
  }

  /// Get custom asset icon (PNG/JPG)
  static Widget assetIcon(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      color: color,
    );
  }

  /// Get SVG icon from assets
  /// Note: You'll need flutter_svg package for this to work
  static Widget svgIcon(
    String svgPath, {
    double? width,
    double? height,
    Color? color,
  }) {
    // Uncomment when you add flutter_svg dependency
    // return SvgPicture.asset(
    //   svgPath,
    //   width: width,
    //   height: height,
    //   color: color,
    // );

    // Fallback to placeholder until flutter_svg is added
    return Icon(Icons.image, size: width ?? height ?? 24);
  }

  /// Build dynamic category icon path
  static String categoryIcon(String categoryId) {
    return '$_svgIconsPath/category_$categoryId.svg';
  }

  /// Check if a custom icon asset exists
  static bool customIconExists(String iconPath) {
    return iconPath.isNotEmpty && iconPath.startsWith('assets/');
  }

  // ===== ICON COLLECTIONS =====

  /// Get all navigation icons
  static List<IconData> get navigationIcons => [
        home,
        search,
        profile,
        settings,
      ];

  /// Get all action icons
  static List<IconData> get actionIcons => [
        add,
        edit,
        delete,
        save,
        share,
      ];

  /// Get all social media icon paths
  static List<String> get socialMediaIcons => [
        facebook,
        twitter,
        instagram,
        linkedin,
        youtube,
      ];

  /// Get all status icons
  static List<IconData> get statusIcons => [
        check,
        error,
        warning,
        info,
        success,
      ];
}
