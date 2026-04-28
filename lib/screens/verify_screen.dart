import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../data/surah_data.dart';
import '../theme/app_colors.dart';
import '../widgets/word_chip.dart';

class VerifyScreen extends StatelessWidget {
  final Surah surah;

  const VerifyScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    final correct = mockWords.where((w) => w.isCorrect).length;
    final wrong = mockWords.where((w) => !w.isCorrect).length;
    final pct = (correct / mockWords.length * 100).round();

    String feedbackIcon;
    String feedbackText;
    if (pct >= 80) {
      feedbackIcon = '🌟';
      feedbackText = 'Excellent recitation! Keep up the great work.';
    } else if (pct >= 50) {
      feedbackIcon = '📖';
      feedbackText = 'Good effort. Review the highlighted words and try again.';
    } else {
      feedbackIcon = '💪';
      feedbackText = 'Keep practicing. Focus on the words marked in red.';
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.4, -0.6),
            radius: 1.5,
            colors: [Color(0xFFF5E6C8), AppColors.bg, Color(0xFFF0DFC0)],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Score card
                      _buildScoreCard(pct, correct, wrong),
                      const SizedBox(height: 16),

                      // Section label
                      const Text(
                        'Your Recitation — Word by Word',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMid,
                          letterSpacing: 0.5,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Word chips (RTL wrap)
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            mockWords.length,
                            (i) => TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(milliseconds: 300 + i * 40),
                              curve: Curves.easeOut,
                              builder: (_, v, child) => Opacity(
                                opacity: v,
                                child: Transform.translate(
                                  offset: Offset(0, 14 * (1 - v)),
                                  child: child,
                                ),
                              ),
                              child: WordChip(word: mockWords[i]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Feedback box
                      _buildFeedbackBox(feedbackIcon, feedbackText),
                      const SizedBox(height: 20),

                      // Retry button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.goldLight,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '↺  Try Again',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5E8CC), AppColors.bgCard],
          transform: GradientRotation(2.97),
        ),
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              '‹ Back',
              style: TextStyle(fontSize: 16, color: AppColors.goldLight),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "RECITATION ANALYSIS",
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 3,
              color: AppColors.goldLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            surah.arabic,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 32,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            surah.name,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textMid,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(int pct, int correct, int wrong) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF9F0DC), AppColors.bgDark],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Score circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.goldPale, Color(0xFFFFE8A0)],
              ),
              border: Border.all(color: AppColors.goldLight, width: 2.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$pct%',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brown,
                    height: 1,
                  ),
                ),
                const Text(
                  'ACCURACY',
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.brownLight,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Stats
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _statItem(correct, 'Correct', AppColors.green),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.border,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                _statItem(wrong, 'Incorrect', const Color(0xFFC0392B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(int count, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMid),
        ),
      ],
    );
  }

  Widget _buildFeedbackBox(String icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMid,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
