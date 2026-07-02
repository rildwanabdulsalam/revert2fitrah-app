import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/home_shell.dart';
import 'services/quran_api.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  final quranApi = QuranApiService(await SharedPreferences.getInstance());
  runApp(Revert2FitrahApp(state: state, quranApi: quranApi));
}

class Revert2FitrahApp extends StatelessWidget {
  const Revert2FitrahApp({
    super.key,
    required this.state,
    required this.quranApi,
  });

  final AppState state;
  final QuranApiService quranApi;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: state),
        Provider<QuranApiService>.value(value: quranApi),
      ],
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
