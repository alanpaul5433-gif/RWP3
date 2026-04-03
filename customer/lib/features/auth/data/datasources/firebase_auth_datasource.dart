import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'auth_datasource.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDataSource({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _usersCollection => _firestore.collection(CollectionName.users);

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('Login failed');

      // Fetch user profile from Firestore
      return await _getUserFromFirestore(user.uid);
    } on fb.FirebaseAuthException catch (e) {
      // Auto-create demo account if it doesn't exist
      if (_isDemoEmail(email) && (e.code == 'user-not-found' || e.code == 'invalid-credential')) {
        return await signupWithEmail(
          email: email,
          password: password,
          fullName: 'Demo Customer',
          gender: 'Other',
        );
      }
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  bool _isDemoEmail(String email) {
    final e = email.trim().toLowerCase();
    return e == 'demo@rwp.com' || e == 'test@rwp.com';
  }

  @override
  Future<UserEntity> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
    String referralCode = '',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('Signup failed');

      // Update display name
      await user.updateDisplayName(fullName);

      // Create user profile in Firestore
      final now = DateTime.now();
      final userEntity = UserEntity(
        id: user.uid,
        fullName: fullName,
        email: email.trim(),
        gender: gender,
        loginType: AppConstants.loginEmail,
        referralCode: referralCode,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      await _usersCollection.doc(user.uid).set({
        'id': user.uid,
        'fullName': fullName,
        'email': email.trim(),
        'phoneNumber': '',
        'countryCode': '',
        'profilePic': '',
        'gender': gender,
        'loginType': AppConstants.loginEmail,
        'fcmToken': '',
        'walletAmount': 0.0,
        'loyaltyCredits': 0.0,
        'totalRide': 0,
        'isActive': true,
        'referralCode': referralCode,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return userEntity;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      return await _getUserFromFirestore(user.uid);
    } catch (_) {
      // User exists in Auth but not Firestore — create profile
      final now = DateTime.now();
      final userEntity = UserEntity(
        id: user.uid,
        fullName: user.displayName ?? '',
        email: user.email ?? '',
        phoneNumber: user.phoneNumber ?? '',
        loginType: AppConstants.loginEmail,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      await _usersCollection.doc(user.uid).set({
        'id': user.uid,
        'fullName': user.displayName ?? '',
        'email': user.email ?? '',
        'phoneNumber': user.phoneNumber ?? '',
        'countryCode': '',
        'profilePic': user.photoURL ?? '',
        'gender': '',
        'loginType': AppConstants.loginEmail,
        'fcmToken': '',
        'walletAmount': 0.0,
        'loyaltyCredits': 0.0,
        'totalRide': 0,
        'isActive': true,
        'referralCode': '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return userEntity;
    }
  }

  /// Fetch user profile from Firestore and map to UserEntity
  Future<UserEntity> _getUserFromFirestore(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) throw const AuthException('User profile not found');

    final data = doc.data() as Map<String, dynamic>;
    return UserEntity(
      id: uid,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryCode: data['countryCode'] ?? '',
      profilePic: data['profilePic'] ?? '',
      gender: data['gender'] ?? '',
      loginType: data['loginType'] ?? '',
      fcmToken: data['fcmToken'] ?? '',
      walletAmount: (data['walletAmount'] ?? 0.0).toDouble(),
      loyaltyCredits: (data['loyaltyCredits'] ?? 0.0).toDouble(),
      totalRide: data['totalRide'] ?? 0,
      isActive: data['isActive'] ?? true,
      referralCode: data['referralCode'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Map Firebase Auth error codes to user-friendly messages
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'Authentication failed: $code';
    }
  }
}
