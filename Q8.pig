players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
player_data = FOREACH players GENERATE $0 AS id, (INT) $2 AS month, $5 AS state;
players_filtered = FILTER player_data BY month >= 1 AND month <= 12 AND state !='';
grouped_month_state = GROUP players_filtered BY (month, state);
count_month_state = FOREACH grouped_month_state GENERATE group, COUNT(players_filtered.id);
filter_month_state = FILTER count_month_state BY $1>=5;


batters = LOAD 'hdfs:/home/ubuntu/pig/Batting.csv' USING PigStorage(',');
batter_data = FOREACH batters GENERATE $0 AS id, (DOUBLE) $5 AS ab, (DOUBLE) $7 AS hits;


combined = JOIN player_data BY id, batter_data BY id;
filtered_combined = FILTER combined BY month>=1 AND month<=12 AND state!='' AND ab>=0 AND hits>=0;
remove_id = FOREACH filtered_combined GENERATE $1 AS month, $2 AS state, $4 AS ab, $5 AS hits;
group_ms = GROUP remove_id BY (month,state);
month_states = FOREACH group_ms GENERATE group, SUM(remove_id.ab) AS total_AB, SUM(remove_id.hits) AS total_hits;

select_combos_ab_hits = JOIN filter_month_state BY group, month_states BY group;
combo_ab_hits = FOREACH select_combos_ab_hits GENERATE $0, (DOUBLE)($4 / $3) AS ranking;
rank_combos = RANK combo_ab_hits BY ranking ASC;
sort_rank_combos = ORDER rank_combos BY $0 ASC;
filter_sort_rank_combos = FILTER sort_rank_combos BY $0==1;
final_answer = FOREACH filter_sort_rank_combos GENERATE FLATTEN($1.$0), FLATTEN($1.$1);
DUMP final_answer;

