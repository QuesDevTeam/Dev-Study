#!/bin/sh

if [ $# -lt 1 ]; then
  echo "Usage: $(basename $0) TARGET_TTY MESSAGE_FILE"
  exit
fi

TTY=$1
MESSAGE=$(cat $2)

# Move to a new line before printing message
echo "" > $TTY
IDX=0
while [ $IDX -lt ${#MESSAGE} ]; do
  CHAR=${MESSAGE:$IDX:1}
  if [[ $CHAR = $'\n' ]]; then
    echo "" > $TTY
  elif [[ $CHAR = $' ' ]]; then
    echo -n " " > $TTY
  else
    echo -n $CHAR > $TTY
  fi
  sleep 0.01

  IDX=$((IDX + 1))
done

echo ""
