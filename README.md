# **SISOP-1-2026-IT-054**
Nabila Sharliz Sigit (5027251054)<br>
Berikut adalah Reporting dari Praktikum SISOP Modul 1 :

---
## **Soal 1**
**Penjelasan**

Langkah pertama yaitu semua command dibuat pada satu file yaitu pada KANJ.sh.
Pada Begin menggunakan ARGV[2] untuk pilihan karena pada terminal memanggil menggunakan "awk -f KANJ.sh passenger.csv (pilihan a/b/c/d/e)"

```
BEGIN {
        FS=","
        pilihan=ARGV[2]
        delete ARGV[2]
}
```

Dilanjutkan dengan logika logika command yang dibutuhkan seperti menghitung jumlah passenger, menghitung banyak jenis gerbong, mencari passenger yang tertua, menghitung rata-rata usia passenger, dan menghitung banyaknya business class passenger

(Note: NR > 1 artinya mulai dari baris ke 2 agar header tidak keikut di hitung)

```
NR > 1 {
        count_passenger++
        sum_age+=$2
        carriage[$4]=1

        if(NR==2 || $2 > age){
                age=$2
                oldest=$1
        }

        if($3=="Business"){
                business_passenger++
        }
}
```
Langkah terakhir yaitu output menggunakan if-else

```
END {
        if(pilihan=="a"){
                print "Jumlah seluruh penumpang KANJ adalah " count_passenger " orang"
        } else if(pilihan=="b"){
                print "Jumlah gerbong penumpang KANJ adalah", length(carriage)
        } else if(pilihan=="c"){
                print oldest " adalah penumpang kereta tertua dengan usia " age " tahun"
        } else if(pilihan=="d"){
                print "Rata-rata usia penumpang adalah " int(sum_age/count_passenger) " tahun"
        } else if(pilihan=="e"){
                print "Jumlah penumpang business class ada " business_passenger " orang"
        } else{
                print "Soal tidak dikenali. Gunakan a, b, c, d, atau e.\nContoh penggunaan: awk -f file.sh data.csv a"
        }
}
```

**Output:** <br>
<br>
<img width="657" height="314" alt="image" src="https://github.com/user-attachments/assets/e8cd3b1d-30b9-468d-8f3b-7c76c3675708" />
<br>

Full code bisa dilihat di [KANJ.sh](./soal_1/KANJ.sh)<br>
Data yang dipakai yaitu [Data Passenger](./soal_1/passenger.csv)

---
## **Soal 2**
**Penjelasan**

Langkah pertama yaitu mengunduh file [peta-ekspedisi-amba.pdf](./soal_2/ekspedisi/peta-ekspedisi-amba.pdf), menyimpannya di file ekspedisi lalu membacanya secara concatonate, akan menemukan tautan tersembunyi : <br>
<img width="847" height="44" alt="image" src="https://github.com/user-attachments/assets/4b2d49c9-9afb-45b5-8f39-8e07c87ee45e" />
<br>
Setelah itu di clone kan dan menemukan file [gsxtrack.json](./soal_2/ekspedisi/peta-gunung-kawi/gsxtrack.json)
<br>

**parserkoordinat.sh** <br>
Membuat shell script yang berisi id, site name, latitude dan longitude lalu menyimpannya di titik-penting.txt 
<br>
```
#!/bin/bash

awk -F'"' '/site_name/ {site=$4} /id/ {id=$4}
/latitude/{
        split($0, a, ": ")
        gsub(/,/, "", a[2])
        x=a[2]
}
/longitude/{
        split($0, b, ": ")
        gsub(/,/, "", b[2])
        y=b[2]

        print id "," site "," x "," y

}' gsxtrack.json
```
Pertama-tama menyimpan id dan site_name ke variabel id dan site<br>
Untuk latitude dan longitude, menggunakan split untuk memecah menjadi dua dan a[2] berarti mengambil bagian ke-2 lalu gsub untuk menghilangkan koma yang ada di belakang, setelah itu menyimpannya di variabel x dan y dan print output.
<br>

Untuk menyimpannya ke titik-penting.txt menggunakan command **./parserkoordinat.sh > titik-penting.txt** pada terminal
<br>

**nemupusaka.sh** <br>
Membuat shell script untuk menghitung titik tengah dan menyimpan outputnya ke file posisipusaka.txt (latitude, longitude)
<br>
```
#!/bin/bash

awk 'BEGIN {FS=","} {
        sumx+=$3
        sumy+=$4
} END { print "Koordinat pusat:\n(" sumx/4 "," sumy/4 ")" }' titik-penting.txt

```
<br>
Mengambil data latitude dan longitude melalui titik-penting.txt, dimulai dari memisahkan antara koma dan mennjumlahkan kolom ke 3 untuk latitude dan menjumlahkan kolom ke 4 untuk longitude, lalu outputnya dibagi jumlah titik yang ditemukan masing2 yaitu 4.
<br>

Untuk menyimpannya ke posisipusaka.txt menggunakan command **./nemupusaka.sh > posisipusaka.txt** pada terminal
<br>

**Output:**
<br>
1. parserkoordinat.sh
<br>
<img width="768" height="141" alt="image" src="https://github.com/user-attachments/assets/d83c58d5-c039-4743-9c3a-354b2bd5f852" />
<br>
3. titik-penting.txt <br>
<img width="754" height="83" alt="image" src="https://github.com/user-attachments/assets/f749ce3c-2e51-4cbb-94b6-a9f5a5f8686b" />
<br>
4. nemupusaka.sh <br>
<img width="730" height="43" alt="image" src="https://github.com/user-attachments/assets/bb198086-5820-4554-9f26-c022d964408f" />
<br>
5. posisipusaka.txt <br>
<img width="767" height="52" alt="image" src="https://github.com/user-attachments/assets/e3373ffa-49af-4579-a255-62b0444f8bbe" />
<br>

---





