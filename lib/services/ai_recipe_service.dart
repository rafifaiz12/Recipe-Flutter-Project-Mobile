class AiRecipeService {
  Future<String> generateRecipeRecommendation(String ingredients) async {
    await Future.delayed(const Duration(milliseconds: 700));

    return '''
Dari bahan yang kamu punya: $ingredients

Rekomendasi resep:
Nasi Goreng Sederhana

Bahan tambahan opsional:
• Garam
• Kecap manis
• Minyak goreng
• Daun bawang

Langkah memasak:
1. Panaskan minyak lalu tumis bawang hingga harum.
2. Masukkan bahan utama yang tersedia.
3. Tambahkan nasi, kecap, dan sedikit garam.
4. Aduk hingga semua bahan tercampur rata.
5. Sajikan selagi hangat.

Catatan:
Untuk tahap frontend, jawaban ini masih berupa dummy response. Nanti service ini bisa diganti untuk memanggil Gemini API.
''';
  }
}