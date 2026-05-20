import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_list_bloc.dart';
import 'package:spacebar/features/home/presentation/pages/home_page.dart';
import 'package:spacebar/features/evi_store/presentation/bloc/evi_store_bloc/evi_store_bloc.dart';
import 'package:spacebar/init_deps.dart';

const String _windowsMetaKeyAssertion =
    'Attempted to send a key down event when no keys are in keysPressed';

void main() async {
  _installDebugKeyboardAssertionFilter();
  WidgetsFlutterBinding.ensureInitialized();
  await initDeps();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<EviBloc>()),
        BlocProvider(create: (_) => serviceLocator<EviListBloc>()),
      ],
      child: const MainApp(),
    ),
  );
}

void _installDebugKeyboardAssertionFilter() {
  var enabled = false;
  assert(() {
    enabled = true;
    return true;
  }());
  if (!enabled) return;

  final original = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final message = details.exceptionAsString();

    // Workaround for a known Windows Meta key raw keyboard assertion in debug.
    if (message.contains(_windowsMetaKeyAssertion)) {
      debugPrint('Ignored known Windows keyboard assertion: $message');
      return;
    }

    if (original != null) {
      original(details);
      return;
    }
    FlutterError.presentError(details);
  };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const HomePage(),
    );
  }

  ThemeData _buildTheme() {
    const primary = Color(0xFF0B57D0);
    const secondary = Color(0xFF0D7A5F);
    const tertiary = Color(0xFF6941C6);
    const bg = Color(0xFFF4F6FA);
    const surface = Color(0xFFFFFFFF);
    const cardBg = Color(0xFFFFFFFF);
    const textPrimary = Color(0xFF0F1C2E);
    const textSecondary = Color(0xFF52637A);

    final cs = ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceContainerHighest: const Color(0xFFE8EDF5),
      outline: const Color(0xFFDDE5F0),
      outlineVariant: const Color(0xFFEEF3FA),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: bg,
      cardColor: cardBg,
      fontFamily: 'System',
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        iconTheme: IconThemeData(color: textSecondary),
      ),
      dividerColor: const Color(0xFFDDE5F0),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
      ),
      iconTheme: const IconThemeData(color: textSecondary),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: Color(0xFFDDE5F0),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? primary : Colors.transparent,
        ),
        side: const BorderSide(color: Color(0xFFDDE5F0), width: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF0F1C2E),
        contentTextStyle: TextStyle(color: Color(0xFFEEF3FA)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        displayMedium: TextStyle(color: textPrimary),
        displaySmall: TextStyle(color: textPrimary),
        headlineLarge: TextStyle(color: textPrimary),
        headlineMedium: TextStyle(color: textPrimary),
        headlineSmall: TextStyle(color: textPrimary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textSecondary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: textPrimary),
        labelMedium: TextStyle(color: textSecondary),
        labelSmall: TextStyle(color: textSecondary),
      ),
    );
  }
}
