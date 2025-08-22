import 'package:flutter/foundation.dart';

import '../services/network_service.dart';
import 'network_provider.dart';

abstract class BaseProvider extends ChangeNotifier {
  final NetworkProvider _networkProvider = NetworkProvider();

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Error handling
  String? _error;
  String? get error => _error;
  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  // Network-aware getters
  bool get hasNetworkConnection => _networkProvider.isConnected;
  NetworkStatus get networkStatus => _networkProvider.networkStatus;
  String get networkErrorMessage => _networkProvider.getNetworkErrorMessage();

  /// Execute API call with network-aware error handling
  Future<T> executeNetworkCall<T>(
    Future<T> Function() apiCall, {
    String? customErrorMessage,
    bool showLoadingState = true,
    bool clearErrorFirst = true,
  }) async {
    try {
      if (clearErrorFirst) error = null;
      if (showLoadingState) isLoading = true;

      // Ensure network provider is initialized
      if (!_networkProvider.isInitialized) {
        await _networkProvider.initialize();
      }

      // Pre-check network connectivity for critical operations
      if (!_networkProvider.isConnected) {
        throw Exception(_networkProvider.getNetworkErrorMessage());
      }

      // Execute the API call
      final result = await apiCall();

      // Clear any previous network errors on success
      if (isNetworkError(error)) {
        error = null;
      }

      return result;
    } catch (e) {
      // Handle network-specific errors
      String errorMessage = customErrorMessage ?? e.toString();

      if (isNetworkError(errorMessage)) {
        // For network errors, get updated status and provide contextual message
        await _networkProvider.checkConnectivity(forceCheck: true);
        errorMessage = _networkProvider.getNetworkErrorMessage();
      }

      error = errorMessage;
      rethrow;
    } finally {
      if (showLoadingState) isLoading = false;
    }
  }

  /// Execute API call with automatic retry on network issues
  Future<T> executeWithRetry<T>(
    Future<T> Function() apiCall, {
    int maxRetries = 2,
    Duration retryDelay = const Duration(seconds: 2),
    String? customErrorMessage,
  }) async {
    int attempts = 0;

    while (attempts <= maxRetries) {
      try {
        return await executeNetworkCall(
          apiCall,
          customErrorMessage: customErrorMessage,
          showLoadingState: attempts == 0, // Only show loading on first attempt
          clearErrorFirst: attempts == 0, // Only clear error on first attempt
        );
      } catch (e) {
        attempts++;

        // If it's a network error and we have retries left, wait and retry
        if (isNetworkError(e.toString()) && attempts <= maxRetries) {
          debugPrint(
            'Network error, retrying in ${retryDelay.inSeconds}s... ($attempts/${maxRetries + 1})',
          );
          await Future.delayed(retryDelay);

          // Wait for network to be restored if needed
          try {
            await _networkProvider.waitForConnection(timeout: retryDelay);
          } catch (_) {
            // Continue with retry even if wait times out
          }

          continue;
        }

        // If we've exhausted retries or it's not a network error, rethrow
        rethrow;
      }
    }

    throw Exception('Unexpected error in retry logic');
  }

  /// Wait for network connection to be restored
  Future<void> waitForNetworkConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!_networkProvider.isInitialized) {
      await _networkProvider.initialize();
    }
    await _networkProvider.waitForConnection(timeout: timeout);
  }

  /// Check if error is network-related (public method for UI access)
  bool isNetworkError(String? errorMessage) {
    if (errorMessage == null) return false;
    return _networkProvider.isNetworkError(errorMessage);
  }

  /// Get appropriate retry button text based on network status
  String getRetryButtonText() {
    if (!_networkProvider.isInitialized) return 'Retry';
    return _networkProvider.getRetryMessage();
  }

  /// Check if the current error is a network error
  bool get hasNetworkError => isNetworkError(error);

  @override
  void dispose() {
    _networkProvider.dispose();
    super.dispose();
  }
}
