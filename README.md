# 🚀 Flutter App Template

A comprehensive Flutter app template to quick-start your new projects with best practices, clean architecture, and essential utilities pre-configured.

## ✨ Features

- 🏗️ **Clean Architecture** - Well-organized folder structure
- 🎨 **Smart Image Management** - Centralized asset paths and smart caching widget
- 🔗 **Flexible API Integration** - Support for both REST and legacy PHP backends
- 🎯 **Icon Management** - Organized Material Design and custom icons
- ⚙️ **Configuration Ready** - Comprehensive constants file with feature flags
- 🎨 **Theme System** - Predefined colors and text styles
- 📱 **Cross-Platform** - Android, iOS, Web, Desktop ready
- 🔧 **Developer Friendly** - Clear documentation and examples

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   └── your_data_model.dart
├── pages/                       # UI screens
│   └── bottom_nav_bar.dart
├── providers/                   # State management
│   ├── base_provider.dart
│   ├── network_provider.dart
│   └── your_provider.dart
├── services/                    # API and business logic
│   ├── base_your_api_service.dart
│   ├── network_service.dart
│   └── your_api_service.dart
└── utils/                       # Utilities and helpers
    ├── api_caller.dart
    ├── color.dart              # Color definitions
    ├── constants.dart          # App-wide constants
    ├── my_icons.dart           # Icon management
    ├── my_images.dart          # Image path management
    ├── theme.dart              # Theme configuration
    └── w_smart_image.dart      # Smart image widget
```

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the template
git clone https://github.com/divijsahu/flutter-app-template.git your-app-name
cd your-app-name

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 2. Customize for Your Project

#### Update App Information
```dart
// lib/utils/constants.dart
static const String APP_NAME = 'Your App Name';
static const String APP_VERSION = '1.0.0';
static const String CONTACT_EMAIL = 'support@yourapp.com';
```

#### Configure API Endpoints
```dart
// For REST APIs
ApiEndpoints.setHost('https://api.yourapp.com');

// For legacy PHP backends
ApiEndpointsPhp.setHost('https://yourapp.com');
```

#### Add Your Assets
```dart
// lib/utils/my_images.dart
static const String yourLogo = '$_basePath/your_logo.png';

// lib/utils/my_icons.dart
static const String yourIcon = '$_svgIconsPath/your_icon.svg';
```

## 🛠️ Key Components

### 📷 Smart Image Management

**Two-file system for clear separation:**

1. **`my_images.dart`** - String paths only
2. **`w_smart_image.dart`** - Widget creation with caching

```dart
// Using image paths
Image.asset(MyImages.logo)

// Using smart image widget with helpers
SmartImageHelpers.userAvatar('user123', size: 60)
SmartImageWidget(imageUrl: MyImages.networkImage('photo.jpg'))
```

### 🔗 API Integration

**Flexible endpoint management:**

```dart
// REST API (recommended)
String loginUrl = ApiEndpoints.LOGIN;
String customUrl = ApiEndpoints.endpoint('custom/path');

// Legacy PHP API
String phpUrl = ApiEndpointsPhp.endpoint('login');
```

### 🎨 Theme & Styling

```dart
// Using predefined colors
Container(color: AppColors.primary)

// Using text styles
Text('Hello', style: AppTextStyles.heading1)
```

### ⚙️ Configuration Management

```dart
// Feature flags
if (AppConstants.IS_SUBSCRIPTION_ACTIVE) {
  // Show premium features
}

// Environment-specific settings
if (AppConstants.IS_DEBUG) {
  // Debug-only code
}
```

## 📋 Customization Checklist

- [ ] Update `APP_NAME`, `APP_VERSION` in `constants.dart`
- [ ] Replace API host URLs in `ApiEndpoints`
- [ ] Add your contact information and social media links
- [ ] Update privacy policy and terms URLs
- [ ] Add your app-specific image assets
- [ ] Configure your app's color scheme in `color.dart`
- [ ] Update app icons and splash screens
- [ ] Modify `pubspec.yaml` with your app details
- [ ] Add your specific API endpoints
- [ ] Configure feature flags for your app

## 📦 Recommended Packages

This template is designed to work well with:

```yaml
dependencies:
  # State Management
  provider: ^6.0.0
  riverpod: ^2.0.0
  
  # Networking
  http: ^1.0.0
  dio: ^5.0.0
  
  # Local Storage
  shared_preferences: ^2.0.0
  hive: ^2.0.0
  
  # UI/UX
  cached_network_image: ^3.0.0
  flutter_svg: ^2.0.0
  lottie: ^2.0.0
  
  # Utilities
  intl: ^0.18.0
  url_launcher: ^6.0.0
```

## 🎯 Best Practices Included

- **DRY Principle** - No code duplication
- **Single Responsibility** - Each file has a clear purpose
- **Type Safety** - Compile-time error checking
- **Scalable Architecture** - Easy to extend and maintain
- **Clear Documentation** - Well-documented code and structure
- **Performance Optimized** - Image caching and efficient widgets

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Community packages that make development easier
- Contributors who help improve this template

---

**Happy Coding! 🎉**

If you find this template helpful, please consider giving it a ⭐ on GitHub!
