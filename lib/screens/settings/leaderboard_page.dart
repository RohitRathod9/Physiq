import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';
import 'package:physiq/services/leaderboard_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final _leaderboardService = LeaderboardService();
  final _auth = FirebaseAuth.instance;
  List<LeaderItem> _top10 = [];
  int _myRank = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = _auth.currentUser?.uid;
    final top10 = await _leaderboardService.fetchTop10();
    int myRank = 0;
    
    if (uid != null) {
      // Check if in top 10
      final meInTop10 = top10.indexWhere((item) => item.uid == uid);
      if (meInTop10 != -1) {
        myRank = top10[meInTop10].rank;
      } else {
        // Fetch rank
        myRank = await _leaderboardService.fetchUserRank(uid);
      }
    }

    if (mounted) {
      setState(() {
        _top10 = top10;
        _myRank = myRank;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Leaderboard', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Prize Summary
                Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadii.bigCard),
                    boxShadow: [AppShadows.card],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Challenge',
                              style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Top 3 win premium features!',
                              style: AppTextStyles.label.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // My Rank if not in top 10 (Optional UI enhancement)
                if (uid != null && !_top10.any((i) => i.uid == uid) && _myRank > 0)
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                     child: Text('Your Rank: #$_myRank', style: AppTextStyles.bodyBold),
                   ),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _top10.length,
                    itemBuilder: (context, index) {
                      final user = _top10[index];
                      final isMe = user.uid == uid;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary.withOpacity(0.05) : AppColors.card,
                          borderRadius: BorderRadius.circular(AppRadii.card),
                          border: isMe ? Border.all(color: AppColors.primary, width: 1.5) : null,
                          boxShadow: [AppShadows.card],
                        ),
                        child: Row(
                          children: [
                            Text(
                              '#${user.rank}',
                              style: AppTextStyles.heading2.copyWith(
                                color: isMe ? AppColors.primary : AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                user.displayName,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${user.score.toInt()} pts',
                              style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
