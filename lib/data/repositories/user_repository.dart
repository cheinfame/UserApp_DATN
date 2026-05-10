import '../models/account_model.dart';
import '../models/notification_model.dart';

abstract class UserRepository {
  Future<Account> updateUserProfile(Account account);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<Account> getUserProfile(String id);
  Future<List<Notification>> getNotifications(String userId);
}
