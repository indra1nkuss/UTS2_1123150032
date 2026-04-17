import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/services/secure_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, emailNotVerified, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthStatus _status = AuthStatus.initial;
  String? errorMessage;
  Timer? _timer;

  AuthStatus get status => _status;
  bool get isLoading => _status == AuthStatus.loading;

  Future<void> register(String email, String password, String name) async {
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(name);
      await cred.user?.sendEmailVerification();
      _status = AuthStatus.emailNotVerified;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (cred.user?.emailVerified ?? false) {
        await _verifyBackend();
      } else {
        _status = AuthStatus.emailNotVerified;
      }
    } catch (e) {
      errorMessage = "Login gagal. Periksa email/password.";
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> _verifyBackend() async {
    try {
      String? token = await _auth.currentUser?.getIdToken();
      if (token != null) {
        final backendJwt = await _repository.verifyFirebaseToken(token);
        await SecureStorageService.saveToken(backendJwt);
        _status = AuthStatus.authenticated;
      }
    } catch (e) {
      errorMessage = "Server error";
      _status = AuthStatus.error;
    }
  }

  void startVerificationCheck(VoidCallback onSuccess) {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _auth.currentUser?.reload();
      if (_auth.currentUser?.emailVerified ?? false) {
        timer.cancel();
        await _verifyBackend();
        onSuccess();
      }
    });
  }

  void stopCheck() => _timer?.cancel();

  Future<void> logout() async {
    await _auth.signOut();
    await SecureStorageService.deleteToken();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}