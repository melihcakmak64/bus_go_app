import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, UserModel?>(AuthViewModel.new);

class AuthViewModel extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    return ref.read(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login({
    required String identifier,
    required String password,
    required bool isPhone,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).login(
            identifier: identifier,
            password: password,
            isPhone: isPhone,
          ),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    String? phone,
    required String password,
    required bool marketingOptIn,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).register(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: password,
            marketingOptIn: marketingOptIn,
          ),
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      return null;
    });
  }
}