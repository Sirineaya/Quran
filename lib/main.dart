import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/surah_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const QuranRecitationApp());
}

class QuranRecitationApp extends StatelessWidget {
  const QuranRecitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Recitation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SurahListScreen(),
    );
  }
}
