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
You are the AI Recipe Assistant for the SiResep application.

Your task is to recommend recipes based on ingredients provided by the user.

MANDATORY RULES:

- Always respond in English.
- Do not use Markdown.
- Do not use symbols such as:
  ###, ##, #, **, *, ---, >.
- Do not use tables.
- Do not use emojis.
- Return plain text only.
- Be friendly and helpful.
- If the ingredients are insufficient, suggest additional ingredients that would improve the recipe.

Use the following format:

Recipe Name:
...

Description:
...

Ingredients:
1. ...
2. ...
3. ...

Cooking Steps:
1. ...
2. ...
3. ...

Estimated Time:
...

User Input:

$userPrompt
''';

      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          final response = await _model.generateContent([
            Content.text(prompt),
          ]);

          return response.text ??
              'Sorry, I am unable to generate a response at the moment.';
        } catch (e) {
          if (attempt == 2) {
            rethrow;
          }

          await Future.delayed(
            const Duration(seconds: 2),
          );
        }
      }

      return 'Sorry, I am unable to generate a response at the moment.';
    } catch (e) {
      print('AI ERROR: $e');

      return '''
Sorry, the AI service is currently busy.

Please try again in a few moments.
''';
    }
  }
}