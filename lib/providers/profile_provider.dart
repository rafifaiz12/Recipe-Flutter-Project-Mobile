import 'dart:io';

import 'package:flutter/material.dart';

import 'package:siresep/core/utils/dummy_data.dart';

import 'package:siresep/models/user_model.dart';

import 'package:siresep/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  UserModel? _user;

  bool _isLoading = false;

  bool _isUpdating = false;

  String? _errorMessage;

  UserModel? get user => _user;

  bool get isLoading => _isLoading;

  bool get isUpdating => _isUpdating;

  String? get errorMessage => _errorMessage;

  /*
  |--------------------------------------------------------------------------
  | REALTIME STATS
  |--------------------------------------------------------------------------
  */

  int get savedRecipesCount {
    return DummyData.favorites.length;
  }

  int get plannedMealsCount {
    return DummyData.mealPlans.length;
  }

  int get shoppingItemsCount {
    return DummyData.shoppingItems.length;
  }

  int get reviewsCount {
    if (_user == null) {
      return 0;
    }

    return DummyData.reviews
        .where((review) => review.userId == _user!.id)
        .length;
  }

  /*
  |--------------------------------------------------------------------------
  | LOAD PROFILE
  |--------------------------------------------------------------------------
  */

  Future<void> loadProfile() async {
    _isLoading = true;

    notifyListeners();

    try {
      _errorMessage = null;
      _user = await _service.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
      _user = null;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | CHANGE NAME
  |--------------------------------------------------------------------------
  */

  Future<bool> changeName(String newName) async {
    if (newName.trim().isEmpty) {
      return false;
    }

    _isUpdating = true;

    notifyListeners();

    try {
      _user = await _service.updateName(newName.trim());

      return true;
    } catch (_) {
      return false;
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | CHANGE EMAIL
  |--------------------------------------------------------------------------
  */

  Future<bool> changeEmail(String newEmail) async {
    if (newEmail.trim().isEmpty) {
      return false;
    }

    _isUpdating = true;

    notifyListeners();

    try {
      _user = await _service.updateEmail(newEmail.trim());

      return true;
    } catch (_) {
      return false;
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | CHANGE PASSWORD
  |--------------------------------------------------------------------------
  */

  Future<bool> changePassword(String newPassword) async {
    if (newPassword.length < 6) {
      return false;
    }

    _isUpdating = true;

    notifyListeners();

    try {
      await _service.updatePassword(newPassword);

      return true;
    } catch (_) {
      return false;
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | CHANGE PROFILE PHOTO
  |--------------------------------------------------------------------------
  */

  Future<bool> changeProfilePhoto(File imageFile) async {
    _isUpdating = true;

    notifyListeners();

    try {
      _user = await _service.updateProfilePhoto(imageFile);

      return true;
    } catch (_) {
      return false;
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  Future<bool> changeProfilePhotoUrl(String imageUrl) async {
    _isUpdating = true;

    notifyListeners();

    try {
      _user = await _service.updateProfilePhotoUrl(imageUrl);

      return true;
    } catch (_) {
      return false;
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | DIETARY PREFERENCES
  |--------------------------------------------------------------------------
  */

  Future<bool> updateDietaryPreferences(List<String> preferences) async {
    _isUpdating = true;

    notifyListeners();

    try {
      _user = await _service.updateDietaryPreferences(preferences);

      return true;
    } catch (_) {
      return false;
    } finally {
      _isUpdating = false;

      notifyListeners();
    }
  }

  void refreshStats() {
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | LOGOUT
  |--------------------------------------------------------------------------
  */

  Future<void> logout() async {
    _isLoading = true;

    notifyListeners();

    try {
      await _service.logout();

      clearState();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | CLEAR STATE
  |--------------------------------------------------------------------------
  */

  void clearState() {
    _user = null;

    notifyListeners();
  }
}
