#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#g1 and g2 store temp. info. can be used for error fixing
g1="$($PSQL "TRUNCATE teams,games")"

cat games.csv | while IFS="," read yr rd w o wg og
do
  if [[ $yr != 'year' ]]
  then
    #check if winner is in teams
    wid="$($PSQL "select team_id from teams where name='$w'")"
    #if null add new row in teams
    if [[ -z $wid ]]
    then
      g1="$($PSQL "insert into teams(name) values ('$w')")"
      wid="$($PSQL "select team_id from teams where name='$w'")"
    fi
    #check if opponent in teams
    oid="$($PSQL "select team_id from teams where name='$o'")"
    #if null add into teams
    if [[ -z $oid ]]
    then
      g2="$($PSQL "insert into teams(name) values('$o')")"
      oid="$($PSQL "select team_id from teams where name='$o'")"
    fi
    #insert all values into games
    g3="$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($yr,'$rd',$wid,$oid,$wg,$og)")"
  fi
done