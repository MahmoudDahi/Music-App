import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongQueueWidget extends ConsumerWidget {
  const SongQueueWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsInQueue =
        ref.watch(currentSongNitifierProvider.notifier).getSongQueue();

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        title: const Text('Queue'),
        backgroundColor: Pallete.backgroundColor,
      ),
      body: ListView.builder(
        itemCount: songsInQueue.length,
        itemBuilder: (context, index) {
          final song = songsInQueue[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.thumbnail_url,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
            title: Text(
              song.song_name,
              style: const TextStyle(color: Pallete.whiteColor),
            ),
            subtitle: Text(
              song.artist,
              style: const TextStyle(color: Pallete.subtitleText),
            ),
            onTap: () {
              ref.read(currentSongNitifierProvider.notifier).updateSong(song);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
