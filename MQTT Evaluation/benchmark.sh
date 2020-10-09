benchmark="/home/uphill/go/bin/mqtt-benchmark"
log="results.log"

# Message Size
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%           Message Size           %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
for msgSize in 100 1024 2048 5120 10240 102400 1024000
do
	logfile="msgSize_$msgSize.log"
	if [ ! -f "$logfile" ]; then
		for i in {0..9}
		do
			$benchmark -broker 192.168.2.10:1883 -clients=10 -count=100 -format="text" -qos=1 -size="$msgSize" \
			| sed -n '/^Total Bandwidth/p' | sed -n 's/.* //p' >> $logfile
		done
		sum=$(awk '{s+=$0}END{print s}' $logfile)
		avg=$(echo "$sum/10" | bc)
		bitrateavg=$(echo "($avg * $msgSize) / 1024" | bc)
#		avg=$(awk -v s="$sum" 'BEGIN{printf "%.2f\n", s/10}')
#		byte_avg=$($msgSize * $avg)
#		bitrate_avg=$(awk -v a="byte_avg" 'BEGIN{printf "%.2f\n", a/1024}')

		echo -e "Average total bandwidth for message size = $msgSize B:\t$avg msg/sec\t| $bitrateavg KBps" >> $log

	fi
done

echo -e "" >> $log


# QoS
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%     Quality of Service (QoS)     %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
for qos in 0 1 2
do
	logfile="QoS_$qos.log"
	if [ ! -f "$logfile" ]; then
		for i in {0..9}
		do
			$benchmark -broker 192.168.2.10:1883 -clients=10 -count=100 -format="text" -qos=$qos -size=1024 \
			| sed -n '/^Total Bandwidth/p' | sed -n 's/.* //p' >> $logfile
		done
		sum=$(awk '{s+=$0}END{print s}' $logfile)
		avg=$(echo "$sum/10" | bc)
		echo -e "Average total bandwidth for QoS = $qos:\t$avg msg/sec\t | $avg KBps" >> $log

	fi
done

echo -e "" >> $log


# Scalability
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%      Scalability (#clients)      %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
for numClients in 1 2 5 10 20 50 100 200 500 1000
do
	logfile="numClients_$numClients.log"
	if [ ! -f "$logfile" ]; then
		for i in {0..9}
		do
			$benchmark -broker 192.168.2.10:1883 -clients=$numClients -count=100 -format="text" -qos=1 -size=1024 \
			| sed -n '/^Total Bandwidth/p' | sed -n 's/.* //p' >> $logfile
		done
		sum=$(awk '{s+=$0}END{print s}' $logfile)
		avg=$(echo "$sum/10" | bc)
		echo -e "Average total bandwidth for # of clients = $numClients:\t$avg msg/sec\t | $avg KBps" >> $log

	fi
done

echo -e "" >> $log
