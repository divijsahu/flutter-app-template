# 🚀 Flutter App Template - 2026 Enterprise Architecture

A modern, scalable Flutter app template following 2026 enterprise architecture principles with clean code, multi-lingual support, and modular design system.

## ✨ Features

- 🏗️ **Clean Architecture** - Domain-driven design with clear separation of concerns
- 🎨 **Design System** - Token-based design with atoms, molecules, and organisms
- 🌍 **Multi-Lingual** - Built-in support for English, Spanish, Hindi, and Arabic
- 📱 **Responsive** - Mobile, tablet, and desktop layouts
- 🎯 **Type-Safe** - Result types for error handling
- ⚡ **Performance** - Optimized with best practices
- 🧪 **Testable** - Every layer independently testable

## 📁 Project Structure

```
lib/
├── core/                      # Core infrastructure
│   ├── base/                  # Base classes (UseCase, etc.)
│   ├── errors/                # Failure types
│   ├── network/               # Result type, network utilities
│   ├── constants/             # App-wide constants
│   └── utils/                 # Utility functions
│
├── design_system/             # Design tokens & components
│   ├── tokens/                # Colors, typography, spacing, breakpoints
│   ├── theme/                 # Theme configuration
│   ├── atoms/                 # Basic UI components (buttons, inputs)
│   ├── molecules/             # Composite components
│   ├── organisms/             # Complex components
│   └── layouts/               # Layout components (responsive)
│
├── shared/                    # Shared across features
│   ├── extensions/            # Context, String extensions
│   ├── helpers/               # Snackbar, dialog helpers
│   ├── widgets/               # Reusable widgets
│   └── models/                # Shared models
│
├── features/                  # Feature modules
│   └── home/
│       ├── data/              # Data sources, DTOs, repositories
│       ├── domain/            # Entities, use cases, contracts
│       └── presentation/      # Screens, widgets, providers
│
├── app/                       # App configuration
│   └── app.dart               # Root app widget
│
└── l10n/                      # Localization files
    ├── app_en.arb             # English
    ├── app_es.arb             # Spanish
    ├── app_hi.arb             # Hindi
    └── app_ar.arb             # Arabic
```

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/divijsahu/flutter-app-template.git your-app-name
cd your-app-name
flutter pub get
flutter gen-l10n  # Generate localization files
flutter run
```

### 2. Add New Language

1. Create new ARB file in `lib/l10n/` (e.g., `app_fr.arb`)
2. Copy structure from `app_en.arb`
3. Translate all strings
4. Run `flutter gen-l10n`

### 3. Add New Feature

```bash
# Create feature structure
mkdir -p lib/features/your_feature/{data,domain,presentation}/{datasources,models,repositories,entities,usecases,screens,widgets,providers}
```

Follow the clean architecture pattern:
- **Domain**: Define entities and use cases
- **Data**: Implement repositories and data sources
- **Presentation**: Build UI with screens and widgets

## 🎨 Design System Usage

### Using Design Tokens

```dart
// Colors
Container(color: AppColors.primary)

// Spacing
Padding(padding: AppSpacing.pagePadding)

// Typography
Text('Hello', style: AppTypography.headlineMedium)

// Breakpoints
if (MediaQuery.of(context).size.width >= AppBreakpoints.tablet) {
  // Tablet layout
}
```

### Using Components

```dart
// Primary Button
PrimaryButton(
  label: 'Submit',
  onPressed: () {},
  isLoading: false,
)

// Responsive Layout
ResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

### Using Context Extensions

```dart
// Access theme
context.colors.primary
context.textTheme.bodyLarge

// Access localization
context.l10n.welcomeMessage

// Check device type
if (context.isMobile) { }
if (context.isTablet) { }
if (context.isDesktop) { }
```

## 🌍 Localization

### Using Translations

```dart
// In widgets
Text(context.l10n.welcomeMessage)
Text(context.l10n.getStarted)

// Available languages
- English (en)
- Spanish (es)
- Hindi (hi)
- Arabic (ar)
```

### Adding New Strings

1. Add to `lib/l10n/app_en.arb`:
```json
{
  "myNewString": "My New String",
  "@myNewString": {
    "description": "Description of the string"
  }
}
```

2. Add translations to other ARB files
3. Run `flutter gen-l10n`
4. Use: `context.l10n.myNewString`

## 🏗️ Architecture Principles

### 1. Feature Isolation
Each feature is self-contained with its own data, domain, and presentation layers.

### 2. Dependency Rule
```
Presentation → Domain ← Data
```
Domain knows nothing about other layers.

### 3. Result Type
Use `Result<T>` for error handling:
```dart
Future<Result<User>> login(String email, String password) async {
  try {
    final user = await api.login(email, password);
    return Success(user);
  } catch (e) {
    return Failure(NetworkFailure());
  }
}
```

### 4. Use Cases
Business logic lives in use cases:
```dart
class LoginUseCase extends BaseUseCase<User, LoginParams> {
  @override
  Future<Result<User>> execute(LoginParams params) {
    // Business logic here
  }
}
```

## 📦 Recommended Packages

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.5.0
  
  # Networking
  dio: ^5.4.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  hive_flutter: ^1.1.0
  
  # Routing
  go_router: ^13.0.0
  
  # Code Generation
  freezed: ^2.4.0
  json_serializable: ^6.7.0
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## 📝 Best Practices

1. ✅ Use design tokens - never hardcode values
2. ✅ Follow clean architecture layers
3. ✅ Use Result type for error handling
4. ✅ Keep features isolated
5. ✅ Use context extensions for common operations
6. ✅ Localize all user-facing strings
7. ✅ Make layouts responsive
8. ✅ Write tests for business logic

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

---

**Happy Coding! 🎉**

Built with ❤️ using Flutter and 2026 Enterprise Architecture principles.
