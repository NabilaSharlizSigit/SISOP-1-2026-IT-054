
BEGIN {
	FS=","
	pilihan=ARGV[2]
	delete ARGV[2]
}

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
