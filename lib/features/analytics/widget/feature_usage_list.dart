import 'package:flutter/material.dart';
import 'package:meet_now_admin_panel/features/analytics/cubit/analytics_cubit.dart';

class FeatureUsageList extends StatelessWidget {
  final List<FeatureUsage> featureUsage;

  const FeatureUsageList({super.key, required this.featureUsage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Usage Ranking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            ...featureUsage.asMap().entries.map((entry) {
              final index = entry.key;
              final feature = entry.value;
              return _buildFeatureItem(index + 1, feature);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(int rank, FeatureUsage feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.feature,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${feature.usageCount} uses • ${feature.growth.toStringAsFixed(1)}% growth',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: feature.growth >= 0 ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  feature.growth >= 0 ? Icons.trending_up : Icons.trending_down,
                  size: 14,
                  color: feature.growth >= 0
                      ? Colors.green[600]
                      : Colors.red[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${feature.growth.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: feature.growth >= 0
                        ? Colors.green[600]
                        : Colors.red[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
