import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

class QuranApiService {
  static const String baseUrl = 'https://0c3a-35-237-151-57.ngrok-free.app';

  static Future<RecitationResult> recite({
    File? audioFile,
    Uint8List? audioBytes,
    String filename = 'audio.wav',
    required int surahNumber,
    int startWordAbs = 0,
    int wordCount = 100,
  }) async {
    final uri = Uri.parse('$baseUrl/recite');
    final request = http.MultipartRequest('POST', uri);

    if (audioBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'audio',
          audioBytes,
          filename: filename,
        ),
      );
    } else if (audioFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('audio', audioFile.path),
      );
    } else {
      throw Exception('No audio provided');
    }

    request.fields['surah_number'] = surahNumber.toString();
    request.fields['start_word_abs'] = startWordAbs.toString();
    request.fields['word_count'] = wordCount.toString();

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}\n${response.body}');
    }

    return RecitationResult.fromJson(jsonDecode(response.body));
  }
}