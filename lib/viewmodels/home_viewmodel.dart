import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/services/firestore_service.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  return HomeViewModel(ref.watch(firestoreServiceProvider));
});

class HomeViewModel extends StateNotifier<HomeState> {
  final FirestoreService _firestoreService;

  HomeViewModel(this._firestoreService) : super(HomeState()) {
    fetchDailySummary(state.selectedDate);
    fetchRecentMeals();
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    fetchDailySummary(date);
  }

  void fetchDailySummary(DateTime date) {
    _firestoreService.streamDailySummary('dummy_uid', date).listen((data) {
      state = state.copyWith(dailySummary: data);
    });
  }

  void fetchRecentMeals() {
    _firestoreService.fetchRecentMeals('dummy_uid').then((data) {
      state = state.copyWith(recentMeals: data);
    });
  }

  void openAddMenu() {
    // Logic to open add menu
  }

  void openCalendar() {
    // Logic to open calendar
  }
}

class HomeState {
  final DateTime selectedDate;
  final Map<String, dynamic>? dailySummary;
  final List<Map<String, dynamic>>? recentMeals;
  final bool isPremium;

  HomeState({
    DateTime? selectedDate,
    this.dailySummary,
    this.recentMeals,
    this.isPremium = false,
  }) : selectedDate = selectedDate ?? DateTime.now();

  HomeState copyWith({
    DateTime? selectedDate,
    Map<String, dynamic>? dailySummary,
    List<Map<String, dynamic>>? recentMeals,
    bool? isPremium,
  }) {
    return HomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      dailySummary: dailySummary ?? this.dailySummary,
      recentMeals: recentMeals ?? this.recentMeals,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
