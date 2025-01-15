import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/main_screen.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class CustomSideNavigation extends StatelessWidget {
  const CustomSideNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.isExpanded,
    required this.items,
    required this.onExpandToggle,
    required this.onSignOut,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool isExpanded;
  final List<NavigationItem> items;
  final VoidCallback onExpandToggle;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: isExpanded ? 240 : 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildNavigationItems(context),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36, left: 12),
          child: SvgPicture.asset(
            isExpanded
                ? context.isDarkMode
                    ? 'assets/icons/logo-onstage-large-white.svg'
                    : 'assets/icons/logo-onstage-large-black.svg'
                : context.isDarkMode
                    ? 'assets/icons/logo-onstage-white.svg'
                    : 'assets/icons/logo-onstage-black-2.svg',
            height: 40,
          ),
        ),
        _buildExpandButton(context),
      ],
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 36, left: 8),
      child: InkWell(
        overlayColor: WidgetStateProperty.all(const Color(0x33FFFFFF)),
        borderRadius: BorderRadius.circular(7),
        onTap: onExpandToggle,
        child: Ink(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            LucideIcons.panel_right_open,
            color: context.colorScheme.surfaceDim,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == selectedIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onDestinationSelected(index),
                  borderRadius: _getBorderRadius(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: isExpanded
                        ? _buildExpandedItem(context, item, isSelected)
                        : _buildCollapsedItem(context, item, isSelected),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius() => isExpanded
      ? const BorderRadius.horizontal(
          left: Radius.circular(12),
          right: Radius.circular(12),
        )
      : BorderRadius.circular(12);

  Widget _buildNavigationIcon(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
  ) {
    return SvgPicture.asset(
      item.iconPath,
      height: 24,
      colorFilter: ColorFilter.mode(
        isSelected
            ? context.colorScheme.onSurface
            : context.colorScheme.outline,
        BlendMode.srcIn,
      ),
    );
  }

  Widget _buildNavigationLabel(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
  ) {
    return Text(
      item.label,
      style: context.textTheme.bodyMedium?.copyWith(
        color: isSelected
            ? context.colorScheme.onSurface
            : context.colorScheme.outline,
      ),
    );
  }

  BoxDecoration _getItemDecoration(
    BuildContext context,
    bool isSelected, {
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: isSelected
          ? context.colorScheme.onSurfaceVariant
          : Colors.transparent,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
    );
  }

  Widget _buildCollapsedItem(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
  ) {
    return Container(
      decoration: _getItemDecoration(context, isSelected),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildNavigationIcon(context, item, isSelected),
          _buildNavigationLabel(context, item, isSelected),
        ],
      ),
    );
  }

  Widget _buildExpandedItem(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
  ) {
    return Row(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: _getItemDecoration(
            context,
            isSelected,
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(12)),
          ),
          child: _buildNavigationIcon(context, item, isSelected),
        ),
        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            decoration: _getItemDecoration(
              context,
              isSelected,
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildNavigationLabel(context, item, isSelected),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final logoutIcon = IconButton(
      icon: Icon(
        Icons.logout,
        color: context.colorScheme.error,
      ),
      onPressed: onSignOut,
    );

    const logoutLabel = Text('Sign Out');

    return Padding(
      padding: EdgeInsets.only(bottom: 32, left: isExpanded ? 12 : 16),
      child: isExpanded
          ? Row(children: [logoutIcon, logoutLabel])
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [logoutIcon, logoutLabel],
            ),
    );
  }
}
