#! /bin/bash

export NUM_EXPS=$(expr $2 - $1)
cd build
export SUM=0

for i in $(seq $1 $(expr $2 - 1))
do
	export MS=$(grep 'Query time: ' dig_logs/run_$i.log | cut -d ' ' -f 4)
	SUM=$(expr $MS + $SUM)
done
mean=$(echo "$SUM / $NUM_EXPS" | bc -l)


# Calculate the variance
sum_sq_diff=0
for i in $(seq $1 $(expr $2 - 1))
do
  export MS=$(grep 'Query time: ' dig_logs/run_$i.log | cut -d ' ' -f 4)
  diff=$(echo "$MS - $mean" | bc -l)
  sq_diff=$(echo "$diff * $diff" | bc -l)
  sum_sq_diff=$(echo "$sum_sq_diff + $sq_diff" | bc -l)
done

variance=$(echo "$sum_sq_diff / $NUM_EXPS" | bc -l)

# Calculate the standard deviation
std_dev=$(echo "scale=10; sqrt($variance)" | bc -l)

# Print the results
echo "Mean Resolution Time: $mean"
echo "Variance: $variance"
echo "Standard Deviation: $std_dev"
