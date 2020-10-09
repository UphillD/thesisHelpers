mosquitto_sub -v -h 192.168.2.10 -t "test" -C 10 -q 1 -F %U >> rec_times_2mb.log
mosquitto_sub -v -h 192.168.2.10 -t "test" -C 10 -q 1 -F %U >> rec_times_20mb.log
