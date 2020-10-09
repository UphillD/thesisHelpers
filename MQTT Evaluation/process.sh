# Set the location of the final results log
log="results.log"


# Message Size (File) Benchmark
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log
echo -e "%        Message Size (File)       %" >> $log
echo -e "%            Evaluation            %" >> $log
echo -e "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" >> $log

# Loop through the different filesizes
for size in 1 5 10 50 100 500 1024 2048 5120 10240 20480 51200 102400
do

	# Open publishing times into file descriptor 5
	exec 5<pub_$size.log
	# Open subscribing times into file descriptor 6
	exec 6<sub_$size.log

	# Initialize the counter
	sum=0
	# Read both of the files in parallel, one line at a time
	while IFS=, read -a p <&5 &&
	      IFS=, read -a s <&6
	do
		# Store the publishing time
		pubTime=${p[0]}
		# Store the receiving time
		subTime=$(echo ${s[0]} | sed -e 's/\.//g')
		# Calculate the transfer time (ns)
		sumTime=$((subTime - pubTime))
		# Add to the counter
		sum=$((sum + sumTime))
	done

	# Calculate the average transfer time
	avgTime=$(echo "$sum/10" | bc)
	# Calculate the average speed (KBps)
	avgSpeed=$(echo "($size * 1000000000) / $avgTime" | bc)


	# Store the result to the final log
	echo -e "Average total bandwidth for filesize (KB) = $size:\t$avgSpeed KBps" >> $log

done
