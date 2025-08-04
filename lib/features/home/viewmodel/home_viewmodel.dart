import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
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
  final token = ref.read(currentUserNotifierProvider)!.token;
  final res =
      await ref.watch(homeRemoteRepositoryProvider).getSongsList(token: token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRemoteRepository _homeRemoteRepository;
  @override
  AsyncValue? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
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

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r)
    };
  }
}
