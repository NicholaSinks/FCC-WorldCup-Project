#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest --no-align --tuples-only -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) from games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) from games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) from games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(COALESCE(winner_goals,0) + COALESCE(opponent_goals,0)) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(winner_goals) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT teams.name FROM games FULL JOIN teams ON games.winner_id = teams.team_id WHERE year=2018 AND round='Final'")"
 
echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT m.teams FROM games FULL JOIN teams AS wt ON games.winner_id = wt.team_id FULL JOIN teams AS ot ON games.opponent_id = ot.team_id cross join lateral (values (wt.name), (ot.name)) as m(teams) WHERE year=2014 AND
round='Eighth-Final' ORDER BY m.teams")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT(teams.name) FROM teams RIGHT JOIN games ON teams.team_id = games.winner_id ORDER BY teams.name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT games.year, teams.name FROM teams RIGHT JOIN games ON teams.team_id = games.winner_id WHERE round='Final' ORDER BY games.year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name from teams WHERE name LIKE 'Co%'")"
