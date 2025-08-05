import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNitifier extends _$CurrentSongNitifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  bool isSongPlaying() => _isPlaying;
  AudioPlayer? audioPlayer() => _audioPlayer;

  void updateSong(SongModel song) async {
    await _audioPlayer?.stop();
    _audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(
      Uri.parse(song.song_url),
    );
    await _audioPlayer!.setAudioSource(audioSource);
    _audioPlayer!.playerStateStream.listen(
      (event) {
        if (event.processingState == ProcessingState.completed) {
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
}
