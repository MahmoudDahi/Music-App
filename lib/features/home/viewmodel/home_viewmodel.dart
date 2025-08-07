import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/model/favorite_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_remote_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils.dart';
import '../model/song_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getSongsList(Ref ref) async {
  final token = ref.read(
    currentUserNotifierProvider.select(
      (user) => user!.token,
    ),
  );
  final res =
      await ref.watch(homeRemoteRepositoryProvider).getSongsList(token: token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavoriteSongsList(Ref ref) async {
  final token = ref.read(
    currentUserNotifierProvider.select(
      (user) => user!.token,
    ),
  );
  final res = await ref
      .watch(homeRemoteRepositoryProvider)
      .getFavoriteSongsList(token: token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRemoteRepository _homeRemoteRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedImage,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRemoteRepository.uploadSong(
      selectImage: selectedImage,
      selectSong: selectedAudio,
      artist: artist,
      songName: songName,
      color: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        break;
      case Right(value: final r):
        state = AsyncValue.data(r);
        break;
    }
  }

  Future<void> favoriteSongUser({
    required String songID,
  }) async {
    state = const AsyncValue.loading();

    final res = await _homeRemoteRepository.favoriteSong(
      songId: songID,
      token: ref.watch(
        currentUserNotifierProvider.select(
          (user) => user!.token,
        ),
      ),
    );

    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.message, StackTrace.current);
        break;
      case Right(value: final r):
        _favoriteSongSuccess(r, songID);
        break;
    }
  }

  void _favoriteSongSuccess(bool isFavorite, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorite) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: [
            ...ref.read(currentUserNotifierProvider)!.favorites,
            FavoriteModel(
              id: '',
              song_id: songId,
              user_id: '',
            ),
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
              favorites: ref
                  .read(currentUserNotifierProvider)!
                  .favorites
                  .where((fav) => fav.song_id != songId)
                  .toList(),
            ),
      );
    }
    ref.invalidate(getFavoriteSongsListProvider);

    state = AsyncValue.data(isFavorite);
  }

  List<SongModel> getRecentlyPlaySongs() {
    return _homeLocalRepository.loadSongs();
  }
}
