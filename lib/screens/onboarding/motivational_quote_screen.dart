
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:physiq/theme/design_system.dart';

class MotivationalQuoteScreen extends StatefulWidget {
  const MotivationalQuoteScreen({super.key});

  @override
  State<MotivationalQuoteScreen> createState() => _MotivationalQuoteScreenState();
}

class _MotivationalQuoteScreenState extends State<MotivationalQuoteScreen> {
  final List<Map<String, String>> _quotes = [
    {
      'quote': 'Take action today — transform tomorrow.',
      'author': 'Cristiano Ronaldo',
    },
    {
      'quote': 'Success starts with self-discipline.',
      'author': 'Dwayne Johnson',
    },
    {
      'quote': 'Believe in yourself and anything is possible.',
      'author': 'Virat Kohli',
    },
    {
      'quote': 'There is no talent here, this is hard work.',
      'author': 'Conor McGregor',
    },
    {
      'quote': 'I trained 4 years to run 9 seconds.',
      'author': 'Usain Bolt',
    },
    {
      'quote': 'Strength does not come from winning.',
      'author': 'Arnold Schwarzenegger',
    },
    {
      'quote': 'Discipline is doing what you hate to do, but doing it like you love it.',
      'author': 'Mike Tyson',
    },
    {
      'quote': 'Be water, my friend.',
      'author': 'Bruce Lee',
    },
    {
      'quote': 'Dedication makes dreams come true.',
      'author': 'Kobe Bryant',
    },
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                final quote = _quotes[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadii.card),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.format_quote, size: 48, color: Colors.grey),
                      const SizedBox(height: 24),
                      Text(
                        quote['quote']!,
                        style: AppTextStyles.h2.copyWith(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '- ${quote['author']}',
                        style: AppTextStyles.bodyBold.copyWith(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/onboarding/paywall-free'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Start Your Journey'),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
