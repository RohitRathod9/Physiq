import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:physiq/viewmodels/home_viewmodel.dart';
import 'package:physiq/widgets/header_widget.dart';
import 'package:physiq/widgets/date_slider.dart';
import 'package:physiq/widgets/calorie_and_macros_page.dart';
import 'package:physiq/widgets/water_steps_card.dart';
import 'package:physiq/widgets/recent_meals_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const HeaderWidget(),
              const SizedBox(height: 16),
              DateSlider(onDateSelected: homeViewModel.selectDate),
              const SizedBox(height: 24),
              SizedBox(
                height: 280, // Adjusted height for the PageView
                child: homeState.dailySummary != null
                    ? PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        children: [
                          // This new widget contains the properly arranged cards.
                          CalorieAndMacrosPage(dailySummary: homeState.dailySummary!),
                          WaterStepsCard(dailySummary: homeState.dailySummary!),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => _buildDot(index, context)),
              ),
              const SizedBox(height: 24),
              RecentMealsList(meals: homeState.recentMeals),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    bool isActive = _currentPage == index;
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accent : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? AppColors.accent : AppColors.secondaryText.withOpacity(0.4),
          width: 1.5,
        ),
      ),
    );
  }
}
