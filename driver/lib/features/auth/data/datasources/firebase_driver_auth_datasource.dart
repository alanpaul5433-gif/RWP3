import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'driver_auth_datasource.dart';

class FirebaseDriverAuthDataSource implements DriverAuthDataSource {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseDriverAuthDataSource({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _driversCollection => _firestore.collection(CollectionName.drivers);

  @override
  Future<DriverEntity> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('Login failed');

      return await _getDriverFromFirestore(user.uid);
    } on fb.FirebaseAuthException catch (e) {
      // Auto-create demo account if it doesn't exist
      if (_isDemoEmail(email) && (e.code == 'user-not-found' || e.code == 'invalid-credential')) {
        return await signupWithEmail(
          email: email,
          password: password,
          fullName: 'Demo Driver',
          gender: 'Other',
        );
      }
      throw AuthException(_mapFirebaseAuthError(e.code));
    }
  }

  bool _isDemoEmail(String email) {
    final e = email.trim().toLowerCase();
    return e == 'driver@rwp.com' || e == 'test.driver@rwp.com';
  }

  @override
  Future<DriverEntity> signupWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String gender,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw const AuthException('Signup failed');

      await user.updateDisplayName(fullName);

      final now = DateTime.now();
      final driver = DriverEntity(
        id: user.uid,
        fullName: fullName,
        email: email.trim(),
        gender: gender,
        loginType: AppConstants.loginEmail,
        isActive: true,
        isVerified: false,
        isOnline: false,
        createdAt: now,
        updatedAt: now,
      );

      await _driversCollection.doc(user.uid).set({
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
        'totalEarning': 0.0,
        'reviewsCount': 0,
        'reviewsSum': 0.0,
        'isActive': true,
        'isVerified': false,
        'isOnline': false,
        'vehicleTypeName': '',
        'vehicleBrandName': '',
        'vehicleModelName': '',
        'vehicleNumber': '',
        'zoneIds': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return driver;
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
  Future<DriverEntity?> getCurrentDriver() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      return await _getDriverFromFirestore(user.uid);
    } catch (_) {
      // User exists in Auth but not in drivers collection
      final now = DateTime.now();
      final driver = DriverEntity(
        id: user.uid,
        fullName: user.displayName ?? '',
        email: user.email ?? '',
        phoneNumber: user.phoneNumber ?? '',
        loginType: AppConstants.loginEmail,
        isActive: true,
        isVerified: false,
        isOnline: false,
        createdAt: now,
        updatedAt: now,
      );

      await _driversCollection.doc(user.uid).set({
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
        'totalEarning': 0.0,
        'reviewsCount': 0,
        'reviewsSum': 0.0,
        'isActive': true,
        'isVerified': false,
        'isOnline': false,
        'vehicleTypeName': '',
        'vehicleBrandName': '',
        'vehicleModelName': '',
        'vehicleNumber': '',
        'zoneIds': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return driver;
    }
  }

  Future<DriverEntity> _getDriverFromFirestore(String uid) async {
    final doc = await _driversCollection.doc(uid).get();
    if (!doc.exists) throw const AuthException('Driver profile not found');

    final data = doc.data() as Map<String, dynamic>;
    return DriverEntity(
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
      totalEarning: (data['totalEarning'] ?? 0.0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      reviewsSum: (data['reviewsSum'] ?? 0.0).toDouble(),
      isActive: data['isActive'] ?? true,
      isVerified: data['isVerified'] ?? false,
      isOnline: data['isOnline'] ?? false,
      vehicleTypeName: data['vehicleTypeName'] ?? '',
      vehicleBrandName: data['vehicleBrandName'] ?? '',
      vehicleModelName: data['vehicleModelName'] ?? '',
      vehicleNumber: data['vehicleNumber'] ?? '',
      zoneIds: List<String>.from(data['zoneIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email';
      case 'wrong-password': return 'Incorrect password';
      case 'invalid-credential': return 'Invalid email or password';
      case 'email-already-in-use': return 'An account already exists with this email';
      case 'weak-password': return 'Password must be at least 6 characters';
      case 'invalid-email': return 'Invalid email address';
      case 'user-disabled': return 'This account has been disabled';
      case 'too-many-requests': return 'Too many attempts. Please try again later';
      case 'network-request-failed': return 'Network error. Check your connection';
      default: return 'Authentication failed: $code';
    }
  }
}
