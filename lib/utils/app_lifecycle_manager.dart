import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

/// App lifecycle manager to handle app state changes
/// Useful for refreshing data when app comes back from background
class AppLifecycleManager extends WidgetsBindingObserver {
  final Function()? onResume;
  final Function()? onPause;
  final Function()? onInactive;
  final Function()? onDetached;

  Timer? _resumeTimer;
  DateTime? _pausedTime;

  AppLifecycleManager({
    this.onResume,
    this.onPause,
    this.onInactive,
    this.onDetached,
  });

  /// Initialize the lifecycle manager
  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Dispose of the lifecycle manager
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _resumeTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _handleResume();
        break;
      case AppLifecycleState.inactive:
        onInactive?.call();
        break;
      case AppLifecycleState.paused:
        _handlePause();
        break;
      case AppLifecycleState.detached:
        onDetached?.call();
        break;
      case AppLifecycleState.hidden:
        // Handle hidden state (new in Flutter 3.13+)
        break;
    }
  }

  void _handlePause() {
    _pausedTime = DateTime.now();
    onPause?.call();
    debugPrint('App paused at $_pausedTime');
  }

  void _handleResume() {
    if (_pausedTime != null) {
      final pauseDuration = DateTime.now().difference(_pausedTime!);
      debugPrint('App resumed after ${pauseDuration.inSeconds}s');

      // If app was paused for more than 5 minutes, trigger resume callback
      if (pauseDuration.inMinutes >= 5) {
        debugPrint('Long pause detected, refreshing...');
        onResume?.call();
      }
    }

    // Add a small delay before calling resume to let the app settle
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(milliseconds: 500), () {
      onResume?.call();
    });
  }

  /// Check if app was paused for a long time
  bool wasLongPause({Duration threshold = const Duration(minutes: 5)}) {
    if (_pausedTime == null) return false;
    return DateTime.now().difference(_pausedTime!) > threshold;
  }
}

/// Mixin for widgets that need to handle app lifecycle
mixin AppLifecycleAware<T extends StatefulWidget> on State<T> {
  late AppLifecycleManager _lifecycleManager;

  @override
  void initState() {
    super.initState();
    _lifecycleManager = AppLifecycleManager(
      onResume: onAppResumed,
      onPause: onAppPaused,
      onInactive: onAppInactive,
    );
    _lifecycleManager.initialize();
  }

  @override
  void dispose() {
    _lifecycleManager.dispose();
    super.dispose();
  }

  /// Override this method to handle app resume
  void onAppResumed() {
    debugPrint('${T.toString()} - App resumed');
  }

  /// Override this method to handle app pause
  void onAppPaused() {
    debugPrint('${T.toString()} - App paused');
  }

  /// Override this method to handle app inactive state
  void onAppInactive() {
    debugPrint('${T.toString()} - App inactive');
  }
}

/// Extension to check if the app is currently in foreground
extension AppLifecycleExtension on WidgetsBinding {
  bool get isAppInForeground {
    return SchedulerBinding.instance.lifecycleState ==
        AppLifecycleState.resumed;
  }

  bool get isAppInBackground {
    final state = SchedulerBinding.instance.lifecycleState;
    return state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive;
  }
}
