#!/bin/bash

if [ "$1" == "--check-tagihan" ]; then
	mkdir -p log

	awk -F ',' '
	$5=="Menunggak" {
		print "[" strftime("%Y-%m-%d %H:%M:%S") "] TAGIHAN: " $1 " (Kamar" $2 ") - Menunggak Rp" $3
	}' data/penghuni.csv >> log/tagihan.log

	exit 0
fi

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

		echo "[!] Data penghuni $nama_hapus berhasil diarsipkan ke sampah/history_hapus.csv dan dihapus dari sistem."
		read -p "Tekan [ENTER] untuk kembali ke menu..."
		;;

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

	7)
		break
		;;

	*)
		echo "Pilihan tidak valid!"
		read
		;;
	esac
done
