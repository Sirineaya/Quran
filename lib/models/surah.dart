class Surah {
  final int number;
  final String name;
  final String arabic;
  final int verses;
  final String meaning;

  const Surah({
    required this.number,
    required this.name,
    required this.arabic,
    required this.verses,
    required this.meaning,
  });
}

class RecitedWord {
  final String word;
  final bool isCorrect;

  const RecitedWord({required this.word, required this.isCorrect});
}
