import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StageAppBar({
    required this.title,
    this.titleWidget,
    this.trailing,
    this.isBackButtonVisible = false,
    this.background,
    this.bottom,
    this.onBackButtonPressed,
    this.centerTitle = false,
    super.key,
  });

  final String title;
  final Widget? titleWidget;
  final bool isBackButtonVisible;
  final Widget? trailing;
  final PreferredSize? bottom;
  final void Function()? onBackButtonPressed;
  final Color? background;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: AppBar(
        bottom: bottom,
        backgroundColor: background ??
            (context.isLargeScreen
                ? context.colorScheme.surfaceContainerHigh
                : context.colorScheme.surface),
        leading: _buildLeading(context),
        // leadingWidth: 48,
        centerTitle: centerTitle,
        title: titleWidget ??
            Text(
              title,
              style: context.textTheme.labelLarge?.copyWith(
                fontSize: isBackButtonVisible ? 16 : 28,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
        automaticallyImplyLeading: false,
        actions: [trailing ?? const SizedBox()],
        surfaceTintColor: context.colorScheme.surface,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (isBackButtonVisible) {
      return InkWell(
        onTap: onBackButtonPressed ?? () => context.pop(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 22,
          color: context.colorScheme.outline,
        ),
      );
    }
    return null;
  }

  @override
  Size get preferredSize {
    var appBarHeight = defaultAppBarHeight;
    if (bottom != null) {
      appBarHeight += bottom!.preferredSize.height;
    }
    return Size.fromHeight(appBarHeight);
  }
}
