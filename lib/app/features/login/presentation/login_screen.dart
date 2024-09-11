import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/login_text_field.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  bool isObscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: defaultScreenPadding.copyWith(left: 24, right: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Insets.large),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/onstageapp_logo.png',
                            height: 120,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      Text(
                        'Log In',
                        style: context.textTheme.headlineLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      LoginTextField(
                        controller: _emailController,
                        label: 'Email',
                        hintText: 'example@email.com',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: Insets.medium),
                      LoginTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your password',
                        obscureText: isObscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscurePassword = !isObscurePassword;
                            });
                          },
                          icon: Icon(
                            isObscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Forgot password?',
                            style: context.textTheme.bodySmall,
                          ),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      Column(
                        children: [
                          ContinueButton(
                            isLoading: false,
                            text: 'Log In',
                            onPressed: () async {
                              final status = await ref
                                  .read(loginNotifierProvider.notifier)
                                  .loginWithCredentials(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                              if (status == true && mounted) {
                                unawaited(
                                  context.pushNamed(AppRoute.home.name),
                                );
                              }
                            },
                            isEnabled: true,
                          ),
                          const SizedBox(height: Insets.normal),
                          ContinueButton(
                            text: 'Sign in with Google',
                            onPressed: () async {
                              final isSuccess = await ref
                                  .read(loginNotifierProvider.notifier)
                                  .signInWithGoogle();
                              if (isSuccess && mounted) {
                                context.goNamed(AppRoute.home.name);
                              }
                            },
                            isEnabled: true,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: context.textTheme.bodyMedium,
                          ),
                          InkWell(
                            splashColor: lightColorScheme.surfaceTint,
                            highlightColor: lightColorScheme.surfaceTint,
                            onTap: () {
                              // context.pushNamed(AppRoute.signUpDetails.name);
                            },
                            child: Text(
                              'Sign up now!',
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Insets.large),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
