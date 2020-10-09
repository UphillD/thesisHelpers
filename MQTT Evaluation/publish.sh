for size in 1 5 10 50 100 500 1024 2048 5120 10240 20480 51200 102400
do
	for i in {0..4}
	do
		echo $(date +%s%N) >> pub_$size.log
		mosquitto_pub -h 192.168.2.10 -t "test" -q 1 -f testfile_$size
		sleep 5
	done
done
