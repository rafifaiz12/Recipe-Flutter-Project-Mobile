import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:siresep/models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
  FirebaseFirestore.instance.collection('users');

  static UserModel? _currentUser;

  static UserModel? get currentUser => _currentUser;

  Future<UserModel?> restoreSession() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      _currentUser = null;
      return null;
    }

    final user = await _validateAndBuildUser(firebaseUser);
    _currentUser = user;
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('Login gagal. User tidak ditemukan.');
    }

    final user = await _validateAndBuildUser(firebaseUser);
    _currentUser = user;

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw Exception('Registrasi gagal. User tidak ditemukan.');
    }

    await firebaseUser.updateDisplayName(name);

    final user = UserModel(
      id: firebaseUser.uid,
      name: name,
      email: firebaseUser.email ?? email,
      photoUrl: firebaseUser.photoURL ?? '',
      role: 'user',
      dietaryPreferences: [],
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );

    await _usersCollection.doc(firebaseUser.uid).set({
      ...user.toMap(),
      'status': 'Aktif',
      'reviewCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _currentUser = user;

    return user;
  }

  Future<UserModel> _validateAndBuildUser(
      firebase_auth.User firebaseUser,
      ) async {
    final doc = await _usersCollection.doc(firebaseUser.uid).get();

    if (!doc.exists || doc.data() == null) {
      await logout();
      throw Exception('Akun Anda tidak ditemukan atau telah dinonaktifkan.');
    }

    final data = doc.data()!;
    final status = data['status']?.toString().trim().toLowerCase() ?? 'aktif';

    if (status == 'suspended') {
      await logout();
      throw Exception('Akun Anda sedang disuspend oleh admin.');
    }

    return UserModel(
      id: firebaseUser.uid,
      name:
      data['name']?.toString() ??
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          'User',
      email: data['email']?.toString() ?? firebaseUser.email ?? '',
      photoUrl: data['photoUrl']?.toString() ?? firebaseUser.photoURL ?? '',
      role: data['role']?.toString() ?? 'user',
      dietaryPreferences: [],
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  static void updateCurrentUser(UserModel user) {
    _currentUser = user;
  }
}
