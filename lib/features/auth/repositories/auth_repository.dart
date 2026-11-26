import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/network_providers.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(db, storage);
});

class AuthRepository {
  static const String _sessionUserIdKey = 'session_user_id';

  final AppDatabase _appDatabase;
  final FlutterSecureStorage _storage;

  const AuthRepository(this._appDatabase, this._storage);

  String _normalizePhone(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.startsWith('90') && digitsOnly.length > 10) {
      return digitsOnly.substring(2);
    }
    return digitsOnly;
  }

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    required String password,
    required bool marketingOptIn,
  }) async {
    final db = await _appDatabase.database;
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone =
        (phone != null && phone.trim().isNotEmpty) ? _normalizePhone(phone) : null;

    final existing = await db.query(
      'User',
      where: 'Email = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw Exception('Bu e-posta adresi zaten kayıtlı.');
    }

    final createdAt = DateTime.now().toIso8601String();
    final cleanFirstName = firstName.trim();
    final cleanLastName = lastName.trim();

    final id = await db.insert('User', {
      'FirstName': cleanFirstName,
      'LastName': cleanLastName,
      'Email': normalizedEmail,
      'Phone': normalizedPhone,
      'Password': password,
      'MarketingOptIn': marketingOptIn ? 1 : 0,
      'CreatedAt': createdAt,
    });

    await _storage.write(key: _sessionUserIdKey, value: id.toString());

    return UserModel(
      id: id,
      firstName: cleanFirstName,
      lastName: cleanLastName,
      email: normalizedEmail,
      phone: normalizedPhone,
      marketingOptIn: marketingOptIn,
      createdAt: createdAt,
    );
  }

  Future<UserModel> login({
    required String identifier,
    required String password,
    required bool isPhone,
  }) async {
    final db = await _appDatabase.database;

    final rows = isPhone
        ? await db.query(
            'User',
            where: 'Phone = ? AND Password = ?',
            whereArgs: [_normalizePhone(identifier), password],
            limit: 1,
          )
        : await db.query(
            'User',
            where: 'Email = ? AND Password = ?',
            whereArgs: [identifier.trim().toLowerCase(), password],
            limit: 1,
          );

    if (rows.isEmpty) {
      throw Exception(
        isPhone ? 'Telefon numarası veya şifre hatalı.' : 'E-posta veya şifre hatalı.',
      );
    }

    final user = UserModel.fromMap(rows.first);
    if (user.id != null) {
      await _storage.write(key: _sessionUserIdKey, value: user.id.toString());
    }
    return user;
  }

  Future<UserModel?> getCurrentUser() async {
    final savedId = await _storage.read(key: _sessionUserIdKey);
    if (savedId == null || savedId.isEmpty) return null;

    final userId = int.tryParse(savedId);
    if (userId == null) return null;

    final db = await _appDatabase.database;
    final rows = await db.query(
      'User',
      where: 'Id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (rows.isEmpty) {
      await _storage.delete(key: _sessionUserIdKey);
      return null;
    }

    return UserModel.fromMap(rows.first);
  }

  Future<void> logout() async {
    await _storage.delete(key: _sessionUserIdKey);
  }
}