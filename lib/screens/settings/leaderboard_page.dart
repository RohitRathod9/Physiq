import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> users = [
      {'rank': 1, 'name': 'Sarah J.', 'score': 2450},
      {'rank': 2, 'name': 'Mike T.', 'score': 2300},
      {'rank': 3, 'name': 'Jessica L.', 'score': 2150},
      {'rank': 4, 'name': 'David B.', 'score': 1980},
      {'rank': 5, 'name': 'You', 'score': 1850, 'isMe': true},
      {'rank': 6, 'name': 'Emily R.', 'score': 1720},
      {'rank': 7, 'name': 'Chris M.', 'score': 1650},
      {'rank': 8, 'name': 'Amanda W.', 'score': 1500},
      {'rank': 9, 'name': 'Tom H.', 'score': 1420},
      {'rank': 10, 'name': 'Laura K.', 'score': 1300},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Leaderboard', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryText),
      ),
      body: Column(
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
          
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isMe = user['isMe'] == true;
                
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
                        '#${user['rank']}',
                        style: AppTextStyles.heading2.copyWith(
                          color: isMe ? AppColors.primary : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          user['name'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: isMe ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${user['score']} pts',
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
