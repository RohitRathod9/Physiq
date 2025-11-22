import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/models/leaderboard_model.dart';
import 'package:physiq/services/user_repository.dart';
import 'package:physiq/utils/design_system.dart';

class LeaderboardSheet extends ConsumerStatefulWidget {
  const LeaderboardSheet({super.key});

  @override
  ConsumerState<LeaderboardSheet> createState() => _LeaderboardSheetState();
}

class _LeaderboardSheetState extends ConsumerState<LeaderboardSheet> {
  List<LeaderboardEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  Future<void> _fetchLeaderboard() async {
    final entries = await ref.read(userRepositoryProvider).fetchGlobalLeaderboard();
    if (mounted) {
      setState(() {
        _entries = entries;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('Leaderboard', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              _buildPrizeBanner(),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _entries.length + 1, // +1 for current user header
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildCurrentUserRank();
                          }
                          final entry = _entries[index - 1];
                          return _buildLeaderboardItem(entry, index);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrizeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Win ₹10,000', style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                const Text('Top performer after 3 months!', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUserRank() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent, width: 2),
      ),
      child: Row(
        children: [
          Text('24', style: AppTextStyles.heading2), // Rank
          const SizedBox(width: 16),
          const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person)),
          const SizedBox(width: 16),
          Expanded(child: Text('You', style: AppTextStyles.heading2)),
          Text('124.3 pts', style: AppTextStyles.label),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry, int rank) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        child: Center(child: Text('#$rank', style: AppTextStyles.heading2.copyWith(fontSize: 16))),
      ),
      title: Text(entry.displayName, style: AppTextStyles.bodyMedium),
      subtitle: Text('${entry.streakDays} day streak', style: AppTextStyles.smallLabel),
      trailing: Text('${entry.score.toStringAsFixed(1)} pts', style: AppTextStyles.label),
    );
  }
}
