
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check whether an argument was provided
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Look up the element by atomic number, symbol, or name
ELEMENT=$($PSQL "
  SELECT
    'The element with atomic number ' || e.atomic_number ||
    ' is ' || e.name || ' (' || e.symbol || '). It''s a ' ||
    t.type || ', with a mass of ' || p.atomic_mass ||
    ' amu. ' || e.name ||
    ' has a melting point of ' || p.melting_point_celsius ||
    ' celsius and a boiling point of ' ||
    p.boiling_point_celsius || ' celsius.'
  FROM elements e
  JOIN properties p USING (atomic_number)
  JOIN types t USING (type_id)
  WHERE
    e.atomic_number::TEXT = '$1'
    OR LOWER(e.symbol) = LOWER('$1')
    OR LOWER(e.name) = LOWER('$1')
  LIMIT 1;
")

# Display the result or the not-found message
if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT"
fi

