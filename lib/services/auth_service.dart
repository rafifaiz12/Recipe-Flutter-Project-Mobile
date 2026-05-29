import 'package:siresep/models/user_model.dart';

class AuthService {
  static UserModel? _currentUser;

  static UserModel? get currentUser =>
      _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(
        milliseconds: 800,
      ),
    );

    final user = UserModel(
      id: 'user_001',
      name: email.split('@').first,
      email: email,
      photoUrl: '',
      role: 'user',
      dietaryPreferences: [],
      createdAt: DateTime.now(),
    );

    _currentUser = user;

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(
        milliseconds: 800,
      ),
    );

    final user = UserModel(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      name: name,
      email: email,
      photoUrl: '',
      role: 'user',
      dietaryPreferences: [],
      createdAt: DateTime.now(),
    );

    _currentUser = user;

    return user;
  }

  Future<void> logout() async {
    _currentUser = null;
  }

  static void updateCurrentUser(
      UserModel user,
      ) {
    _currentUser = user;
  }
}