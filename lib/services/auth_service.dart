import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep/models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  static UserModel? _currentUser;

  static UserModel? get currentUser {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return _currentUser;
    }

    _currentUser = UserModel(
      id: firebaseUser.uid,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          'User',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      role: 'user',
      dietaryPreferences: [],
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );

    return _currentUser;
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

    final user = UserModel(
      id: firebaseUser.uid,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          'User',
      email: firebaseUser.email ?? email,
      photoUrl: firebaseUser.photoURL ?? '',
      role: 'user',
      dietaryPreferences: [],
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );

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
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _currentUser = user;

    return user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  static void updateCurrentUser(UserModel user) {
    _currentUser = user;
  }
}
