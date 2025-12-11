import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Pastikan file ini ada

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kDarkBlue = Color(0xFF1B1D2A);
    const Color kAccentBlue = Color(0xFF6A53F0);

    return MaterialApp(
      title: 'Islamic Movie Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kAccentBlue,
        scaffoldBackgroundColor: kDarkBlue,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
             fontSize: 20,
             fontWeight: FontWeight.w600
           ),
        ),

         inputDecorationTheme: InputDecorationTheme( 
          filled: true,
          fillColor: Colors.black.withOpacity(0.3), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Colors.grey.shade400),
          prefixIconColor: Colors.grey.shade400,
          // contentPadding dihapus dari sini, diatur di tiap field
        ),

         bottomNavigationBarTheme: BottomNavigationBarThemeData(
           backgroundColor: kDarkBlue.withOpacity(0.95),
           selectedItemColor: kAccentBlue,
           unselectedItemColor: Colors.grey,
           elevation: 0,
         ),

    ),
      home: const LoginScreen(),
    );
  }
}