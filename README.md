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
Full code bisa dilihat di [KANJ.sh](./soal_1/KANJ.sh)<br>
Data yang dipakai yaitu [Data Passenger](./soal_1/passenger.csv)

**Output:**
<img width="657" height="314" alt="image" src="https://github.com/user-attachments/assets/e8cd3b1d-30b9-468d-8f3b-7c76c3675708" />


---
## **Soal 2**
**Penjelasan**

