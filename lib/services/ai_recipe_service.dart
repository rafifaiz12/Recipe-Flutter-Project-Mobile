class AiRecipeService {
  Future<String>
  generateRecipeRecommendation(
      String ingredients,
      ) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final lowerIngredients =
    ingredients.toLowerCase();

    if (lowerIngredients
        .contains('telur') &&
        lowerIngredients
            .contains('nasi')) {
      return '''
Berdasarkan bahan yang kamu punya, kamu bisa membuat:

🍳 Nasi Goreng Telur

Bahan:
- Nasi
- Telur
- Bawang
- Cabai

Cara memasak:
1. Tumis bawang dan cabai.
2. Masukkan telur lalu orak-arik.
3. Tambahkan nasi.
4. Aduk hingga matang.

Selamat mencoba 👨‍🍳
''';
    }

    if (lowerIngredients
        .contains('ayam')) {
      return '''
🍗 Ayam Tumis Pedas

Bahan:
- Ayam
- Bawang
- Cabai
- Kecap

Cara memasak:
1. Tumis bawang dan cabai.
2. Masukkan ayam.
3. Tambahkan kecap.
4. Masak hingga matang.

Selamat memasak 🔥
''';
    }

    return '''
Saya menemukan beberapa ide resep berdasarkan bahan yang kamu masukkan:

🥘 Tumis Sederhana
🍳 Omelette Rumahan
🍲 Sup Praktis

Coba tambahkan bahan yang lebih detail agar rekomendasi resep lebih akurat 😊
''';
  }
}