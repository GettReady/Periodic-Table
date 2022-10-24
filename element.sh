#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

OUTPUT_RESULT() {
  if [[ -z $ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
    read A_NUM BAR SYMBOL BAR NAME BAR TYPE BAR A_MASS BAR M_POINT_C BAR B_POINT_C <<< $ELEMENT
    echo "The element with atomic number $A_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $M_POINT_C celsius and a boiling point of $B_POINT_C celsius."
  fi
}

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    ELEMENT=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1")    
    OUTPUT_RESULT $ELEMENT    
  else 
    INPUT_LENGTH=$(echo $1 | wc -m)
    if [[ $INPUT_LENGTH > 3 ]]
    then
      ELEMENT=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name='$1'")    
      OUTPUT_RESULT $ELEMENT
    else
      ELEMENT=$($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where symbol='$1'")    
      OUTPUT_RESULT $ELEMENT
    fi
  fi
else
  echo Please provide an element as an argument.
fi
