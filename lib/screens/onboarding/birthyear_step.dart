import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:physiq/theme/design_system.dart';

class BirthYearStep extends StatelessWidget {
  final int? birthYear;
  final ValueChanged<int> onChanged;

  const BirthYearStep({super.key, this.birthYear, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final startYear = 2000;
    final years = List.generate(currentYear - startYear + 1, (index) => startYear + index);
    
    // Default to middle if not set
    int initialIndex = 0;
    if (birthYear != null) {
      initialIndex = years.indexOf(birthYear!);
      if (initialIndex == -1) initialIndex = 0;
    } else {
      initialIndex = years.length ~/ 2;
      // Trigger default selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChanged(years[initialIndex]);
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Birth Year', style: AppTextStyles.h2),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(initialItem: initialIndex),
              onSelectedItemChanged: (index) {
                onChanged(years[index]);
              },
              children: years.map((year) => Center(
                child: Text(
                  year.toString(),
                  style: AppTextStyles.h3,
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
