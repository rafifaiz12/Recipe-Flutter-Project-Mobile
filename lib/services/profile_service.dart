import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:siresep/models/user_model.dart';
import 'package:siresep/services/auth_service.dart';

class ProfileService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  firebase_auth.User get _currentFirebaseUser {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User belum login');
    }

    return user;
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    final doc = await _usersCollection.doc(firebaseUser.uid).get();

    if (doc.exists && doc.data() != null) {
      final user = UserModel.fromMap({'id': doc.id, ...doc.data()!});

      AuthService.updateCurrentUser(user);

      return user;
    }

    final fallbackUser = UserModel(
      id: firebaseUser.uid,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          'User',
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      role: 'user',
      dietaryPreferences: [],
      reviewCount: 0,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );

    await _usersCollection.doc(firebaseUser.uid).set({
      ...fallbackUser.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    AuthService.updateCurrentUser(fallbackUser);

    return fallbackUser;
  }

  Future<UserModel> updateName(String newName) async {
    final firebaseUser = _currentFirebaseUser;

    await firebaseUser.updateDisplayName(newName);

    await _usersCollection.doc(firebaseUser.uid).update({
      'name': newName,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final updatedUser = (await getCurrentUser())!;

    AuthService.updateCurrentUser(updatedUser);

    return updatedUser;
  }

  Future<UserModel> updateEmail(String newEmail) async {
    final firebaseUser = _currentFirebaseUser;

    await firebaseUser.verifyBeforeUpdateEmail(newEmail);

    await _usersCollection.doc(firebaseUser.uid).update({
      'pendingEmail': newEmail,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final currentUser = await getCurrentUser();

    if (currentUser == null) {
      throw Exception('User not found');
    }

    return currentUser;
  }

  Future<void> updatePassword(String newPassword) async {
    final firebaseUser = _currentFirebaseUser;

    await firebaseUser.updatePassword(newPassword);
  }

  Future<UserModel> updateProfilePhoto(File imageFile) async {
    final firebaseUser = _currentFirebaseUser;

    await _usersCollection.doc(firebaseUser.uid).update({
      'photoUrl': imageFile.path,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final updatedUser = (await getCurrentUser())!;

    AuthService.updateCurrentUser(updatedUser);

    return updatedUser;
  }

  Future<UserModel> updateProfilePhotoUrl(String imageUrl) async {
    final firebaseUser = _currentFirebaseUser;

    await _usersCollection.doc(firebaseUser.uid).update({
      'photoUrl': imageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final updatedUser = (await getCurrentUser())!;

    AuthService.updateCurrentUser(updatedUser);

    return updatedUser;
  }

  Future<UserModel> updateDietaryPreferences(List<String> preferences) async {
    final firebaseUser = _currentFirebaseUser;

    await _usersCollection.doc(firebaseUser.uid).update({
      'dietaryPreferences': preferences,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final updatedUser = (await getCurrentUser())!;

    AuthService.updateCurrentUser(updatedUser);

    return updatedUser;
  }

  Future<void> logout() async {
    await AuthService().logout();
  }
}
