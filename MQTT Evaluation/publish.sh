for i in {0..9}
do
	echo "Package $i started publishing @ $(date +%s%N)" >> pub_times_2mb.log
	mosquitto_pub -h 192.168.2.10 -f testfile_2mb -t "test" -q 1
done

for i in {0..9}
do
	echo "Package $i started publishing @ $(date +%s%N)" >> pub_times_20mb.log
	mosquitto_pub -h 192.168.2.10 -f testfile_20mb -t "test" -q 1
done
