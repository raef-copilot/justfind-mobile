import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static bool _isShowing = false;
  static Timer? _resetTimer;
  
  static void _resetFlag() {
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), () {
      _isShowing = false;
    });
  }
  
  static void showSuccess(String title, String message) {
    // Log to console
    developer.log(
      '✅ SUCCESS: $title - $message',
      name: 'SnackbarHelper',
      time: DateTime.now(),
    );
    if (kDebugMode) {
      print('✅ SUCCESS: $title - $message');
    }
    
    if (_isShowing) return;
    _isShowing = true;
    
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
      onTap: (_) {
        _isShowing = false;
        _resetTimer?.cancel();
      },
      isDismissible: true,
    );
    _resetFlag();
  }
  
  static void showError(String title, String message, [StackTrace? stackTrace]) {
    // Log to console with stack trace
    developer.log(
      '❌ ERROR: $title - $message',
      name: 'SnackbarHelper',
      error: message,
      stackTrace: stackTrace ?? StackTrace.current,
      time: DateTime.now(),
    );
    if (kDebugMode) {
      print('❌ ERROR: $title - $message');
      if (stackTrace != null) {
        print('Stack trace:\n$stackTrace');
      } else {
        print('Stack trace:\n${StackTrace.current}');
      }
    }
    
    if (_isShowing) return;
    _isShowing = true;
    
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
      onTap: (_) {
        _isShowing = false;
        _resetTimer?.cancel();
      },
      isDismissible: true,
    );
    _resetFlag();
  }
  
  static void showInfo(String title, String message) {
    // Log to console
    developer.log(
      'ℹ️ INFO: $title - $message',
      name: 'SnackbarHelper',
      time: DateTime.now(),
    );
    if (kDebugMode) {
      print('ℹ️ INFO: $title - $message');
    }
    
    if (_isShowing) return;
    _isShowing = true;
    
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      onTap: (_) {
        _isShowing = false;
        _resetTimer?.cancel();
      },
      isDismissible: true,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info, color: Colors.white),
    );
    _resetFlag();
  }
  
  static void showWarning(String title, String message) {
    // Log to console
    developer.log(
      '⚠️ WARNING: $title - $message',
      name: 'SnackbarHelper',
      time: DateTime.now(),
    );
    if (kDebugMode) {
      print('⚠️ WARNING: $title - $message');
    }
    
    if (_isShowing) return;
    _isShowing = true;
    
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning, color: Colors.white),
      onTap: (_) {
        _isShowing = false;
        _resetTimer?.cancel();
      },
      isDismissible: true,
    );
    _resetFlag();
  }
}
