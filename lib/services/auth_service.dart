import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A simple configuration class to toggle between mock and real backends.
class AppConfig {
  static const bool useMockBackend = true;
  static const bool mockDelete = true;
  static const int referralReward = 100;
  static const int referralBonusAt = 5;
}

/// A custom user class to abstract the Firebase User object from the UI.
class AuthUser {
  final String uid;
  final String? displayName;
  final String? email;
  final double? goalWeightKg;
  final int? birthYear;

  AuthUser({
    required this.uid,
    this.displayName,
    this.email,
    this.goalWeightKg,
    this.birthYear,
  });
}

/// A service to handle all authentication-related tasks, with a mock mode.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // CORRECTED: Use the constructor, not the old `.instance` getter.
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  /// Returns the current user as a custom [AuthUser] object.
  AuthUser? getCurrentUser() {
    if (AppConfig.useMockBackend) {
      return AuthUser(
        uid: 'mock_user_id',
        displayName: 'Test User',
        email: 'test@user.com',
        goalWeightKg: 75.0,
        birthYear: 1995,
      );
    }

    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    return _userFromFirebase(firebaseUser);
  }

  /// Signs in the user with Google.
  Future<AuthUser?> signInWithGoogle() async {
    if (AppConfig.useMockBackend) {
      print("AuthService (Mock): Signing in with Google...");
      return AuthUser(uid: 'mock_google_user', displayName: 'Google User', email: 'google.user@example.com');
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in.
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) return null;
      return _userFromFirebase(user);

    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  /// Signs in a user with the given [email] and [password].
  Future<AuthUser?> signInWithEmail(String email, String password) async {
    if (AppConfig.useMockBackend) {
      print("AuthService (Mock): Signing in with Email...");
       return AuthUser(uid: 'mock_email_user', displayName: 'Email User', email: email);
    }
    try {
       final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return null;
      return _userFromFirebase(user);
    } catch(e) {
      print("Email Sign-In Error: $e" );
      return null;
    }
  }

  /// Signs in the user anonymously.
  Future<AuthUser?> signInAnonymously() async {
    if (AppConfig.useMockBackend) {
      print("AuthService (Mock): Signing in Anonymously...");
      return AuthUser(uid: 'mock_user', displayName: 'Test User');
    }
    try {
       final UserCredential userCredential = await _firebaseAuth.signInAnonymously();
       final user = userCredential.user;
      if (user == null) return null;
      return _userFromFirebase(user);
    } catch(e) {
      print("Anonymous Sign-In Error: $e");
      return null;
    }
  }

  /// Signs out the current user from all providers.
  Future<void> signOut() async {
    if (AppConfig.useMockBackend) {
      print("AuthService (Mock): Signing out...");
      return;
    }
    try {
      // CORRECTED: The `isSignedIn()` method was removed.
      // Check `currentUser` to see if the user is signed in with Google.
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Sign Out Error: $e");
    }
  }
  
  /// Helper to convert a Firebase User to our custom AuthUser.
  AuthUser _userFromFirebase(User user) {
    return AuthUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      // In a real app, these would come from a separate Firestore fetch, 
      // not the Auth object directly. For now, we leave them null or mock them if needed.
      goalWeightKg: null, 
      birthYear: null,
    );
  }
}
