import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

enum RepeatMode {
  off,
  all,
  one,
}

@riverpod
class CurrentSongNitifier extends _$CurrentSongNitifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  RepeatMode _repeatMode = RepeatMode.off;
  bool _isShuffle = false;
  late int _currentSongIndex;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    _audioPlayer = AudioPlayer();
    return null;
  }

  bool isSongPlaying() => _isPlaying;
  bool isSongShuffle() => _isShuffle;
  int getCurrentSongIndex() => _currentSongIndex;
  AudioPlayer? audioPlayer() => _audioPlayer;
  RepeatMode? repeatMode() => _repeatMode;

  void updateSong(
    SongModel song,
  ) async {
    await _audioPlayer?.stop();

    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
      tag: MediaItem(
        id: song.id,
        artist: song.artist,
        title: song.song_name,
        duration: _audioPlayer!.duration,
        extras: {
          'hex': song.hex_code,
        },
        artUri: Uri.parse(song.thumbnail_url),
      ),
    );
    _currentSongIndex = 0;
    await _audioPlayer!.setAudioSource(audioSource);
    _audioPlayer!.currentIndexStream.listen(
      (index) {
        if (index != null && index != _currentSongIndex) {
          _currentSongIndex = index;
          _setNewSong();
        }
      },
    );

    _audioPlayer!.playerStateStream.listen(
      (audioState) {
        if (audioState.processingState == ProcessingState.completed) {
          _audioPlayer!.seek(Duration.zero);
          _audioPlayer!.pause();
          _isPlaying = false;
          state = state!.copyWith(hex_code: state!.hex_code);
        }
      },
    );

    _homeLocalRepository.uploadSong(song);
    _audioPlayer!.play();
    _isPlaying = true;
    state = song;
  }

  void toggleRepeat() {
    if (_audioPlayer == null) return;

    if (_repeatMode == RepeatMode.off) {
      _repeatMode = RepeatMode.all;
      _audioPlayer!.setLoopMode(LoopMode.all);
    } else if (_repeatMode == RepeatMode.all) {
      _repeatMode = RepeatMode.one;
      _audioPlayer!.setLoopMode(LoopMode.one);
    } else {
      _repeatMode = RepeatMode.off;
      _audioPlayer!.setLoopMode(LoopMode.off);
    }
    state = state!.copyWith(hex_code: state!.hex_code);
  }

  void playAndPause() {
    if (_isPlaying) {
      _audioPlayer!.pause();
    } else {
      _audioPlayer!.play();
    }
    _isPlaying = !_isPlaying;
    state = state!.copyWith(hex_code: state!.hex_code);
  }

  void seek(double val) {
    _audioPlayer!.seek(
      Duration(
        milliseconds: (val * _audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }

  void addSongToQueue(SongModel song) {
    if (_audioPlayer?.playing == true) {
      if (_isSongExistOnQueue(song)) {
        return;
      }
      final audioSource = AudioSource.uri(
        Uri.parse(song.song_url),
        tag: MediaItem(
          id: song.id,
          artist: song.artist,
          title: song.song_name,
          duration: _audioPlayer!.duration,
          artUri: Uri.parse(song.thumbnail_url),
          extras: {
            'hex': song.hex_code,
          },
        ),
      );
      _audioPlayer!.addAudioSource(audioSource);
    } else {
      updateSong(
        song,
      );
    }
  }

  bool _isSongExistOnQueue(SongModel song) {
    if (_audioPlayer!.audioSources.isNotEmpty) {
      return _audioPlayer!.audioSources.any((audoSource) {
        if (audoSource is UriAudioSource) {
          final MediaItem mediaItem = audoSource.tag as MediaItem;
          return mediaItem.id == song.id;
        }
        return false;
      });
    }
    return false;
  }

  void selectSongFromQueue(int songIndex) async {
    await _audioPlayer!.seek(Duration.zero, index: songIndex);
  }

  List<SongModel> getSongQueue() {
    if (_audioPlayer!.audioSources.isNotEmpty) {
      final List<SongModel> songs = [];
      for (final source in _audioPlayer!.audioSources) {
        if (source is UriAudioSource) {
          songs.add(_convertAudioSourceToSongModel(source: source));
        }
      }
      return songs;
    }
    return [];
  }

  void playNextSong() async {
    await _audioPlayer!.seekToNext();
  }

  void playPreviousSong() async {
    await _audioPlayer!.seekToPrevious();
  }

  void shuffleSong() async {
    _isShuffle = !_isShuffle;
    await _audioPlayer!.setShuffleModeEnabled(_isShuffle);
    state = state!.copyWith(hex_code: state!.hex_code);
  }

  void _setNewSong() {
    final sequence = _audioPlayer!.sequence;
    if (_audioPlayer!.currentIndex != null) {
      final currentSource =
          sequence[_audioPlayer!.currentIndex!] as AudioSource;
      if (currentSource is UriAudioSource) {
        state = _convertAudioSourceToSongModel(source: currentSource);
        _audioPlayer!.play();
        _isPlaying = true;
      }
    }
  }

  SongModel _convertAudioSourceToSongModel({
    required UriAudioSource source,
  }) {
    final mediaItem = source.tag as MediaItem;
    return SongModel(
      id: mediaItem.id,
      song_name: mediaItem.title,
      artist: mediaItem.artist ?? '',
      song_url: (source).uri.toString(),
      thumbnail_url: mediaItem.artUri?.toString() ?? '',
      hex_code: mediaItem.extras?['hex'] ?? '121212',
    );
  }
}
