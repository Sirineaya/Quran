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
  final int score;
  final String spokenWord;

  const RecitedWord({
    required this.word,
    required this.isCorrect,
    this.score = 0,
    this.spokenWord = '',
  });

  factory RecitedWord.fromJson(Map<String, dynamic> json) {
    return RecitedWord(
      word: json['text_original'] ?? '',
      isCorrect: json['state'] == 'correct',
      score: (json['score'] as num?)?.round() ?? 0,
      spokenWord: json['spoken_word'] ?? '',
    );
  }
}

class RecitationResult {
  final String spokenText;
  final List<RecitedWord> words;
  final bool finished;
  final double progress;

  const RecitationResult({
    required this.spokenText,
    required this.words,
    required this.finished,
    required this.progress,
  });

  factory RecitationResult.fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>? ?? [];

    return RecitationResult(
      spokenText: json['spoken_text'] ?? '',
      words: results
          .map((e) => RecitedWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      finished: json['finished'] ?? false,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}