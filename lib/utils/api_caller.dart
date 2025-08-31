import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:provider_app_template/utils/constants.dart';

import '../services/network_service.dart';

// Custom Exceptions
class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No internet connection']);
}

class RequestTimeoutException implements Exception {
  final String message;
  RequestTimeoutException([this.message = 'Request timed out']);
}

class DuplicateException implements Exception {
  final String message;
  DuplicateException([this.message = 'Duplicate entry found']);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'Unauthorized access']);
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class ClientException implements Exception {
  late String message;
  ClientException(String msg) {
    message = msg;
  }
}

// Exception for Subscription-related errors
class SubscriptionException implements Exception {
  final String message;
  SubscriptionException([this.message = 'Subscription error occurred']);
}

class ApiCaller {
  static const int _maxRetries = 2; // Increased retries for network issues
  static const Duration _timeoutDuration = Duration(seconds: 30);
  static const Duration _retryDelay =
      Duration(milliseconds: 1500); // Delay between retries

  final ConnectivityService _connectivityService = ConnectivityService();

  // Standard HTTP methods with network pre-checks
  Future<http.Response> getRequest(String url) async {
    await _ensureConnectivity();
    return await _makeRequest(
      () => http.get(Uri.parse(url), headers: AppConstants.API_HEADER),
    );
  }

  Future<http.Response> postRequest(
    String url,
    Map<String, dynamic> data,
  ) async {
    await _ensureConnectivity();
    return await _makeRequest(
      () => http.post(
        Uri.parse(url),
        headers: AppConstants.API_HEADER,
        body: jsonEncode(data),
      ),
    );
  }

  Future<http.Response> putRequest(
    String url,
    Map<String, dynamic> data,
  ) async {
    await _ensureConnectivity();
    return await _makeRequest(
      () => http.put(
        Uri.parse(url),
        headers: AppConstants.API_HEADER,
        body: jsonEncode(data),
      ),
    );
  }

  Future<http.Response> deleteRequest(String url) async {
    await _ensureConnectivity();
    return await _makeRequest(
      () => http.delete(Uri.parse(url), headers: AppConstants.API_HEADER),
    );
  }

  /// Ensure network connectivity before making requests
  Future<void> _ensureConnectivity() async {
    if (!_connectivityService.isConnected) {
      // Force check connectivity
      final hasInternet =
          await _connectivityService.checkInternetConnection(forceCheck: true);
      if (!hasInternet) {
        throw NoInternetException(
            _connectivityService.getNetworkErrorMessage());
      }
    }
  }

  Future<http.Response> _makeRequest(
    Future<http.Response> Function() requestFn, {
    int retries = 0,
  }) async {
    try {
      final response = await requestFn().timeout(_timeoutDuration);
      return _processResponse(response);
    } on TimeoutException {
      if (retries < _maxRetries) {
        log('Request timeout, retrying... (${retries + 1}/$_maxRetries)');
        await Future.delayed(_retryDelay);
        return await _makeRequest(requestFn, retries: retries + 1);
      }
      throw RequestTimeoutException(
          'Request timed out after $_maxRetries retries');
    } on SocketException {
      if (retries < _maxRetries) {
        log('Network error, retrying... (${retries + 1}/$_maxRetries)');
        await Future.delayed(_retryDelay);
        // Re-check connectivity before retry
        await _ensureConnectivity();
        return await _makeRequest(requestFn, retries: retries + 1);
      }
      throw NoInternetException(_connectivityService.getNetworkErrorMessage());
    } catch (e) {
      // For other HTTP errors, don't retry but log the error
      log('API Caller Error: $e', name: 'ApiCaller');
      rethrow;
    }
  }

  http.Response _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 204:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 226:
        throw DuplicateException(_getErrorMessageFromResponse(response));
      case 400:
      case 422:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 401:
        AppConstants.clearTokens();
        throw UnauthorizedException(_getErrorMessageFromResponse(response));
      case 403:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 404:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 408:
        throw RequestTimeoutException();
      case 409:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 413:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 415:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 417:
        AppConstants.IS_SUBSCRIPTION_ACTIVE = false;
        throw SubscriptionException(_getErrorMessageFromResponse(response));
      case 426:
        AppConstants.clearTokens();
        throw ClientException(_getErrorMessageFromResponse(response));
      case 429:
        throw ClientException(_getErrorMessageFromResponse(response));
      case 500:
      case 502:
      case 503:
        throw ServerException(_getErrorMessageFromResponse(response));
      default:
        throw Exception('Unexpected error: ${response.statusCode}');
    }
  }

  String _getErrorMessageFromResponse(http.Response response) {
    try {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      return errorResponse['message'] ?? 'Error: ${response.statusCode}';
    } catch (_) {
      return 'Error: ${response.statusCode}';
    }
  }

  /// Returns user-friendly error messages based on exception type.
  String getErrorMessageFromException(dynamic error) {
    log('Error occurred: $error', name: 'ApiCaller');
    if (error is ClientException) return error.message;
    if (error is ServerException) return error.message;
    if (error is SubscriptionException) return error.message;
    if (error is DuplicateException) return error.message;

    if (error is UnauthorizedException) {
      return error.message;
    }
    if (error is NoInternetException) {
      return error
          .message; // Now contains more context from connectivity service
    }
    if (error is RequestTimeoutException) {
      return error.message; // Now contains retry information
    }
    return 'An unexpected error occurred, please try again.';
  }
}
