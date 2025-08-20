import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../viewmodel/upload_state.dart';

class UploadProgressWidget extends StatelessWidget {
  final UploadState state;

  const UploadProgressWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (!state.isLoading) {
      return const SizedBox.shrink();
    }

    final percentage = (state.progress * 100).toStringAsFixed(0);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: state.progress,
              color: Pallete.gradient2,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
            Text("$percentage %", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
