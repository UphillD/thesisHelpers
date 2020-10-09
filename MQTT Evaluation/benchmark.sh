# Set the location of the benchmark executable
benchmark="/home/uphill/go/bin/mqtt-benchmark"
# Set the location of the final results log
log="results.log"
# Create log directory
mkdir -p logs


# QoS Benchmark
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%     Quality of Service (QoS)     %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log

# Loop through the different qos levels
for qos in 0 1 2
do

	# Create temporary log
	logfile="logs/QoS_$qos.log"

	# Check whether the benchmark has been already run
	if [ ! -f "$logfile" ]; then

		# Repeat the benchmark 10 times
		for i in {0..9}
		do
			# Execute the benchmark, grab the output, format it so that we are
			# left with the achieved bandwidth (msg/sec), store the final number
			# to the temp log
			$benchmark -broker 192.168.2.10:1883 -clients=10 -count=100 -format="text" -qos=$qos -size=1024 \
			| sed -n '/^Total Bandwidth/p' | sed -n 's/.* //p' >> $logfile
		done

		# Calculate the average bandwidth
		sum=$(awk '{s+=$0}END{print s}' $logfile)
		avg=$(echo "$sum/10" | bc)

		# Store the result to the final log
		echo -e "Average total bandwidth for QoS = $qos:\t$avg msg/sec\t | $avg KBps" >> $log

	fi
done

# Print newline to final log
echo -e "" >> $log


# Scalability Benchmark
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%      Scalability (#clients)      %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log

# Loop through the different numbers of clients
for numClients in 1 2 5 10 20 50 100 200 500 1000
do

	logfile="logs/numClients_$numClients.log"

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


# Message Size (Text) Benchmark
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%        Message Size (Text)       %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log

# Loop through the different message sizes
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
		# Convert the result from msg/sec to KB/sec
		bitrateavg=$(echo "($avg * $msgSize) / 1024" | bc)

		echo -e "Average total bandwidth for message size = $msgSize B:\t$avg msg/sec\t| $bitrateavg KBps" >> $log

	fi
done

echo -e "" >> $log

