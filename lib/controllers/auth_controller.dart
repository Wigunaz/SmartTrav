import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // 1. FUNGSI REGISTER
  // FUNGSI REGISTER BARU YANG LEBIH BERSIH & AMAN
  Future<String?> signUp({
    required String email,
    required String password,
    required String namaLengkap,
    required String role,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Kita titipkan nama_lengkap dan role ke dalam dataOptions userMetadata Supabase
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'nama_lengkap': namaLengkap,
          'role': role,
        },
      );

      if (response.user != null) {
        return null; // Sukses, trigger di server yang akan mengurus insert ke public.users
      }
      return 'Registration failed';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. FUNGSI LOGIN
  Future<String?> signIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      return null; // Login Sukses
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. FUNGSI RESET PASSWORD (FORGET PASSWORD)
  Future<String?> resetPassword({required String email}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mengirim email berisi tautan reset password otomatis
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // Pengiriman Berhasil
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. FUNGSI LOGIN WITH GOOGLE (OAUTH)
  Future<String?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.smarttrav.app://login-callback',
        // PAKSA GOOGLE BUAT SELALU NAMPILIN POP-UP PILIH AKUN
        queryParams: {
          'prompt': 'select_account',
        },
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}