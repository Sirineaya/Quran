import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../theme/app_colors.dart';

class WordChip extends StatelessWidget {
  final RecitedWord word;

  const WordChip({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final isCorrect = word.isCorrect;
    final bg = isCorrect ? AppColors.greenBg : AppColors.redBg;
    final border = isCorrect ? AppColors.greenBorder : AppColors.redBorder;
    final textColor = isCorrect ? AppColors.green : AppColors.red;
    final icon = isCorrect ? '✓' : '✗';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            word.word,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: textColor,
              height: 1,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            icon,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
