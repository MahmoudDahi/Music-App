import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader_widget.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/latest_song_widget.dart';
import '../widgets/recent_song_widget.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentPlaySongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlaySongs();

    final currentSong = ref.watch(currentSongNitifierProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    hexToColor(currentSong.hex_code),
                    Pallete.transparentColor,
                  ],
                  stops: const [
                    0.0,
                    0.3
                  ]),
            ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: IconButton(
                  onPressed: () {
                    ref.read(currentUserNotifierProvider.notifier).userLogout();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 36,
              ),
              height: 280,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: recentPlaySongs.length,
                itemBuilder: (context, index) {
                  final song = recentPlaySongs[index];
                  return RecentSongWidget(song: song);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Latest Today',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ref.watch(getSongsListProvider).when(
              data: (songs) {
                return SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return LatestSongWidget(song: song);
                    },
                  ),
                );
              },
              error: (error, st) {
                return Text(error.toString());
              },
              loading: () {
                return const LoaderWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
