import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class PositionTileShimmer extends StatelessWidget {
  const PositionTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2, // Show 3 shimmer cards
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _buildCardShimmer(context),
      ),
    );
  }

  Widget _buildCardShimmer(BuildContext context) {
    return SizedBox(
      height: 164,
      child: Shimmer.fromColors(
        baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
        highlightColor: context.colorScheme.onSurfaceVariant,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
