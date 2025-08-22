import 'package:flutter/material.dart';
import 'dart:async';
import '../services/network_service.dart';

class NetworkProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<NetworkStatus>? _networkSubscription;

  NetworkStatus _networkStatus = NetworkStatus.unknown;
  bool _isInitialized = false;
  String? _lastErrorMessage;

  // Getters
  NetworkStatus get networkStatus => _networkStatus;
  bool get isConnected => _networkStatus == NetworkStatus.connected;
  bool get isDisconnected => _networkStatus == NetworkStatus.disconnected;
  bool get isInitialized => _isInitialized;
  String? get lastErrorMessage => _lastErrorMessage;
  String get connectionStatusString =>
      _connectivityService.connectionStatusString;

  /// Initialize the network provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _connectivityService.initialize();
      _networkStatus = _connectivityService.networkStatus;

      // Listen to network status changes
      _networkSubscription = _connectivityService.networkStatusStream.listen((
        NetworkStatus status,
      ) {
        final wasConnected = _networkStatus == NetworkStatus.connected;
        _networkStatus = status;

        // Update error message based on status
        if (status == NetworkStatus.disconnected) {
          _lastErrorMessage = _connectivityService.getNetworkErrorMessage();
        } else if (status == NetworkStatus.connected && !wasConnected) {
          _lastErrorMessage = null; // Clear error when connection is restored
        }

        notifyListeners();
      });

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('NetworkProvider initialization error: $e');
      _networkStatus = NetworkStatus.disconnected;
      _lastErrorMessage = 'Failed to initialize network monitoring';
      notifyListeners();
    }
  }

  /// Force check network connectivity
  Future<bool> checkConnectivity({bool forceCheck = false}) async {
    try {
      final hasConnection = await _connectivityService.checkInternetConnection(
        forceCheck: forceCheck,
      );

      if (!hasConnection && _networkStatus == NetworkStatus.connected) {
        _networkStatus = NetworkStatus.disconnected;
        _lastErrorMessage = _connectivityService.getNetworkErrorMessage();
        notifyListeners();
      } else if (hasConnection && _networkStatus != NetworkStatus.connected) {
        _networkStatus = NetworkStatus.connected;
        _lastErrorMessage = null;
        notifyListeners();
      }

      return hasConnection;
    } catch (e) {
      debugPrint('Network check error: $e');
      return false;
    }
  }

  /// Wait for network connection to be restored
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (isConnected) return;

    try {
      await _connectivityService.waitForConnection(timeout: timeout);
    } on TimeoutException {
      throw TimeoutException(
        'Network connection not restored within ${timeout.inSeconds} seconds',
      );
    }
  }

  /// Get user-friendly network error message
  String getNetworkErrorMessage() {
    return _connectivityService.getNetworkErrorMessage();
  }

  /// Check if an error is network-related
  bool isNetworkError(String errorMessage) {
    final lowerError = errorMessage.toLowerCase();
    return lowerError.contains('no internet') ||
        lowerError.contains('connection') ||
        lowerError.contains('network') ||
        lowerError.contains('timeout') ||
        lowerError.contains('socketexception');
  }

  /// Get appropriate retry message based on network status
  String getRetryMessage() {
    switch (_networkStatus) {
      case NetworkStatus.connected:
        return 'Retry';
      case NetworkStatus.disconnected:
        return 'Check connection & retry';
      case NetworkStatus.unknown:
        return 'Checking connection...';
    }
  }

  @override
  void dispose() {
    _networkSubscription?.cancel();
    super.dispose();
  }
}
