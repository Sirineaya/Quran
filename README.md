# Quran Recitation App — Flutter

Converted from the HTML prototype to a full Flutter project.

## Structure

```
lib/
├── main.dart                    # App entry point
├── theme/
│   ├── app_colors.dart          # All color constants
│   └── app_theme.dart           # ThemeData
├── models/
│   └── surah.dart               # Surah & RecitedWord models
├── data/
│   └── surah_data.dart          # Surah list + mock NLP words
├── screens/
│   ├── surah_list_screen.dart   # Screen 1: Browse Surahs
│   ├── record_screen.dart       # Screen 2: Record recitation
│   └── verify_screen.dart       # Screen 3: Word-by-word analysis
└── widgets/
    ├── surah_card.dart          # Animated Surah list card
    ├── waveform_widget.dart     # Animated audio waveform bars
    ├── word_chip.dart           # Correct/wrong word chip
    └── gradient_button.dart     # Gold gradient CTA button
```

## Screens

| Screen | HTML equivalent | Key features |
|--------|----------------|--------------|
| SurahListScreen | `#screen-list` | Staggered fade-in list, gold header |
| RecordScreen | `#screen-record` | Timer, pulse animation, waveform, record toggle |
| VerifyScreen | `#screen-verify` | Score circle, RTL word chips, feedback box |

## Setup

1. Add fonts to `pubspec.yaml` (uncomment the fonts section).
2. Download **Amiri** and **Cormorant Garamond** from Google Fonts and place in `fonts/`.
3. Alternatively, use the `google_fonts` package:

```yaml
dependencies:
  google_fonts: ^6.0.0
```

Then replace font references with:
```dart
GoogleFonts.amiri(...)
GoogleFonts.cormorantGaramond(...)
```

## Real Microphone Integration

Replace the mock timer in `RecordScreen` with `record` package:
```yaml
dependencies:
  record: ^5.0.0
  permission_handler: ^11.0.0
```

## Real NLP Verification

Replace `mockWords` in `surah_data.dart` with an API call to your Quranic speech recognition backend.
