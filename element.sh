#!/bin/bash
# author: Mate

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [ -z "$1" ]
then
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    CONDITION="atomic_number=$1"
  else
    CONDITION="symbol='$1' OR name='$1'"
  fi

  
  SELECTED=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $CONDITION")
  if [ -z "$SELECTED" ]
  then 
    echo "I could not find that element in the database."
  else
    echo $SELECTED | {
        IFS=" | "
        read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      }
  fi
fi
