// Lokasi: lib/viewmodel/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/foundation.dart'; 

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _userCollection = 'users'; 

  // --- Fungsi createUserDocument (TANPA USERNAME) ---
  Future<void> createUserDocument({
    required User user,
    required String email, 
  }) async {
    try {
      await _db.collection(_userCollection).doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(), 
      });
      debugPrint('--> Dokumen user berhasil dibuat untuk UID: ${user.uid}'); 
    } catch (e, stackTrace) { 
      debugPrint('--> Error saat membuat dokumen user: $e'); 
      debugPrint('--> StackTrace: $stackTrace');
      rethrow; 
    }
  }

  // Fungsi getEmailFromUsername dan isUsernameTaken sudah dihapus
}