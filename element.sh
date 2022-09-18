#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]] 
then
  echo "Please provide an element as an argument."
else
  element_input=$1
  element_input_str="$1"

  #get atomic number
  # if input is a number
  if [[ $element_input =~ ^[0-9]+$ ]];
  then
    # get atomic number from atomic number
    atomic_number=$($PSQL "select atomic_number from elements where atomic_number='$element_input'")
  # if variable length > 2
  elif [[ ${#element_input_str} > 2 ]];
  then
    # get atomic number from name
    atomic_number=$($PSQL "select atomic_number from elements where name='$element_input'")
  # input is (maybe) element symbol
  else
    # get atomic number from symbol
    atomic_number=$($PSQL "select atomic_number from elements where symbol='$element_input'")
  fi


  # if atomic number is empty, return failure
  if [[ -z $atomic_number ]] 
  then
    echo "I could not find that element in the database."
  else
    # get properties
    # get name
    name=$($PSQL "select name from elements where atomic_number=$atomic_number")
    # get symbol
    symbol=$($PSQL "select symbol from elements where atomic_number=$atomic_number")
    # get type id
    type_id=$($PSQL "select type_id from properties where atomic_number=$atomic_number")
    # get type
    type=$($PSQL "select type from types where type_id=$type_id")
    # get mass
    mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
    # get melting point
    melt=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
    # get boiling point
    boil=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
    # print result
    echo "The element with atomic number $(echo $atomic_number | sed 's/ //g') is $(echo $name | sed 's/ //g') ($(echo $symbol | sed 's/ //g')). It's a $(echo $type | sed 's/ //g'), with a mass of $(echo $mass | sed 's/ //g') amu. $(echo $name | sed 's/ //g') has a melting point of $(echo $melt | sed 's/ //g') celsius and a boiling point of $(echo $boil | sed 's/ //g') celsius."
  fi
fi

# commit 2
# commit 3
# commit 4
# commit 5
