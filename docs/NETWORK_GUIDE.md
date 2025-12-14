# Network & Lifecycle Management Guide

This guide explains how to use the enhanced network utilities and app lifecycle management features in this template.

## 🌐 Network Utils

Located in `lib/utils/network_utils.dart`, this provides robust network handling for slow connections and transient failures.

### Features

✅ **Automatic retries with exponential backoff**  
✅ **Adaptive timeouts based on network quality**  
✅ **Multiple fallback servers for connectivity checks**  
✅ **Comprehensive error handling and classification**  
✅ **User-friendly error messages**

### Basic Usage

#### Making HTTP Requests with Retry

```dart
import 'package:http/http.dart' as http;
import 'package:your_app/utils/network_utils.dart';

// Make request with automatic retries
Future<http.Response> fetchData() async {
  return await NetworkUtils.makeRequest(
    request: () => http.get(Uri.parse('https://api.example.com/data')),
    maxRetries: 3,  // Will retry up to 3 times
    timeout: NetworkUtils.normalTimeout,  // 20 seconds
    useExponentialBackoff: true,  // 1s, 2s, 4s delays
  );
}
```

#### Checking Internet Connection

```dart
// Check internet with multiple fallback servers
final hasInternet = await NetworkUtils.hasInternetConnection();

if (hasInternet) {
  // Proceed with network request
} else {
  // Show offline message
}
```

#### Execute Function with Retry Logic

```dart
// Retry any async function
final data = await NetworkUtils.executeWithRetry<UserData>(
  action: () => apiService.getUserData(),
  maxRetries: 3,
  shouldRetry: (error) {
    // Only retry network errors, not auth errors
    return NetworkUtils.isNetworkError(error);
  },
);
```

#### Adaptive Timeouts

```dart
// Automatically adjust timeout based on network speed
Duration lastRequestTime = Duration(seconds: 15);
Duration timeout = NetworkUtils.getAdaptiveTimeout(
  lastRequestDuration: lastRequestTime,
);

// Now use this adaptive timeout for your next request
```

### Error Handling

```dart
try {
  final response = await NetworkUtils.makeRequest(
    request: () => http.get(Uri.parse(url)),
  );
  // Handle success
} on NetworkException catch (e) {
  // Handle specific network error types
  switch (e.type) {
    case NetworkErrorType.noConnection:
      showSnackBar('No internet connection');
      break;
    case NetworkErrorType.timeout:
      showSnackBar('Request timed out. Try again.');
      break;
    case NetworkErrorType.serverError:
      showSnackBar('Server error. Please try later.');
      break;
    default:
      showSnackBar(e.message);
  }
} catch (e) {
  // Handle other errors
  showSnackBar(NetworkUtils.getErrorMessage(e));
}
```

---

## 📱 App Lifecycle Manager

Located in `lib/utils/app_lifecycle_manager.dart`, this helps manage app state changes (foreground/background transitions).

### Why Use This?

- **Refresh data** when app returns from background
- **Pause timers** when app goes to background
- **Reconnect websockets** when app resumes
- **Clear sensitive data** when app is inactive

### Using the AppLifecycleAware Mixin

```dart
import 'package:flutter/material.dart';
import 'package:your_app/utils/app_lifecycle_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
    with AppLifecycleAware<MyHomePage> {
  
  @override
  void onAppResumed() {
    super.onAppResumed();
    // App came back to foreground
    print('App resumed - refreshing data');
    _refreshData();
    _checkNetworkStatus();
  }

  @override
  void onAppPaused() {
    super.onAppPaused();
    // App went to background
    print('App paused - stopping timers');
    _stopTimers();
  }

  @override
  void onAppInactive() {
    super.onAppInactive();
    // App is inactive (e.g., receiving a call)
    print('App inactive');
  }

  void _refreshData() {
    // Refresh your data here
  }

  void _checkNetworkStatus() {
    // Re-check network connectivity
  }

  void _stopTimers() {
    // Pause background tasks
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: const Center(child: Text('Hello')),
    );
  }
}
```

### Manual Lifecycle Manager

```dart
class MyService {
  late AppLifecycleManager _lifecycleManager;

  void initialize() {
    _lifecycleManager = AppLifecycleManager(
      onResume: () {
        print('Service: App resumed');
        _reconnectWebSocket();
      },
      onPause: () {
        print('Service: App paused');
        _disconnectWebSocket();
      },
    );
    _lifecycleManager.initialize();
  }

  void dispose() {
    _lifecycleManager.dispose();
  }

  void _reconnectWebSocket() {
    // Reconnect your websocket
  }

  void _disconnectWebSocket() {
    // Disconnect to save battery
  }
}
```

---

## 🔄 Complete Example: API Service with Network Utilities

Here's a complete example combining network utils and lifecycle management:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:your_app/utils/network_utils.dart';
import 'package:your_app/providers/network_provider.dart';

class UserApiService {
  final NetworkProvider networkProvider;

  UserApiService(this.networkProvider);

  Future<User> getUser(String userId) async {
    // Check network first
    if (!networkProvider.isConnected) {
      throw NetworkException(
        'No internet connection',
        type: NetworkErrorType.noConnection,
      );
    }

    // Make request with automatic retries
    final response = await NetworkUtils.makeRequest(
      request: () => http.get(
        Uri.parse('https://api.example.com/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      ),
      maxRetries: 3,
      timeout: NetworkUtils.normalTimeout,
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode >= 500) {
      throw NetworkException(
        'Server error',
        type: NetworkErrorType.serverError,
      );
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<User>> getUserList() async {
    return await NetworkUtils.executeWithRetry<List<User>>(
      action: () async {
        final response = await http.get(
          Uri.parse('https://api.example.com/users'),
        ).timeout(NetworkUtils.normalTimeout);

        if (response.statusCode == 200) {
          final List data = jsonDecode(response.body);
          return data.map((json) => User.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load users');
        }
      },
      maxRetries: 3,
      shouldRetry: (error) => NetworkUtils.isNetworkError(error),
    );
  }
}
```

---

## 🎯 Best Practices

### 1. Always Check Connectivity First

```dart
if (!networkProvider.isConnected) {
  showErrorDialog('No internet connection');
  return;
}
// Proceed with network request
```

### 2. Use Appropriate Timeouts

```dart
// For simple GET requests
timeout: NetworkUtils.fastTimeout  // 10s

// For POST/PUT with data
timeout: NetworkUtils.normalTimeout  // 20s

// For large uploads/downloads
timeout: NetworkUtils.slowTimeout  // 30s

// For very slow networks
timeout: NetworkUtils.verySlowTimeout  // 45s
```

### 3. Handle Errors Gracefully

```dart
try {
  final data = await apiService.fetchData();
} on NetworkException catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message)),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Unexpected error occurred')),
  );
}
```

### 4. Refresh Data on App Resume

```dart
class _HomePageState extends State<HomePage> 
    with AppLifecycleAware<HomePage> {
  
  @override
  void onAppResumed() {
    super.onAppResumed();
    // Refresh if app was in background for > 5 minutes
    if (_lifecycleManager.wasLongPause()) {
      _refreshAllData();
    }
  }
}
```

### 5. Show Loading States

```dart
bool _isLoading = false;

Future<void> _loadData() async {
  setState(() => _isLoading = true);
  
  try {
    final data = await NetworkUtils.executeWithRetry(
      action: () => apiService.getData(),
    );
    // Update UI
  } catch (e) {
    // Show error
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## 📊 Monitoring Network Quality

```dart
// Track request durations to estimate network quality
DateTime start = DateTime.now();

final response = await http.get(url);

Duration requestDuration = DateTime.now().difference(start);

// Use adaptive timeout for next request
Duration nextTimeout = NetworkUtils.getAdaptiveTimeout(
  lastRequestDuration: requestDuration,
);
```

---

## 🚀 Migration from Existing Code

### Before (Basic HTTP)
```dart
final response = await http.get(Uri.parse(url));
```

### After (With Network Utils)
```dart
final response = await NetworkUtils.makeRequest(
  request: () => http.get(Uri.parse(url)),
  maxRetries: 3,
);
```

### Before (Manual Lifecycle)
```dart
// No handling of app resume
```

### After (With Lifecycle Manager)
```dart
class _MyState extends State<MyWidget> with AppLifecycleAware<MyWidget> {
  @override
  void onAppResumed() {
    super.onAppResumed();
    _refreshData();
  }
}
```

---

## 💡 Tips

1. **Combine with existing NetworkProvider**: Use `NetworkUtils` alongside `NetworkProvider` for best results
2. **Set maxRetries based on operation**: Use fewer retries (1-2) for mutations, more (3-5) for reads
3. **Log network events**: Enable debug prints to monitor network behavior
4. **Test on slow networks**: Use Android Studio/Xcode network throttling to test
5. **Handle offline gracefully**: Always provide offline fallbacks or cached data

---

## 🔗 Related Files

- `lib/utils/network_utils.dart` - Network utilities implementation
- `lib/utils/app_lifecycle_manager.dart` - Lifecycle management
- `lib/providers/network_provider.dart` - Network state management
- `lib/services/network_service.dart` - Connectivity service

---

For more information, see the main [README.md](../README.md).
