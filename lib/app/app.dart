import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/shared/connectivity/connectivity_overlay.dart';
import 'package:on_stage_app/app/theme/theme_state.dart';
import 'package:on_stage_app/app/utils/app_startup/app_startup.dart';
import 'package:on_stage_app/app/utils/navigator/router_notifier.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Building AppPPPPPPPPPP');
    final startupState = ref.watch(appStartupProvider);

    return startupState.when(
      data: (_) {
        final themeState = ref.watch(themeProvider);
        final router = ref.watch(navigationNotifierProvider);

        return MaterialApp.router(
          routerConfig: router,
          theme: themeState.theme,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                child!,
                const ConnectivityOverlay(),
              ],
            );
          },
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
