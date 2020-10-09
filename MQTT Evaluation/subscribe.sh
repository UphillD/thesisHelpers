for size in 1 5 10 50 100 500 1024 2048 5120 10240 20480 51200 102400
do
	mosquitto_sub -h 192.168.2.10 -t "test" -C 5 -q 1 -F %U >> sub_$size.log
done
