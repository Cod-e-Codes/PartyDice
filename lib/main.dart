import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import '../screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully.');
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  // Run the app
  runApp(const PartyDiceApp());
}

class PartyDiceApp extends StatelessWidget {
  const PartyDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil here
    ScreenUtil.init(
      context,
      designSize: const Size(432, 864),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return MaterialApp(
      home: const LoginScreen(), // Directly navigate to the LoginScreen
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}
