import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ← add
import 'package:subscriptions/features/home/ui/homescreen.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.instance.init(); // keep if you already added notifications
  runApp(const ProviderScope(child: AbboKollApp()));
}

class AbboKollApp extends StatelessWidget {
  const AbboKollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Abonnemangskollen',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // ↓↓↓ REQUIRED for DatePicker & Swedish strings
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('sv'), // Swedish
        Locale('en'), // optional fallback
      ],
      locale: const Locale('sv'),

      home: const HomeScreen(),
    );
  }
}
