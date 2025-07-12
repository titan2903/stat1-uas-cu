# ===================================================================
# UAS Statistical Thinking - Studi Kasus 1: Uji Chi-Square
# Nama: Titanio Yudista
# NIM: 24120500031
# ===================================================================

library(vcd)
library(ggplot2)
library(dplyr)
library(tidyr)

# --- PERSIAPAN DATA ---

# Langkah 1: Membuat matriks data observasi
# Data ini dimasukkan sesuai dengan tabel pada soal di PDF.
observed_data <- matrix(c(120, 90, 60, 100, 130, 70, 80, 100, 140), 
                        nrow = 3, 
                        byrow = FALSE)

# Memberi nama pada baris dan kolom agar tabel lebih mudah dibaca
colnames(observed_data) <- c("Desain A", "Desain B", "Desain C")
rownames(observed_data) <- c("18-25", "26-35", ">35")

# Menampilkan tabel data observasi untuk verifikasi
print("Tabel Frekuensi Observasi:")
print(observed_data)


# --- ANALISIS STATISTIK ---

# Langkah 2: Melakukan Uji Chi-Square
# Langkah ini tetap sama, kita perlu hasil tes untuk mendapatkan nilai harapan
chi_test_result <- chisq.test(observed_data)
print("Hasil Uji Chi-Square:")
print(chi_test_result)


# --- VISUALISASI DATA LANJUTAN ---

# Langkah 3: Membuat Visualisasi - Mosaic Plot yang Lebih Detail
# Kita akan menggunakan fungsi mosaic() dari paket 'vcd' yang lebih powerful.
# Plot ini akan memberikan informasi yang lebih kaya:
# 1. Shading: Warna biru menunjukkan frekuensi observasi LEBIH TINGGI dari harapan.
#    Warna merah menunjukkan frekuensi observasi LEBIH RENDAH dari harapan.
#    Intensitas warna menunjukkan seberapa signifikan perbedaannya.
# 2. Labeling: Menambahkan angka frekuensi observasi langsung di dalam plot.
print("Membuat Mosaic Plot Lanjutan...")

mosaic(observed_data,
       main = "Mosaic Plot: Hubungan Kategori Usia dan Preferensi Desain",
       # Menggunakan shading_hcl untuk mewarnai sel berdasarkan signifikansi residu
       # dan secara otomatis membuat legenda untuk menjelaskan warna.
       shade = TRUE,
       legend = TRUE,
       # Menambahkan label pada setiap kotak untuk menunjukkan frekuensi observasi
       labeling_args = list(
         # Menampilkan nilai frekuensi di dalam kotak
         gp_labels = gpar(fontsize = 11),
         # Menampilkan nama variabel (kategori)
         gp_varnames = gpar(fontsize = 12, fontface = "bold")
       ),
       # Memberi nama pada sumbu
       set_labels = list(Var1 = "Kategori Usia", Var2 = "Preferensi Desain")
)


# Langkah 4: Membuat Visualisasi - Bar Plot Perbandingan yang Lebih Detail
# Untuk membuat bar plot perbandingan, kita perlu mengubah format data
# dari 'wide' menjadi 'long' agar mudah diplot dengan ggplot2.

# Mengubah matriks observasi dan harapan menjadi data frame 'long format'
observed_df <- as.data.frame.table(observed_data)
colnames(observed_df) <- c("Usia", "Desain", "Frekuensi")
observed_df$Tipe <- "Observasi (Observed)"

expected_df <- as.data.frame.table(chi_test_result$expected)
colnames(expected_df) <- c("Usia", "Desain", "Frekuensi")
expected_df$Tipe <- "Harapan (Expected)"

plot_data <- rbind(observed_df, expected_df)

# Membuat Bar Plot dengan ggplot2 dengan tambahan label data
print("Membuat Bar Plot Perbandingan...")
ggplot(plot_data, aes(x = Usia, y = Frekuensi, fill = Tipe)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
  # Menambahkan label teks di atas setiap bar
  geom_text(
    aes(label = round(Frekuensi, 1)), 
    position = position_dodge(width = 0.9),
    vjust = -0.5, # Mengatur posisi vertikal teks sedikit di atas bar
    size = 3.5
  ) +
  facet_wrap(~ Desain) + # Membuat panel terpisah untuk setiap desain
  labs(
    title = "Perbandingan Frekuensi Observasi vs. Harapan",
    subtitle = "Berdasarkan Kategori Usia dan Preferensi Desain",
    x = "Kategori Usia",
    y = "Jumlah Pengguna",
    fill = "Tipe Frekuensi"
  ) +
  scale_fill_brewer(palette = "Paired") + # Menggunakan palet warna yang lebih jelas
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )