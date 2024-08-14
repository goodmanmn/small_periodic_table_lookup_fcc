#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]] 
  then
    echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUM_RESULT=$($PSQL "SELECT * FROM properties INNER JOIN elements using(atomic_number) INNER JOIN types using(type_id) WHERE atomic_number=$1")
  if [[ -z $ATOMIC_NUM_RESULT ]]
    then
      echo "I could not find that element in the database."
  else
    echo $ATOMIC_NUM_RESULT | while IFS=\| read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
    do 
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done  
  fi
else
  SYMBOL_RESULT=$($PSQL "SELECT * FROM properties INNER JOIN elements using(atomic_number) INNER JOIN types using(type_id) WHERE symbol='$1'")
  NAME_RESULT=$($PSQL "SELECT * FROM properties INNER JOIN elements using(atomic_number) INNER JOIN types using(type_id) WHERE name='$1'")
  if [[ -z $SYMBOL_RESULT && -z $NAME_RESULT ]] 
    then
      echo "I could not find that element in the database."
  elif [[ -z $SYMBOL_RESULT ]]
    then 
     echo $NAME_RESULT | while IFS=\| read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
    do 
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done  
  else
     echo $SYMBOL_RESULT | while IFS=\| read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
    do 
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done  
  fi  
fi
