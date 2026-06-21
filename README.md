# Mobile SiResep

## Gambaran Umum

SiResep merupakan aplikasi mobile yang dikembangkan untuk membantu pengguna dalam menemukan, mengelola, dan merencanakan aktivitas memasak secara lebih mudah, praktis, dan terorganisir. Aplikasi ini hadir sebagai solusi digital bagi masyarakat yang sering mengalami kesulitan dalam mencari referensi masakan, menyusun menu harian, maupun mengelola kebutuhan bahan makanan.

Melalui aplikasi SiResep, pengguna dapat mengakses berbagai resep masakan yang tersedia secara cepat melalui fitur pencarian dan kategori resep. Setiap resep dilengkapi dengan informasi yang lengkap, mulai dari daftar bahan, langkah-langkah memasak, estimasi waktu memasak, tingkat kesulitan, hingga ulasan dan penilaian dari pengguna lain. Dengan demikian, pengguna dapat memperoleh panduan memasak yang lebih jelas dan mudah dipahami.

Selain menyediakan informasi resep, SiResep juga menawarkan berbagai fitur pendukung yang membantu pengguna dalam mengatur aktivitas memasak sehari-hari. Fitur Meal Planner memungkinkan pengguna menyusun rencana menu makanan harian maupun mingguan, sedangkan fitur Shopping List membantu mencatat kebutuhan bahan makanan yang harus dibeli berdasarkan resep yang dipilih. Kehadiran fitur-fitur tersebut menjadikan proses persiapan memasak lebih efisien dan terstruktur.

## Teknologi yang Digunakan

Pengembangan aplikasi **SiResep** memanfaatkan berbagai teknologi modern untuk mendukung kebutuhan aplikasi mobile, dashboard admin, serta integrasi backend berbasis cloud. Flutter digunakan sebagai framework utama untuk membangun aplikasi mobile Android dan dashboard admin berbasis web dengan satu basis kode yang sama. Bahasa pemrograman yang digunakan adalah Dart karena memiliki integrasi yang kuat dengan Flutter serta mendukung pengembangan antarmuka yang responsif dan efisien.

Untuk pengelolaan data, aplikasi menggunakan **Cloud Firestore** sebagai database NoSQL yang memungkinkan sinkronisasi data secara real-time antara dashboard admin dan aplikasi mobile. Sistem autentikasi pengguna diintegrasikan dengan **Firebase Authentication**, sehingga proses login dan registrasi dapat dilakukan dengan aman dan terpusat.

Dalam proses pengembangan, tim menggunakan **Git** dan **GitHub** sebagai sistem version control untuk mendukung kolaborasi, pelacakan perubahan kode, dan pengelolaan repositori proyek. Dari sisi antarmuka, aplikasi mengadopsi prinsip **Material Design** guna menghasilkan tampilan yang konsisten, modern, dan mudah digunakan. Pengembangan serta pengujian aplikasi dilakukan menggunakan **Visual Studio Code** dan **Android Studio** sebagai lingkungan pengembangan utama.

## Dokumentasi

### Login & Register
Halaman Login dan Register berfungsi sebagai gerbang autentikasi pengguna ke dalam aplikasi SiResep. Pengguna dapat membuat akun baru melalui fitur registrasi dan masuk ke aplikasi menggunakan akun yang telah terdaftar. Sistem autentikasi ini menjadi dasar untuk mengakses fitur personal seperti Favorite Recipe, Meal Planner, dan Shopping List.

<img width="200" height="342" alt="image2" src="https://github.com/user-attachments/assets/5fb71b40-9ddf-4458-8739-e86a4b69f502" />
<img width="200" height="375" alt="image3" src="https://github.com/user-attachments/assets/58efaca5-c62f-499c-817f-41820ab0e16b" />

### Home Dashboard dan Chat Bot AI
Halaman Home Dashboard menampilkan daftar resep populer, kategori makanan, rekomendasi resep, serta melakukan navigasi ke berbagai fitur utama aplikasi. Tersedia juga tombol Ask AI Recipe yang memungkinkan pengguna memperoleh rekomendasi resep berbasis kecerdasan buatan dengan memasukkan bahan makanan yang tersedia, kemudian sistem akan memberikan saran resep yang sesuai.

<img width="200" height="406" alt="image4" src="https://github.com/user-attachments/assets/42b76f70-90a8-4c97-9d71-fbc63e5e0257" />
<img width="200" height="369" alt="image5" src="https://github.com/user-attachments/assets/50abbf27-273b-4386-b6f1-3519a75db5ad" />

### Recipe Detail
Halaman Recipe Detail menampilkan informasi lengkap mengenai resep yang dipilih. Informasi yang tersedia meliputi nama resep, gambar makanan, daftar bahan, langkah memasak, estimasi waktu memasak, tingkat kesulitan, serta rating dari pengguna lain.

<img width="200" height="439" alt="image7" src="https://github.com/user-attachments/assets/1e7a95c6-0d5a-4e18-9cf1-de3df0cd4e2d" />
<img width="200" height="331" alt="image6" src="https://github.com/user-attachments/assets/9092cb66-e9ab-4c03-81bf-b165f59724d4" />

### Search & Categories
Fitur Search & Categories memudahkan pengguna dalam menemukan resep berdasarkan kata kunci maupun kategori tertentu. Pengguna dapat mencari resep dengan lebih cepat sesuai kebutuhan dan preferensi.

<img width="200" height="415" alt="image11" src="https://github.com/user-attachments/assets/52842610-ff95-4332-9835-5df4d4754357" />
<img width="200" height="401" alt="image10" src="https://github.com/user-attachments/assets/07d9c5de-da98-4bac-84ed-07489351dd71" />

### Rating & Review
Fitur Rating & Review memungkinkan pengguna memberikan penilaian dan ulasan terhadap resep yang telah dicoba. Fitur ini membantu pengguna lain dalam menentukan kualitas resep yang tersedia.

<img width="200" height="261" alt="image13" src="https://github.com/user-attachments/assets/33d849c0-2669-4521-8b27-a178004b35cb" />
<img width="200" height="111" alt="image12" src="https://github.com/user-attachments/assets/d74b120b-bca0-45d6-bba9-5e46484de522" />

### Shopping List
Fitur Shopping List membantu pengguna mencatat bahan-bahan yang perlu dibeli sebelum memasak. Daftar belanja dapat dibuat secara otomatis berdasarkan resep yang dipilih sehingga mempermudah persiapan memasak.

<img width="200" height="401" alt="image15" src="https://github.com/user-attachments/assets/ae814e18-7202-49aa-bb35-031be2bddc3a" />

### Profile Dashboard
Halaman Profile Dashboard menampilkan informasi akun pengguna, statistik penggunaan aplikasi, serta akses ke berbagai pengaturan akun dan fitur personal lainnya.

<img width="200" height="385" alt="image17" src="https://github.com/user-attachments/assets/356060d6-73ba-4f65-a944-1eba77db9b93" />

### Account Setting
Fitur Account Setting memungkinkan pengguna mengelola informasi akun seperti nama, email, foto profil, dan pengaturan lainnya yang berkaitan dengan akun pengguna.

<img width="200" height="412" alt="image18" src="https://github.com/user-attachments/assets/5c9449dc-0773-4b7f-bcf8-2d65f946d1bc" />

### Meal Planner
Fitur Meal Planner membantu pengguna merencanakan menu makanan harian maupun mingguan berdasarkan resep yang tersedia. Dengan fitur ini pengguna dapat mengatur pola makan secara lebih terstruktur.

<img width="200" height="358" alt="image20" src="https://github.com/user-attachments/assets/705ac312-5f6c-4503-8fd9-94dbd84c16fd" />
<img width="200" height="399" alt="image21" src="https://github.com/user-attachments/assets/a2cf8e81-3d8c-4245-8a87-33e89b31d37f" />

### Favorite Recipe
Fitur Favorite Recipe memungkinkan pengguna menyimpan resep yang disukai ke dalam daftar favorit sehingga dapat diakses kembali dengan cepat tanpa perlu melakukan pencarian ulang.

<img width="200" height="406" alt="image23" src="https://github.com/user-attachments/assets/2ad27120-ce74-4dc7-a915-953f099f952a" />
