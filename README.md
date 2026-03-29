# **SISOP-1-2026-IT-054**
Nabila Sharliz Sigit (5027251054)<br>
Berikut adalah Reporting dari Praktikum SISOP Modul 1 :

---
## **Soal 1**
**Penjelasan**

Langkah pertama yaitu semua command dibuat pada satu file yaitu pada KANJ.sh.
Pada Begin menggunakan ARGV[2] untuk pilihan karena pada terminal memanggil menggunakan "awk -f KANJ.sh passenger.csv (pilihan a/b/c/d/e)"

```shell
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
<img width="768" height="141" alt="image" src="https://github.com/user-attachments/assets/d83c58d5-c039-4743-9c3a-354b2bd5f852" />
<br>
2. titik-penting.txt <br>
<img width="754" height="83" alt="image" src="https://github.com/user-attachments/assets/f749ce3c-2e51-4cbb-94b6-a9f5a5f8686b" />
<br>
3. nemupusaka.sh <br>
<img width="730" height="43" alt="image" src="https://github.com/user-attachments/assets/bb198086-5820-4554-9f26-c022d964408f" />
<br>
4. posisipusaka.txt <br>
<img width="767" height="52" alt="image" src="https://github.com/user-attachments/assets/e3373ffa-49af-4579-a255-62b0444f8bbe" />
<br>

---
## **Soal 3**
**Penjelasan**

Langkah pertama membuat loop Menu Utama dengan do-while yang akan berhenti jika berhenti jika memilih pilihan 7.Exit
```
while true
do
echo " "
echo "===== KOST SLEBEW MANAGEMENT SYSTEM ====="
echo " "
echo "NO | OPTION"
echo "........................................."
echo " 1 | Tambah Penghuni Baru"
echo " 2 | Hapus Penghuni"
echo " 3 | Tampilkan Daftar Penghuni"
echo " 4 | Update Status Penghuni"
echo " 5 | Cetak Laporan Keuangan"
echo " 6 | Kelola Cron (Pengingat Tagihan)"
echo " 7 | Exit Program"
echo " "
echo "=========================================="
echo "Enter Option [1-7]:"

```
Untuk pilihan menggunakan read pilihan lalu switch case: <br>
<br>
1. Opsi 1 : Tambah Penguni

```
read pilihan
case $pilihan  in
        1)
                echo "=========== TAMBAH PENGHUNI ==========="
                echo "......................................."
                read -p "Masukkan Nama: " nama
                read -p "Masukkan Kamar: " kamar
                read -p "Masukkan Harga Sewa: " harga
                read -p "Masukkan Tanggal Masuk (YYYY-MM-DD): " tanggal
                read -p "Masukkan Status Awal (Aktif/Menunggak): " status
                echo " "
                echo "[!] Penghuni $nama berhasil ditambahkan ke Kamar $kamar dengan status $status."
                echo " "
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                echo "$nama,$kamar,$harga,$tanggal,$status" >> data/penghuni.csv
                ;;

```
Untuk opsi pertama yaitu fitur tambah penghuni yang diisi dengan nama, kamar, harga, tanggal, status, lalu akan disimpan di [data_penghuni](./data/penghuni.csv) <br>
<br>
2. Opsi 2 : Hapus Penghuni 

```
        2)
                echo "=========== HAPUS PENGHUNI ============="
                echo "........................................"
                read -p "Masukkan nama penghuni yang akan dihapus: " nama_hapus

                if ! grep -q "^$nama_hapus," data/penghuni.csv; then
                echo "[!] Penghuni $nama_hapus tidak ditemukan."
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                fi

                baris_penghuni=$(grep "^$nama_hapus," data/penghuni.csv)
                tanggal_hapus=$(date +%F)
                echo "$baris_penghuni,$tanggal_hapus" >> sampah/history_hapus.csv
                sed -i "/^$nama_hapus,/d" data/penghuni.csv

                echo "[!] Data penghuni $nama_hapus berhasil diarsipkan ke sampah/history_hapus.csv dan dihapus dari si>
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                ;;

```
Untuk opsi kedua yaitu fitur hapus penghuni, dimana pertama mencari apakah nama yang diinput ada di data yang disimpan menggunakan grep, jika ada maka melanjutkan untuk dihapus. Mengambil nama yang ingin dihapus dari data menggunakan grep dan mendeklarasikan sebagai variabel baris_penghuni, menambah tanggal_hapus dan menyimpan keduanya di [History Hapus](./sampah/history_hapus.csv)
<br>
Lalu menggunakan sed untuk menghapus nama penghuni yang ada di data. <br>
<br>
3. Opsi 3 : Menampilkan Daftar Penghuni

```
        3)
                echo "=========================== DAFTAR PENGHUNI ============================"
                echo " "
                printf "%-20s | %-6s | %-12s | %-12s | %-10s\n" "Nama" "Kamar" "Harga Sewa" "Tanggal Masuk" "Status"
                echo "---------------------+--------+--------------+--------------+-----------"

                awk -F ',' '{
                        printf "%-20s | %-6s | %-12s | %-12s | %-10s\n", $1, $2, $3, $4, $5
                        total++
                        if($5=="Aktif") {
                                aktif++
                        } else if($5=="Menunggak"){
                                menunggak++
                        }
                } END {
                        print " "
                        print "Total Penghuni: ", total
                        print "Aktif: ", aktif
                        print "Menunggak: ", menunggak
                }' data/penghuni.csv

                echo " "
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                ;;

```
Opsi ketiga yaitu melihat daftar penghuni yang telah di rapikan menjadi tabel. Diberi tambahan informasi juga untuk total penghuni, total penghuni aktif dan totak penghuni menunggak. <br>
<br>
4. Opsi 4 : Update Status Penghuni

```
        4)
                echo "=============== UPDATE STATUS ==============="
                echo " "
                read -p "Masukkan Nama Penghuni: " name

                if ! grep -q "^$name," data/penghuni.csv; then
                        echo "[!] Penghuni $name tidak ditemukan."
                        read -p "Tekan [ENTER] untuk kembali ke menu..."
                fi

                read -p "Masukkan Status Baru (Aktif/Menunggak): " status_baru

                sed -i "s/^$name,\([^,]*\),\([^,]*\),\([^,]*\),.*/$name,\1,\2,\3,$status_baru/" data/penghuni.csv

                echo "[!] Status $name berhasil diubah menjadi: $status_baru"
                read -p "Tekan [ENTER] untuk kembali ke menu..."
                ;;

```
Opsi keempat yaitu meng-update status penghuni yang diawali dengan mencari apakah nama penghuni tersebut ada di data, jika iya maka dilanjut dengan memasukkan status baru. Lalu, menggunakan sed untuk mengganti pola lama dengan pola baru (status baru) <br>
<br>
5. Opsi 5 : Laporan Keuangan Kost Slebew

```
	5)
		echo "=============== LAPORAN KEUANGAN KOST SLEBEW ==============="
		echo " "

		awk -F ',' '{
			if($5 == "Aktif"){
				pemasukan+=$3
			} else if($5 == "Menunggak"){
				tunggakan+=$3
				print "- " $1 " (Kamar " $2 ")"
				ada=1
			}

			total_kamar++

		} END {
			print "Total Pemasukan (Aktif)   : Rp" pemasukan
			print "Total Tunggakan           : Rp" tunggakan
			print "Jumlah Kamar Terisi       : " total_kamar
			print "-----------------------------------------"
			print "Daftar penghuni menunggak: "
			if(ada!=1) print "Tidak ada Tunggakan."
		}' data/penghuni.csv > rekap/laporan_bulanan.txt

		echo "[!] Laporan berhasil disimpan ke rekap/laporan_bulanan.txt"
		read -p "Tekan [ENTER] untuk kembali ke menu..."
		;;

```
Opsi kelima yaitu menampilkan laporan keuangan yang berisi total pemasukan ( dari penghuni aktif ), total tunggakan, jumlah kamar dan daftar penghuni tunggakan menggunakan awk. Laporan ini lalu disimpan di **rekap/laporan_bulanan.txt**. <br>
<br>
6. Opsi 6 : Menu Kelola Cron <br>
<br>
Sebelum memulai menu interaktif dari Cron, tambah fungsi berikut di bawah #!/bin/bash (di paling atas program)

```
#!/bin/bash

if [ "$1" == "--check-tagihan" ]; then
        mkdir -p log

        awk -F ',' '
        $5=="Menunggak" {
                print "[" strftime("%Y-%m-%d %H:%M:%S") "] TAGIHAN: " $1 " (Kamar" $2 ") - Menunggak Rp" $3
        }' data/penghuni.csv >> log/tagihan.log

        exit 0
fi

```
Ini gunanya untuk menangani mode eksekusi khusus berbasis argumen, yaitu --check-tagihan. Peletakan di atas ini bertujuan agar fitur dapat dijalankan secara otomatis (Membaca file data/penghuni.csv, memfilter data penghuni yang memiliki status "Menunggak", mencatat informasi tagihan ke dalam file log/tagihan.log) <br>
<br>
Setelah itu dilanjutkan kembali di switch-case 6, dengan do-while menu kelola cron dan nested switch case di setiap opsinya (agar tidak langsung kembali ke menu utama setiap melakukan satu aksi)

```
        6)
                while true
                do
                        clear
                        echo "========== MENU KELOLA CRON =========="
                        echo " "
                        echo "1. Lihat Cron Job Aktif"
                        echo "2. Daftarkan Cron Job Pengingat"
                        echo "3. Hapus Cron Job Pengingat"
                        echo "4. Kembali"
                        echo " "
                        echo "======================================"
                        read -p "Pilih [1-4]: " choice
```
Opsi 1 : Lihat Cron Job Aktif <br>
Berfungsi untuk melihat daftar cron job yang aktif. Menggunakan perintah crontab -l, kemudian memfilter hanya baris yang mengandung parameter --check-tagihan menggunakan grep.

```
                        1)
                                echo "--- Daftar Cron Job Pengingat Tagihan ---"
                                crontab -l 2>/dev/null | grep "--check-tagihan" || echo "Tidak ada jadwal."
                                echo " "
                                read -p "Tekan [ENTER] untuk kembali ke menu..."
                                ;;
```

Opsi 2 : Daftarkan Cron Job Pengingat <br>
Berfungsi untuk mendaftarkan jadwal pengingat baru, dengan menginputkan waktu berupa jam dan menit sebagai waktu eksekusi. Selanjutnya, sistem akan mengambil daftar cron job yang sudah ada menggunakan crontab -l, lalu menghapus entri lama yang mengandung parameter --check-tagihan menggunakan grep -v, lalu program akan menambahkan cron job baru dengan format waktu yang telah dimasukkan.

```
                        2)
                                read -p "Masukkan Jam (0-23): " jam
                                read -p "Masukkan Menit (0-59): " menit

                                (crontab -l 2>/dev/null | grep -v "--check-tagihan"; \
                                echo "$menit $jam * * * $(pwd)/$0 --check-tagihan") | crontab -
                                ;;
```

Opsi 3 : Hapus Cron Job Pengingat <br>
Berfungsi untuk menghapus jadwal cron job. Setelah sistem disaring seperti pada opsi 2, hasilnya kemudian langsung disimpan kembali ke dalam crontab menggunakan crontab -, sehingga cron job pengingat tagihan yang sebelumnya terdaftar akan dihapus sepenuhnya.

```
                        3)
                                crontab -l 2>/dev/null | grep -v "--check-tagihan" | crontab -
                                echo "[!] Cron job pengingat tagihan berhasil dihapus."
                                echo " "
                                read -p "Tekan [ENTER] untuk kembali ke menu..."
                                ;;
```

Opsi terakhir : Exit (pada menu kelola dan menu utama)

```
                        4)
                                break
                                ;;

                        *)
                                echo "Pilihan tidak valid!"
                                read
                                ;;
                        esac
                done
        ;;

        7)
                break
                ;;

        *)
                echo "Pilihan tidak valid!"
                read
                ;;
        esac
done
```
Full code untuk Menu Kelola Cron :

```
	6)
		while true
		do
			clear
			echo "========== MENU KELOLA CRON =========="
			echo " "
			echo "1. Lihat Cron Job Aktif"
			echo "2. Daftarkan Cron Job Pengingat"
			echo "3. Hapus Cron Job Pengingat"
			echo "4. Kembali"
			echo " "
			echo "======================================"
			read -p "Pilih [1-4]: " choice

			case $choice in

			1)
				echo "--- Daftar Cron Job Pengingat Tagihan ---"
				crontab -l 2>/dev/null | grep "--check-tagihan" || echo "Tidak ada jadwal."
				echo " "
				read -p "Tekan [ENTER] untuk kembali ke menu..."
				;;

			2)
				read -p "Masukkan Jam (0-23): " jam
				read -p "Masukkan Menit (0-59): " menit

				(crontab -l 2>/dev/null | grep -v "--check-tagihan"; \
				echo "$menit $jam * * * $(pwd)/$0 --check-tagihan") | crontab - 
				;;

			3)
				crontab -l 2>/dev/null | grep -v "--check-tagihan" | crontab -
				echo "[!] Cron job pengingat tagihan berhasil dihapus."
				echo " "
				read -p "Tekan [ENTER] untuk kembali ke menu..."
				;;

			4)
				break
				;;

			*)
				echo "Pilihan tidak valid!"
				read
				;;
			esac
		done
	;;
```






