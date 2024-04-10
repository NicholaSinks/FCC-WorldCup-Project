#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo "$($PSQL "TRUNCATE TABLE games, teams")"
echo "$($PSQL "SELECT setval(pg_get_serial_sequence('teams', 'team_id'), coalesce(MAX(team_id), 1)) from teams")"
echo "$($PSQL "SELECT setval(pg_get_serial_sequence('games', 'gane_id'), coalesce(MAX(game_id), 1)) from games")"

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR -ne "year" ]]
    then
    echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPOENENT_GOALS
    TEST_WINNER="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
    if [[ -z $TEST_WINNER ]]
    then
      echo -e "\nInserting $WINNER"
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
    else
      echo -e "\n$TEST_WINNER already exists, skipping."
    fi
    TEST_OPPONENT="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $TEST_OPPONENT ]]
    then
      echo -e "\nINSERTING $OPPONENT"
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    else
      echo -e "\n$TEST_OPPONENT already exists, skipping."
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo -e "\n$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
  fi
done