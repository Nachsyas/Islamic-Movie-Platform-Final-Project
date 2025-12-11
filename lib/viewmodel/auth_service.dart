import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Untuk debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- FUNGSI REGISTRASI (DAFTAR) ---
  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      // Melempar pesan error yang lebih mudah dibaca
      if (e.code == 'weak-password') {
        throw 'Password terlalu lemah.';
      } else if (e.code == 'email-already-in-use') {
        throw 'Email ini sudah terdaftar.';
      }
      throw e.message ?? 'Terjadi kesalahan saat registrasi.';
    } catch (e) {
      throw e.toString();
    }
  }

  // --- FUNGSI LOGIN (MASUK) ---
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'user-not-found') {
        throw 'Email tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        throw 'Password salah.';
      }
      throw e.message ?? 'Gagal login. Periksa koneksi internet.';
    } catch (e) {
      throw e.toString();
    }
  }

  // --- FUNGSI LOGOUT (KELUAR) ---
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // --- CEK STATUS LOGIN ---
  User? get currentUser => _auth.currentUser;
}