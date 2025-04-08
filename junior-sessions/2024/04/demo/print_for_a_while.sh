#!/bin/sh

print_for_a_while() {
  IDX=0
  MESSAGE=""

  while [[ $IDX -lt 10 ]]; do
    echo "Running $IDX th loop"
    echo "Message: "$MESSAGE

    if [[ $((IDX % 2)) -eq 0 && $IDX -gt 5 ]]; then
      echo "Even!"
    fi

    if [[ $MESSAGE = "%%%%%" ]]; then
      echo "You've reached a checkpoint!"
    fi

    echo ""

    IDX=$((IDX+1))
    MESSAGE="$MESSAGE"%
    sleep 1
  done
}

print_for_a_while
