import 'package:flutter/material.dart';

class AppTheme {
  // Choose a single brand color; the rest is generated from it
  //static const _seed = Color(0xFF2B5CE7); // Indigo-ish blue
  static const _seed = Colors.white;

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    final colors = ColorScheme.fromSeed(
      primary: Colors.orange,
      onPrimary: Colors.black,
      seedColor: _seed,
      brightness: Brightness.light,
    );
    final texts = _buildTextTheme(base.textTheme);

    return base.copyWith(
      colorScheme: colors,
      textTheme: texts,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      visualDensity: VisualDensity.standard,
    );
  }

  static ThemeData get dark {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
    final colors = ColorScheme.fromSeed(
      primary: Colors.orange,
      onPrimary: Colors.black,
      seedColor: _seed,
      brightness: Brightness.dark,
    );
    final texts = _buildTextTheme(base.textTheme);

    return base.copyWith(
      colorScheme: colors,
      textTheme: texts,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      visualDensity: VisualDensity.standard,
    );
  }

  /// Increase base sizes a bit for readability and tweak key roles used in UI
  static TextTheme _buildTextTheme(TextTheme base) {
    // Avoid global apply(fontSizeFactor) because some TextStyles have null fontSize
    // which triggers an assertion when applying a factor. Instead, tweak only
    // the roles we actually use and provide safe fallbacks.
    final titleLargeSize = base.titleLarge?.fontSize ?? 22.0;
    final titleMediumSize = base.titleMedium?.fontSize ?? 16.0;

    return base.copyWith(
      // Home cards use these frequently
      titleLarge: (base.titleLarge ?? const TextStyle()).copyWith(
        fontSize: titleLargeSize,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: (base.titleMedium ?? const TextStyle()).copyWith(
        fontSize: titleMediumSize,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: (base.bodyLarge ?? const TextStyle()).copyWith(height: 1.3),
      bodyMedium: (base.bodyMedium ?? const TextStyle()).copyWith(height: 1.3),
    );
  }
}
