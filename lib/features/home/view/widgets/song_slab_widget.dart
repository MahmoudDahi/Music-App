import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';

class SongSlabWidget extends ConsumerWidget {
  const SongSlabWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNitifierProvider);
    if (currentSong == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: hexToColor(currentSong.hex_code),
          borderRadius: BorderRadius.circular(4),
        ),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    image: NetworkImage(currentSong.thumbnail_url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.song_name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                          color: Pallete.subtitleText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.suit_heart,
                  color: Pallete.whiteColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.play_fill,
                  color: Pallete.whiteColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
