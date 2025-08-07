import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../model/song_model.dart';

class RecentSongWidget extends ConsumerWidget {
  const RecentSongWidget({
    super.key,
    required this.song,
  });

  final SongModel song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(currentSongNitifierProvider.notifier).addSongToQueue(song);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Pallete.borderColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
                image: DecorationImage(
                  image: NetworkImage(song.thumbnail_url),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                song.song_name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
