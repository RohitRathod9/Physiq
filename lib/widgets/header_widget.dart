import 'package:flutter/material.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:physiq/widgets/streak_calendar_popup.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder for logo - Increased size
              Image.asset('assets/Physiq_logo.png', width: 40, height: 40),
              const SizedBox(width: 8),
              Text('Physiq', style: AppTextStyles.heading1),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => showStreakCalendar(context),
                icon: const Icon(Icons.calendar_today_outlined, color: AppColors.secondaryText),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(100), // Pill shape
                  boxShadow: [AppShadows.card],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                    const SizedBox(width: 6),
                    Text('0', style: AppTextStyles.button.copyWith(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
