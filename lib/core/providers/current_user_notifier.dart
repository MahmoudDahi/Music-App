import 'package:client/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/repositories/auth_local_repository.dart';

part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  late AuthLocalRepository _authLocalRepository;

  @override
  UserModel? build() {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);

    return null;
  }

  void addUser(UserModel user) {
    state = user;
  }

  void userLogout() {
    _authLocalRepository.removeToken();
  }
}
