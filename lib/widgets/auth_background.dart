import 'dart:async';
import 'package:flutter/material.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> {
  int _currentIndex = 0;
  Timer? _timer;
  
  // LIST GAMBAR DIPERBAIKI (Gunakan w500 atau original agar lebih stabil)
  final List<String> _bgImages = [
    "https://www.themoviedb.org/t/p/w600_and_h900_face/tu4BWsGFHcYDWulZwHxylA91vo0.jpg", // Kurulus Osman
    "https://www.themoviedb.org/t/p/w600_and_h900_face/qVCBMg4ZuLPnWhIWJHD9IP4nIuY.jpg", // The Message
    "https://www.themoviedb.org/t/p/w600_and_h900_face/yLxq3KAuKeRHtEVR64QLrSPft6J.jpg",   // Omar
    "https://www.themoviedb.org/t/p/w600_and_h900_face/xzTAM0yaOKkdD4C2tVbdHilcNAc.jpg",       // Fetih 1453
    // Jika gambar di atas mati, kita tambahkan gambar fallback yang pasti jalan (Unsplash)
    "https://www.themoviedb.org/t/p/w600_and_h900_face/dujTx4ZNu1xgIVMV22nge0jfwRs.jpg", // Masjid Estetik
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _bgImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Gambar Background Animasi (DENGAN ERROR HANDLING)
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: SizedBox(
              key: ValueKey<int>(_currentIndex),
              width: double.infinity,
              height: double.infinity,
              // Menggunakan Image.network agar bisa pakai errorBuilder
              child: Image.network(
                _bgImages[_currentIndex],
                fit: BoxFit.cover,
                // ERROR HANDLER: Jika gambar gagal load (404), tampilkan warna hitam, JANGAN CRASH
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF1B1D2A), // Warna background aplikasi
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(color: Colors.black); // Tampilkan hitam saat loading
                },
              ),
            ),
          ),
        ),
        
        // 2. Overlay Hitam (Gradient)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9), 
                ],
              ),
            ),
          ),
        ),

        // 3. Konten
        SafeArea(child: widget.child),
      ],
    );
  }
}