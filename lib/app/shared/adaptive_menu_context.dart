import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:pull_down_button/pull_down_button.dart';

part 'adaptive_menu_context.freezed.dart';

@freezed
class MenuAction with _$MenuAction {
  const factory MenuAction({
    required String title,
    required VoidCallback onTap,
    IconData? icon,
    @Default(false) bool isDestructive,
  }) = _MenuAction;
}

class AdaptiveMenuContext extends StatelessWidget {
  const AdaptiveMenuContext({
    required this.items,
    required this.child,
    super.key,
  });

  final List<MenuAction> items;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => PullDownButton(
          itemBuilder: (context) => items
              .map(
                (item) => PullDownMenuItem(
                  title: item.title,
                  icon: item.icon,
                  onTap: item.onTap,
                  isDestructive: item.isDestructive,
                ),
              )
              .toList(),
          buttonBuilder: (_, showMenu) => InkWell(
            onTap: showMenu,
            child: child,
          ),
        ),
      _ => SizedBox(
          height: 24,
          width: 24,
          child: PopupMenuButton<MenuAction>(
            padding: EdgeInsets.zero,
            icon: child,
            onSelected: (item) => item.onTap(),
            itemBuilder: (context) => items
                .map(
                  (item) => PopupMenuItem<MenuAction>(
                    value: item,
                    child: Row(
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon,
                            color: item.isDestructive
                                ? Theme.of(context).colorScheme.error
                                : context.colorScheme.outline,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          item.title,
                          style: TextStyle(
                            color: item.isDestructive
                                ? Theme.of(context).colorScheme.error
                                : context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
    };
  }
}
