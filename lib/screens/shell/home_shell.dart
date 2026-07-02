import 'package:flutter/material.dart';

import '../../widgets/pill_nav.dart';
import '../ask/ask_screen.dart';
import '../duas/duas_screen.dart';
import '../home/home_screen.dart';
import '../quran/quran_screen.dart';
import '../solat/solat_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          QuranScreen(),
          SolatScreen(),
          DuasScreen(),
          AskScreen(),
        ],
      ),
      bottomNavigationBar: PillNav(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

/// Bottom padding that clears the floating pill nav on scrollable tabs.
const kPillNavClearance = 96.0;
