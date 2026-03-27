import 'package:flutter/material.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class SkeletonPoints extends StatelessWidget {
  const SkeletonPoints({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerGradient = LinearGradient(
      colors:
          isDark
              ? [
                Colors.grey.shade800,
                Colors.grey.shade600,
                Colors.grey.shade800,
              ]
              : [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
      stops: const [0.0, 0.5, 1.0],
      begin: const Alignment(-1.0, -0.5),
      end: const Alignment(1.0, 0.5),
    );

    return SkeletonTheme(
      shimmerGradient: shimmerGradient,
      child: SkeletonLine(
        style: SkeletonLineStyle(
          height: 20,
          width: 50,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
