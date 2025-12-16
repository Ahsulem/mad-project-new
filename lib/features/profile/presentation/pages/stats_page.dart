import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spotify/core/services/hive_service.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/features/profile/data/models/listening_event.dart';
import 'package:spotify/features/snap_to_song/data/models/vibe_session.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats & History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              // Section 1: The Vibe Log
              child: Text(
                'Vibe Log (History)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildVibeLog(),
            const Divider(color: Colors.grey),
            const Padding(
              padding: EdgeInsets.all(16.0),
              // Section 2: Most Played (Chart)
              child: Text(
                'Most Played Songs',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildListeningChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildVibeLog() {
    return ValueListenableBuilder(
      valueListenable: HiveService.vibeHistoryBox.listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No vibe history yet!"),
          );
        }
        // Reverse to show latest first
        final sessions = box.values.toList().reversed.toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final session = sessions[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "On ${session.timestamp.toString().split('.')[0]}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: session.detectedLabels.map((label) {
                      return Chip(
                        label: Text(
                          label,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10),
                        ),
                        backgroundColor: AppColors.primary,
                        shape: const RoundedRectangleBorder(),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text("Listened to: ${session.suggestedSongs.join(', ')}"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListeningChart() {
    return ValueListenableBuilder(
      valueListenable: HiveService.listeningStatsBox.listenable(),
      builder: (context, box, _) {
        if (box.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("No listening stats yet!"),
          );
        }

        // Count frequency
        final Map<String, int> frequency = {};
        for (var event in box.values) {
          frequency[event.songTitle] = (frequency[event.songTitle] ?? 0) + 1;
        }

        // Sort by frequency
        final sortedEntries = frequency.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        
        // Take top 5
        final top5 = sortedEntries.take(5).toList();

        // Simple text list instead of chart for now
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: top5.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.key,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        '${entry.value} plays',
                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
