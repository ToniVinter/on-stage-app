import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/shared/dash_divider.dart';
import 'package:on_stage_app/app/shared/profile_image_widget.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class MomentScreen extends StatefulWidget {
  const MomentScreen({super.key});

  @override
  State<MomentScreen> createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StageAppBar(title: 'Moments', isBackButtonVisible: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: ProfileImageWidget(
                  name: 'User',
                  size: 64,
                  photo: null,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Timotei George',
                  style: context.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Badge(
                    backgroundColor: context.colorScheme.secondary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    label: Text(
                      '12:10',
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Badge(
                    backgroundColor: context.colorScheme.surface,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    label: Row(
                      children: [
                        Icon(
                          LucideIcons.clock,
                          color: context.colorScheme.outline,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '5min',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              DashedLineDivider(
                color: context.colorScheme.primaryContainer,
                dashWidth: 2,
                dashSpace: 6,
              ),
              const SizedBox(height: 24),
              Text(
                'Rugăciune',
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'Descriere marturia lui X, Rugaciune pentru orfelinat si binecuvantare.',
                style: context.textTheme.bodyMedium!.copyWith(
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
