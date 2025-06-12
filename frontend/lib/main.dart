import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'src/providers/video_provider.dart';
import 'src/screens/home_screen.dart';
import 'src/constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoProvider(),
      child: MaterialApp(
        title: 'Veo3',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: AppColors.accentBlue,
            onPrimary: Colors.white,
            secondary: AppColors.charcoal,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: AppColors.scaffoldLight,
            onBackground: AppColors.textLight,
            surface: AppColors.white,
            onSurface: AppColors.textLight,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
          scaffoldBackgroundColor: AppColors.scaffoldLight,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.charcoal,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: AppColors.accentBlue,
            onPrimary: Colors.white,
            secondary: AppColors.charcoal,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: AppColors.scaffoldDark,
            onBackground: AppColors.textDark,
            surface: AppColors.charcoal,
            onSurface: AppColors.textDark,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
          scaffoldBackgroundColor: AppColors.scaffoldDark,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.charcoal,
            foregroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('tr', ''),
        ],
        home: const HomeScreen(),
      ),
    );
  }
}
