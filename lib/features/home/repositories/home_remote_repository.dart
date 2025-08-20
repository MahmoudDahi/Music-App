import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRemoteRepository(Ref ref) {
  return HomeRemoteRepository();
}

class HomeRemoteRepository {
  final Dio _dio = Dio();
  Future<Either<AppFailure, String>> uploadSong({
    required File selectImage,
    required File selectSong,
    required String artist,
    required String songName,
    required String color,
    required String token,
    required void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'song': await MultipartFile.fromFile(selectSong.path),
        'thumbnail': await MultipartFile.fromFile(selectImage.path),
        'artist': artist,
        'song_name': songName,
        'color': color,
      });

      final response = await _dio.post(
        '${ServerConstant.serverURL}/song/upload',
        data: formData,
        options: Options(
          headers: {'x-auth-token': token},
        ),
        onSendProgress: onProgress,
      );
      if (response.statusCode != 201) {
        return Left(AppFailure(response.data.toString()));
      }
      return Right(response.data.toString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getSongsList({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstant.serverURL}/song/list'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      var responseBody = jsonDecode(res.body);
      if (res.statusCode != 200) {
        responseBody = responseBody as Map<String, dynamic>;
        return Left(AppFailure(responseBody['detail']));
      }
      responseBody = responseBody as List;
      List<SongModel> songs = [];
      for (final map in responseBody) {
        songs.add(SongModel.fromMap(map));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favoriteSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstant.serverURL}/song/favorite'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            'song_id': songId,
          },
        ),
      );
      var responseBody = jsonDecode(res.body);
      if (res.statusCode != 200) {
        responseBody = responseBody as Map<String, dynamic>;
        return Left(AppFailure(responseBody['detail']));
      }

      return Right(responseBody['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavoriteSongsList({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse('${ServerConstant.serverURL}/song/list/favorites'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });
      var responseBody = jsonDecode(res.body);
      if (res.statusCode != 200) {
        responseBody = responseBody as Map<String, dynamic>;
        return Left(AppFailure(responseBody['detail']));
      }
      responseBody = responseBody as List;
      List<SongModel> songs = [];
      for (final map in responseBody) {
        songs.add(SongModel.fromMap(map['song']));
      }
      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
