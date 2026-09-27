import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProWorkApp());
}

class ProWorkApp extends StatefulWidget {
  const ProWorkApp({super.key});

  @override
  State<ProWorkApp> createState() => _ProWorkAppState();
}

class _ProWorkAppState extends State<ProWorkApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        if (_appState.isLoading) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              backgroundColor: AppTheme.background,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          title: _appState.projectData.projectName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          home: _appState.isAuthenticated
              ? HomeScreen(appState: _appState)
              : LoginScreen(appState: _appState),
        );
      },
    );
  }
}
