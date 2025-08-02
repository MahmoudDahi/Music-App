import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up.',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 50),
            ),
            SizedBox(height: 30),
            CustomField(hintText: 'Name', controller: nameController),
            SizedBox(height: 15),
            CustomField(hintText: 'Email', controller: emailController),
            SizedBox(height: 15),
            CustomField(
              hintText: 'Password',
              controller: passwordController,
              isObscure: true,
            ),
            SizedBox(height: 15),
            AuthGradientButton(
              buttonText: 'Sign Up',
              onTap: () async {
                final res = await AuthRemoteRepository().signUp(
                    name: nameController.text,
                    email: emailController.text,
                    password: passwordController.text);
                final val = switch (res) {
                  Left(value: final e) => e.toString(),
                  Right(value: final r) => r.toString(),
                };
                print(val);
              },
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleMedium,
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: Pallete.gradient2,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          result: false,
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
