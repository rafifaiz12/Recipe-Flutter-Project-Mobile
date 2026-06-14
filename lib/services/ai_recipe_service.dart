import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiRecipeService {
  static final String _apiKey =
      dotenv.env['GEMINI_API_KEY'] ?? '';

  late final GenerativeModel _model;

  AiRecipeService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1200,
      ),
    );
  }

  Future<String> generateRecipeRecommendation(
      String userPrompt,
      ) async {
    try {
      final prompt = '''
Kamu adalah AI Recipe Assistant untuk aplikasi SiResep.

Tugasmu adalah memberikan resep makanan berdasarkan bahan yang diberikan pengguna.

ATURAN WAJIB:

- Gunakan Bahasa Indonesia.
- Jangan gunakan Markdown.
- Jangan gunakan simbol:
  ###, ##, #, **, *, ---, >.
- Jangan gunakan format tabel.
- Jangan gunakan emoji.
- Berikan jawaban dalam teks biasa.

Gunakan format berikut:

Nama Resep:
...

Deskripsi:
...

Bahan:
1. ...
2. ...
3. ...

Langkah Memasak:
1. ...
2. ...
3. ...

Estimasi Waktu:
...

Input pengguna:

$userPrompt
''';

      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          final response =
          await _model.generateContent([
            Content.text(prompt),
          ]);

          return response.text ??
              'Maaf, saya tidak dapat menghasilkan jawaban saat ini.';
        } catch (e) {
          if (attempt == 2) {
            rethrow;
          }

          await Future.delayed(
            const Duration(seconds: 2),
          );
        }
      }
      return 'Maaf, saya tidak dapat menghasilkan jawaban saat ini.';
    } catch (e) {
      print('AI ERROR: $e');

      return '''
    Maaf, layanan AI sedang sibuk saat ini.
    
    Silakan coba lagi beberapa saat lagi.
    ''';
    }
  }
}