import 'dart:io';
import 'package:client/features/home/viewmodel/upload_state.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/current_user_notifier.dart';
import '../../../core/utils.dart';
import '../repositories/home_remote_repository.dart';

part 'upload_viewmodel.g.dart';

@riverpod
class UploadViewModel extends _$UploadViewModel {
  late HomeRemoteRepository _homeRemoteRepository;

  @override
  UploadState? build() {
    _homeRemoteRepository = ref.watch(homeRemoteRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedImage,
    required File selectedAudio,
    required String artist,
    required String songName,
    required Color selectedColor,
  }) async {
    state = const UploadState(isLoading: true, progress: 0);
    final token = ref.read(
      currentUserNotifierProvider.select(
        (user) => user!.token,
      ),
    );

    final res = await _homeRemoteRepository.uploadSong(
      selectImage: selectedImage,
      selectSong: selectedAudio,
      artist: artist,
      songName: songName,
      color: rgbToHex(selectedColor),
      token: token,
      onProgress: (sent, total) {
        state = state?.copyWith(
          isLoading: true,
          progress: sent / total,
        );
      },
    );

    switch (res) {
      case Left(value: final l):
        state = UploadState(error: l.message);
        break;
      case Right(value: final r):
        state = UploadState(data: r);
        break;
    }
  }
}
