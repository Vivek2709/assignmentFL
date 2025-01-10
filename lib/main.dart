import 'package:flutter/material.dart';
import 'package:assignment/screens/splash_screen.dart';
import 'package:assignment/screens/bottom_nav.dart';
import 'package:assignment/screens/details_screen.dart';
import 'package:assignment/models/movie_model.dart';
import 'package:assignment/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const BottomNavScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final movie = settings.arguments as Movie;
          return MaterialPageRoute(
            builder: (context) => DetailsScreen(movie: movie),
          );
        }
        return null;
      },
    );
  }
}
