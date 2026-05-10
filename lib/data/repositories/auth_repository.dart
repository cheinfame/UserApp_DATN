import '../models/account_model.dart';

abstract class AuthRepository {
  Future<Account> signUp(Account signUpAccount);

  Future<Account> login(String username, String password);

  Future<void> logout();

  Future<Account> loginWithCache();
}
