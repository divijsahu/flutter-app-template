import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Enhanced network utilities for handling slow networks and retries
class NetworkUtils {
  /// Timeout durations based on network quality
  static const Duration fastTimeout = Duration(seconds: 10);
  static const Duration normalTimeout = Duration(seconds: 20);
  static const Duration slowTimeout = Duration(seconds: 30);
  static const Duration verySlowTimeout = Duration(seconds: 45);

  /// Make HTTP request with automatic retries and exponential backoff
  /// Handles slow networks and transient failures gracefully
  static Future<http.Response> makeRequest({
    required Future<http.Response> Function() request,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration timeout = normalTimeout,
    bool useExponentialBackoff = true,
  }) async {
    int retryCount = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        final response = await request().timeout(timeout);
        return response;
      } on TimeoutException catch (e) {
        retryCount++;
        if (retryCount > maxRetries) {
          throw NetworkException(
            'Request timed out after $maxRetries retries',
            type: NetworkErrorType.timeout,
            originalError: e,
          );
        }
        debugPrint(
            'Request timeout, retry $retryCount/$maxRetries after ${delay.inSeconds}s');
        await Future.delayed(delay);
        if (useExponentialBackoff) {
          delay *= 2; // Exponential backoff
        }
      } on SocketException catch (e) {
        retryCount++;
        if (retryCount > maxRetries) {
          throw NetworkException(
            'No internet connection',
            type: NetworkErrorType.noConnection,
            originalError: e,
          );
        }
        debugPrint(
            'Connection error, retry $retryCount/$maxRetries after ${delay.inSeconds}s');
        await Future.delayed(delay);
        if (useExponentialBackoff) {
          delay *= 2;
        }
      } on http.ClientException catch (e) {
        retryCount++;
        if (retryCount > maxRetries) {
          throw NetworkException(
            'Network error occurred',
            type: NetworkErrorType.clientError,
            originalError: e,
          );
        }
        debugPrint(
            'Client error, retry $retryCount/$maxRetries after ${delay.inSeconds}s');
        await Future.delayed(delay);
        if (useExponentialBackoff) {
          delay *= 2;
        }
      } catch (e) {
        // Don't retry on unexpected errors
        throw NetworkException(
          'Unexpected error: $e',
          type: NetworkErrorType.unknown,
          originalError: e,
        );
      }
    }
  }

  /// Check internet connectivity with multiple fallback servers
  /// More reliable than checking just one server
  static Future<bool> hasInternetConnection({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final List<String> testHosts = [
      'google.com',
      'cloudflare.com',
      '1.1.1.1',
    ];

    for (final host in testHosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(timeout);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (e) {
        // Try next host
        continue;
      }
    }
    return false;
  }

  /// Get recommended timeout based on network quality estimation
  static Duration getAdaptiveTimeout({
    Duration? lastRequestDuration,
    bool isSlowNetwork = false,
  }) {
    if (isSlowNetwork) {
      return verySlowTimeout;
    }
    if (lastRequestDuration != null) {
      // If last request took long, use longer timeout
      if (lastRequestDuration.inSeconds > 15) {
        return slowTimeout;
      } else if (lastRequestDuration.inSeconds > 8) {
        return normalTimeout;
      }
    }
    return fastTimeout;
  }

  /// Execute a function with retry logic
  static Future<T> executeWithRetry<T>({
    required Future<T> Function() action,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    bool useExponentialBackoff = true,
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int retryCount = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await action();
      } catch (e) {
        retryCount++;

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        if (retryCount > maxRetries) {
          rethrow;
        }

        debugPrint(
            'Action failed, retry $retryCount/$maxRetries after ${delay.inSeconds}s: $e');
        await Future.delayed(delay);

        if (useExponentialBackoff) {
          delay *= 2;
        }
      }
    }
  }

  /// Check if an error is network-related
  static bool isNetworkError(dynamic error) {
    if (error is NetworkException) return true;
    if (error is SocketException) return true;
    if (error is TimeoutException) return true;
    if (error is http.ClientException) return true;

    final errorString = error.toString().toLowerCase();
    return errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('handshake');
  }

  /// Get user-friendly error message from network error
  static String getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return error.message;
    }
    if (error is SocketException) {
      return 'No internet connection. Please check your network settings.';
    }
    if (error is TimeoutException) {
      return 'Request timed out. Your internet connection may be slow.';
    }
    if (error is http.ClientException) {
      return 'Network error. Please try again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

/// Custom network exception with error type classification
class NetworkException implements Exception {
  final String message;
  final NetworkErrorType type;
  final dynamic originalError;

  NetworkException(
    this.message, {
    required this.type,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// Types of network errors for better error handling
enum NetworkErrorType {
  noConnection,
  timeout,
  serverError,
  clientError,
  unknown,
}
