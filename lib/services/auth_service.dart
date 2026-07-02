import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  const AuthUser({required this.uid, required this.name, required this.email});

  final String uid;
  final String name;
  final String email;
}

/// Thrown by [AuthService] with a message safe to show in the UI.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Auth seam. [LocalAuthService] keeps everything on device;
/// [FirebaseAuthService] is used automatically once real Firebase options
/// are in place (see firebase_options.dart / FIREBASE_SETUP.md).
abstract class AuthService {
  AuthUser? get currentUser;

  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<AuthUser> logIn({required String email, required String password});

  Future<void> signOut();
}

class LocalAuthService implements AuthService {
  LocalAuthService(this._prefs);

  final SharedPreferences _prefs;

  @override
  AuthUser? get currentUser {
    final email = _prefs.getString('user.email') ?? '';
    if (email.isEmpty) return null;
    return AuthUser(
      uid: 'local',
      name: _prefs.getString('user.name') ?? '',
      email: email,
    );
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _prefs.setString('user.name', name);
    await _prefs.setString('user.email', email);
    return currentUser!;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    await _prefs.setString('user.email', email);
    if ((_prefs.getString('user.name') ?? '').isEmpty) {
      final guess = email.split('@').first;
      await _prefs.setString(
        'user.name',
        guess.isEmpty ? 'Friend' : guess[0].toUpperCase() + guess.substring(1),
      );
    }
    return currentUser!;
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove('user.name');
    await _prefs.remove('user.email');
  }
}

class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._auth);

  final fb.FirebaseAuth _auth;

  @override
  AuthUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      return AuthUser(uid: credential.user!.uid, name: name, email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e));
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      return AuthUser(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? email,
      );
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  static String _friendlyMessage(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'That email already has an account — try logging in instead.';
      case 'invalid-email':
        return 'That email address doesn\'t look right.';
      case 'weak-password':
        return 'That password is too easy to guess — try a longer one.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password didn\'t match. Have another try.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts — please wait a moment and try again.';
      case 'network-request-failed':
        return 'Couldn\'t reach the server. Check your connection and try again.';
      default:
        return 'Something went wrong (${e.code}). Please try again.';
    }
  }
}
