players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
player_data = FOREACH players GENERATE $0 AS id, $6 AS city, $5 AS state;
player_data_filtered = FILTER player_data BY city !='' AND state!='';

batters = LOAD 'hdfs:/home/ubuntu/pig/Batting.csv' USING PigStorage(',');
batter_data = FOREACH batters GENERATE $0 AS id, (INT) $8 AS doubles, (INT) $9 AS triples;
batter_data_filtered = FILTER batter_data BY doubles>=0 AND triples>=0;
batter_grouped = GROUP batter_data_filtered BY id;
batter_totals = FOREACH batter_grouped GENERATE group, SUM(batter_data_filtered.doubles), SUM(batter_data_filtered.triples);

combined = JOIN batter_totals BY $0, player_data_filtered BY $0;
dtTotals = FOREACH combined GENERATE ($1 + $2) AS final_total, $4 AS final_city, $5 AS final_state;
ranked_dtTotals = RANK dtTotals BY final_total DESC;
filtered_ranked_dtTotals = FILTER ranked_dtTotals BY $0<=5;
answer_city_state = ORDER filtered_ranked_dtTotals BY $0 ASC;
final_city_state = FOREACH answer_city_state GENERATE $2, $3;
DUMP final_city_state;
