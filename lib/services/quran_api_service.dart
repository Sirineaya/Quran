import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/surah.dart';

class QuranApiService {
  //Important: every time ngrok changes, update only this line:
  static const String baseUrl = 'https://acapnial-macrostylous-tyra.ngrok-free.dev';

  static Future<RecitationResult> recite({
    required File audioFile,
    required int surahNumber,
    int startWordAbs = 0,
    int wordCount = 100,
  }) async {
    final uri = Uri.parse('$baseUrl/recite');

    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        audioFile.path,
      ),
    );

    request.fields['surah_number'] = surahNumber.toString();
    request.fields['start_word_abs'] = startWordAbs.toString();
    request.fields['word_count'] = wordCount.toString();

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}\n${response.body}');
    }

    final data = jsonDecode(response.body);
    return RecitationResult.fromJson(data);
  }
}