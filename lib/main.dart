import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justfind_app/app/dependency_injection.dart';
import 'package:justfind_app/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    developer.log(
      '❌ FLUTTER ERROR',
      name: 'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
      time: DateTime.now(),
    );
    if (kDebugMode) {
      print('❌ FLUTTER ERROR: ${details.exception}');
      print('Stack trace:\n${details.stack}');
    }
  };
  
  // Catch errors in async code
  PlatformDispatcher.instance.onError = (error, stack) {
    developer.log(
      '❌ PLATFORM ERROR',
      name: 'PlatformError',
      error: error,
      stackTrace: stack,
      time: DateTime.now(),
    );
    if (kDebugMode) {
      print('❌ PLATFORM ERROR: $error');
      print('Stack trace:\n$stack');
    }
    return true;
  };
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Initialize dependencies
  await DependencyInjection.init();
  
  runApp(const MyApp());
}
