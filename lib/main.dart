import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const NhatNguyetApp());
}

class NhatNguyetApp extends StatelessWidget {
  const NhatNguyetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nhật Nguyệt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const MainNavigationScreen(),
    );
  }
}
