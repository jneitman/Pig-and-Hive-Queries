batters = LOAD 'hdfs:/home/ubuntu/pig/Batting.csv' USING PigStorage(',');
realbatters = FILTER batters BY $1>0;
ab_data = FOREACH realbatters GENERATE $0 AS id, (INT) $5 AS ab;
grouped_ab_data = GROUP ab_data BY id;
total_ab_data = FOREACH grouped_ab_data GENERATE group, SUM(ab_data.ab) AS sum_ab;

players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
player_data = FOREACH players GENERATE $0 AS id, $6 AS birth_city;

all_cities = JOIN total_ab_data BY $0, player_data BY id;
filtered_cities = FOREACH all_cities GENERATE $1 as most_ab, $3 as final_birth_city;
sorted_cities = ORDER filtered_cities BY most_ab DESC;

ranked_cities = RANK sorted_cities;
ranked_answer = FILTER ranked_cities BY $0==1;
answer = FOREACH ranked_answer GENERATE $2;
DUMP answer;


