import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nxl_flutter_auth_task/model/auth_model.dart';
import 'package:nxl_flutter_auth_task/model/user_model.dart';

class AuthController {
  final AuthModel _authModel;

  AuthController(this._authModel);

  UserModel? getCurrentUser() {
    final user = _authModel.getCurrentUser();
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      // Validate input
      final validation = _validateLoginInput(email, password);
      if (!validation.isValid) {
        return AuthResult(success: false, error: validation.error);
      }

      // Attempt login
      await _authModel.signInWithEmailPassword(email, password);
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        error: _handleFirebaseAuthError(e),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<AuthResult> register(
      String name, String email, String password, String confirmPassword) async {
    try {
      // Validate input
      final validation = _validateRegisterInput(
        name,
        email,
        password,
        confirmPassword,
      );
      if (!validation.isValid) {
        return AuthResult(success: false, error: validation.error);
      }

      // Attempt registration
      await _authModel.registerWithEmailPassword(email, password);
      await _authModel.updateDisplayName(name);
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        error: _handleFirebaseAuthError(e),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> logout() async {
    await _authModel.signOut();
  }

  // Validation methods
  ValidationResult _validateLoginInput(String email, String password) {
    if (email.isEmpty) {
      return ValidationResult(isValid: false, error: 'Email is required');
    }
    if (!_isValidEmail(email)) {
      return ValidationResult(
          isValid: false, error: 'Enter a valid email address');
    }
    if (password.isEmpty) {
      return ValidationResult(isValid: false, error: 'Password is required');
    }
    if (password.length < 6) {
      return ValidationResult(
          isValid: false, error: 'Password must be at least 6 characters');
    }
    return ValidationResult(isValid: true);
  }

  ValidationResult _validateRegisterInput(
      String name, String email, String password, String confirmPassword) {
    if (name.isEmpty) {
      return ValidationResult(isValid: false, error: 'Name is required');
    }
    if (name.length < 2) {
      return ValidationResult(
          isValid: false, error: 'Name must be at least 2 characters');
    }
    if (email.isEmpty) {
      return ValidationResult(isValid: false, error: 'Email is required');
    }
    if (!_isValidEmail(email)) {
      return ValidationResult(
          isValid: false, error: 'Enter a valid email address');
    }
    if (password.isEmpty) {
      return ValidationResult(isValid: false, error: 'Password is required');
    }
    if (password.length < 6) {
      return ValidationResult(
          isValid: false, error: 'Password must be at least 6 characters');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return ValidationResult(
        isValid: false,
        error: 'Password must contain at least one uppercase letter',
      );
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return ValidationResult(
        isValid: false,
        error: 'Password must contain at least one number',
      );
    }
    if (confirmPassword.isEmpty) {
      return ValidationResult(
          isValid: false, error: 'Please confirm your password');
    }
    if (password != confirmPassword) {
      return ValidationResult(
          isValid: false, error: 'Passwords do not match');
    }
    return ValidationResult(isValid: true);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}

// Helper classes
class AuthResult {
  final bool success;
  final String? error;

  AuthResult({required this.success, this.error});
}

class ValidationResult {
  final bool isValid;
  final String? error;

  ValidationResult({required this.isValid, this.error});
}

// Riverpod providers
final authModelProvider = Provider<AuthModel>((ref) => AuthModel());

final authControllerProvider = Provider<AuthController>((ref) {
  final authModel = ref.watch(authModelProvider);
  return AuthController(authModel);
});
