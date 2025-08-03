import 'dart:developer';

import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.signUp(
        name: name, email: email, password: password);
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.toString(),
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    log(val.value.toString());
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res =
        await _authRemoteRepository.login(email: email, password: password);
    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.toString(),
          StackTrace.current,
        ),
      Right(value: final r) => _loginSuccessfuly(r),
    };
    log(val.toString());
  }

  Future<UserModel?> getUserData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getUserData(token: token);
      final val = switch (res) {
        Left(value: final l) => state = AsyncValue.error(
            l.toString(),
            StackTrace.current,
          ),
        Right(value: final r) => state = AsyncValue.data(r),
      };
      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel>? _loginSuccessfuly(UserModel user) {
    _authLocalRepository.setToken(user.token);
    return state = AsyncValue.data(user);
  }
}
