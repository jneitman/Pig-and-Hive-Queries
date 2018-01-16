players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
player_data = FOREACH players GENERATE $0 AS id, $13 AS first_name, $14 AS last_name;

field = LOAD 'hdfs:/home/ubuntu/pig/Fielding.csv' USING PigStorage(',');
field_data = FOREACH field GENERATE $0 AS id, (INT) $10 AS errors;
grouped_field_data = GROUP field_data BY id;
total_errors = FOREACH grouped_field_data GENERATE group, SUM(field_data.errors) AS counter;
ranked_errors = RANK total_errors BY counter DESC;

combined = JOIN ranked_errors BY $1, player_data BY id;
player_rank = FOREACH combined GENERATE $0, $4 AS first_name, $5 AS last_name;
answer_filtered = FILTER player_rank BY $0==1;
answer = FOREACH answer_filtered GENERATE $2, $1;
DUMP answer;