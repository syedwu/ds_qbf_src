#! /bin/bash

export NUM_EXPS=$(expr $2 - $1)

# Check if dig_logs exists
DIR="build/dig_logs"

# Check if the directory exists
if [ -d "$DIR" ]; then
    # If it exists, delete the directory and its contents
    rm -r "$DIR"
    echo "Directory $DIR has been deleted."
else
    # If it does not exist, print a message
    echo "Directory $DIR does not exist."
fi
echo "Creating dig_logs"
mkdir -p build/dig_logs

# Running all containers and doing initial testing...
cd build
./tmux-run-docker-part1.bash
sleep 2
echo "Setting Network Condition..."
cd ..
./set_network_conditions.bash
sleep 1
cd build
echo "Starting experiments..."
sleep 1
if [[ $3 != "JUST_RESULTS" ]]
then
	for i in $(seq $1 $(expr $2 - 1))
	do
		echo "Performing query $i..."
		./tmux-run-docker-part2.bash $i
		export FILESIZE=$(wc -c dig_logs/run_$i.log | tr -d ' '| cut -d 'd' -f 1)
		export fails=-1
#		echo "FILESIZE=$FILESIZE"
		while [[ $FILESIZE -le 830 ]]
		do
			fails=$(expr $fails + 1)
			if [[ $fails -ge 3 ]]
			then
				echo "Hit max retrys for run $i"
				echo "Hit max retrys for run $i" >> ../failed.log
				break
			fi
			echo "Error with query $i"
			echo "Exiting..."
			exit
		done
	done
fi


