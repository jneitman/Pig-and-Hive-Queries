players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
all_weights = FOREACH players GENERATE (INT) $16 AS weight, $0 AS id;
filter_weights = FILTER all_weights BY weight>0;
grouped_weights = GROUP filter_weights BY weight;
count_weights = FOREACH grouped_weights GENERATE group, COUNT(filter_weights.id) as counter;
sorted = ORDER count_weights BY counter DESC;
ranked_sorted = RANK sorted;
filtered_answer = FILTER ranked_sorted BY $0==2;
answer = FOREACH filtered_answer GENERATE $1;
DUMP answer;