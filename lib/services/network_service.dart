import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkStatus { connected, disconnected, unknown }

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  // Stream controller for broadcasting network status changes
  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  NetworkStatus _currentStatus = NetworkStatus.unknown;
  DateTime? _lastInternetCheck;
  bool _hasInternetAccess = false;

  /// Initialize connectivity service and start listening to connectivity changes
  Future<void> initialize() async {
    try {
      // Get initial connectivity status
      _connectionStatus = await _connectivity.checkConnectivity();
      await _updateNetworkStatus();

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> result,
      ) async {
        _connectionStatus = result;
        await _updateNetworkStatus();
      });
    } catch (e) {
      debugPrint('ConnectivityService initialization error: $e');
      _connectionStatus = [ConnectivityResult.none];
      _currentStatus = NetworkStatus.disconnected;
      _networkStatusController.add(_currentStatus);
    }
  }

  /// Update network status and broadcast changes
  Future<void> _updateNetworkStatus() async {
    final wasConnected = _currentStatus == NetworkStatus.connected;

    if (hasConnection) {
      // Check actual internet access every 30 seconds or when connectivity changes
      final now = DateTime.now();
      if (_lastInternetCheck == null ||
          now.difference(_lastInternetCheck!).inSeconds > 30) {
        _hasInternetAccess = await _checkInternetAccess();
        _lastInternetCheck = now;
      }
    } else {
      _hasInternetAccess = false;
    }

    final newStatus = _hasInternetAccess
        ? NetworkStatus.connected
        : NetworkStatus.disconnected;

    // Only broadcast if status actually changed
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _networkStatusController.add(_currentStatus);

      debugPrint('Network status changed: ${newStatus.name}');
      if (!wasConnected && newStatus == NetworkStatus.connected) {
        debugPrint('Internet connection restored');
      } else if (wasConnected && newStatus == NetworkStatus.disconnected) {
        debugPrint('Internet connection lost');
      }
    }
  }

  /// Check if device has basic connectivity
  bool get hasConnection {
    return _connectionStatus.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );
  }

  /// Get current network status
  NetworkStatus get networkStatus => _currentStatus;

  /// Check if currently connected to internet
  bool get isConnected => _currentStatus == NetworkStatus.connected;

  /// Force check internet connectivity with actual network test
  Future<bool> checkInternetConnection({bool forceCheck = false}) async {
    try {
      // First check connectivity status
      if (!hasConnection) {
        return false;
      }

      // Use cached result if recent and not forcing check
      if (!forceCheck &&
          _lastInternetCheck != null &&
          DateTime.now().difference(_lastInternetCheck!).inSeconds < 30) {
        return _hasInternetAccess;
      }

      _hasInternetAccess = await _checkInternetAccess();
      _lastInternetCheck = DateTime.now();

      // Update status if needed
      final newStatus = _hasInternetAccess
          ? NetworkStatus.connected
          : NetworkStatus.disconnected;
      if (newStatus != _currentStatus) {
        _currentStatus = newStatus;
        _networkStatusController.add(_currentStatus);
      }

      return _hasInternetAccess;
    } catch (e) {
      debugPrint('Internet connectivity check error: $e');
      return false;
    }
  }

  /// Internal method to check internet access
  Future<bool> _checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Internet access check error: $e');
      return false;
    }
  }

  /// Get current connectivity status as a user-friendly string
  String get connectionStatusString {
    if (_connectionStatus.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (_connectionStatus.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (_connectionStatus.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (_connectionStatus.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else {
      return 'No Connection';
    }
  }

  /// Get network status stream for reactive UI updates
  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;

  /// Get connectivity status stream for lower-level connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream {
    return _connectivity.onConnectivityChanged;
  }

  /// Wait for network connection to be restored
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (isConnected) return;

    await networkStatusStream
        .where((status) => status == NetworkStatus.connected)
        .first
        .timeout(timeout);
  }

  /// Get user-friendly error message based on network status
  String getNetworkErrorMessage() {
    switch (_currentStatus) {
      case NetworkStatus.connected:
        return 'Connection is stable';
      case NetworkStatus.disconnected:
        if (!hasConnection) {
          return 'No internet connection. Please check your ${connectionStatusString.toLowerCase()} connection.';
        } else {
          return 'Unable to reach server. Please check your internet connection.';
        }
      case NetworkStatus.unknown:
        return 'Checking connection status...';
    }
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}
