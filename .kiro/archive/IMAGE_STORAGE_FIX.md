# Image Storage Fix - Foto Hilang Setelah App Ditutup

## Masalah

Foto yang disimpan saat scanning hilang setelah aplikasi ditutup dan dibuka kembali, meskipun feedback tetap tersimpan.

## Penyebab

Foto disimpan sebagai file path ke `getApplicationDocumentsDirectory()/TANAMAN/`, tetapi:

1. Path file dapat berubah atau tidak valid setelah app restart
2. File dapat dihapus oleh sistem
3. Tidak ada jaminan file tetap ada di lokasi tersebut

## Solusi

Mengubah sistem penyimpanan foto dari file path menjadi **base64 encoding** yang disimpan langsung di Hive database.

## Perubahan yang Dilakukan

### 1. Service Baru: `ImageStorageService`

- `saveImageAsBase64()` - Konversi file foto ke base64 string
- `getImageFromBase64()` - Konversi base64 kembali ke file
- `getCachedImageFromBase64()` - Ambil file dengan caching
- `deleteImage()` - Hapus file cache
- `clearAllImages()` - Bersihkan semua cache

### 2. Update `ScanResultModel`

- Field `imagePath` sekarang menyimpan base64 string, bukan file path
- Dokumentasi diperbarui untuk menjelaskan perubahan

### 3. Update `ScanHistoryService`

- `saveScanResult()` sekarang mengkonversi foto ke base64 sebelum menyimpan
- Method baru `getImageFile()` untuk mengambil foto dari base64
- `deleteScanResult()` sekarang juga menghapus file cache

### 4. Update `ScanPage`

- Foto ditampilkan dari base64 menggunakan `FutureBuilder`
- Foto otomatis di-cache saat pertama kali diakses

### 5. Update `HistoryPage`

- Foto ditampilkan dari base64 menggunakan `FutureBuilder`
- Foto di-cache untuk performa lebih baik

## Alur Kerja

### Saat Scanning:

1. Foto diambil dan disimpan sementara
2. Foto dikonversi ke base64
3. Base64 disimpan di Hive bersama data scan
4. File sementara dapat dihapus

### Saat Membuka History:

1. Base64 diambil dari Hive
2. Dikonversi kembali ke file dan di-cache
3. File cache ditampilkan di UI
4. Cache tetap ada untuk akses cepat berikutnya

## Keuntungan

✅ Foto tetap tersimpan setelah app ditutup  
✅ Tidak bergantung pada file system yang tidak stabil  
✅ Data tersimpan aman di Hive database  
✅ Caching otomatis untuk performa  
✅ Feedback dan foto tetap sinkron

## Testing

1. Buka app dan lakukan scan
2. Tutup app sepenuhnya
3. Buka app kembali
4. Buka History - foto harus tetap ada
5. Feedback juga tetap ada
