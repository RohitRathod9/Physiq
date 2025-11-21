import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physiq/utils/design_system.dart';
import 'package:dotted_border/dotted_border.dart';

class DateSlider extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DateSlider({super.key, required this.onDateSelected});

  @override
  _DateSliderState createState() => _DateSliderState();
}

class _DateSliderState extends State<DateSlider> {
  DateTime _selectedDate = DateTime.now();
  late final ScrollController _scrollController;

  // Constants for the slider layout
  static const double _itemWidth = 62.0; // 50 for item, 12 for margin
  static const int _totalDays = 31;
  static const int _centerIndex = 15;

  @override
  void initState() {
    super.initState();
    // This calculation sets the initial scroll position to roughly center the current day.
    final initialOffset = (_itemWidth * _centerIndex) - (_itemWidth * 2.5);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65, // Made the slider shorter to fix the overflow.
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: _totalDays, // Use a wider, more "live" range of days.
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - _centerIndex));
          final isSelected =
              date.day == _selectedDate.day && date.month == _selectedDate.month;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
              widget.onDateSelected(date);
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      DateFormat.E().format(date).toUpperCase(),
                      style: AppTextStyles.smallLabel.copyWith(
                        color: isSelected ? AppColors.accent : AppColors.secondaryText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                  // Reduced the vertical spacing to fix the overflow.
                  const SizedBox(height: 2),
                  _buildDateBubble(date, isSelected),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateBubble(DateTime date, bool isSelected) {
    if (isSelected) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accent, width: 2),
          boxShadow: [AppShadows.card],
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: AppTextStyles.button.copyWith(fontSize: 16),
          ),
        ),
      );
    } else {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        color: AppColors.secondaryText.withOpacity(0.4),
        strokeWidth: 1.5,
        dashPattern: const [4, 4],
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: Text(
              date.day.toString(),
              style: AppTextStyles.label.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ),
      );
    }
  }
}
