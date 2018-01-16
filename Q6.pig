field = LOAD 'hdfs:/home/ubuntu/pig/Fielding.csv' USING PigStorage(',');
field_data = FOREACH field GENERATE $0 AS id, (INT) $1 AS year, (DOUBLE) $5 AS games, (DOUBLE) $10 AS errors;
filter_year_field = FILTER field_data BY year>=2005 AND year<=2009;
grouped_field = GROUP filter_year_field BY (id,year);
field_totals = FOREACH grouped_field GENERATE FLATTEN(group), SUM(filter_year_field.games) AS total_games, SUM(filter_year_field.errors) AS total_errors;
filter_field_twenty = FILTER field_totals BY total_games >=20;
groupF = GROUP filter_field_twenty BY (id,year);

batters = LOAD 'hdfs:/home/ubuntu/pig/Batting.csv' USING PigStorage(',');
batter_data = FOREACH batters GENERATE $0 AS id, (INT) $1 AS year, (DOUBLE) $5 AS at_bat, (DOUBLE) $7 AS hits;
filter_year_bat = FILTER batter_data BY year>=2005 AND year<=2009;
grouped_bat = GROUP filter_year_bat BY (id,year);
batter_totals = FOREACH grouped_bat GENERATE FLATTEN(group), SUM(filter_year_bat.at_bat) AS atbats, SUM(filter_year_bat.hits) AS allhits;
filter_batter_totals = FILTER batter_totals BY atbats>=40;
groupB = GROUP filter_batter_totals BY (id,year);

players = LOAD 'hdfs:/home/ubuntu/pig/Master.csv' USING PigStorage(',');
player_data = FOREACH players GENERATE $0 AS id, $13 AS first_name, $14 AS last_name;


fb = JOIN groupF BY group , groupB BY group;

player_info = FOREACH fb GENERATE FLATTEN($0.$0) AS id, FLATTEN($1.$2) AS games, FLATTEN($1.$3) AS errors, FLATTEN($3.$2) AS ab, FLATTEN($3.$3) AS hits;
group_players = GROUP player_info BY id;
players_totals = FOREACH group_players GENERATE FLATTEN(group) AS id, SUM(player_info.games) AS games, SUM(player_info.errors) AS errors, SUM(player_info.ab) AS ab, SUM(player_info.hits) AS hits;
player_crit = FOREACH players_totals GENERATE id, (DOUBLE)((hits / ab) - (errors / games)) AS rank_score;

ranked_player_crit = RANK player_crit BY rank_score DESC;
sorted_rank_player_crit = ORDER ranked_player_crit BY $0 ASC;
answer_filtered = FILTER sorted_rank_player_crit BY $0<=3;
answer_id = FOREACH answer_filtered GENERATE $1 AS id;

add_names = JOIN answer_id by id, player_data BY id;
remove_ids = FOREACH add_names GENERATE $3, $2;
DUMP remove_ids;






