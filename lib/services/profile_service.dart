import 'dart:io';

import 'package:siresep/models/user_model.dart';
import 'package:siresep/services/auth_service.dart';

class ProfileService {
  /*
  |--------------------------------------------------------------------------
  | GET CURRENT USER
  |--------------------------------------------------------------------------
  */

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    return AuthService.currentUser;
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE NAME
  |--------------------------------------------------------------------------
  */

  Future<UserModel> updateName(
      String newName,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    final user =
        AuthService.currentUser;

    if (user == null) {
      throw Exception(
        'User not found',
      );
    }

    final updatedUser =
    user.copyWith(
      name: newName,
    );

    AuthService.updateCurrentUser(
      updatedUser,
    );

    return updatedUser;
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE EMAIL
  |--------------------------------------------------------------------------
  */

  Future<UserModel> updateEmail(
      String newEmail,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    final user =
        AuthService.currentUser;

    if (user == null) {
      throw Exception(
        'User not found',
      );
    }

    final updatedUser =
    user.copyWith(
      email: newEmail,
    );

    AuthService.updateCurrentUser(
      updatedUser,
    );

    return updatedUser;
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE PASSWORD
  |--------------------------------------------------------------------------
  */

  Future<void> updatePassword(
      String newPassword,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    // nanti diganti Firebase Auth
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE PROFILE PHOTO
  |--------------------------------------------------------------------------
  */

  Future<UserModel>
  updateProfilePhoto(
      File imageFile,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 400,
      ),
    );

    final user =
        AuthService.currentUser;

    if (user == null) {
      throw Exception(
        'User not found',
      );
    }

    final updatedUser =
    user.copyWith(
      photoUrl:
      imageFile.path,
    );

    AuthService.updateCurrentUser(
      updatedUser,
    );

    return updatedUser;
  }

  Future<UserModel>
  updateProfilePhotoUrl(
      String imageUrl,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 400,
      ),
    );

    final user =
        AuthService.currentUser;

    if (user == null) {
      throw Exception(
        'User not found',
      );
    }

    final updatedUser =
    user.copyWith(
      photoUrl: imageUrl,
    );

    AuthService.updateCurrentUser(
      updatedUser,
    );

    return updatedUser;
  }

  /*
  |--------------------------------------------------------------------------
  | UPDATE DIETARY PREFERENCES
  |--------------------------------------------------------------------------
  */

  Future<UserModel>
  updateDietaryPreferences(
      List<String> preferences,
      ) async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    final user =
        AuthService.currentUser;

    if (user == null) {
      throw Exception(
        'User not found',
      );
    }

    final updatedUser =
    user.copyWith(
      dietaryPreferences:
      preferences,
    );

    AuthService.updateCurrentUser(
      updatedUser,
    );

    return updatedUser;
  }

  /*
  |--------------------------------------------------------------------------
  | LOGOUT
  |--------------------------------------------------------------------------
  */

  Future<void> logout() async {
    await Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
    );

    await AuthService()
        .logout();
  }
}