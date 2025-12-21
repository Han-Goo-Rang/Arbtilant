# Requirements Document - Arbtilant UI/UX Redesign

## Introduction

Arbtilant adalah aplikasi Flutter untuk deteksi penyakit tanaman menggunakan AI. Saat ini, aplikasi memiliki fitur dasar yang berfungsi namun desain UI/UX masih sederhana dan perlu ditingkatkan. Redesign ini bertujuan untuk meningkatkan user experience, visual consistency, dan menambahkan fitur detail scan result tanpa mengubah fungsionalitas core.

## Glossary

- **Arbtilant System**: Aplikasi Flutter untuk deteksi penyakit tanaman
- **Disease Library**: Halaman yang menampilkan daftar penyakit tanaman dengan fitur search & filter
- **Scan Result**: Hasil deteksi penyakit dari foto daun yang diambil
- **Scan Detail Page**: Halaman baru yang menampilkan detail lengkap dari setiap scan result
- **UI/UX Design**: Desain antarmuka pengguna dan pengalaman pengguna
- **Design System**: Kumpulan komponen, warna, typography, dan spacing yang konsisten
- **Material Design 3**: Framework desain dari Google yang digunakan sebagai foundation
- **Responsive Design**: Desain yang dapat menyesuaikan dengan berbagai ukuran layar
- **Visual Hierarchy**: Pengaturan elemen visual untuk menunjukkan prioritas informasi

## Requirements

### Requirement 1: Design System & Visual Consistency

**User Story:** Sebagai developer, saya ingin memiliki design system yang konsisten, sehingga semua halaman memiliki tampilan yang unified dan mudah di-maintain.

#### Acceptance Criteria

1. WHEN aplikasi dijalankan THEN THE Arbtilant System SHALL menampilkan semua halaman dengan color palette yang konsisten (primary, secondary, accent, background, surface)
2. WHEN user membuka halaman apapun THEN THE Arbtilant System SHALL menggunakan typography yang sama (font family, sizes, weights) di seluruh aplikasi
3. WHEN user berinteraksi dengan komponen THEN THE Arbtilant System SHALL menampilkan spacing dan padding yang konsisten (8px grid system)
4. WHEN user melihat button atau interactive element THEN THE Arbtilant System SHALL menampilkan visual feedback yang jelas (hover, pressed, disabled states)
5. WHEN aplikasi dijalankan di berbagai ukuran layar THEN THE Arbtilant System SHALL menampilkan layout yang responsive dan readable

### Requirement 2: Home Page Redesign

**User Story:** Sebagai pengguna, saya ingin home page yang lebih menarik dan informatif, sehingga saya dapat dengan cepat memahami fitur-fitur aplikasi.

#### Acceptance Criteria

1. WHEN user membuka home page THEN THE Arbtilant System SHALL menampilkan hero section dengan visual yang menarik dan call-to-action yang jelas
2. WHEN user melihat home page THEN THE Arbtilant System SHALL menampilkan feature cards yang menjelaskan 3 fitur utama (Scan, Library, History)
3. WHEN user scroll down THEN THE Arbtilant System SHALL menampilkan quick stats atau recent activity
4. WHEN user melihat navigation THEN THE Arbtilant System SHALL menampilkan bottom navigation yang clear dan mudah digunakan
5. WHEN user tap tombol "Scan Plant" THEN THE Arbtilant System SHALL navigate ke scan page dengan smooth transition

### Requirement 3: Disease Library Page Redesign

**User Story:** Sebagai pengguna, saya ingin library page yang lebih visual dan mudah di-browse, sehingga saya dapat menemukan informasi penyakit dengan cepat.

#### Acceptance Criteria

1. WHEN user membuka library page THEN THE Arbtilant System SHALL menampilkan search bar yang prominent dan mudah diakses
2. WHEN user melihat disease cards THEN THE Arbtilant System SHALL menampilkan disease image, name, severity badge, dan short description
3. WHEN user scroll THEN THE Arbtilant System SHALL menampilkan disease list dengan infinite scroll atau pagination
4. WHEN user tap disease card THEN THE Arbtilant System SHALL navigate ke disease detail page dengan smooth animation
5. WHEN user menggunakan filter THEN THE Arbtilant System SHALL menampilkan hasil filter secara real-time dengan visual feedback

### Requirement 4: Disease Detail Page Redesign

**User Story:** Sebagai pengguna, saya ingin disease detail page yang comprehensive dan well-organized, sehingga saya dapat memahami penyakit secara mendalam.

#### Acceptance Criteria

1. WHEN user membuka disease detail page THEN THE Arbtilant System SHALL menampilkan disease image yang prominent di bagian atas
2. WHEN user melihat detail page THEN THE Arbtilant System SHALL menampilkan informasi terstruktur (symptoms, causes, treatment, prevention) dalam sections yang jelas
3. WHEN user scroll THEN THE Arbtilant System SHALL menampilkan scientific names, affected plants, dan severity indicator
4. WHEN user melihat treatment section THEN THE Arbtilant System SHALL menampilkan treatment steps dalam format yang mudah dibaca (numbered list atau cards)
5. WHEN user tap "Scan Similar" button THEN THE Arbtilant System SHALL navigate ke scan page dengan context disease yang dipilih

### Requirement 5: Scan Result Page Redesign

**User Story:** Sebagai pengguna, saya ingin scan result page yang menampilkan hasil deteksi dengan jelas dan memberikan actionable information.

#### Acceptance Criteria

1. WHEN user selesai scan THEN THE Arbtilant System SHALL menampilkan hasil deteksi dengan confidence score yang prominent
2. WHEN user melihat result THEN THE Arbtilant System SHALL menampilkan top 3 predictions dengan confidence bars untuk comparison
3. WHEN user melihat result THEN THE Arbtilant System SHALL menampilkan treatment recommendations yang relevan
4. WHEN user tap "View Details" THEN THE Arbtilant System SHALL navigate ke scan detail page (NEW) dengan informasi lengkap
5. WHEN user tap "Save" THEN THE Arbtilant System SHALL menyimpan scan result dan menampilkan confirmation message

### Requirement 6: Scan Detail Page (NEW FEATURE)

**User Story:** Sebagai pengguna, saya ingin melihat detail lengkap dari setiap scan yang saya lakukan, sehingga saya dapat melacak history dan membandingkan hasil.

#### Acceptance Criteria

1. WHEN user membuka scan detail page THEN THE Arbtilant System SHALL menampilkan foto yang diambil dengan metadata (tanggal, waktu, lokasi jika tersedia)
2. WHEN user melihat detail page THEN THE Arbtilant System SHALL menampilkan hasil deteksi dengan confidence score dan top 3 predictions
3. WHEN user melihat detail page THEN THE Arbtilant System SHALL menampilkan treatment recommendations yang relevan dengan detected disease
4. WHEN user scroll THEN THE Arbtilant System SHALL menampilkan feedback section dimana user dapat report jika hasil salah
5. WHEN user tap "View Disease Info" THEN THE Arbtilant System SHALL navigate ke disease detail page dengan disease yang terdeteksi

### Requirement 7: History Page Redesign

**User Story:** Sebagai pengguna, saya ingin history page yang menampilkan semua scan saya dengan cara yang mudah di-browse dan di-manage.

#### Acceptance Criteria

1. WHEN user membuka history page THEN THE Arbtilant System SHALL menampilkan list semua scan results dengan thumbnail, disease name, dan date
2. WHEN user melihat history list THEN THE Arbtilant System SHALL menampilkan scan items dalam format card atau list dengan visual hierarchy yang jelas
3. WHEN user tap scan item THEN THE Arbtilant System SHALL navigate ke scan detail page dengan informasi lengkap
4. WHEN user swipe atau tap delete THEN THE Arbtilant System SHALL menampilkan confirmation dialog sebelum delete
5. WHEN user scroll THEN THE Arbtilant System SHALL menampilkan pagination atau infinite scroll dengan loading indicator

### Requirement 8: Bottom Navigation Redesign

**User Story:** Sebagai pengguna, saya ingin bottom navigation yang clear dan mudah digunakan, sehingga saya dapat navigate antar halaman dengan cepat.

#### Acceptance Criteria

1. WHEN user melihat bottom navigation THEN THE Arbtilant System SHALL menampilkan 4 tab (Home, Scan, Library, History) dengan icon dan label yang jelas
2. WHEN user tap tab THEN THE Arbtilant System SHALL navigate ke halaman yang sesuai dengan smooth transition
3. WHEN user berada di halaman tertentu THEN THE Arbtilant System SHALL menampilkan active tab dengan visual indicator (color, underline, atau badge)
4. WHEN user menggunakan aplikasi THEN THE Arbtilant System SHALL menampilkan bottom navigation yang responsive di berbagai ukuran layar
5. WHEN user tap Scan tab THEN THE Arbtilant System SHALL menampilkan floating action button atau prominent button untuk mulai scan

### Requirement 9: Feedback Dialog Redesign

**User Story:** Sebagai pengguna, saya ingin feedback dialog yang user-friendly dan mudah digunakan, sehingga saya dapat dengan mudah melaporkan hasil yang salah.

#### Acceptance Criteria

1. WHEN user tap feedback button THEN THE Arbtilant System SHALL menampilkan dialog dengan form yang clear dan organized
2. WHEN user melihat feedback form THEN THE Arbtilant System SHALL menampilkan options untuk select correct disease dan input feedback text
3. WHEN user submit feedback THEN THE Arbtilant System SHALL menampilkan success message dan close dialog
4. WHEN user cancel THEN THE Arbtilant System SHALL close dialog tanpa menyimpan data
5. WHEN feedback dialog ditampilkan THEN THE Arbtilant System SHALL menampilkan dialog dengan backdrop yang semi-transparent

### Requirement 10: Responsive Design & Mobile Optimization

**User Story:** Sebagai pengguna mobile, saya ingin aplikasi yang responsive dan optimal untuk berbagai ukuran layar, sehingga saya dapat menggunakan aplikasi dengan nyaman.

#### Acceptance Criteria

1. WHEN aplikasi dijalankan di phone (320px - 480px) THEN THE Arbtilant System SHALL menampilkan layout yang readable dan tidak ada overflow
2. WHEN aplikasi dijalankan di tablet (600px - 900px) THEN THE Arbtilant System SHALL menampilkan layout yang optimal dengan better spacing
3. WHEN user scroll THEN THE Arbtilant System SHALL menampilkan smooth scrolling tanpa jank atau lag
4. WHEN user tap button atau interactive element THEN THE Arbtilant System SHALL menampilkan touch target yang cukup besar (minimum 48px)
5. WHEN aplikasi dijalankan di landscape mode THEN THE Arbtilant System SHALL menampilkan layout yang sesuai dengan orientation
