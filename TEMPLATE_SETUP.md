# 🚀 Template Setup Guide

Welcome! This guide will help you customize this Flutter app template for your specific project.

## Quick Start

### 1. Clone and Rename

```bash
# Clone this template
git clone https://github.com/divijsahu/flutter-app-template.git your-app-name
cd your-app-name

# Remove existing git history (start fresh)
rm -rf .git
git init
git add .
git commit -m "Initial commit from flutter-app-template"
```

### 2. Update Project Name

#### Option A: Using Scripts (Recommended)

**macOS/Linux:**
```bash
chmod +x scripts/rename_project.sh
./scripts/rename_project.sh your_app_name "Your App Display Name"
```

**Windows:**
```bash
scripts\rename_project.bat your_app_name "Your App Display Name"
```

#### Option B: Manual Rename

1. **Update `pubspec.yaml`:**
   ```yaml
   name: your_app_name  # Change this
   description: "Your app description"
   ```

2. **Update import statements:**
   - Find all imports with `provider_app_template`
   - Replace with `your_app_name`
   - Use IDE's "Find and Replace in Files" (Cmd/Ctrl + Shift + F)

3. **Update native project names:**
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`

### 3. Configure Your App

#### Update App Constants

**File:** `lib/utils/constants.dart`

```dart
// App Information
static const String APP_NAME = 'Your App Name';
static const String APP_VERSION = '1.0.0';
static const String COMPANY_NAME = 'Your Company';

// Contact Information
static const String CONTACT_EMAIL = 'support@yourapp.com';
static const String CONTACT_PHONE = '+1234567890';

// Social Media Links
static const String FACEBOOK_PROFILE = 'https://facebook.com/yourpage';
static const String INSTAGRAM_PROFILE = 'https://instagram.com/yourprofile';
// ... update all social links
```

#### Configure API Endpoints

**For REST APIs:**
```dart
// In your app initialization or before making API calls
ApiEndpoints.setHost('https://api.yourapp.com');

// Then use the endpoints
String loginUrl = ApiEndpoints.LOGIN;
```

**For Legacy PHP APIs:**
```dart
ApiEndpointsPhp.setHost('https://yourapp.com');
String url = ApiEndpointsPhp.endpoint('login');
```

#### Update Colors & Theme

**File:** `lib/utils/color.dart`

```dart
// Update primary colors to match your brand
static const Color primary = Color(0xFFYOURCOLOR);
static const Color secondary = Color(0xFFYOURCOLOR);
```

### 4. Add Your Assets

#### Create Assets Structure

The template expects this structure:
```
assets/
├── icons/
│   ├── svg/        # SVG icons
│   └── png/        # PNG icons
├── images/
│   ├── backgrounds/
│   ├── logos/
│   └── placeholders/
└── fonts/          # Custom fonts (optional)
```

#### Update pubspec.yaml

```yaml
flutter:
  assets:
    - assets/icons/svg/
    - assets/icons/png/
    - assets/images/
    - assets/images/backgrounds/
    - assets/images/logos/
```

#### Add Image Paths

**File:** `lib/utils/my_images.dart`

```dart
// Add your image paths
static const String yourLogo = '$_basePath/logos/your_logo.png';
static const String yourBackground = '$_basePath/backgrounds/bg.jpg';
```

### 5. Configure Features

#### Feature Flags

**File:** `lib/utils/constants.dart`

```dart
// Enable/disable features
static bool IS_SUBSCRIPTION_ACTIVE = true;
static bool IS_ANALYTICS_ENABLED = true;
static bool IS_PUSH_NOTIFICATIONS_ENABLED = false;
```

#### Environment Setup

Create `.env` file (use `.env.example` as reference):
```bash
cp .env.example .env
```

Edit `.env`:
```
API_BASE_URL=https://api.yourapp.com
APP_NAME=Your App Name
DEBUG_MODE=true
```

### 6. Update App Icons & Splash Screen

#### App Icons

```bash
# Install flutter_launcher_icons package
flutter pub add --dev flutter_launcher_icons

# Configure in pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"

# Generate icons
flutter pub run flutter_launcher_icons
```

#### Splash Screen

```bash
# Install flutter_native_splash
flutter pub add --dev flutter_native_splash

# Configure and generate
flutter pub run flutter_native_splash:create
```

### 7. Clean Up Template Code

#### Remove Template-Specific Files

```bash
# Remove template example page (optional)
rm lib/pages/template_example_page.dart

# Remove this setup guide after completion
rm TEMPLATE_SETUP.md
```

#### Update README

Edit `README.md` to describe your specific app instead of the template.

### 8. Initialize Git Repository

```bash
# Create your repository on GitHub
# Then link it

git remote add origin https://github.com/yourusername/your-app-name.git
git branch -M main
git push -u origin main
```

## Customization Checklist

Use this checklist to track your setup progress:

### Project Configuration
- [ ] Renamed project in `pubspec.yaml`
- [ ] Updated import statements
- [ ] Updated native project names (Android/iOS)
- [ ] Removed old git history and initialized new repo

### App Constants
- [ ] Updated `APP_NAME`
- [ ] Updated `APP_VERSION`
- [ ] Updated contact information
- [ ] Updated social media links
- [ ] Updated legal/policy URLs

### API Configuration
- [ ] Set API base URL
- [ ] Updated/added API endpoints
- [ ] Configured authentication headers
- [ ] Tested API connections

### Branding
- [ ] Updated app colors in `color.dart`
- [ ] Added your logo to assets
- [ ] Generated app icons
- [ ] Created splash screen
- [ ] Updated app theme (if needed)

### Assets
- [ ] Created assets folder structure
- [ ] Added all required images
- [ ] Updated `pubspec.yaml` assets section
- [ ] Updated `my_images.dart` with paths

### Features
- [ ] Configured feature flags
- [ ] Set up environment variables
- [ ] Removed unused features
- [ ] Added project-specific features

### Dependencies
- [ ] Reviewed and updated package versions
- [ ] Added project-specific packages
- [ ] Removed unused packages
- [ ] Ran `flutter pub get`

### Testing
- [ ] App runs successfully
- [ ] Theme displays correctly
- [ ] Assets load properly
- [ ] API integration works
- [ ] No build errors

### Documentation
- [ ] Updated README.md
- [ ] Removed TEMPLATE_SETUP.md (this file)
- [ ] Added project-specific documentation
- [ ] Updated LICENSE (if needed)

### Deployment Preparation
- [ ] Set `IS_DEBUG = false` for production
- [ ] Set `IS_PRODUCTION = true` for production
- [ ] Configured app signing (Android/iOS)
- [ ] Tested production build
- [ ] Reviewed PRODUCTION_CHECKLIST.md

## Next Steps

After completing this setup:

1. **Review the code structure** - Familiarize yourself with the folder organization
2. **Check out the example implementations** - See how to use providers, services, etc.
3. **Read the main README** - Understand all available utilities
4. **Start building** - Begin adding your app-specific features!

## Need Help?

- **Template Documentation**: Check the main [README.md](README.md)
- **Flutter Documentation**: https://docs.flutter.dev
- **Report Issues**: Open an issue on the template repository

## Tips for Success

1. **Start small** - Get one feature working before adding more
2. **Follow the structure** - Keep the clean architecture pattern
3. **Use constants** - Don't hardcode values, use `constants.dart`
4. **Test frequently** - Run the app after each major change
5. **Commit often** - Save your progress with meaningful commit messages

---

**Happy Coding! 🎉**

Once you're done with setup, you can safely delete this file.
