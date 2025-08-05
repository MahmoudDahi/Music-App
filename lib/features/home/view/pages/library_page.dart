import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(authViewModelProvider.notifier).userLogout();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const SignupPage(),
          ));
        },
        child: const Text('Logout'),
      ),
    );
  }
}
