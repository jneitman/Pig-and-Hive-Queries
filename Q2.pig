players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
birth_data = FOREACH players GENERATE (INT) $2 AS month, (INT) $3 AS day, $0 AS id;
filter_data = FILTER birth_data BY month>0 AND day>0;
grouped_data = GROUP filter_data BY (month, day);
count_data = FOREACH grouped_data GENERATE group, COUNT(filter_data.id) as counter;
sorted = ORDER count_data BY counter DESC;
ranked_sorted = RANK sorted BY counter DESC;
ranked_answer = FILTER ranked_sorted BY $0<=3;
answer = ORDER ranked_answer BY $0;
final_answer = FOREACH answer GENERATE FLATTEN($1);

DUMP final_answer;
