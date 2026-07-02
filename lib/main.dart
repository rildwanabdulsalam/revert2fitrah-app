import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/home_shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  runApp(Revert2FitrahApp(state: state));
}

class Revert2FitrahApp extends StatelessWidget {
  const Revert2FitrahApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: state,
      child: Consumer<AppState>(
        builder: (context, state, _) => MaterialApp(
          title: 'Revert2Fitrah',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: state.isSignedIn ? const HomeShell() : const OnboardingScreen(),
        ),
      ),
    );
  }
}
