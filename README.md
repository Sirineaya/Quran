# Quran Recitation App — Flutter

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
├── services/
│   └── quran_api_service.dart          # link
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
# Quran Recitation Correction — Web Version (Chrome)

This project includes a web testing version of the Quran Recitation Correction System.  
It allows users to verify recitation using an audio file upload instead of live recording.

Note: The web version is intended for testing and demonstration. The full functionality is designed for mobile platforms (Android/iOS).

---

## Architecture

User (Chrome) → Upload audio (.wav)  
→ Flutter Web App  
→ POST /recite (FastAPI via ngrok)  
→ Whisper Model (Colab)  
→ Word-by-word correction

---

## How to Test (Chrome)

### 1. Run the backend (Google Colab)

- Open the Colab notebook
- Run all cells
- Ensure the following output appears:
API is live
URL: https://0c3a-35-237-151-57.ngrok-free.app


- Test the API:


https://0c3a-35-237-151-57.ngrok-free.app/health


Expected response:

```json
{"status":"ok","device":"cpu","surahs_loaded":29}
```
### Test workflow
Select a surah
Click "Record"
Upload an audio file (.wav)
Click "Verify Recitation"
View results:
Correct words are shown in green
Incorrect words are shown in red

### Important Conditions

Backend must be running

The system depends on:

Google Colab session
ngrok tunnel

If Colab stops:

API stops working
Requests will fail
### No microphone recording in Chrome

Due to Flutter Web limitations:

Microphone recording is not supported
Mobile plugins do not work on web

The web version uses:

File upload instead of recording