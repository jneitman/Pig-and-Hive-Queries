field = LOAD 'hdfs:/home/ubuntu/pig/Fielding.csv' USING PigStorage(',');
team_errors = FOREACH field GENERATE $1 AS year, $2 AS team_id, (INT) $10 AS errors;
team_errors_year = FILTER team_errors BY year=='2001';
teams = FOREACH team_errors_year GENERATE $1 AS team_id, $2 AS errors;
grouped_teams = GROUP teams BY team_id;
sum_errors = FOREACH grouped_teams GENERATE group, SUM(teams.errors) AS total_errors;

sorted = ORDER sum_errors BY total_errors DESC;
ranked_teams = RANK sorted;
ranked_answer = FILTER ranked_teams BY $0==1;
answer = FOREACH ranked_answer GENERATE $1;

DUMP answer;