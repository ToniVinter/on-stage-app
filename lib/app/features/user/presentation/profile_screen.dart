import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/app_settings.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/library_section.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/profile_header.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/sign_out_button.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/song_view_settings.dart';
import 'package:on_stage_app/app/features/user/presentation/widgets/team_section.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(teamNotifierProvider.notifier).getCurrentTeam();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.normal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('Profile', style: context.textTheme.headlineLarge),
                const SizedBox(height: 32),
                const ProfileHeader(),
                const SizedBox(height: 24),
                const SongViewSettings(),
                const SizedBox(height: 24),
                const TeamsSection(),
                const SizedBox(height: 24),
                const AppSettings(),
                const SizedBox(height: 24),
                const LibrarySection(),
                const SizedBox(height: 24),
                const SignOutButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
